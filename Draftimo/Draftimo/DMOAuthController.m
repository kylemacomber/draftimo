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
#import <MPOAuth/MPURLRequestParameter.h>
#import <JSON/JSON.h>


static NSTimeInterval const authTimeoutInterval = 5.0;

@interface DMOAuthController ()
@property (nonatomic, assign, readwrite, setter = setOAuthStateMask:) DMOAuthState oauthStateMask;
@property (nonatomic, copy, readwrite) NSURL *userAuthURL;

@property (nonatomic, retain) MPOAuthAPI *oauthAPI;
@property (nonatomic, retain) Reachability *YAuthReachable;
@property (nonatomic, retain) NSMutableArray *waitingOperations;

// If user enters verifier code before clicking agree, get requestTokenRejected response and MPOAuth nukes valid request token. I cache it to prevent that.
@property (nonatomic, copy) NSString *cachedRequestToken;
@property (nonatomic, copy) NSString *cachedRequestTokenSecret;

- (void)accessTimeout;
- (void)getUserGames;
- (void)authenticate;
- (void)discardCredentials;
- (DMOAuthState)nextOAuthState;
- (void)setOAuthStateMaskReachable:(BOOL)reachable;
@end

@implementation DMOAuthController
//Public
@synthesize oauthStateMask;
@synthesize verifierCode;
//Private
@synthesize oauthAPI;
@synthesize cachedRequestToken;
@synthesize cachedRequestTokenSecret;
@synthesize YAuthReachable;
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
    
    self.oauthStateMask = ([self.oauthAPI credentials].accessToken && [self.oauthAPI credentials].requestToken) ? DMOAuthAuthenticated : DMOAuthUnauthenticated; //self.oauthAPI credentials].accessToken && [self.oauthAPI credentials].requestToken are the same tests MPOAuth uses internally
    
    const id authMethod = self.oauthAPI.authenticationMethod;
    if ([authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]]) {
        [(MPOAuthAuthenticationMethodOAuth *)authMethod setDelegate:self];
    }
    
    //** Kick off authentication
    [self authenticate];
    
    return self;
}

#pragma mark API

- (void)launchBrowser
{
    if (!self.userAuthURL) {
        ALog(@"");
        return;
    }
    
    self.oauthStateMask = DMOAuthBrowserLaunched;
    [[NSWorkspace sharedWorkspace] openURL:self.userAuthURL];
}

- (void)setVerifierCode:(NSString *)newVerifierCode
{
    DLog(@"");
    
    newVerifierCode = [newVerifierCode copy];
    [verifierCode release];
    verifierCode = newVerifierCode;

    if (!verifierCode) {
        self.oauthStateMask = DMOAuthBrowserLaunched;
        return; //we need to be able to blank the verifierCode w/o spawning an authentication   
    }
    
    [self authenticate];
}

#pragma mark MPOAuthAuthenticationMethodOAuthDelegate

- (NSString *)oauthVerifierForCompletedUserAuthorization
{
	return self.verifierCode;
}

- (BOOL)automaticallyRequestAuthenticationFromURL:(NSURL *)inAuthURL withCallbackURL:(NSURL *)inCallbackURL
{
    DLog(@"inAuthURL:%@ withCallbackURL:%@", inAuthURL, inCallbackURL);
    self.userAuthURL = inAuthURL;
    return NO;
}

#pragma mark ReachabilityNotifications

- (void)reachabilityChanged:(NSNotification *)notification
{
    DLog(@"%@, %d", notification, [(Reachability *)[notification object] currentReachabilityStatus]);
    const BOOL reachable = [self.YAuthReachable currentReachabilityStatus] != NotReachable;
    [self setOAuthStateMaskReachable:reachable];
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
        [self getUserGames];
        
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
            
        ALog(@"%@", notification);
        [self discardCredentials];
        [self authenticate];
    }
}

- (void)accessTimeout
{
    DLog(@"");
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
    DLog(@"");
    switch (self.oauthStateMask) {
        case DMOAuthUnreachable:
            return DMOAuthUnreachable;
        case DMOAuthUnauthenticated:
        case DMOAuthRequestTokenRequesting:
            return DMOAuthRequestTokenRequesting;
        case DMOAuthBrowserLaunched:
        case DMOAuthRequestTokenRecieved:
        case DMOAuthAccessTokenTimeout:
        case DMOAuthAccessTokenRequesting:
            return DMOAuthAccessTokenRequesting;
        default:
            return DMOAuthAuthenticated;
    }
}

- (void)authenticate
{
    DLog(@"%@, %d", self.oauthAPI, self.oauthStateMask);    
    
    // If Yahoo! unreachable, add -authenticate to queue to execute when connection returns
    if ([self.YAuthReachable currentReachabilityStatus] == NotReachable) {
        [self.waitingOperations addObject:[[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(authenticate) object:nil] autorelease]];
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

- (void)performedMethodLoadForURL:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    NSDictionary *response = [responseBody JSONValue];
    DLog(@"%@", response);
//    if ([response objectForKey:@"error"] && self.oauthState < DMOAuthAuthenticated) {
//        [self authenticate];
//    }
}

- (void)getUserGames
{
    [self.oauthAPI performMethod:YFUserGamesMethod atURL:[NSURL URLWithString:YFBaseURL] withParameters:[MPURLRequestParameter parametersFromDictionary:[NSDictionary dictionaryWithObject:@"json" forKey:@"format"]] withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

@end
