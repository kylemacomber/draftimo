//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DMAuthWindowController.h"


@implementation DMAuthWindowController

- (void)dealloc
{
    //[object release], object = nil;
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

@end
