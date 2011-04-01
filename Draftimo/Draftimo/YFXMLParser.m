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
    
    id(^objFromNode)(Class, NSXMLNode *) = ^(Class class, NSXMLNode *xml) {
        id obj = [[[class alloc] init] autorelease];
        NSDictionary *values = [self dictForNode:xml];
        values = [obj validateValuesForKeysWithDictionary:values error:nil];
        [obj setValuesForKeysWithDictionary:values];
        return obj;
    };
    
    NSMutableArray *games = [NSMutableArray array];
    for (NSXMLNode *xgame in [doc nodesForXPath:@"./fantasy_content/users/user/games/game" error:nil]) {
        DMGame *game = objFromNode([DMGame class], xgame);
        
        NSMutableArray *leagues = [NSMutableArray array];
        for (NSXMLNode *xleague in [xgame nodesForXPath:@"./leagues/league" error:nil]) {
            DMLeague *league = objFromNode([DMLeague class], xleague);
            {
                NSXMLNode *xsettings = [[xleague nodesForXPath:@"./settings" error:nil] lastObject];
                NSDictionary *settingValues = [self dictForNode:xsettings];
                settingValues = [league validateValuesForKeysWithDictionary:settingValues error:nil];
                [league setValuesForKeysWithDictionary:settingValues];
                {
                    NSMutableArray *positions = [NSMutableArray array];
                    for (NSXMLNode *xposition in [xsettings nodesForXPath:@"./roster_positions/roster_position" error:nil]) {
                        DMPosition *position = objFromNode([DMPosition class], xposition);
                        
                        [positions addObject:position];
                    }
                    [league setValue:positions forKey:@"positions"];
                }
                {
                    NSMutableArray *stats = [NSMutableArray array];
                    for (NSXMLNode *xstat in [xsettings nodesForXPath:@"./stat_categories/stats/stat" error:nil]) {
                        if ([[xstat nodesForXPath:@"./is_only_display_stat" error:nil] count]) continue; //skip non scoring stats
                        DMStat *stat = objFromNode([DMStat class], xstat);

                        [stats addObject:stat];
                    }
                    [league setValue:stats forKey:@"stats"];
                }
            }
            
            {
                NSXMLNode *xteam = [[xleague nodesForXPath:@"./teams/team" error:nil] lastObject];
                DMTeam *userTeam = objFromNode([DMStat class], xteam);
                
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
