//
//  DMPlayer.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague, DMPosition, DMTeam;

@interface DMPlayer : NSManagedObject {
@private
}
@property (nonatomic, retain) DMTeam * team;
@property (nonatomic, retain) NSSet* positions;
@property (nonatomic, retain) DMLeague * league;

@end
