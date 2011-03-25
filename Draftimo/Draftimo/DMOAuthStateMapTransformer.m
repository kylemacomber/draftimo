//
//  DMOAuthStateMapTransformer.m
//  draftimo
//
//  Created by Kyle Macomber on 3/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMOAuthStateMapTransformer.h"
#import "DMOAuthController.h"


@interface DMOAuthStateMapTransformer ()
- (id)initWithMap:(NSDictionary *)aMap;
@property (nonatomic, copy, readwrite) NSDictionary *map;
@end

@implementation DMOAuthStateMapTransformer
@synthesize map;

+ (Class)transformedValueClass { return [NSObject class]; }

- (void)dealloc
{
    self.map = nil;
    [super dealloc];
}

+ (id)authStateValueTransformerWithMap:(NSDictionary *)aMap { return [[[self alloc] initWithMap:aMap] autorelease]; }

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
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"(%@) is not an NSNumber.", [value class]];
    }
    
    const DMOAuthState state = [(NSNumber *)value unsignedIntegerValue];
    
    for (id key in [self.map allKeys]) {
        const DMOAuthState mask = (DMOAuthState)[(NSNumber *)key unsignedIntegerValue];
        if ((state & mask) == state) {
            return [self.map objectForKey:key];
        }
    }
    
    return nil;
}

@end
