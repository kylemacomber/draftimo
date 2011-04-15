//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthSheetController.h"
#import "DMOAuthStateMapTransformer.h"
#import "DMBoolTransformer.h"
#import "NSDictionary-Utilities.h"
#import "DMOAuthController.h"


static NSTimeInterval const DMAuthSheetSuccessDismissDelay = 2.0;

@interface DMAuthSheetController ()
@property (nonatomic, assign, readwrite) BOOL browserLaunched;

- (void)endSheetWithSuccess;
@end

@implementation DMAuthSheetController
//** Private
@synthesize browserLaunched;

+ (void)initialize
{
    NSDictionary *map;
    
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolTransformerWithYesObject:[NSColor textColor] noObject:[NSColor disabledControlTextColor]] forName:@"VerifierInstructionLabelTextColor"];
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"RequestProgressIndicatorAnimateTransformer"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~(DMOAuthUnreachable)]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"RequestErrorViewHiddenTransformer"];
    map = [NSDictionary dictionaryWithObject:NSLocalizedString(@"DMOAuthUnreachable", nil) forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"RequestErrorLabelValue"];
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable|DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"VerifierViewHiddenTransformer"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthRequestTokenRecieved|DMOAuthAccessTokenRequesting|DMOAuthAccessTokenTimeout]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"VerifierTextFieldEnabled"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"VerifierProgressIndicatorAnimate"];
    map = [NSDictionary dictionaryWithObjectsAndKeys:[NSImage imageNamed:@"Status_Declined.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenTimeout], [NSImage imageNamed:@"Status_Accepted.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAuthenticated], nil];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"VerifierStatusImageViewValue"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"LaunchBrowserButtonEnabled"];
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"CancelButtonEnabled"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"HelpButtonEnabled"];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    self.browserLaunched = (([DMOAuthController sharedOAuthController].oauthStateMask & ~DMOAuthUnreachable) > DMOAuthRequestTokenRecieved);
    [[DMOAuthController sharedOAuthController] addObserver:self forKeyPath:@"oauthStateMask" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    return self;
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%d->%d", [[change objectForKey:NSKeyValueChangeOldKey] unsignedIntegerValue], [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue]);
    
    const DMOAuthState reachableState = ([DMOAuthController sharedOAuthController].oauthStateMask & ~DMOAuthUnreachable);
    self.browserLaunched = ((reachableState == DMOAuthRequestTokenRecieved && self.browserLaunched) || reachableState > DMOAuthRequestTokenRecieved);

    if ([DMOAuthController sharedOAuthController].oauthStateMask == DMOAuthAuthenticated) {
        [self performSelector:@selector(endSheetWithSuccess) withObject:nil afterDelay:DMAuthSheetSuccessDismissDelay];
    }
}

#pragma mark IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
    self.browserLaunched = YES;
    [[NSWorkspace sharedWorkspace] openURL:[DMOAuthController sharedOAuthController].userAuthURL];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"");
    [[NSApplication sharedApplication] endSheet:[self window] returnCode:DMAuthCancel];
}

- (IBAction)helpButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma mark Private Methods

- (void)endSheetWithSuccess
{
    [[NSApplication sharedApplication] endSheet:self.window returnCode:DMAuthSuccess];
}

@end
