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

@interface DMAuthSheetController : NSWindowController <NSTextFieldDelegate> {
@private
    NSBox *instructionBox;
    // Authorize View
    NSView *authorizeView;
    NSTextField *authorizeLabel;
    // Verify View
    NSView *verifyView;
    NSTextField *verifyLabel;
}

@property (nonatomic, assign) IBOutlet NSBox *instructionBox;
@property (nonatomic, assign) IBOutlet NSButton *previousInstructionButton;
// Authorize View
@property (nonatomic, assign) IBOutlet NSView *authorizeView;
@property (nonatomic, assign) IBOutlet NSTextField *authorizeLabel;
// Verify View
@property (nonatomic, assign) IBOutlet NSView *verifyView;
@property (nonatomic, assign) IBOutlet NSTextField *verifyLabel;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)previousInstructionButtonClicked:(id)sender;

@end

@interface DMOAuthStateTransformer : NSValueTransformer {} @end
@interface StatusTextFieldValueNSStringTransformer : NSValueTransformer {} @end
@interface StatusTextFieldTextColorNSColorTransformer : NSValueTransformer {} @end
@interface RequestTokenButtonEnabledBOOLTransformer : NSValueTransformer {} @end
@interface RequestTokenProgressAnimatingBOOLTransformer : NSValueTransformer {} @end
@interface VerifierImageValueNSImageTransformer : NSValueTransformer {} @end
@interface VerifierProgressAnimatingBOOLTransformer : NSValueTransformer {} @end
@interface VerifierTextFieldEnabledBOOLTransformer : NSValueTransformer {} @end
//@interface PreviousInstructionButtonVisibleBOOLTransformer : NSValueTransformer {} @end
