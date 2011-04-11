//
//  DMSetupWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/10/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSetupWindowController.h"


@implementation DMSetupWindowController

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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
