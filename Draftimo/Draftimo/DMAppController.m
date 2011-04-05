//
//  DraftimoAppDelegate.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAppController.h"
#import "DMConstants.h"
#import "DMWelcomeWindowController.h"
#import "DMAuthSheetController.h"
#import "DMLeague.h"
#import "YFXMLParser.h"


static NSString *const DMStoreFilename = @"Drafts.xml";

@interface DMAppController ()
@property (nonatomic, retain, readwrite) DMOAuthController *oauthController;
@property (nonatomic, retain, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) DMWelcomeWindowController *welcomeWindowController;
@property (nonatomic, retain) DMAuthSheetController *authSheetController;

- (void)showWelcomeWindow;
- (void)getUserGames;
@end

@implementation DMAppController
@synthesize oauthController;
@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;
@synthesize welcomeWindowController;
@synthesize authSheetController;

- (void)dealloc
{
    self.oauthController = nil;
    self.managedObjectModel = nil;
    self.managedObjectContext = nil;
    self.persistentStoreCoordinator = nil;
    self.welcomeWindowController = nil;
    self.authSheetController = nil;
    [super dealloc];
}

+ (DMAppController *)sharedAppController
{
    return [[NSApplication sharedApplication] delegate];
}

#pragma mark NSApplicationDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification 
{
    // Note this code cannot be put in applicationDidFinishLaunching according to http://stackoverflow.com/questions/49510/
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *url = (NSURL *)[event paramDescriptorForKeyword:keyDirectObject];
    DLog(@"%@", url);
}

// Returns a NSURL to ~/Library/Application\ Support/Draftimo/ and mkdir -p if it doesn't exist
static inline NSURL *appDirectory() {
    NSError *error;
    NSURL *appDirectory = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if (!appDirectory) {
        ALog(@"%@, %@", error, [error userInfo]);
        return nil;
    }
    
    appDirectory = [appDirectory URLByAppendingPathComponent:@"Draftimo"];
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[appDirectory path] withIntermediateDirectories:YES attributes:nil error:&error]) {
        ALog(@"%@", error);
        return nil;
    }

    return appDirectory;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel] autorelease];
    self.managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    NSURL *storeURL = [appDirectory() URLByAppendingPathComponent:DMStoreFilename];
	NSError *error;
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		ALog(@"%@, %@", error, [error userInfo]);
    }
    ZAssert(self.managedObjectModel && self.persistentStoreCoordinator && self.managedObjectContext, @"");
    
    self.oauthController = [[[DMOAuthController alloc] init] autorelease];
    [self showWelcomeWindow];
}

- (void)applicationWillTerminate:(NSNotification *)notification {

}

#pragma mark App Navigation

- (void)showWelcomeWindow
{
    if (!self.welcomeWindowController) {
        self.welcomeWindowController = [[[DMWelcomeWindowController alloc] init] autorelease];
    }
    
    [self.welcomeWindowController showWindow:nil];
}

- (void)showSelectDraftWindow
{
    DLog(@"");
    if (![self.oauthController oauthStateMaskMatches:DMOAuthAuthenticated] && ![self.oauthController oauthStateMaskMatches:DMOAuthAccessTokenRefreshing]) {
        if (!self.authSheetController) {
            self.authSheetController = [[[DMAuthSheetController alloc] init] autorelease];
        }
        [[NSApplication sharedApplication] beginSheet:self.authSheetController.window modalForWindow:self.welcomeWindowController.window modalDelegate:self didEndSelector:@selector(authSheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
        
        return;
    }
    
    DLog(@"Launch Select Draft Window");
    [self getUserGames];
}

#pragma AuthWindow ModalDelegate

- (void)authSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    DLog(@"");
    if (returnCode == DMAuthCancel) {
        [sheet orderOut:self];
        return;
    }
    
    [sheet orderOut:self];
    self.authSheetController = nil;
    [self showSelectDraftWindow];
}

#pragma mark Private Methods

- (void)getUserGames
{
    [self.oauthController performYFMethod:YFUserLeaguesMethod withParameters:nil withTarget:[YFXMLParser class] andAction:@selector(parseYFXMLMethod:withResponseBody:)];
}

@end