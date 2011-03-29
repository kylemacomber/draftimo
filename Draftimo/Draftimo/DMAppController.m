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
@property (nonatomic, retain, readwrite) DMOAuthController *oauthController;
@property (nonatomic, retain) DMWelcomeWindowController *welcomeWindowController;
@property (nonatomic, retain) DMAuthSheetController *authSheetController;

- (void)showWelcomeWindow;
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
    //TODO:see if the below code even did anything
//    DLog(@"%@", notification);
//    if (![self.oauthAPI isAuthenticated]) { //!!!: This has not been tested. Need to see the state of things when isAuthenticated becomes YES
//        DLog(@"Not Authenticated. Discarding Credentials");
//        [self.oauthAPI discardCredentials];
//    }
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
    self.authSheetController = [[[DMAuthSheetController alloc] init] autorelease];
    [[NSApplication sharedApplication] beginSheet:self.authSheetController.window modalForWindow:self.welcomeWindowController.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

#pragma AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == DMAuthCancel) {
        [sheet orderOut:self];
        //[self.oauthController discardCredentials]; TODO:see if this does anything
    } else /*DMAuthSuccess*/ {
        [sheet orderOut:self];
        DLog(@"Launch Select Draft Window");
    }
    
    //self.authSheetController = nil;
}

@end