//
//  DMStat.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMStat.h"
#import "DMLeague.h"
#import "DMPosition.h"


@implementation DMStat

- (BOOL)validateIncreasing:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        *ioValue = [NSNumber numberWithBool:[*ioValue boolValue]];
        return YES;
    }
    
    return NO;
}

#pragma Generated

@dynamic longName;
@dynamic increasing;
@dynamic ratio;
@dynamic name;
@dynamic equation;
@dynamic league;
@dynamic positions;


- (void)addPositionsObject:(DMPosition *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"positions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"positions"] addObject:value];
    [self didChangeValueForKey:@"positions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePositionsObject:(DMPosition *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"positions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"positions"] removeObject:value];
    [self didChangeValueForKey:@"positions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPositions:(NSSet *)value {    
    [self willChangeValueForKey:@"positions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"positions"] unionSet:value];
    [self didChangeValueForKey:@"positions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePositions:(NSSet *)value {
    [self willChangeValueForKey:@"positions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"positions"] minusSet:value];
    [self didChangeValueForKey:@"positions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
