//
//  DMAuthWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DMAuthWindowController : NSWindowController <NSTextFieldDelegate> {
@private
    
}

@property (nonatomic, assign) IBOutlet NSBox *instruction2Box;
@property (nonatomic, assign) IBOutlet NSTextField *verifierTextField;
@property (nonatomic, assign) IBOutlet NSProgressIndicator *verifierProgressIndicator;
@property (nonatomic, assign) IBOutlet NSImageView *verifierStatusImageView;
@property (nonatomic, assign) IBOutlet NSButton *cancelButton;
@property (nonatomic, assign) IBOutlet NSButton *continueButton;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)continueButtonClicked:(id)sender;

@end
