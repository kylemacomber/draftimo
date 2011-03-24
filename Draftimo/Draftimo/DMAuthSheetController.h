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

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)retryRequestButtonClicked:(id)sender;

@end

@interface DMOAuthStateTransformer : NSValueTransformer {} @end

@interface RequestTokenProgressAnimatingBOOL : DMOAuthStateTransformer {} @end
@interface ErrorStatusHiddenBOOL : DMOAuthStateTransformer {} @end
@interface ErrorStatusNSString : DMOAuthStateTransformer {} @end

@interface AccessTokenViewHiddenBOOL : DMOAuthStateTransformer {} @end
@interface BrowserLaunchedBOOL : DMOAuthStateTransformer {} @end //label, verifier enabled on this
@interface VerifierInstructionsNSColor : DMOAuthStateTransformer {} @end
@interface VerifierProgressAnimatingBOOL : DMOAuthStateTransformer {} @end
@interface VerifierFieldEnabledBOOL : DMOAuthStateTransformer {} @end
@interface VerifierStatusNSImage : DMOAuthStateTransformer {} @end

@interface AuthenticatedEnabledBOOL : DMOAuthStateTransformer {} @end
