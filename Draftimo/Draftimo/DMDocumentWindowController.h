//
//  DMDocumentWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class DMSetupWindowController;
@interface DMDocumentWindowController : NSWindowController {
@private
    DMSetupWindowController *__setupWindowController;
}

@end
