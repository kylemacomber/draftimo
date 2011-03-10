//
//  DraftimoAppDelegate.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAppController.h"
#import "DMAuthWindowController.h"

@interface DMAppController ()
@property (nonatomic, retain) DMAuthWindowController *authWindowController;

- (void)showAuthWindow;
@end

@implementation DMAppController
@synthesize authWindowController;

- (void)dealloc
{
    [authWindowController release], authWindowController = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self showAuthWindow];
}

- (void)showAuthWindow
{
    if (!self.authWindowController) {
        self.authWindowController = [[[DMAuthWindowController alloc] init] autorelease];
    }
    
    [self.authWindowController.window center];
    [self.authWindowController showWindow:nil];
}

@end