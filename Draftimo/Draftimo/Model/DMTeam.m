//
//  DMTeam.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMTeam.h"
#import "DMLeague.h"
#import "NSKeyValueCoding-DMAdditions.h"


@implementation DMTeam
@dynamic teamID;
@dynamic userTeam;
@dynamic name;
@dynamic budget;
@dynamic league;

- (BOOL)validateTeamID:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateIntegerValue:ioValue error:outError];
}

@end
