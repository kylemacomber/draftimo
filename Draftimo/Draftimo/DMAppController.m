//
//  DraftimoAppDelegate.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAppController.h"
#import "DMConstants.h"
#import "DMWelcomeWindowController.h"
#import "DMAuthSheetController.h"
#import <MPOAuth/MPURLRequestParameter.h>

@interface DMAppController ()
@property (nonatomic, retain, readwrite) MPOAuthAPI *oauthAPI;
@property (nonatomic, retain) DMWelcomeWindowController *helloWindowController;
@property (nonatomic, retain) DMAuthSheetController *authSheetController;

- (void)showHelloWindow;
- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody;
- (void)getUserGames;
@end

@implementation DMAppController
@synthesize oauthAPI;
@synthesize helloWindowController;
@synthesize authSheetController;

- (void)dealloc
{
    self.oauthAPI = nil;
    self.helloWindowController = nil;
    [super dealloc];
}

+ (DMAppController *)sharedAppController
{
    return [[NSApplication sharedApplication] delegate];
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
    
    NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:DMOAuthConsumerKey, kMPOAuthCredentialConsumerKey, DMOAuthConsumerSecret, kMPOAuthCredentialConsumerSecret, nil];
    self.oauthAPI = [[[MPOAuthAPI alloc] initWithCredentials:credentials authenticationURL:[NSURL URLWithString:YAuthBaseURL] andBaseURL:[NSURL URLWithString:YAuthBaseURL] autoStart:NO] autorelease];

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

- (void)applicationWillTerminate:(NSNotification *)notification {
    DLog(@"%@", notification);
    if (![self.oauthAPI isAuthenticated]) { //!!!: This has not been tested. Need to see the state of things when isAuthenticated becomes YES
        [self.oauthAPI discardCredentials];
    }
}

#pragma mark App Navigation

- (void)showHelloWindow
{
    if (!self.helloWindowController) {
        self.helloWindowController = [[[DMWelcomeWindowController alloc] init] autorelease];
    }
    
    [self.helloWindowController showWindow:nil];
}

- (void)showSelectDraftWindow
{
    DLog(@"");
    self.authSheetController = [[[DMAuthSheetController alloc] init] autorelease];
    [[NSApplication sharedApplication] beginSheet:self.authSheetController.window modalForWindow:self.helloWindowController.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

#pragma AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == DMAuthCancel) {
        [sheet orderOut:self];
        [self.oauthAPI discardCredentials];
    } else /*DMAuthSuccess*/ {
        [sheet orderOut:self];
        DLog(@"Launch Select Draft Window");
    }
    
    self.authSheetController = nil;
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