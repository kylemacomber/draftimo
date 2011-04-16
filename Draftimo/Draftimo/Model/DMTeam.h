//
//  DMTeam.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague;

@interface DMTeam : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * teamID;
@property (nonatomic, retain) NSNumber * userTeam;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * budget;
@property (nonatomic, retain) DMLeague * league;

@end
