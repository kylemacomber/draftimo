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

//???: Do I need to call super in these validation methods?
- (BOOL)validateGameID:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
            
    if ([*ioValue isKindOfClass:[NSString class]]) {
        const NSInteger value = [(NSString *)*ioValue integerValue];
        if (value < 1) {
            ALog(@"%d");
            return NO;
        }
        
        *ioValue = [NSNumber numberWithInteger:value];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateCode:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        DMGameCode value;
        if ([*ioValue isEqualToString:@"nfl"]) {
            value = DMGameCodeNFL;
        } else if ([*ioValue isEqualToString:@"mlb"]) {
            value = DMGameCodeMLB;
        } else if ([*ioValue isEqualToString:@"nba"]) {
            value = DMGameCodeNBA;
        } else if ([*ioValue isEqualToString:@"nhl"]) {
            value = DMGameCodeNHL;
        } else {
            NSInteger const value = [(NSString *)*ioValue integerValue];
            ALog(@"%d", value);
            if (value < 1) {
                return NO;
            }
        }
        
        *ioValue = [NSNumber numberWithUnsignedInteger:value];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateNumTeams:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {   
        NSInteger const value = [(NSString *)*ioValue integerValue];
        if (value < 1) {
            ALog(@"%d", value);
            return NO;
        }
        *ioValue = [NSNumber numberWithInteger:value];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateType:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        DMGameType value;
        if ([*ioValue isEqualToString:@"full"]) {
            value = DMGameTypeFull;
        } else {
            ALog(@"%@", *ioValue);
            return NO;
        }
        
        *ioValue = [NSNumber numberWithUnsignedInteger:value];
        return YES;
    }
    
    return NO;
}

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
