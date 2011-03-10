//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DMAuthWindowController.h"


@implementation DMAuthWindowController
@synthesize instruction2Box;
@synthesize verifierTextField;
@synthesize verifierProgressIndicator;
@synthesize verifierStatusImageView;
@synthesize cancelButton;
@synthesize continueButton;

- (void)dealloc
{
    instruction2Box = nil;
    verifierTextField = nil;
    verifierProgressIndicator = nil;
    verifierStatusImageView = nil;
    cancelButton = nil;
    continueButton = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthWindow"];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)continueButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    DLog(@"%@", obj);
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    DLog(@"%@", obj);
}

@end
