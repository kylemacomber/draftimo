//
//  DMPosition.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/15/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import "DMPosition.h"
#import "DMLeague.h"
#import "NSKeyValueCoding-DMAdditions.h"


@implementation DMPosition
@dynamic count;
@dynamic name;
@dynamic league;

- (BOOL)validateCount:(id *)ioValue error:(NSError **)outError
{
    DLog(@"");
    return [self validateIntegerValue:ioValue error:outError];
}

@end
