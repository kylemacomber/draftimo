//
//  DMOAuthController.m
//  draftimo
//
//  Created by Kyle Macomber on 3/22/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMOAuthController.h"
#import "DMConstants.h"
#import "Reachability.h"
#import "NSDictionary-Utilities.h"
#import <MPOAuth/MPURLRequestParameter.h>


static NSTimeInterval const authTimeoutInterval = 5.0;

@interface DMDelayedBlockOperation :  NSBlockOperation {}
@property (nonatomic, retain) Reachability *reachability;
@property (nonatomic, assign) BOOL waitingForAuth;
@end

@interface DMOAuthController ()
@property (nonatomic, assign, readwrite, setter = setOAuthStateMask:) DMOAuthState oauthStateMask;
@property (nonatomic, copy, readwrite) NSURL *userAuthURL;

@property (nonatomic, retain) MPOAuthAPI *oauthAPI;
@property (nonatomic, retain) Reachability *YAuthReachable;
@property (nonatomic, retain) Reachability *YFReachable;
@property (nonatomic, retain) NSMutableArray *waitingOperations;

// If user enters verifier code before clicking agree, get requestTokenRejected response and MPOAuth nukes valid request token. I cache it to prevent that.
@property (nonatomic, copy) NSString *cachedRequestToken;
@property (nonatomic, copy) NSString *cachedRequestTokenSecret;

- (void)accessTimeout;
- (void)authenticate;
- (void)discardCredentials;
- (DMOAuthState)nextOAuthState;
- (void)setOAuthStateMaskReachable:(BOOL)reachable;
@end

@implementation DMOAuthController
//** Public
@synthesize oauthStateMask;
@synthesize verifierCode;
//** Private
@synthesize oauthAPI;
@synthesize cachedRequestToken;
@synthesize cachedRequestTokenSecret;
@synthesize YAuthReachable;
@synthesize YFReachable;
@synthesize waitingOperations;
@synthesize userAuthURL;

- (void)dealloc
{
    self.oauthStateMask = 0;
    self.verifierCode = nil;
    self.oauthAPI = nil;
    self.cachedRequestToken = nil;
    self.cachedRequestTokenSecret = nil;
    self.YAuthReachable = nil;
    self.waitingOperations = nil;
    self.userAuthURL = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //** No Internet Handling Setup
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.YAuthReachable = [Reachability reachabilityWithHostName:YAuthHostName];
    [self.YAuthReachable startNotifier];
    self.YFReachable = [Reachability reachabilityWithHostName:YFHostName];
    [self.YFReachable startNotifier];
    self.waitingOperations = [NSMutableArray array];
    
    //** OAuthAPI Setup
    const SEL notificationSEL = @selector(oauthStateChanged:);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    NSDictionary *const credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials authenticationURL:[NSURL URLWithString:YAuthBaseURL]  andBaseURL:[NSURL URLWithString:YAuthBaseURL] autoStart:NO] autorelease]; // I don't know what authentication URL is. This is what MPOAuth does internal so I copied it.
    
    self.cachedRequestToken = [self.oauthAPI credentialNamed:kMPOAuthCredentialRequestToken];
    self.cachedRequestTokenSecret = [self.oauthAPI credentialNamed:kMPOAuthCredentialRequestTokenSecret];
    
    //These are the same tests MPOAuth uses internally, to decide its state
    if ([self.oauthAPI credentials].accessToken && [self.oauthAPI credentials].requestToken) {
        NSTimeInterval expiryDateInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:MPOAuthTokenRefreshDateDefaultsKey];
        NSDate *tokenExpiryDate = [NSDate dateWithTimeIntervalSinceReferenceDate:expiryDateInterval];
        
        if ([tokenExpiryDate compare:[NSDate date]] == NSOrderedAscending) {
            self.oauthStateMask = DMOAuthAccessTokenRefreshing;
        } else {
            self.oauthStateMask = DMOAuthAuthenticated;
        }
    } else {
        self.oauthStateMask = DMOAuthUnauthenticated;
    }
    
    const id authMethod = self.oauthAPI.authenticationMethod;
    if ([authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]]) {
        [(MPOAuthAuthenticationMethodOAuth *)authMethod setDelegate:self];
    }
    
    //** Kick off authentication
    [self authenticate];
    
    return self;
}

