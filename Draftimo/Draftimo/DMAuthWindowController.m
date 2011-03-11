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
    
    CGFloat animationDistance = [self.instruction2Box frame].size.height + NSMinY(self.instruction1Box.frame) - NSMaxY(self.instruction2Box.frame);
    CGRect frame = [self.window frame];
    if (reveal) {
        frame.size.height += animationDistance;
        frame.origin.y -= animationDistance;
    } else {
        frame.size.height -= animationDistance;
        frame.origin.y += animationDistance;
    }
    [self.window setFrame:frame display:YES animate:YES];
    [self.instruction2Box setHidden:!reveal];
}

@end
