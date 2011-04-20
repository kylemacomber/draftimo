//
//  DMUnboxTransformer.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/18/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMUnboxTransformer.h"


@implementation DMUnboxTransformer

+ (Class)transformedValueClass { return [NSObject class]; }

+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if ([value isKindOfClass:[NSArray class]] && ([value count] <= 1)) {
        return [value lastObject];
    }
    
    if ([value isKindOfClass:[NSSet class]] && ([value count] <= 1)) {
        return [value anyObject];
    }
    
    return value;
}

@end
