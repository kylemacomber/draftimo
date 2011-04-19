//
//  DMDocumentWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMDocumentWindowController.h"
#import "DMSetupWindowController.h"


@interface DMDocumentWindowController ()
@property (retain) DMSetupWindowController *setupWindowController;

- (void)setupSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end

@implementation DMDocumentWindowController
@synthesize setupWindowController = __setupWindowController;

- (id)init
{
    self = [self initWithWindowNibName:NSStringFromClass([self class])];
    if (!self) return nil;
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

#pragma mark NSWindowController

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    const BOOL newDraft = !([[self document] fileURL]);
    if (newDraft) {
        self.setupWindowController = [[DMSetupWindowController alloc] init];
        //[self.setupWindowController setDocument:[self document]];
        self.setupWindowController.document = self.document;
        [[NSApplication sharedApplication] beginSheet:self.setupWindowController.window modalForWindow:self.window modalDelegate:self didEndSelector:@selector(setupSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
    }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    const BOOL newDraft = !([[self document] fileURL]);
    if (newDraft) return @"";
    
    return [super windowTitleForDocumentDisplayName:displayName];
}

#pragma mark Setup Window Modal Delegate

- (void)setupSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == NSCancelButton) {
        [sheet orderOut:self];
        [self close];
        return;
    }
    
    [sheet orderOut:self];
    //start the draft! (probably drop a progress indicator down while we rank the players)
}

@end
