//
//  YFXMLParser.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "YFXMLParser.h"
#import "DMConstants.h"
#import "DMLeague.h"
#import "NSKeyValueCoding-Additions.h"


@interface YFXMLParser ()
+ (void)parseYFXMLUserLeagues:(NSString *)responseBody;
@end

@implementation YFXMLParser

static NSDictionary *YFtoDM= nil;
+ (void)initialize
{
    if (!YFtoDM) {
        YFtoDM = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YFtoDMMap" ofType:@"plist"]];
    }
}

#pragma mark API
+ (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    DLog(@"%@", method);
    if ([[method relativeString] isEqualToString:YFUserLeaguesMethod]) {
        [self parseYFXMLUserLeagues:responseBody];
    }    
}

#pragma mark Private Methods

+ (NSDictionary *)dictForNode:(NSXMLNode *)node
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSXMLNode *child in [node children]) {
        NSString *const dmKey = [YFtoDM valueForKeyPath:[NSString stringWithFormat:@"%@.%@", [node name], [child name]]];
        if (!dmKey) continue;
        [dict setObject:[child objectValue] forKey:dmKey];
    }
    return dict;
}

+ (void)parseYFXMLUserLeagues:(NSString *)responseBody
{
    NSError *error;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:responseBody options:NSXMLDocumentValidate error:&error];
    if (error) {
        ALog(@""); //maybe find a way to call getUserGames or whatever method
    }
    
    NSMutableArray *games = [NSMutableArray array];
    for (NSXMLNode *xgame in [doc nodesForXPath:@"./fantasy_content/users/user/games/game" error:nil]) {
        DMGame *game = [[[DMGame alloc] init] autorelease];
        NSDictionary *gameValues = [self dictForNode:xgame];
        gameValues = [game validateValuesForKeysWithDictionary:gameValues error:nil];
        [game setValuesForKeysWithDictionary:gameValues];
        
        NSMutableArray *leagues = [NSMutableArray array];
        for (NSXMLNode *xleague in [xgame nodesForXPath:@"./leagues/league" error:nil]) {
            DMLeague *league = [[[DMLeague alloc] init] autorelease];
            NSDictionary *leagueValues = [self dictForNode:xleague];
            leagueValues = [league validateValuesForKeysWithDictionary:leagueValues error:nil];
            [league setValuesForKeysWithDictionary:leagueValues];
            
            {
                NSXMLNode *xsettings = [[xleague nodesForXPath:@"./settings" error:nil] lastObject];
                NSDictionary *settingValues = [self dictForNode:xsettings];
                settingValues = [league validateValuesForKeysWithDictionary:leagueValues error:nil];
                [league setValuesForKeysWithDictionary:settingValues];
                {
                    NSMutableArray *positions = [NSMutableArray array];
                    for (NSXMLNode *xposition in [xsettings nodesForXPath:@"./roster_positions/roster_position" error:nil]) {
                        DMPosition *position = [[[DMPosition alloc] init] autorelease];                
                        NSDictionary *positionValues = [self dictForNode:xposition];
                        positionValues = [position validateValuesForKeysWithDictionary:positionValues error:nil];
                        [position setValuesForKeysWithDictionary:positionValues];
                        [positions addObject:position];
                    }
                    [league setValue:positions forKey:@"positions"];
                }
                {
                    NSMutableArray *stats = [NSMutableArray array];
                    for (NSXMLNode *xstat in [xsettings nodesForXPath:@"./stat_categories/stats/stat" error:nil]) {
                        if ([[xstat nodesForXPath:@"./is_only_display_stat" error:nil] count]) continue; //skip non scoring stats
                        DMStat *stat = [[[DMStat alloc] init] autorelease];
                        NSDictionary *statValues = [self dictForNode:xstat];
                        statValues = [stat validateValuesForKeysWithDictionary:statValues error:nil];
                        [stat setValuesForKeysWithDictionary:statValues];
                        [stats addObject:stat];
                    }
                    [league setValue:stats forKey:@"stats"];
                }
            }
            
            {
                DMTeam *userTeam = [[[DMTeam alloc] init] autorelease];
                NSXMLNode *xteam = [[xleague nodesForXPath:@"./teams/team" error:nil] lastObject];
                
                NSDictionary *teamValues = [self dictForNode:xteam];
                teamValues = [userTeam validateValuesForKeysWithDictionary:teamValues error:nil];
                [userTeam setValuesForKeysWithDictionary:teamValues];
                
                NSMutableArray *managers = [NSMutableArray array];
                for (NSXMLNode *xmanager in [xteam nodesForXPath:@"./managers/manager/nickname" error:nil]) {
                    [managers addObject:[xmanager objectValue]];
                }
                
                [userTeam setValue:managers forKey:@"managers"];
                [league setValue:userTeam forKey:@"userTeam"];
            }
            [leagues addObject:league];
        }
        [game setValue:leagues forKey:@"leagues"];
        [games addObject:game];
    }
}

@end
