//
//  DMSetupWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/10/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSetupWindowController.h"
#import "DMWelcomeViewController.h"
#import "DMOAuthController.h"
#import "DMAuthSheetController.h"


@interface DMSetupWindowController ()
@property (retain) DMWelcomeViewController *welcomeViewController;
@property (retain) DMAuthSheetController *authSheetController;

- (void)showSelectDraftView;
@end

@implementation DMSetupWindowController
@synthesize box = __box;
@synthesize boxTitleTextField = __boxTitleTextField;
@synthesize welcomeViewController = __welcomeViewController;
@synthesize authSheetController = __authSheetController;

- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    const BOOL needsAuth = ![[DMOAuthController sharedOAuthController] oauthStateMaskMatches:DMOAuthAuthenticated] && ![[DMOAuthController sharedOAuthController] oauthStateMaskMatches:DMOAuthAccessTokenRefreshing];
    if (needsAuth) {
        self.welcomeViewController = [[DMWelcomeViewController alloc] init];
        [self.box setContentView:self.welcomeViewController.view];
    } else {
        [self showSelectDraftView];
    }
}

#pragma mark IBActions

- (IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"");
    [[NSApplication sharedApplication] endSheet:self.window returnCode:NSCancelButton];
}

- (IBAction)previousButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)nextButtonClicked:(id)sender
{
    DLog(@"");
    [[NSApplication sharedApplication] endSheet:self.window returnCode:NSOKButton];
}

#pragma mark DMWelcomeViewController Actions

- (IBAction)welcomeTryButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)welcomeAuthButtonClicked:(id)sender
{
    DLog(@"");
    self.authSheetController = [[DMAuthSheetController alloc] init];
    [[NSApplication sharedApplication] beginSheet:self.authSheetController.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (IBAction)welcomeLearnButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma mark AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == NSCancelButton) {
        [sheet orderOut:self];
        return;
    }
    
    [sheet orderOut:self];
    self.authSheetController = nil;
    [self showSelectDraftView];
}

#pragma mark Private Methods

- (void)showSelectDraftView
{
    DLog(@"");
}

@end
