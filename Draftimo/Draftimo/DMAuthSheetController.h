//
//  DMAuthWindowController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MPOAuth/MPOAuthAuthenticationMethodOAuth.h>
//@protocol MPOAuthAuthenticationMethodOAuthDelegate;

enum {
    DMAuthSuccess,
    DMAuthCancel
};
typedef NSInteger DMAuthReturnCode;

@interface DMAuthSheetController : NSWindowController <NSTextFieldDelegate, MPOAuthAuthenticationMethodOAuthDelegate> {
@private
    
}

@property (nonatomic, assign) IBOutlet NSBox *instruction1Box;
@property (nonatomic, assign) IBOutlet NSBox *instruction2Box;
@property (nonatomic, assign) IBOutlet NSTextField *verifierTextField;
@property (nonatomic, assign) IBOutlet NSButton *cancelButton;
@property (nonatomic, assign) IBOutlet NSButton *continueButton;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)continueButtonClicked:(id)sender;

@end
