//
//  PlayerFetcherOperation.m
//  PlayerFetcher
//
//  Created by Kyle Macomber on 4/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "PlayerFetcherOperation.h"
#import <MPOAuth/MPOAuth.h>
#import "NSURLResponse+Encoding.h"


NSString *const MLBSportKey = @"mlb";
NSString *const NFLSportKey = @"nfl";
NSString *const NBASportKey = @"nba";
NSString *const NHLSportKey = @"nhl";

@interface PlayerFetcherOperation ()
@property (copy) NSString *sportKey;
@property (copy) NSURL *baseURL;
@property (assign) NSUInteger index;
@property (retain) id credentials;
@end

@implementation PlayerFetcherOperation
@synthesize sportKey = __sportKey;
@synthesize baseURL = __baseURL;
@synthesize index = __index;
@synthesize credentials = __credentials;

static NSDictionary *playerFromNode(NSXMLNode *node);

- (id)initWithSport:(NSString *)sportKey
{
    self = [super init];
    if (!self) return nil;
    
    self.sportKey = sportKey;
    
    return self;
}

- (void)main
{
    self.index = 0;
    self.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://fantasysports.yahooapis.com/fantasy/v2/game/%@/", self.sportKey]];
    NSDictionary *const credentials = [NSDictionary dictionaryWithObjectsAndKeys:@"dj0yJmk9QTJBaWhuTnozYXN4JmQ9WVdrOWNHaElObXhQTnpJbWNHbzlNVE13TVRZeE1UWTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mNg--", kMPOAuthCredentialConsumerKey, @"a6cf76b76796d6afb558b604eaa1166e77cbfe6c", kMPOAuthCredentialConsumerSecret, nil];
    NSURL *const authURL = [NSURL URLWithString:@"https://api.login.yahoo.com/oauth/v2/"]; //This is only necessary bc MPOAuth whines with a nil authURL
    MPOAuthAPI *OAuthAPI = [[MPOAuthAPI alloc] initWithCredentials:credentials authenticationURL:authURL andBaseURL:authURL autoStart:NO];
    self.credentials = OAuthAPI.credentials;
    
    NSMutableArray *players = [NSMutableArray array];
    while (YES) {
        NSURL *const requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"players;count=25;start=%d", self.index] relativeToURL:self.baseURL];
        MPOAuthURLRequest *const request = [[MPOAuthURLRequest alloc] initWithURL:requestURL andParameters:nil];
        MPOAuthURLResponse *OAuthResponse = nil;
        NSData *responseData = [MPOAuthConnection sendSynchronousRequest:request usingCredentials:self.credentials returningResponse:&OAuthResponse error:nil];
        NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:[OAuthResponse.urlResponse encoding]];
        
        NSError *error;
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:responseBody options:NSXMLDocumentValidate error:&error];
        DLog(@"%@", doc);
        if (!doc) { ALog(@"%@", error); }
        NSArray *playerNodes = [doc nodesForXPath:@"//player" error:&error];
        if (![playerNodes count]) { DLog(@"%@", error); break; }
        
        for (NSXMLNode *playerNode in playerNodes) {
            [players addObject:playerFromNode(playerNode)];
        }
        
        self.index += 25;
    }
    if (![players writeToFile:[[NSString stringWithFormat:@"~/Dropbox/Public/Draftimo/%@/Players.plist", self.sportKey] stringByExpandingTildeInPath] atomically:YES]) { ALog(@"Failed to write %@ players to dropbox", self.sportKey); }
}

static NSDictionary *playerFromNode(NSXMLNode *node)
{
    NSMutableDictionary *player = [NSMutableDictionary dictionary];
    [player setObject:[[[node nodesForXPath:@"./player_id" error:nil] lastObject] objectValue] forKey:@"playerID"];
    [player setObject:[[[node nodesForXPath:@"./name/ascii_first" error:nil] lastObject] objectValue] forKey:@"firstName"];
    [player setObject:[[[node nodesForXPath:@"./name/ascii_last" error:nil] lastObject] objectValue] forKey:@"lastName"];
    [player setObject:[[[node nodesForXPath:@"./editorial_team_full_name" error:nil] lastObject] objectValue] forKey:@"teamName"];
    [player setObject:[[[node nodesForXPath:@"./editorial_team_abbr" error:nil] lastObject] objectValue] forKey:@"teamAbbr"];    
    [player setObject:[[node nodesForXPath:@"./eligible_positions/position" error:nil] valueForKey:@"objectValue"] forKey:@"positions"];
    [player setObject:[NSNumber numberWithBool:[(NSString *)[[[node nodesForXPath:@"./has_player_notes" error:nil] lastObject] objectValue] boolValue]] forKey:@"news"];
    [player setObject:[NSNumber numberWithBool:[(NSString *)[[[node nodesForXPath:@"./has_recent_player_notes" error:nil] lastObject] objectValue] boolValue]] forKey:@"recentNews"];    
    return player;
}

@end
