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
#import <JSON/JSON.h>

@interface DMAppController ()
@property (nonatomic, retain, readwrite) DMOAuthController *oauthController;
@property (nonatomic, retain) DMWelcomeWindowController *welcomeWindowController;
@property (nonatomic, retain) DMAuthSheetController *authSheetController;

- (void)showWelcomeWindow;
- (void)getUserGames;
@end

@implementation DMAppController
@synthesize oauthController;
@synthesize welcomeWindowController;
@synthesize authSheetController;

- (void)dealloc
{
    self.oauthController = nil;
    self.welcomeWindowController = nil;
    self.authSheetController = nil;
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
    self.oauthController = [[[DMOAuthController alloc] init] autorelease];
    [self showWelcomeWindow];
}

- (void)applicationWillTerminate:(NSNotification *)notification {

}

#pragma mark App Navigation

- (void)showWelcomeWindow
{
    if (!self.welcomeWindowController) {
        self.welcomeWindowController = [[[DMWelcomeWindowController alloc] init] autorelease];
    }
    
    [self.welcomeWindowController showWindow:nil];
}

- (void)showSelectDraftWindow
{
    DLog(@"");
    if (![self.oauthController oauthStateMaskMatches:DMOAuthAuthenticated] && ![self.oauthController oauthStateMaskMatches:DMOAuthAccessTokenRefreshing]) {
        if (!self.authSheetController) {
            self.authSheetController = [[[DMAuthSheetController alloc] init] autorelease];
        }
        [[NSApplication sharedApplication] beginSheet:self.authSheetController.window modalForWindow:self.welcomeWindowController.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
        
        return;
    }
    
    DLog(@"Launch Select Draft Window");
    [self getUserGames];
}

#pragma AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == DMAuthCancel) {
        [sheet orderOut:self];
        return;
    }
    
    [sheet orderOut:self];
    self.authSheetController = nil;
    [self showSelectDraftWindow];
}

#pragma mark Private Methods

- (void)performedMethodLoadForURL:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    NSDictionary *response = [responseBody JSONValue];
    DLog(@"%@", response);
    //[[[[[[[response valueForKeyPath:@"fantasy_content.users.0.user"] lastObject] valueForKeyPath:@"games.0.game"] lastObject] valueForKeyPath:@"leagues.0.league"] lastObject] valueForKeyPath:@"teams.0.team"]
    
    NSDictionary *const games = [[[response valueForKeyPath:@"fantasy_content.users.0.user"] lastObject] valueForKey:@"games"];
    for (NSString *gameKey in [games allKeys]) {
        if (gameKey == @"count") continue;
        NSDictionary *const game = [games objectForKey:gameKey];
        for (NSDictionary *resource in game) {
            //metadata => leagues
                //for each league settings and userTeam
        }
        
        [[games objectForKey:gameKey] valueForKeyPath:@"game"];
    }
}

- (void)getUserGames
{
    [self.oauthController performYFMethod:YFUserLeaguesMethod withParameters:nil withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

@end