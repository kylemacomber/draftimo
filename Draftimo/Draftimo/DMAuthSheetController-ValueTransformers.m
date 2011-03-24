//
//  DMAuthSheetController-ValueTransformers.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/23/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthSheetController.h"
#import "DMOAuthController.h"


@implementation DMOAuthStateTransformer
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value
{
    if (![value isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"(%@) is not an NSNumber.", [value class]];
    }
    
    return value;
}
@end

@implementation RequestTokenProgressAnimatingBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState == DMOAuthUnauthenticated || authState == DMOAuthRequestTokenRequesting)];
}
@end

@implementation ErrorStatusHiddenBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:!(authState == DMOAuthUnreachable || authState == DMOAuthRequestTokenRejected)];
}
@end

@implementation ErrorStatusNSString
+ (Class)transformedValueClass { return [NSString class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    if (authState == DMOAuthUnreachable) {
        return NSLocalizedString(@"DMOAuthUnreachable", nil);
    } else if (authState == DMOAuthRequestTokenRejected) {
        return NSLocalizedString(@"DMOAuthRequestTokenRejected", nil);
    }
    
    return NSLocalizedString(@"Error", nil);
}
@end

@implementation AccessTokenViewHiddenBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState < DMOAuthRequestTokenRecieved)];
}
@end

@implementation BrowserLaunchedBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState >= DMOAuthBrowserLaunched)];
}
@end

@implementation VerifierInstructionsNSColor
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return (authState >= DMOAuthBrowserLaunched) ? [NSColor controlTextColor] : [NSColor disabledControlTextColor];
}
@end

@implementation VerifierProgressAnimatingBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState == DMOAuthVerifierCodeWaiting || authState == DMOAuthAccessTokenRequesting)];
}
@end

@implementation VerifierFieldEnabledBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState >= DMOAuthBrowserLaunched && authState != DMOAuthAuthenticated)];
}
@end

@implementation VerifierStatusNSImage
+ (Class)transformedValueClass { return [NSImage class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    switch (authState) {
        case DMOAuthAccessTokenTimeout:
        case DMOAuthAccessTokenRejected:
            return [NSImage imageNamed:@"Status_Declined.png"];;
        case DMOAuthAuthenticated:
            return [NSImage imageNamed:@"Status_Accepted.png"];
        default:
            return nil;
    }
}
@end

@implementation AuthenticatedEnabledBOOL
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState != DMOAuthAuthenticated)];
}
@end
