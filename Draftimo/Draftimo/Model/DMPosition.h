//
//  DMPosition.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague;

@interface DMPosition : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DMLeague * league;

@end
