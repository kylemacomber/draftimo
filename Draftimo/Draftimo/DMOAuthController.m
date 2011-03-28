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


static NSTimeInterval const authTimeoutInterval = 10.0;

@interface DMOAuthController ()
@property (nonatomic, retain) MPOAuthAPI *oauthAPI;
@property (nonatomic, assign, readwrite) DMOAuthState oauthState;
@property (nonatomic, retain) Reachability *YAuthReachable;
@property (nonatomic, copy) NSURL *userAuthURL;
@property (nonatomic, retain) NSMutableArray *waitingOperations;

- (void)accessTimeout;
- (void)getUserGames;
- (void)authenticate;
- (DMOAuthState)nextOAuthState;
@end

@implementation DMOAuthController
@synthesize oauthAPI;
@synthesize oauthState;
@synthesize YAuthReachable;
@synthesize userAuthURL;
@synthesize verifierCode;
@synthesize waitingOperations;

- (void)dealloc
{
    self.oauthAPI = nil;
    self.oauthState = 0;
    self.userAuthURL = nil;
    self.verifierCode = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.waitingOperations = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.YAuthReachable = [Reachability reachabilityWithHostName:YAuthHostName];
    [self.YAuthReachable startNotifier];
    
    const SEL notificationSEL = @selector(oauthStateChanged:);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSEL name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    NSDictionary *const credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials authenticationURL:[NSURL URLWithString:YAuthBaseURL] andBaseURL:[NSURL URLWithString:YAuthBaseURL] autoStart:NO] autorelease]; //I don't know what the authentication URL is supposed to be, but this is what MPOAuth uses BaseURL as a placeholder in its simpler inits anyway so i copied that
    self.oauthState = ([self.oauthAPI credentials].accessToken && [self.oauthAPI credentials].requestToken) ? DMOAuthAuthenticated : DMOAuthUnauthenticated;
    DLog(@"%@, %d", self.oauthAPI, self.oauthState);
    [self authenticate];
    
    // This is kind of hacky but it has to be done
    const id authMethod = self.oauthAPI.authenticationMethod;
    if ([authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]]) {
        [(MPOAuthAuthenticationMethodOAuth *)authMethod setDelegate:self];
    }
    
    return self;
}

#pragma mark API

- (void)retry
{
    const BOOL requestError = (self.oauthState == DMOAuthRequestTokenRejected);
    if (!requestError) {
        ALog(@"Should only be able to do this if the requestToken was rejected");
        return;
    }

    self.oauthState = DMOAuthUnauthenticated;
    [self authenticate];
}

- (void)launchBrowser
{
    if (!self.userAuthURL) {
        ALog(@"");
        return;
    }
    
    self.oauthState = DMOAuthBrowserLaunched;
    [[NSWorkspace sharedWorkspace] openURL:self.userAuthURL];
}

- (void)setVerifierCode:(NSString *)newVerifierCode
{
    DLog(@"");
    
    newVerifierCode = [newVerifierCode copy];
    [verifierCode release];
    verifierCode = newVerifierCode;

    if (!verifierCode) return; //we need to be able to blank the verifierCode w/o spawning an authentication
    
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
    if ([self.YAuthReachable currentReachabilityStatus] != NotReachable) {
        [[NSOperationQueue mainQueue] addOperations:self.waitingOperations waitUntilFinished:NO];
        [self.waitingOperations removeAllObjects];
    }
}
#pragma mark MPOAuthNotifications

- (void)oauthStateChanged:(NSNotification *)notification
{
    DLog(@"%@", notification);
    NSString *const note = [notification name];
    if (note == MPOAuthNotificationRequestTokenRejected) {
        // If the user inputs a verifierCode before clicking "Agree" on Yahoo!, the requestToken is rejected
        if (self.oauthState > DMOAuthRequestTokenRejected) {
            self.verifierCode = nil;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
        } else {
            //So I was thinking that I didn't want to do this because if something is wrong I could get in this loop of continually reauthorizing and failing... 
            //but if I can't even authorize correctly then something is wrong and I have bigger problems
            [self authenticate]; 
        }
        
        self.oauthState = DMOAuthRequestTokenRejected;
    } else if (note == MPOAuthNotificationRequestTokenReceived) {
        self.oauthState = DMOAuthRequestTokenRecieved;
    } else if (note == MPOAuthNotificationAccessTokenRejected) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
        self.oauthState = DMOAuthAccessTokenRejected;
    } else if (note == MPOAuthNotificationAccessTokenReceived) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
        self.oauthState = DMOAuthAuthenticated;
        [self getUserGames];
    } else if (note == MPOAuthNotificationAccessTokenRefreshed) {
        self.oauthState = DMOAuthAuthenticated;
        [self getUserGames];
    }
}

- (void)accessTimeout
{
    DLog(@"");
    self.oauthState = DMOAuthAccessTokenTimeout;
}

#pragma mark Private Methods

- (DMOAuthState)nextOAuthState
{
    DLog(@"");
    switch (self.oauthState) {
        case DMOAuthUnreachable:
            return DMOAuthUnreachable;
        case DMOAuthUnauthenticated:
        case DMOAuthRequestTokenRejected:
        case DMOAuthRequestTokenRequesting:
            return DMOAuthRequestTokenRequesting;
        case DMOAuthBrowserLaunched:
        case DMOAuthRequestTokenRecieved:
        case DMOAuthAccessTokenTimeout:
        case DMOAuthAccessTokenRejected:
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
    DLog(@"%@, %d", self.oauthAPI, self.oauthState);    
    
    if ([self.YAuthReachable currentReachabilityStatus] == NotReachable) {
        self.oauthState = DMOAuthUnreachable;
        [self.waitingOperations addObject:[[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(authenticate) object:nil] autorelease]];
        return;
    }
    
    self.oauthState = [self nextOAuthState];
    if (self.oauthState == DMOAuthAccessTokenRequesting) {
        [self performSelector:@selector(accessTimeout) withObject:nil afterDelay:authTimeoutInterval];
    }
    
    [self.oauthAPI authenticate];
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
