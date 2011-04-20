//
//  NSKeyValueCoding-Additions.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "NSKeyValueCoding-DMAdditions.h"


@implementation NSObject (NSKeyValueCoding_DMAdditions)

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

- (BOOL)validateBoolValue:(id *)ioValue error:(NSError **)outError
{
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        *ioValue = [NSNumber numberWithBool:[(NSString *)*ioValue boolValue]];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateIntegerValue:(id *)ioValue error:(NSError **)outError
{
    if (!(*ioValue) || [*ioValue isKindOfClass:[NSNumber class]]) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        *ioValue = [NSNumber numberWithInteger:[(NSString *)*ioValue integerValue]];
        return YES;
    }
    
    return NO;
}

- (BOOL)validateEnumValue:(id *)ioValue forMapping:(NSDictionary *)map error:(NSError **)outError
{
    if (!(*ioValue)) {
        return YES;
    }
    
    if ([*ioValue isKindOfClass:[NSNumber class]]) {
        for (NSNumber *value in [map allValues]) {
            if ([*ioValue isEqualToNumber:value]) return YES;
        }
        ALog(@"Invalid Enum Value: %@", *ioValue);
        return NO;
    }
    
    if ([*ioValue isKindOfClass:[NSString class]]) {
        for (NSString *key in map) {
            if ([*ioValue isEqualToString:key]) {
                *ioValue = [map objectForKey:key];
                return YES;
            }
        }
        ALog(@"Invalid Enum Value: %@", *ioValue);
        return NO;
    }
    
    return NO;
}

@end
