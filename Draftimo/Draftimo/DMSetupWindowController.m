//
//  DMSetupWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/10/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSetupWindowController.h"
#import "DMWelcomeViewController.h"


@interface DMSetupWindowController ()
@property (retain) DMWelcomeViewController *welcomeViewController;
@end

@implementation DMSetupWindowController
@synthesize box = __box;
@synthesize boxTitleTextField = __boxTitleTextField;
@synthesize welcomeViewController = __welcomeViewController;

- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    const BOOL needsAuth = YES;
    if (needsAuth) {
        self.welcomeViewController = [[DMWelcomeViewController alloc] init];
        [self.box setContentView:self.welcomeViewController.view];
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
}

- (IBAction)welcomeLearnButtonClicked:(id)sender
{
    DLog(@"");
}

@end
