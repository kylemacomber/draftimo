//
//  DMHelloWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DMHelloWindowController.h"
#import "DMAppController.h"
#import "DMSplashScreenButtonCell.h"
#import "DMAuthSheetController.h"
#import <BWToolkitFramework/BWTransparentButtonCell.h>

@interface DMHelloWindowController ()
static inline NSAttributedString *headerBodyAttributedString(NSString *, NSString *);
@end

@implementation DMHelloWindowController
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
    self = [super initWithWindowNibName:@"DMHelloWindow"];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self.createButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"HelloCreateHeader", @""), NSLocalizedString(@"HelloCreateBody", @""))];
    [self.exampleButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"HelloExampleHeader", @""), NSLocalizedString(@"HelloExampleBody", @""))];
    [self.tutorialButton.cell setAttributedTitle:headerBodyAttributedString(NSLocalizedString(@"HelloTutorialHeader", @""), NSLocalizedString(@"HelloTutorialBody", @""))];
}

#pragma IBActions

- (IBAction)createButtonClicked:(id)sender
{
    DLog(@"");
    DMAuthSheetController *authSheetController = [[DMAuthSheetController alloc] init];
    [[NSApplication sharedApplication] beginSheet:authSheetController.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:authSheetController];
}

- (IBAction)exampleButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)tutorialButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    //if (returnCode == DMAuthCancel) { return; }
    //[self.window close];
    DLog(@"");
    [sheet orderOut:self];
    //Call [DMAppController sharedAppController] tell it to show selectDraftWindow
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
