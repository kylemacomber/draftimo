//
//  DMAuthSheetController.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTWindowController.h"
#import "DMOAuthController.h"


@class KTViewController;
@interface DMAuthSheetController : KTWindowController {
@private
    NSBox *__box;
    BOOL __browserLaunched;
    KTViewController *__requestErrorViewController;
    KTViewController *__requestingViewController;
    KTViewController *__verifierViewController;
}

@property (retain) IBOutlet NSBox *box;
@property (assign, readonly) BOOL browserLaunched;

- (id)init;
- (IBAction)launchBrowserButtonClicked:(id)sender;
- (IBAction)helpButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
@end