#pragma mark API

- (void)setVerifierCode:(NSString *)newVerifierCode
{  
    newVerifierCode = [newVerifierCode copy];
    [verifierCode release];
    verifierCode = newVerifierCode;

    if (!verifierCode) {
        self.oauthStateMask = DMOAuthRequestTokenRecieved;
        return; //we need to be able to blank the verifierCode w/o spawning an authentication   
    }
    
    [self authenticate];
}

- (void)performYFMethod:(NSString *)theMethod withParameters:(NSDictionary *)theParameters withTarget:(id)theTarget andAction:(SEL)theAction
{
    // If Yahoo! unreachable or we haven't authenticated yet (or both) add performYFMethod to a queue and execute once these conditions are satisfied    
    const BOOL waitingForAuth = (self.oauthStateMask & DMOAuthAuthenticated) == DMOAuthAuthenticated;
    if ([self.YFReachable currentReachabilityStatus] == NotReachable || waitingForAuth) {
        DMDelayedBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            [self performYFMethod:theMethod withParameters:theParameters withTarget:theTarget andAction:theAction];
        }];
        blockOperation.reachability = self.YFReachable;
        blockOperation.waitingForAuth = waitingForAuth;
        [self.waitingOperations addObject:blockOperation];
        return;
    }
    
    NSMutableDictionary *parameters = [[theParameters mutableCopy] autorelease];
    [parameters setObject:@"json" forKey:@"key"];
    [self.oauthAPI performMethod:theMethod atURL:[NSURL URLWithString:YFBaseURL] withParameters:[MPURLRequestParameter parametersFromDictionary:parameters] withTarget:theTarget andAction:theAction];
}

#pragma mark MPOAuthAuthenticationMethodOAuthDelegate

- (NSString *)oauthVerifierForCompletedUserAuthorization
{
	return self.verifierCode;
}

- (BOOL)automaticallyRequestAuthenticationFromURL:(NSURL *)inAuthURL withCallbackURL:(NSURL *)inCallbackURL
{
    self.userAuthURL = inAuthURL;
    return NO;
}

#pragma mark ReachabilityNotifications

- (void)reachabilityChanged:(NSNotification *)notification
{
    DLog(@"%@, %d", notification, [(Reachability *)[notification object] currentReachabilityStatus]);
    const BOOL reachable = [self.YAuthReachable currentReachabilityStatus] != NotReachable;
    [self setOAuthStateMaskReachable:reachable];
#warning EXECUTE WAITING OPERATIONS HERE REMEMBER TO CHECK CONDITIONS    
    if (reachable && [self.waitingOperations count]) {
        [[NSOperationQueue mainQueue] addOperations:self.waitingOperations waitUntilFinished:NO];
        [self.waitingOperations removeAllObjects];
    }
}

#pragma mark MPOAuthNotifications

