//
//  DMSetupWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/10/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DMSetupWindowController : NSWindowController {
@private

}

@property (retain) IBOutlet NSBox *box;
@property (retain) IBOutlet NSTextField *boxTitleTextField;

- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)previousButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
