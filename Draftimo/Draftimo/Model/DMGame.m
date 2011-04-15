//
//  DMGame.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMGame.h"
#import "DMLeague.h"


@implementation DMGame
@dynamic gameID;
@dynamic code;
@dynamic season;
@dynamic name;
@dynamic type;
@dynamic leagues;

- (void)addLeaguesObject:(DMLeague *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"leagues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"leagues"] addObject:value];
    [self didChangeValueForKey:@"leagues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeLeaguesObject:(DMLeague *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"leagues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"leagues"] removeObject:value];
    [self didChangeValueForKey:@"leagues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addLeagues:(NSSet *)value {    
    [self willChangeValueForKey:@"leagues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"leagues"] unionSet:value];
    [self didChangeValueForKey:@"leagues" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeLeagues:(NSSet *)value {
    [self willChangeValueForKey:@"leagues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"leagues"] minusSet:value];
    [self didChangeValueForKey:@"leagues" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
