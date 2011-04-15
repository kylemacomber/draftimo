//
//  YFXMLParser.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "YFXMLParser.h"
#import "DMConstants.h"
#import "DMGame.h"
#import "DMLeague.h"
#import "DMTeam.h"
#import "DMPosition.h"
#import "DMStat.h"


@interface YFXMLParser ()
static inline NSDictionary *dictForNode(NSXMLNode *node);
+ (void)parseYFXMLUserLeagues:(NSString *)responseBody;
@end

@implementation YFXMLParser

#pragma mark API
+ (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    DLog(@"%@", method);
    
    if ([[method relativeString] isEqualToString:YFUserLeaguesMethod]) {
        [self parseYFXMLUserLeagues:responseBody];
    }    
}

#pragma mark Private Methods

// Returns pattern: nil or "name1" or "name1 & name2" or "name1, ... , nameN-1 & nameN"
static inline NSString *managersString(NSArray *nodes)
{
    NSMutableArray *managers = [NSMutableArray array];
    for (NSXMLNode *xmanager in nodes) {
        [managers addObject:[xmanager objectValue]];
    }
    
    NSString *last = [managers lastObject];
    if ([managers count] <= 1) return last;
    [managers removeLastObject];
    return [[managers componentsJoinedByString:@","] stringByAppendingFormat:@"& %@", last];
}

// All ManagedObject have a userInfo where the key is an XPath and the value is the attribute name
// This method initializes an entity from an appropriate XML node using this mapping
static inline id entityFromNode(NSString *entityName, NSXMLNode *node)
{
    NSManagedObjectContext *managedObjectContext = nil; //!!!:INCORRECT REPLACE WITH POINTER TO ACTUAL MANAGED OBJECT CONTEXT
    id entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    NSEntityDescription *const entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    NSDictionary *const attributesMap = [entityDescription userInfo];
    
    for (NSString *attributeName in [[entityDescription attributesByName] allKeys]) {
        id value = [[[node nodesForXPath:[attributesMap objectForKey:attributeName] error:nil] lastObject] objectValue];
        if (!value) continue;
        
        NSError *error;
        if (![entity validateValue:&value forKey:attributeName error:&error]) {
            ALog(@"%@", error);
        }
        [entity setValue:value forKey:attributeName];
    }
    
    return entity;
};

+ (void)parseYFXMLUserLeagues:(NSString *)responseBody
{
    DLog(@"%@", responseBody);
    NSError *error;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:responseBody options:NSXMLDocumentValidate error:&error];
    if (!doc) {
        ALog(@"%@", error); //maybe find a way to call web service again
    }
    
    NSMutableSet *games = [NSMutableSet set];
    for (NSXMLNode *xgame in [doc nodesForXPath:@"./fantasy_content/users/user/games/game" error:nil]) {
        DMGame *game = entityFromNode(@"DMGame", xgame);
        [games addObject:game];
        //Leagues
        for (NSXMLNode *xleague in [xgame nodesForXPath:@"./leagues/league" error:nil]) {
            DMLeague *league = entityFromNode(@"DMLeague", xleague);
            [game addLeaguesObject:league];
            // Positions
            for (NSXMLNode *xposition in [xleague nodesForXPath:@"./settings/roster_positions/roster_position" error:nil]) {
                [league addPositionsObject:entityFromNode(@"DMPosition", xposition)];
            }
            // Stats
            for (NSXMLNode *xstat in [xleague nodesForXPath:@"./settings/stat_categories/stats/stat" error:nil]) {
                if ([[xstat nodesForXPath:@"./is_only_display_stat" error:nil] count]) continue; //skip non scoring stats
                [league addPositionsObject:entityFromNode(@"DMStat", xstat)];
            }
            // Team
            NSXMLNode *const xteam = [[xleague nodesForXPath:@"./teams/team" error:nil] lastObject];
            DMTeam *userTeam = entityFromNode(@"DMTeam", xteam);
            [userTeam setValue:[NSNumber numberWithBool:YES] forKey:@"userTeam"];
            [userTeam setValue:managersString([xteam nodesForXPath:@"./managers/manager/nickname" error:nil]) forKey:@"managers"];
            [league addTeamsObject:userTeam];
        }
    }
    DLog(@"%@", games);
    [doc release];
}

@end
