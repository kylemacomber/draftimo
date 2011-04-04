//
//  DMPosition.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMPosition.h"
#import "DMLeague.h"
#import "DMPlayer.h"
#import "DMPosition.h"
#import "DMStat.h"


@implementation DMPosition
@dynamic count;
@dynamic name;
@dynamic league;
@dynamic accepts;
@dynamic stats;
@dynamic players;
@dynamic fulfills;


- (void)addAcceptsObject:(DMPosition *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accepts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accepts"] addObject:value];
    [self didChangeValueForKey:@"accepts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAcceptsObject:(DMPosition *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accepts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accepts"] removeObject:value];
    [self didChangeValueForKey:@"accepts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccepts:(NSSet *)value {    
    [self willChangeValueForKey:@"accepts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accepts"] unionSet:value];
    [self didChangeValueForKey:@"accepts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccepts:(NSSet *)value {
    [self willChangeValueForKey:@"accepts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accepts"] minusSet:value];
    [self didChangeValueForKey:@"accepts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addStatsObject:(DMStat *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"stats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stats"] addObject:value];
    [self didChangeValueForKey:@"stats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStatsObject:(DMStat *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"stats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stats"] removeObject:value];
    [self didChangeValueForKey:@"stats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStats:(NSSet *)value {    
    [self willChangeValueForKey:@"stats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"stats"] unionSet:value];
    [self didChangeValueForKey:@"stats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStats:(NSSet *)value {
    [self willChangeValueForKey:@"stats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"stats"] minusSet:value];
    [self didChangeValueForKey:@"stats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addPlayersObject:(DMPlayer *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"players"] addObject:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlayersObject:(DMPlayer *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"players"] removeObject:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlayers:(NSSet *)value {    
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"players"] unionSet:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlayers:(NSSet *)value {
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"players"] minusSet:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addFulfillsObject:(DMPosition *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"fulfills"] addObject:value];
    [self didChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeFulfillsObject:(DMPosition *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"fulfills"] removeObject:value];
    [self didChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addFulfills:(NSSet *)value {    
    [self willChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"fulfills"] unionSet:value];
    [self didChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeFulfills:(NSSet *)value {
    [self willChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"fulfills"] minusSet:value];
    [self didChangeValueForKey:@"fulfills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
