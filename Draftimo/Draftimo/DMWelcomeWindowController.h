//
//  DMWelcomeWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/11/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DMWelcomeWindowController : NSWindowController {
@private
    
}

@property (nonatomic, assign) IBOutlet NSButton *createButton;
@property (nonatomic, assign) IBOutlet NSButton *exampleButton;
@property (nonatomic, assign) IBOutlet NSButton *tutorialButton;

- (id)init;
- (IBAction)createButtonClicked:(id)sender;
- (IBAction)exampleButtonClicked:(id)sender;
- (IBAction)tutorialButtonClicked:(id)sender;

@end
