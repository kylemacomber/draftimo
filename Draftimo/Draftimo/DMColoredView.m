//
//  DMColoredView.m
//  draftimo
//
//  Created by Kyle Macomber on 3/15/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMColoredView.h"

@implementation DMColoredView
@synthesize backgroundColor;

- (void)dealloc
{
    self.backgroundColor = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.backgroundColor) {
        [backgroundColor setFill];
        NSRectFillUsingOperation(dirtyRect, NSCompositeSourceOver);
    }
    [super drawRect:dirtyRect];
}

@end
