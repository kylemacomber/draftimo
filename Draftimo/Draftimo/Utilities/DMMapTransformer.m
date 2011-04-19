//
//  DMMapTransformer.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMMapTransformer.h"


@interface DMMapTransformer ()
- (id)initWithMap:(NSDictionary *)aMap;
@property (nonatomic, copy, readwrite) NSDictionary *map;
@end

@implementation DMMapTransformer
@synthesize map = __map;

+ (Class)transformedValueClass { return [NSObject class]; }

- (id)initWithMap:(NSDictionary *)aMap
{
    self = [super init];
    if (!self) return nil;
    
    self.map = aMap;
    
    return self;
}

+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    
    return [self.map objectForKey:value];
}

@end

