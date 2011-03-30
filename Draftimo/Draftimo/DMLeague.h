//
//  DMLeague.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/29/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DMTeam;

@interface DMLeague : NSObject {}

@property (nonatomic, copy) NSString *game; //game/name
@property (nonatomic, copy) NSString *gameID; //game/game_id
@property (nonatomic, copy) NSString *season; //game/season
@property (nonatomic, copy) NSString *gameType; //game/type = 'full'

@property (nonatomic, assign) BOOL drafted; //league/draft_status <- if there is only predraft and postdraft, then keep as a bool, but if there is indraft or something like that then make into enum
@property (nonatomic, assign) NSUInteger numTeams; //league/num_teams
@property (nonatomic, copy) NSString *leagueName; //league/name
@property (nonatomic, copy) NSString *leagueID; //league/league_id formate is game_id.l.league_id

@property (nonatomic, copy) NSString *scoringType; //league/scoring_type <- Make this an enum if I can figure out all the different values
@property (nonatomic, copy) NSArray *positions; //league/settings/roster_positions an array of DMPosition(s)
@property (nonatomic, copy) NSArray *stats; //league/settings/stat_categories an array of DMStat(s)
@property (nonatomic, copy) NSArray *teams; //an array of DMTeam(s), need separate webservice call to get this
@property (nonatomic, copy) DMTeam *userTeam; //team

@end

@interface DMPosition : NSObject {}

@property (nonatomic, copy) NSString *name; //league/settings/roster_positions/roster_positions/position
@property (nonatomic, assign) NSUInteger numStarters; //league/settings/roster_positions/roster_positions/count
@property (nonatomic, copy) NSSet *accepts; //load from plist

//- (BOOL)fulfills:(DMPosition *)otherPosition; //checks if this position is in the accepts set of otherPosition

@end

@interface DMStat : NSObject {}

@property (nonatomic, copy) NSString *abbr; //league/settings/stat_categories/stats/stat/display_name //ex: ERA
@property (nonatomic, copy) NSString *name; //league/settings/stat_categories/stats/stat/name         //ex: Earned Run Average
@property (nonatomic, assign) NSUInteger positionType; //league/settings/stat_categories/stats/stat/position_type //for baseball it is B or P... end up loading this from plist
@property (nonatomic, assign) BOOL increasing; //league/settings/stat_categories/stats/sort_order 1=increasing, 0=decreasing //also probably end up loading this from plist

@end

@interface DMTeam : NSObject {}

@property (nonatomic, copy) NSString *name; //team/name
@property (nonatomic, copy) NSString *teamID; //team/team_id
@property (nonatomic, copy) NSArray *managerNames; //team/managers/manager/nickname //an array of NSString(s)

@end