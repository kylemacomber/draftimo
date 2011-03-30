//
//  DMWelcomeWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/11/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMWelcomeWindowController.h"
#import "DMAppController.h"
#import "DMSplashScreenButtonCell.h"
#import "DMAuthSheetController.h"
#import <BWToolkitFramework/BWTransparentButtonCell.h>

@interface DMWelcomeWindowController ()
static inline NSAttributedString *headerBodyAttributedString(NSString *, NSString *);
@end

@implementation DMWelcomeWindowController
@synthesize createButton;
@synthesize exampleButton;
@synthesize tutorialButton;

- (void)dealloc
{
    self.createButton = nil;
    self.exampleButton = nil;
    self.tutorialButton = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMWelcomeWindow"];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self.createButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"WelcomeCreateHeader", @""), NSLocalizedString(@"WelcomeCreateBody", @""))];
    [self.exampleButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"WelcomeExampleHeader", @""), NSLocalizedString(@"WelcomeExampleBody", @""))];
    [self.tutorialButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"WelcomeTutorialHeader", @""), NSLocalizedString(@"WelcomeTutorialBody", @""))];
}

#pragma IBActions

- (IBAction)createButtonClicked:(id)sender
{
    DLog(@"");
    [[DMAppController sharedAppController] showSelectDraftWindow];
}

- (IBAction)exampleButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)tutorialButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma Private Functions

NSMutableAttributedString *headerBodyAttributedString(NSString *header, NSString *body)
{
    NSMutableAttributedString *attributedTitle = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", header, body]] autorelease];
    [attributedTitle setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil] range:NSMakeRange(0, [header length])];
    [attributedTitle setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil] range:NSMakeRange([header length], [body length])];
    return attributedTitle;
}

@end
