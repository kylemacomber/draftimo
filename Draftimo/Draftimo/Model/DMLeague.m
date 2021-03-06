//
//  DMLeague.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMLeague.h"
#import "DMGame.h"
#import "DMPosition.h"
#import "DMStat.h"
#import "DMTeam.h"
#import "NSKeyValueCoding-DMAdditions.h"


@implementation DMLeague
@dynamic scoringType;
@dynamic numTeams;
@dynamic drafted;
@dynamic name;
@dynamic leagueID;
@dynamic game;
@dynamic stats;
@dynamic teams;
@dynamic positions;

- (BOOL)validateScoringType:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithUnsignedInteger:DMScoringTypeRoto], @"roto",
                         [NSNumber numberWithUnsignedInteger:DMScoringTypeH2H], @"head", nil];
    return [self validateEnumValue:ioValue forMapping:map error:outError];
}

- (BOOL)validateNumTeams:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateIntegerValue:ioValue error:outError];
}

- (BOOL)validateDrafted:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithBool:YES], @"postdraft",
                         [NSNumber numberWithBool:NO], @"predraft", nil];
    return [self validateEnumValue:ioValue forMapping:map error:outError];
}

- (BOOL)validateLeagueID:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateIntegerValue:ioValue error:outError];
}

- (DMTeam *)userTeam
{
    NSSet *userTeams = [self.teams objectsPassingTest:^BOOL(id team, BOOL *stop) {
        return [[(DMTeam *)team userTeam] boolValue];
    }];
    ZAssert([userTeams count] == 1, @"More than 1 User Team");
    return [userTeams anyObject];
}

#pragma mark Generated Methods

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


- (void)addTeamsObject:(DMTeam *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"teams"] addObject:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTeamsObject:(DMTeam *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"teams"] removeObject:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTeams:(NSSet *)value {    
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"teams"] unionSet:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTeams:(NSSet *)value {
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"teams"] minusSet:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


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
