//
//  DMBoolTransformer.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMBoolTransformer.h"


@interface DMBoolTransformer ()
- (id)initWithObject:(id)anObject;
@property (nonatomic, retain, readwrite) id object;
@end

@implementation DMBoolTransformer
@synthesize object;

+ (Class)transformedValueClass { return [NSObject class]; }

- (void)dealloc
{
    self.object = nil;
    [super dealloc];
}

+ (id)boolValueTransformerForObject:(id)anObject { return [[[self alloc] initWithObject:anObject] autorelease]; }

- (id)initWithObject:(id)anObject
{
    self = [super init];
    if (!self) return nil;
    
    self.object = anObject;
    
    return self;
}

+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"(%@) is not an NSNumber.", [value class]];
    }
    
    if ([(NSNumber *)value boolValue]) {
        return self.object;
    }
    return nil;
}

@end
