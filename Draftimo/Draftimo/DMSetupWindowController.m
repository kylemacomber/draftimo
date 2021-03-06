//
//  DMSetupWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/10/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSetupWindowController.h"
#import "DMOAuthController.h"
#import "DMAuthSheetController.h"
#import "DMSelectDraftViewController.h"
#import "DMConstants.h"
#import "DMDocument.h"


@interface DMSetupWindowController ()
@property (retain) KTViewController *welcomeViewController;
@property (retain) DMAuthSheetController *authSheetController;
@property (retain) DMSelectDraftViewController *selectDraftViewController;

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)showSelectDraftView;
@end

@implementation DMSetupWindowController
@synthesize box = __box;
@synthesize boxTitleTextField = __boxTitleTextField;
@synthesize welcomeViewController = __welcomeViewController;
@synthesize authSheetController = __authSheetController;
@synthesize selectDraftViewController = __selectDraftViewController;

- (id)init
{
    self = [super initWithWindowNibName:ClassKey(DMSetupWindowController)];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    const BOOL needsAuth = ![[DMOAuthController sharedOAuthController] oauthStateMaskMatches:DMOAuthAuthenticated] && ![[DMOAuthController sharedOAuthController] oauthStateMaskMatches:DMOAuthAccessTokenRefreshing];
    if (needsAuth) {
        self.welcomeViewController = [[KTViewController alloc] initWithNibName:@"DMWelcomeViewController" bundle:nil];
        [self addViewController:self.welcomeViewController];
        [self.box setContentView:self.welcomeViewController.view];
    } else {
        [[DMOAuthController sharedOAuthController] performYFMethod:YFUserLeaguesMethod withParameters:nil withTarget:[self document] andAction:@selector(parseYFXMLMethod:withResponseBody:)];
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

- (IBAction)setupNextButtonClicked:(id)sender
{
    DLog(@"");
    if (![[self nextResponder] tryToPerform:@selector(setupNextButtonClicked:) with:sender]) {
        [[NSApplication sharedApplication] endSheet:self.window returnCode:NSOKButton];
    }
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
    self.selectDraftViewController = [[DMSelectDraftViewController alloc] init];
    [self addViewController:self.selectDraftViewController];
    [self.box setContentView:self.selectDraftViewController.view];
}

@end
