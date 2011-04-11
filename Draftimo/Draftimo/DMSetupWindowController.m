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

@end

@implementation DMSetupWindowController

- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
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

@end
