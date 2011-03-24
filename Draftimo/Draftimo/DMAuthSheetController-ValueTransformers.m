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

@implementation StatusTextFieldValueNSStringTransformer
+ (Class)transformedValueClass { return [NSString class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    DLog(@"%@", DMOAuthStateString[authState]);
    DLog(@"%@", NSLocalizedString(DMOAuthStateString[authState], nil));
    return NSLocalizedString(DMOAuthStateString[authState], nil);
}
@end

@implementation StatusTextFieldTextColorNSColorTransformer
+ (Class)transformedValueClass { return [NSColor class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    switch (authState) {
        case DMOAuthRequestTokenTimeout:
        case DMOAuthRequestTokenRejected:
        case DMOAuthAccessTokenTimeout:
        case DMOAuthAccessTokenRejected:
            return [NSColor redColor];
        default:
            return [NSColor controlTextColor];
    }
}
@end

@implementation RequestTokenButtonEnabledBOOLTransformer
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:!(authState == DMOAuthRequestTokenRequesting)];
}
@end

@implementation RequestTokenProgressAnimatingBOOLTransformer
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState == DMOAuthRequestTokenRequesting)];
}
@end

@implementation VerifierImageValueNSImageTransformer
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

@implementation VerifierProgressAnimatingBOOLTransformer
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState == DMOAuthVerifierCodeWaiting || authState == DMOAuthAccessTokenRequesting)];
}
@end

@implementation VerifierTextFieldEnabledBOOLTransformer
+ (Class)transformedValueClass { return [NSNumber class]; }
- (id)transformedValue:(id)value
{
    if (![super transformedValue:value]) return nil;
    
    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
    return [NSNumber numberWithBool:(authState < DMOAuthAuthenticated)];
}
@end

//@implementation PreviousInstructionButtonVisibleBOOLTransformer
//+ (Class)transformedValueClass { return [NSNumber class]; }
//- (id)transformedValue:(id)value
//{
//    if (![super transformedValue:value]) return nil;
//    
//    const DMOAuthState authState = [(NSNumber *)value unsignedIntegerValue];
//    return [NSNumber numberWithBool:(authState >= DMOAuthRequestTokenRecieved)];
//}
//@end
