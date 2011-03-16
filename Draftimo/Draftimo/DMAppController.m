//
//  DraftimoAppDelegate.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAppController.h"
#import "DMConstants.h"
#import "DMHelloWindowController.h"
#import <MPOAuth/MPURLRequestParameter.h>

@interface DMAppController ()
@property (nonatomic, retain, readwrite) MPOAuthAPI *oauthAPI;
@property (nonatomic, retain) DMHelloWindowController *helloWindowController;
@property (nonatomic, copy) NSString *oauthVerifier;

- (void)showHelloWindow;
- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody;
- (void)getUserGames;
@end

@implementation DMAppController
@synthesize oauthAPI;
@synthesize helloWindowController;
@synthesize oauthVerifier;

+ (DMAppController *)sharedAppController
{
    return [[NSApplication sharedApplication] delegate];
}

- (void)dealloc
{
    self.oauthAPI = nil;
    self.helloWindowController = nil;
    [super dealloc];
}

#pragma mark API

//[[NSApplication sharedApplication] beginSheet:self.authWindowController.window modalForWindow:self.helloWindowController.window modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
- (void)refreshOAuthAPI
{
    [self.oauthAPI discardCredentials];
    NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials authenticationURL:[NSURL URLWithString:YAuthBaseURL] andBaseURL:[NSURL URLWithString:YAuthBaseURL] autoStart:NO] autorelease];
}

#pragma mark NSApplicationDelegate

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
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenReceived:) name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenRejected:) name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRejected:) name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRefreshed:) name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    [self refreshOAuthAPI];

#if 1
    [self showHelloWindow];
#else
    if ([[self.oauthAPI credentials] accessToken]) {
        DLog(@"Launch Select Draft Screen");
    } else if ([[self.oauthAPI credentials] requestToken]) {
        DLog(@"Refresh accessToken. Then Launch Select Draft Screen");
        [self.oauthAPI authenticate];
    } else {
        [self showHelloWindow];
    }
#endif
}

#pragma mark Window Launchers

- (void)showHelloWindow
{
    if (!self.helloWindowController) {
        self.helloWindowController = [[[DMHelloWindowController alloc] init] autorelease];
    }
    
    [self.helloWindowController showWindow:nil];
}

#pragma mark MPOAuthNotifications

- (void)requestTokenReceived:(NSNotification *)notification
{
    DLog(@"%@", notification);
}

- (void)requestTokenRejected:(NSNotification *)notification
{
	DLog(@"%@", notification);
}

- (void)accessTokenReceived:(NSNotification *)notification
{
	DLog(@"%@", notification);
    [self getUserGames];
}

- (void)accessTokenRejected:(NSNotification *)notification
{
	DLog(@"%@", notification);
}

- (void)accessTokenRefreshed:(NSNotification *)notification
{
	DLog(@"%@", notification);
    [self getUserGames];
}

#pragma mark Private Methods

- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody
{
    DLog(@"%@", inResponseBody);
}

- (void)getUserGames
{
	[self.oauthAPI performMethod:@"http://fantasysports.yahooapis.com/fantasy/v2/users;use_login=1/games" withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

@end