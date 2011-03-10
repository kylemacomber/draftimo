//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthWindowController.h"

@interface DMAuthWindowController ()
- (void)revealInstruction2Box:(BOOL)reveal;
@end

@implementation DMAuthWindowController
@synthesize instruction1Box;
@synthesize instruction2Box;
@synthesize verifierTextField;
@synthesize verifierProgressIndicator;
@synthesize verifierStatusImageView;
@synthesize cancelButton;
@synthesize continueButton;

- (void)dealloc
{
    instruction1Box = nil;
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
    BOOL reveal = [self.instruction2Box isHidden];
    [self revealInstruction2Box:reveal];
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

#pragma Private Methods

- (void)revealInstruction2Box:(BOOL)reveal
{
    #define INSTRUCTION_BUFFER_HEIGHT 16.0f
    CGRect frame = [self.window frame];
    if (reveal) {
        frame.size.height += [self.instruction2Box frame].size.height + INSTRUCTION_BUFFER_HEIGHT;
        frame.origin.y -= [self.instruction2Box frame].size.height + INSTRUCTION_BUFFER_HEIGHT;
    } else {
        frame.size.height -= [self.instruction2Box frame].size.height + INSTRUCTION_BUFFER_HEIGHT;
        frame.origin.y += [self.instruction2Box frame].size.height + INSTRUCTION_BUFFER_HEIGHT;
    }
    [self.window setFrame:frame display:YES animate:YES];
    [self.instruction2Box setHidden:!reveal]; //!!!:animate this fade in/out
}

@end
