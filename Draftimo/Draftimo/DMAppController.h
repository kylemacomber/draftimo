//
//  DraftimoAppDelegate.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DMOAuthController.h"

@class DMWelcomeWindowController, DMAuthSheetController;

@interface DMAppController : NSObject <NSApplicationDelegate> {
    MPOAuthAPI *oauthAPI;
    DMWelcomeWindowController *welcomeWindowController;
    DMAuthSheetController *authSheetController;
}

+ (DMAppController *)sharedAppController;

@property (nonatomic, retain, readonly) DMOAuthController *oauthController;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)showSelectDraftWindow;

@end
