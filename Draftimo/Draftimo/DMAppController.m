//
//  DraftimoAppDelegate.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAppController.h"
#import "DMConstants.h"
#import "DMAuthWindowController.h"
#import <MPOAuth/MPURLRequestParameter.h>

@interface DMAppController ()
@property (nonatomic, retain, readwrite) MPOAuthAPI *oauthAPI;
@property (nonatomic, retain) DMAuthWindowController *authWindowController;
@property (nonatomic, copy) NSString *oauthVerifier;

- (void)showAuthWindow;
@end

@implementation DMAppController
@synthesize oauthAPI;
@synthesize authWindowController;
@synthesize oauthVerifier;

+ (DMAppController *)sharedAppController
{
    return [[NSApplication sharedApplication] delegate];
}

- (void)dealloc
{
    [oauthAPI release], oauthAPI = nil;
    [authWindowController release], authWindowController = nil;
    [super dealloc];
}

#pragma NSApplicationDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification 
{
    // Note this code cannot be put in applicationDidFinishLaunching according to http://stackoverflow.com/questions/49510/
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *url = (NSURL *)[event paramDescriptorForKeyword:keyDirectObject];
    DLog(@"%@", url);
    
    // the url is the callback url with the query string including oauth_token and oauth_verifier in 1.0a
	if ([[url host] isEqualToString:@"success"] && [url query].length > 0) {
		NSDictionary *oauthParameters = [MPURLRequestParameter parameterDictionaryFromString:[url query]];
		self.oauthVerifier = [oauthParameters objectForKey:@"oauth_verifier"];
	}
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenReceived:) name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenRejected:) name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRejected:) name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRefreshed:) name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials andBaseURL:[NSURL URLWithString:YAuthBaseURL]] autorelease];
    
    // This is kind of hacky but it has to be done
    id authMethod = [DMAppController sharedAppController].oauthAPI.authenticationMethod;
    if ([authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]]) {
        [(MPOAuthAuthenticationMethodOAuth *)authMethod setDelegate:self];
    }
    
    [self showAuthWindow];
}

#pragma MPOAuthAuthenticationMethodOAuthDelegate

- (NSURL *)callbackURLForCompletedUserAuthorization
{
	return [NSURL URLWithString:@"draftimo://success"];
}

- (NSString *)oauthVerifierForCompletedUserAuthorization
{
	return self.oauthVerifier;
}

- (BOOL)automaticallyRequestAuthenticationFromURL:(NSURL *)inAuthURL withCallbackURL:(NSURL *)inCallbackURL
{
	return YES;
}

#pragma Window Launchers

- (void)showAuthWindow
{
    if (!self.authWindowController) {
        self.authWindowController = [[[DMAuthWindowController alloc] init] autorelease];
    }
    
    [self.authWindowController showWindow:nil];
}

#pragma MPOAuthNotifications

- (void)requestTokenReceived:(NSNotification *)notification
{
	DLog(@"");
}

- (void)requestTokenRejected:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenReceived:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenRejected:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenRefreshed:(NSNotification *)notification
{
	DLog(@"");
}

@end