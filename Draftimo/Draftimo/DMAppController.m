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
#import "YFUserLeaguesParser.h"
#import "DMLeague.h"


@interface DMAppController ()
@property (nonatomic, retain, readwrite) DMOAuthController *oauthController;
@property (nonatomic, retain) DMWelcomeWindowController *welcomeWindowController;
@property (nonatomic, retain) DMAuthSheetController *authSheetController;

- (void)showWelcomeWindow;
- (void)getUserGames;
@end

@implementation DMAppController
@synthesize oauthController;
@synthesize welcomeWindowController;
@synthesize authSheetController;

- (void)dealloc
{
    self.oauthController = nil;
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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
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

- (NSDictionary *)dictForNode:(NSXMLNode *)node
{
    NSDictionary *YFtoDM;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSXMLNode *child in [node children]) {
        NSString *const dmKey = [YFtoDM objectForKey:[child XPath]]; //or [child name]
        if (!dmKey) continue;
        [dict setObject:[child objectValue] forKey:dmKey];
    }
    return dict;
}

- (void)performedMethodLoadForURL:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    DLog(@"%@", method);
    NSError *error;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:responseBody options:NSXMLDocumentValidate error:&error];
    if (error) {
        ALog(@""); //maybe find a way to call getUserGames or whatever method
    }
    
    NSMutableArray *games = [NSMutableArray array];
    for (NSXMLNode *xgame in [doc nodesForXPath:@"./fantasy_content/users/user/games/game" error:nil]) {
        DMGame *game = [[[DMGame alloc] init] autorelease];
        [games addObject:game];
        [game setValuesForKeysWithDictionary:[self dictForNode:xgame]];
        
        NSMutableArray *leagues = [NSMutableArray array];
        for (NSXMLNode *xleague in [xgame nodesForXPath:@"./leagues/league" error:nil]) {
            DMLeague *league = [[[DMLeague alloc] init] autorelease];
            [leagues addObject:league];
            [league setValuesForKeysWithDictionary:[self dictForNode:xleague]];
            
            {
                NSXMLNode *xsettings = [[xleague nodesForXPath:@"./settings" error:nil] lastObject];
                [league setValuesForKeysWithDictionary:[self dictForNode:xsettings]];
                {
                    NSMutableArray *positions = [NSMutableArray array];
                    for (NSXMLNode *xposition in [xsettings nodesForXPath:@"./roster_positions/roster_position" error:nil]) {
                        DMPosition *position = [[[DMPosition alloc] init] autorelease];
                        [positions addObject:position];
                        [position setValuesForKeysWithDictionary:[self dictForNode:xposition]];
                    }
                    [league setValue:positions forKey:@"positions"];
                }
                {
                    NSMutableArray *stats = [NSMutableArray array];
                    for (NSXMLNode *xstat in [xsettings nodesForXPath:@"./stat_categories/stats/stat" error:nil]) {
                        DMPosition *stat = [[[DMPosition alloc] init] autorelease];
                        [stats addObject:stat];
                        [stat setValuesForKeysWithDictionary:[self dictForNode:xstat]];
                    }
                    [league setValue:stats forKey:@"stats"];
                }
            }
            
            {
                DMTeam *userTeam = [[[DMTeam alloc] init] autorelease];
                NSXMLNode *xteam = [[xleague nodesForXPath:@"./teams/team" error:nil] lastObject];
                [userTeam setValuesForKeysWithDictionary:[self dictForNode:xteam]];
                
                NSMutableArray *managers = [NSMutableArray array];
                for (NSXMLNode *xmanager in [xteam nodesForXPath:@"./managers/manager/nickname" error:nil]) {
                    [managers addObject:[xmanager objectValue]];
                }
                
                [userTeam setValue:managers forKey:@"managers"];
                [league setValue:userTeam forKey:@"userTeam"];
            }
        }
    }
}

- (void)getUserGames
{
    [self.oauthController performYFMethod:YFUserLeaguesMethod withParameters:nil withTarget:self andAction:@selector(performedMethodLoadForURL:withResponseBody:)];
}

@end