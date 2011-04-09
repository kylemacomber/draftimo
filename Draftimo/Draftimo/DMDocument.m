//
//  DMDocument.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DMDocument.h"
#import "DMDocumentWindowController.h"


@implementation DMDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (void)makeWindowControllers
{
    [self addWindowController:[[DMDocumentWindowController alloc] init]];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

@end
