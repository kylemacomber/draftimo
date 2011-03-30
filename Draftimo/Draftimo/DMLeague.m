//
//  DMLeague.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/29/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMLeague.h"


@implementation DMLeague
@synthesize game; //game/name
@synthesize gameID; //game/game_id
@synthesize season; //game/season
@synthesize gameType; //game/type = 'full'

@synthesize  drafted; //league/draft_status <- if there is only predraft and postdraft, then keep as a bool, but if there is indraft or something like that then make into enum
@synthesize  numTeams; //league/num_teams
@synthesize leagueName; //league/name
@synthesize leagueID; //league/league_id formate is game_id.l.league_id

@synthesize scoringType; //league/scoring_type <- Make this an enum if I can figure out all the different values
@synthesize positions; //league/settings/roster_positions an array of DMPosition(s)
@synthesize stats; //league/settings/stat_categories an array of DMStat(s)
@synthesize teams; //an array of DMTeam(s), need separate webservice call to get this
@synthesize userTeam; //team
@end

@implementation DMPosition
@synthesize name; //league/settings/roster_positions/roster_positions/position
@synthesize  numStarters; //league/settings/roster_positions/roster_positions/count
@synthesize accepts; //load from plist

//- (BOOL)fulfills:(DMPosition *)otherPosition; //checks if this position is in the accepts set of otherPosition
@end

@implementation DMStat
@synthesize abbr; //league/settings/stat_categories/stats/stat/display_name //ex: ERA
@synthesize name; //league/settings/stat_categories/stats/stat/name         //ex: Earned Run Average
@synthesize  positionType; //league/settings/stat_categories/stats/stat/position_type //for baseball it is B or P... end up loading this from plist
@synthesize  increasing; //league/settings/stat_categories/stats/sort_order 1=increasing, 0=decreasing //also probably end up loading this from plist
@end

@implementation DMTeam
@synthesize name; //team/name
@synthesize teamID; //team/team_id
@synthesize managerNames; //team/managers/manager/nickname //an array of NSString(s)
@end
