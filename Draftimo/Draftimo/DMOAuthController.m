//
//  DMOAuthController.m
//  draftimo
//
//  Created by Kyle Macomber on 3/22/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMOAuthController.h"
#import "DMConstants.h"


NSTimeInterval const authTimeoutInterval = 10.0;
NSTimeInterval const verifierCodeWait = 3.0;

NSString *const DMOAuthStateString[] = {
    [DMOAuthUnreachable] = @"DMOAuthUnreachable",
    [DMOAuthUnauthenticated] = @"DMOAuthUnauthenticated",
    
    [DMOAuthRequestTokenRequesting] = @"DMOAuthRequestTokenRequesting",
    [DMOAuthRequestTokenRejected] = @"DMOAuthRequestTokenRejected",
    [DMOAuthRequestTokenRecieved] = @"DMOAuthRequestTokenRecieved",
    
    [DMOAuthBrowserLaunched] = @"DMOAuthBrowserLaunched",
    [DMOAuthVerifierCodeWaiting] = @"DMOAuthVerifierCodeWaiting",
    
    [DMOAuthAccessTokenRequesting] = @"DMOAuthAccessTokenRequesting",
    [DMOAuthAccessTokenTimeout] = @"DMOAuthAccessTokenTimeout",
    [DMOAuthAccessTokenRejected] = @"DMOAuthAccessTokenRejected",
    [DMOAuthAccessTokenRefreshing] = @"DMOAuthAccessTokenRefreshing",
    
    [DMOAuthAuthenticated] = @"DMOAuthAuthenticated"
};

@interface DMOAuthController ()
@property (nonatomic, retain) MPOAuthAPI *oauthAPI;
@property (nonatomic, assign, readwrite) DMOAuthState oauthState;
@property (nonatomic, copy) NSURL *userAuthURL;
@property (nonatomic, assign) BOOL didAutoRetry;

- (void)accessTimeout;
- (void)getUserGames;
- (void)authenticate;
- (DMOAuthState)nextOAuthState;
@end

@implementation DMOAuthController
@synthesize oauthAPI;
@synthesize oauthState;
@synthesize userAuthURL;
@synthesize didAutoRetry;
@synthesize verifierCode;

- (void)dealloc
{
    self.oauthAPI = nil;
    self.oauthState = 0;
    self.userAuthURL = nil;
    self.didAutoRetry = 0;
    self.verifierCode = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenReceived:) name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenRejected:) name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRejected:) name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRefreshed:) name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials andBaseURL:[NSURL URLWithString:YAuthBaseURL]] autorelease];
    self.oauthState = ([self.oauthAPI credentials].accessToken && [self.oauthAPI credentials].requestToken) ? DMOAuthAuthenticated : DMOAuthUnauthenticated;
    self.didAutoRetry = NO;
    
    // This is kind of hacky but it has to be done
    id authMethod = self.oauthAPI.authenticationMethod;
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(authenticate) object:nil];
    [self performSelector:@selector(authenticate) withObject:nil afterDelay:verifierCodeWait];
    
    self.oauthState = DMOAuthVerifierCodeWaiting;
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

#pragma mark MPOAuthNotifications

- (void)requestTokenRejected:(NSNotification *)notification
{
	DLog(@"%@", notification);
    // If the user inputs a verifierCode before clicking "Agree" on Yahoo!, the requestToken is rejected
    if (self.oauthState > DMOAuthRequestTokenRejected) {
        self.verifierCode = nil;
//        - (void)setCredential:(id)inCredential withName:(NSString *)inName;
//        extern NSString * const MPOAuthCredentialRequestTokenKey;
//        extern NSString * const MPOAuthCredentialRequestTokenSecretKey;
//        @property (nonatomic, readonly, retain) NSString *requestToken;
//        @property (nonatomic, readonly, retain) NSString *requestTokenSecret;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeout) object:nil];
    }
    
//    if (!self.didAutoRetry) {
//        self.didAutoRetry = YES;
//        return;
//    }
    
    self.oauthState = DMOAuthRequestTokenRejected;
}

- (void)requestTokenReceived:(NSNotification *)notification
{
    DLog(@"%@", notification);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeout) object:nil];
//    self.requestToken = self.oauthAPI.requestToken;
//    self.requestTokenSecret = self.oauthAPI.requestTokenSecret;
    self.didAutoRetry = NO;
    self.oauthState = DMOAuthRequestTokenRecieved;
}

- (void)accessTimeout
{
    DLog(@"");
    self.oauthState = DMOAuthAccessTokenTimeout;
}

- (void)accessTokenRejected:(NSNotification *)notification
{
	DLog(@"%@", notification);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
    self.oauthState = DMOAuthAccessTokenRejected;
}

- (void)accessTokenReceived:(NSNotification *)notification
{
	DLog(@"%@", notification);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
    self.oauthState = DMOAuthAuthenticated;
    [self getUserGames];
}

- (void)accessTokenRefreshed:(NSNotification *)notification
{
	DLog(@"%@", notification);
    [self getUserGames];
}

#pragma mark Private Methods

- (DMOAuthState)nextOAuthState
{
    DLog(@"");
    switch (self.oauthState) {
        case DMOAuthUnauthenticated:
        case DMOAuthRequestTokenRejected:
        case DMOAuthRequestTokenRequesting:
            return DMOAuthRequestTokenRequesting;
        case DMOAuthRequestTokenRecieved:
        case DMOAuthVerifierCodeWaiting:
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
    DLog(@"");
    self.oauthState = [self nextOAuthState];
    if (self.oauthState == DMOAuthRequestTokenRequesting) {
        [self performSelector:@selector(requestTimeout) withObject:nil afterDelay:authTimeoutInterval];
    } else if (self.oauthState == DMOAuthAccessTokenRequesting) {
        [self performSelector:@selector(accessTimeout) withObject:nil afterDelay:authTimeoutInterval];
    }
    
    [self.oauthAPI authenticate];
}

//- (void)discardCredentials
//{
//    DLog(@"");
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(authenticate) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestTimeout) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(accessTimeout) object:nil];
//    
//    [self.oauthAPI discardCredentials];
//    self.oauthState = DMOAuthUnauthenticated;
//    self.verifierCode = nil;
//}

- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody
{
    DLog(@"%@", inResponseBody);
}

- (void)getUserGames
{
	[self.oauthAPI performMethod:@"http://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games" withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

@end
