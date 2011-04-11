//
//  DMDocument.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMDocument.h"
#import "DMDocumentWindowController.h"


@implementation DMDocument

- (id)init
{
    self = [super init];
    if (!self) return nil;

    return self;
}

- (void)makeWindowControllers
{
    [super makeWindowControllers];
    [self addWindowController:[[DMDocumentWindowController alloc] init]];
}

@end
