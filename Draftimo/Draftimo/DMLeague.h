//
//  DMLeague.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMDraft, DMGame, DMPlayer, DMPosition, DMStat, DMTeam;

@interface DMLeague : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * scoringType;
@property (nonatomic, retain) NSNumber * numTeams;
@property (nonatomic, retain) NSNumber * drafted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * leagueID;
@property (nonatomic, retain) DMGame * game;
@property (nonatomic, retain) NSSet* stats;
@property (nonatomic, retain) NSSet* teams;
@property (nonatomic, retain) NSSet* positions;
@property (nonatomic, retain) NSSet* players;
@property (nonatomic, retain) DMDraft * draft;

- (void)addStatsObject:(DMStat *)value;
- (void)removeStatsObject:(DMStat *)value;
- (void)addStats:(NSSet *)value;
- (void)removeStats:(NSSet *)value;

- (void)addTeamsObject:(DMTeam *)value;
- (void)removeTeamsObject:(DMTeam *)value;
- (void)addTeams:(NSSet *)value;
- (void)removeTeams:(NSSet *)value;

- (void)addPositionsObject:(DMPosition *)value;
- (void)removePositionsObject:(DMPosition *)value;
- (void)addPositions:(NSSet *)value;
- (void)removePositions:(NSSet *)value;


- (void)addPlayersObject:(DMPlayer *)value;
- (void)removePlayersObject:(DMPlayer *)value;
- (void)addPlayers:(NSSet *)value;
- (void)removePlayers:(NSSet *)value;

@end
