//
//  DMLeague.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMGame, DMPosition, DMStat, DMTeam;

@interface DMLeague : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * scoringType;
@property (nonatomic, retain) NSNumber * numTeams;
@property (nonatomic, retain) NSNumber * drafted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * leagueID;
@property (nonatomic, retain) DMGame * game;
@property (nonatomic, retain) NSSet* stats;
@property (nonatomic, retain) NSSet* teams;
@property (nonatomic, retain) NSSet* positions;

@end
