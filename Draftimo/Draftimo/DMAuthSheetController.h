//
//  DMAuthWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MPOAuth/MPOAuthAuthenticationMethodOAuth.h>
@class DMColoredView;

enum {
    DMAuthSuccess,
    DMAuthCancel
};
typedef NSInteger DMAuthReturnCode;

@interface DMAuthSheetController : NSWindowController <NSTextFieldDelegate, MPOAuthAuthenticationMethodOAuthDelegate> {
@private
    
}

@property (nonatomic, assign) IBOutlet NSBox *instructionBox;
@property (nonatomic, assign) IBOutlet NSTextField *verifierTextField;
@property (nonatomic, assign) IBOutlet NSProgressIndicator *verifierProgressIndicator;
@property (nonatomic, assign) IBOutlet NSImageView *verifierConfirmationImageView;
@property (nonatomic, assign) IBOutlet NSButton *cancelButton;
@property (nonatomic, assign) IBOutlet NSButton *helpButton;
@property (nonatomic, assign) IBOutlet NSButton *previousInstructionButton;
@property (nonatomic, assign) IBOutlet NSView *authorizeView;
@property (nonatomic, assign) IBOutlet NSTextField *authorizeLabel;
@property (nonatomic, assign) IBOutlet NSView *verifyView;
@property (nonatomic, assign) IBOutlet NSTextField *verifyLabel;
@property (nonatomic, assign) IBOutlet NSTextField *errorLabel;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)previousInstructionButtonClicked:(id)sender;

@end
