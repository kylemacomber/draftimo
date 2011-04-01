//
//  DMLeague.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/29/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DMTeam;
@class DMLeague;

@interface DMDraft : NSObject {}

@property (nonatomic, copy) DMLeague *league;
//some form of progress: Round for snake drafts, Players of total taken... could always give a %finished
//need to know if it is a snake draft or an auction draft

@end

@interface DMAuctionDraft : NSObject {}
@property (nonatomic, assign) NSDecimal dollarsPerTeam;
@property (nonatomic, assign) NSDecimal minBid;
@end

@interface DMSnakeDraft : NSObject {} //might ultimately make this the base class
@property (nonatomic, assign) NSUInteger pick; //from this I should be able to calculate whose pick it is as well as what round it is and what direction the picks are moving in the snake
@end

@interface DMGame: NSObject {}
@property (nonatomic, copy) NSString *game; //game/name, maybe name it sport? im afraid though itll be like Tournament Pick'em, which isn't a sport
@property (nonatomic, copy) NSString *gameID; //game/game_id
@property (nonatomic, copy) NSString *season; //game/season
@property (nonatomic, copy) NSString *gameType; //game/type = 'full'
@property (nonatomic, copy) NSString *code; //game/code ex:mlb, nfl, pmlb... might be better to make an enum of this and use this for logic rather than the sport anme designation
@property (nonatomic, copy) NSArray *leagues; //an array of DMLeague(s)
@end

@interface DMLeague : NSObject {}
@property (nonatomic, assign) BOOL drafted; //league/draft_status <- if there is only predraft and postdraft, then keep as a bool, but if there is indraft or something like that then make into enum
@property (nonatomic, assign) NSUInteger numTeams; //league/num_teams
@property (nonatomic, copy) NSString *name; //league/name
@property (nonatomic, copy) NSString *leagueID; //league/league_id

@property (nonatomic, copy) NSString *scoringType; //league/scoring_type <- Make this an enum if I can figure out all the different values
@property (nonatomic, copy) NSArray *positions; //league/settings/roster_positions an array of DMPosition(s)
@property (nonatomic, copy) NSArray *stats; //league/settings/stat_categories an array of DMStat(s)
@property (nonatomic, copy) NSArray *teams; //an array of DMTeam(s), need separate webservice call to get this
@property (nonatomic, retain) DMTeam *userTeam; //team

@property (nonatomic, copy) NSArray *players; //an array of DMPlayer(s)
@end

@interface DMPosition : NSObject {}

@property (nonatomic, copy) NSString *name; //league/settings/roster_positions/roster_positions/position
@property (nonatomic, assign) NSUInteger numStarters; //league/settings/roster_positions/roster_positions/count
@property (nonatomic, copy) NSSet *definition; //load from plist

//- (BOOL)accepts:(DMPosition *)otherPosition; //checks if otherPosition is in its definition set
//- (BOOL)fulfills:(DMPosition *)otherPosition; //checks if this position is in the definition set of otherPosition

@end

@interface DMStat : NSObject {}

@property (nonatomic, copy) NSString *name; //league/settings/stat_categories/stats/stat/display_name //ex: ERA
@property (nonatomic, copy) NSString *longName; //league/settings/stat_categories/stats/stat/name         //ex: Earned Run Average
@property (nonatomic, copy) NSString *positionType; //league/settings/stat_categories/stats/stat/position_type //for baseball it is B or P... end up loading this from plist
@property (nonatomic, assign) BOOL increasing; //league/settings/stat_categories/stats/sort_order 1=increasing, 0=decreasing //also probably end up loading this from plist
//@property (nonatomic, assign) BOOL ratio;
//@property (nonatomic, assign) ???? equation;

@end

@interface DMTeam : NSObject {}

@property (nonatomic, copy) NSString *name; //team/name
@property (nonatomic, copy) NSString *teamID; //team/team_id
@property (nonatomic, copy) NSArray *managers; //team/managers/manager/nickname //an array of NSString(s)
@property (nonatomic, copy) NSArray *players; //stores players in order they have been added to this team
@property (nonatomic, copy) NSDictionary *roster; //stores current layout of teamView (might need to make it a retained NSMutableDictionary)
@property (nonatomic, assign) NSDecimal dollars;

@end