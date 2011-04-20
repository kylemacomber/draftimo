//
//  DMStat.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMStat.h"
#import "DMLeague.h"
#import "NSKeyValueCoding-DMAdditions.h"


@implementation DMStat
@dynamic abbreviation;
@dynamic statID;
@dynamic increasing;
@dynamic ratio;
@dynamic name;
@dynamic equation;
@dynamic league;

- (BOOL)validateStatID:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateIntegerValue:ioValue error:outError];
}

- (BOOL)validateIncreasing:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateBoolValue:ioValue error:outError];
}

@end
