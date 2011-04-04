//
//  DMLeague.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/29/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMLeague.h"


@implementation DMDraft
@synthesize league;
//some form of progress: Round for snake drafts, Players of total taken... could always give a %finished
//need to know if it is a snake draft or an auction draft

@end

@implementation DMAuctionDraft
@synthesize dollarsPerTeam;
@synthesize minBid;
@end

@implementation DMSnakeDraft
@synthesize pick; //from this I should be able to calculate whose pick it is as well as what round it is and what direction the picks are moving in the snake
@end

@implementation DMGame
@synthesize game; //game/name
@synthesize gameID; //game/game_id
@synthesize season; //game/season
@synthesize gameType; //game/type = 'full'
@synthesize code;
@synthesize leagues;
@end

@implementation DMLeague
@synthesize drafted;
- (BOOL)validateDrafted:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        *ioValue = [*ioValue isEqualToString:@"postdraft"] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
        return YES;
    }
    
    return NO;
}

@synthesize numTeams;
- (BOOL)validateNumTeams:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        const NSInteger value = [(NSString *)*ioValue integerValue];
        if (value < 1) {
            return NO;
        }
        
        *ioValue = [NSNumber numberWithInteger:value];
        return YES;
    }
    
    return NO;
}

@synthesize name; //league/name
@synthesize leagueID; //league/league_id formate is game_id.l.league_id

@synthesize scoringType; //league/scoring_type <- Make this an enum if I can figure out all the different values
@synthesize positions; //league/settings/roster_positions an array of DMPosition(s)
@synthesize stats; //league/settings/stat_categories an array of DMStat(s)
@synthesize teams; //an array of DMTeam(s), need separate webservice call to get this
@synthesize userTeam; //team

@synthesize players;
@end

@implementation DMPosition
@synthesize name; //league/settings/roster_positions/roster_positions/position
@synthesize numStarters; //league/settings/roster_positions/roster_positions/count
- (BOOL)validateNumStarters:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        const NSInteger value = [(NSString *)*ioValue integerValue];
        if (value < 1) {
            return NO;
        }
        
        *ioValue = [NSNumber numberWithInteger:value];
        return YES;
    }
    
    return NO;
}

@synthesize definition; //load from plist

//- (BOOL)accepts:(DMPosition *)otherPosition; //checks if otherPosition is in its definition set
//- (BOOL)fulfills:(DMPosition *)otherPosition; //checks if this position is in the accepts set of otherPosition
@end

@implementation DMStat
@synthesize name; //league/settings/stat_categories/stats/stat/display_name //ex: ERA
@synthesize longName; //league/settings/stat_categories/stats/stat/name         //ex: Earned Run Average
@synthesize positionType; //league/settings/stat_categories/stats/stat/position_type //for baseball it is B or P... probably end up doing this differently -- load from plist which positions respond to which stats
@synthesize increasing; //league/settings/stat_categories/stats/sort_order 1=increasing, 0=decreasing //also probably end up loading this from plist
- (BOOL)validateIncreasing:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        *ioValue = ([*ioValue isEqualToString:@"1"] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO]);
        return YES;
    }
    
    return NO;
}
@end

@implementation DMTeam
@synthesize name; //team/name
@synthesize teamID; //team/team_id
@synthesize managers; //team/managers/manager/nickname //an array of NSString(s)
@synthesize players;
@synthesize roster;
@synthesize dollars;
@end
