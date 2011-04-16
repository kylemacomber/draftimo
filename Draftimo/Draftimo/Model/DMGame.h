//
//  DMGame.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


enum {
    DMGameTypeFull
};
typedef NSUInteger DMGameType;

enum {
    DMGameCodeNFL,
    DMGameCodeMLB,
    DMGameCodeNBA,
    DMGameCodeNHL
};
typedef NSUInteger DMGameCode;

@class DMLeague;
@interface DMGame : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * gameID;
@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) NSString * season;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet* leagues;

@end
