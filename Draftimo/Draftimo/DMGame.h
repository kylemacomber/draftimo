//
//  DMGame.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague;

@interface DMGame : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * gameID;
@property (nonatomic, retain) NSString * gameType;
@property (nonatomic, retain) NSString * season;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * game;
@property (nonatomic, retain) NSSet* leagues;

- (void)addLeaguesObject:(DMLeague *)value;
- (void)removeLeaguesObject:(DMLeague *)value;
- (void)addLeagues:(NSSet *)value;
- (void)removeLeagues:(NSSet *)value;

@end
