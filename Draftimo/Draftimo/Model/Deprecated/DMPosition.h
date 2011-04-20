//
//  DMPosition.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague, DMPlayer, DMPosition, DMStat;

@interface DMPosition : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DMLeague * league;
@property (nonatomic, retain) NSSet* accepts;
@property (nonatomic, retain) NSSet* stats;
@property (nonatomic, retain) NSSet* players;
@property (nonatomic, retain) NSSet* fulfills;

@end
