//
//  DMStat.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague;

@interface DMStat : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSNumber * statID;
@property (nonatomic, retain) NSNumber * increasing;
@property (nonatomic, retain) NSNumber * ratio;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * equation;
@property (nonatomic, retain) DMLeague * league;

@end
