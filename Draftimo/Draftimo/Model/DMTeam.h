//
//  DMTeam.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague, DMPlayer;

@interface DMTeam : NSManagedObject {
@private
}
@property (nonatomic, retain) id roster;
@property (nonatomic, retain) NSString * teamID;
@property (nonatomic, retain) NSDecimalNumber * budget;
@property (nonatomic, retain) NSNumber * userTeam;
@property (nonatomic, retain) NSString * managers;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DMLeague * league;
@property (nonatomic, retain) NSSet* players;

@end
