//
//  DMAuthWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum {
    DMAuthSuccess,
    DMAuthCancel
};
typedef NSInteger DMAuthReturnCode;

@interface DMAuthSheetController : NSWindowController {
@private

}

@property (nonatomic, assign) IBOutlet NSProgressIndicator *requestProgressIndicator;
@property (nonatomic, assign) IBOutlet NSView *requestErrorView;
@property (nonatomic, assign) IBOutlet NSTextField *requestErrorLabel;

@property (nonatomic, assign) IBOutlet NSView *verifierView;
@property (nonatomic, assign) IBOutlet NSTextField *verifierInstructionLabel1;
@property (nonatomic, assign) IBOutlet NSTextField *verifierInstructionLabel2;
@property (nonatomic, assign) IBOutlet NSTextField *verifierTextField;
@property (nonatomic, assign) IBOutlet NSProgressIndicator *verifierProgressIndicator;
@property (nonatomic, assign) IBOutlet NSImageView *verifierStatusImageView;

@property (nonatomic, assign) IBOutlet NSButton *launchBrowserButton;
@property (nonatomic, assign) IBOutlet NSButton *cancelButton;
@property (nonatomic, assign) IBOutlet NSButton *helpButton;

@property (nonatomic, assign, readonly) BOOL browserLaunched;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
