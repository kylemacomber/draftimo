//
//  NSKeyValueCoding-Additions.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "NSKeyValueCoding-Additions.h"


@implementation NSObject (NSKeyValueCoding_Additions)
- (NSDictionary *)validateValuesForKeysWithDictionary:(NSDictionary *)keyedValues error:(NSError **)outError
{
    NSMutableDictionary *newKeyedValues = [NSMutableDictionary dictionary];
    for (NSString *key in keyedValues) {
        id obj = [keyedValues objectForKey:key];
        if (![self validateValue:&obj forKey:key error:outError]) continue;
        [newKeyedValues setObject:obj forKey:key];
    }
    
    return [[newKeyedValues copy] autorelease];
}
@end
