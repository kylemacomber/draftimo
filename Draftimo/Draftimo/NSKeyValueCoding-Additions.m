//
//  NSKeyValueCoding-Additions.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "NSKeyValueCoding-Additions.h"


@implementation NSObject (NSKeyValueCoding_Additions)

- (NSDictionary *)validateValuesForKeysWithDictionary:(NSDictionary *)keyedValues errors:(NSArray **)outErrors
{
    NSMutableDictionary *newKeyedValues = [NSMutableDictionary dictionary];
    
    NSMutableArray *errors = [NSMutableArray array];
    for (NSString *key in keyedValues) {
        id obj = [keyedValues objectForKey:key];
        NSError *error;
        if (![self validateValue:&obj forKey:key error:&error]) {
            [errors addObject:error];
            continue;
        }
        [newKeyedValues setObject:obj forKey:key];
    }
    
    if ([errors count]) {
        *outErrors = [[errors copy] autorelease];
    }
    
    return [[newKeyedValues copy] autorelease];
}

@end
