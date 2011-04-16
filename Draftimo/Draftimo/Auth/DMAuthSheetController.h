//
//  DMAuthWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DMAuthSheetController : NSWindowController {
@private
    BOOL __browserLaunched;
}

@property (nonatomic, assign, readonly) BOOL browserLaunched;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
