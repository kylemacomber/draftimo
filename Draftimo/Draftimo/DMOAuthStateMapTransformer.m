//
//  DMOAuthStateMapTransformer.m
//  draftimo
//
//  Created by Kyle Macomber on 3/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMOAuthStateMapTransformer.h"
#import "DMOAuthController.h"


@implementation DMOAuthStateMapTransformer

- (id)transformedValue:(id)value
{
    if (!value) return nil;
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"(%@) is not an NSNumber.", [value class]];
    }
    
    typedef BOOL(^arrayTest)(id obj, NSUInteger idx, BOOL *stop);
    arrayTest (^const testForAuthState)(DMOAuthState) = ^arrayTest (DMOAuthState state) {
        return [[^BOOL (id obj, NSUInteger idx, BOOL *stop) {
            const DMOAuthState mask = (DMOAuthState)[(NSNumber *)obj unsignedIntegerValue];
            return ((state & mask) == state);
        } copy] autorelease];
    };
    
    NSArray *const keys = [self.map allKeys];
    const DMOAuthState state = [(NSNumber *)value unsignedIntegerValue];
    
    NSUInteger idx = [keys indexOfObjectPassingTest:testForAuthState(state)];
    if ((state & DMOAuthUnreachable) == DMOAuthUnreachable) { //DMOAuthUnreachable trumps all so overwrite if it's a match
        idx = [keys indexOfObjectPassingTest:testForAuthState(DMOAuthUnreachable)];
    }
    
    if (idx == NSNotFound) return nil;
    return [self.map objectForKey:[keys objectAtIndex:idx]];
}

@end