- (void)oauthStateChanged:(NSNotification *)notification
{
    DLog(@"%@", notification);

    NSString *const notificationKey = [notification name];
    //** Success
    if (notificationKey == MPOAuthNotificationRequestTokenReceived) {
        self.oauthStateMask = DMOAuthRequestTokenRecieved;
        self.cachedRequestToken = [self.oauthAPI credentialNamed:kMPOAuthCredentialRequestToken];
        self.cachedRequestTokenSecret = [self.oauthAPI credentialNamed:kMPOAuthCredentialRequestTokenSecret];
    } else if (notificationKey == MPOAuthNotificationAccessTokenReceived || notificationKey == MPOAuthNotificationAccessTokenRefreshed) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
        self.oauthStateMask = DMOAuthAuthenticated;
        
#warning EXECUTE WAITING OPERATIONS HERE REMEMBER TO CHECK CONDITIONS
        
    //** Error
    } else {
        // If the user inputs a verifierCode before clicking "Agree" on Yahoo!, the requestToken is rejected
        if (notificationKey == MPOAuthNotificationRequestTokenRejected && self.oauthStateMask >= DMOAuthRequestTokenRecieved) {
            self.verifierCode = nil;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
            [self.oauthAPI setCredential:self.cachedRequestToken withName:kMPOAuthCredentialRequestToken];
            [self.oauthAPI setCredential:self.cachedRequestTokenSecret withName:kMPOAuthCredentialRequestTokenSecret];
            return;
        }
            
        // If we have bad credentials, discard them and start over. This will happen, for example, if user gets partway through authentication but quits.
        [self discardCredentials];
        [self authenticate];
    }
}

- (void)accessTimeout
{
    self.oauthStateMask = DMOAuthAccessTokenTimeout;
}

#pragma mark Private Methods

- (void)setOAuthStateMask:(DMOAuthState)newStateMask
{
    if (newStateMask == DMOAuthUnreachable) { ALog(@"use -setOAuthStateMaskReachable: to set the oauthStateMask reachable or unreachable"); }
    
    [self willChangeValueForKey:@"oauthStateMask"];
    if ((oauthStateMask & DMOAuthUnreachable) == DMOAuthUnreachable) {
        oauthStateMask = DMOAuthUnreachable;
    } else {
        oauthStateMask = 0;
    }
    
    oauthStateMask |= newStateMask;
    [self didChangeValueForKey:@"oauthStateMask"];
}

- (void)setOAuthStateMaskReachable:(BOOL)reachable
{
    [self willChangeValueForKey:@"oauthStateMask"];
    
    if (reachable) {
        oauthStateMask &= ~DMOAuthUnreachable;
    } else {
        oauthStateMask |= DMOAuthUnreachable;
    }
    
    [self didChangeValueForKey:@"oauthStateMask"];
}

- (DMOAuthState)nextOAuthState
{
    switch (self.oauthStateMask) {
        case DMOAuthUnreachable:
            return DMOAuthUnreachable;
        case DMOAuthUnauthenticated:
        case DMOAuthRequestTokenRequesting:
            return DMOAuthRequestTokenRequesting;
        case DMOAuthRequestTokenRecieved:
        case DMOAuthAccessTokenTimeout:
        case DMOAuthAccessTokenRequesting:
            return DMOAuthAccessTokenRequesting;
        case DMOAuthAccessTokenRefreshing:
            return DMOAuthAccessTokenRefreshing;
        default:
            return DMOAuthAuthenticated;
    }
}

- (void)authenticate
{
    DLog(@"%@, %d", self.oauthAPI, self.oauthStateMask);    
    
    // If Yahoo! unreachable, add -authenticate to queue to execute when connection returns    
    if ([self.YAuthReachable currentReachabilityStatus] == NotReachable) {
        DMDelayedBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{[self authenticate];}];
        blockOperation.reachability = self.YAuthReachable;
        blockOperation.waitingForAuth = NO;
        [self.waitingOperations addObject:blockOperation];
        return;
    }
    
    self.oauthStateMask = [self nextOAuthState];
    if (self.oauthStateMask == DMOAuthAccessTokenRequesting) {
        [self performSelector:@selector(accessTimeout) withObject:nil afterDelay:authTimeoutInterval];
    }
    
    [self.oauthAPI authenticate];
}

- (void)discardCredentials
{
    [self.oauthAPI discardCredentials];
    self.oauthStateMask = DMOAuthUnauthenticated;
}

@end

@implementation DMDelayedBlockOperation
@synthesize reachability;
@synthesize waitingForAuth;
@end
