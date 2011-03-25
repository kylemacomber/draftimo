//
//  NSDictionary-Utilities.m
//  draftimo
//
//  Created by Kyle Macomber on 3/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "NSDictionary-Utilities.h"


@implementation NSDictionary (NSDictionary_Utilities)

- (NSDictionary *)dictionaryByAddingEntriesFromDictionary:(NSDictionary *)aDictionary
{
    NSMutableDictionary *newDictionary = [[self mutableCopy] autorelease];
    [newDictionary addEntriesFromDictionary:aDictionary];
    return [[newDictionary copy] autorelease];
}

@end
