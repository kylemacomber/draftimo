//
//  DMDocumentWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMDocumentWindowController.h"


@implementation DMDocumentWindowController

- (id)init
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (!self) return nil;
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    DLog(@"");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
