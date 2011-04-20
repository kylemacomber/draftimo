//
//  DMBoolTransformer.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMBoolTransformer.h"


@interface DMBoolTransformer ()
- (id)initWithYesObject:(id)theYesObject noObject:(id)theNoObject;
@property (nonatomic, retain, readwrite) id yesObject;
@property (nonatomic, retain, readwrite) id noObject;
@end

@implementation DMBoolTransformer
@synthesize yesObject = __yesObject;
@synthesize noObject = __noObject;

+ (Class)transformedValueClass { return [NSObject class]; }

+ (id)boolTransformerWithYesObject:(id)yesObject noObject:(id)noObject 
{
    return [[self alloc] initWithYesObject:yesObject noObject:noObject];
}

- (id)initWithYesObject:(id)theYesObject noObject:(id)theNoObject
{
    self = [super init];
    if (!self) return nil;
    
    self.yesObject = theYesObject;
    self.noObject = theNoObject;
    
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
        return self.yesObject;
    } else {
        return self.noObject;
    }
}

@end
