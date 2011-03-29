//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthSheetController.h"
#import "DMAppController.h"
#import "DMOAuthStateMapTransformer.h"
#import "DMBoolTransformer.h"
#import "NSDictionary-Utilities.h"


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
    
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolValueTransformerForObject:[NSColor controlTextColor]] forName:@"VerifierInstructionLabelTextColor"]; //we might need a more complicated value transformer to give disableTextColor when browserLaunched=NO
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"RequestProgressIndicatorAnimateTransformer"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~(DMOAuthUnreachable)]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"RequestErrorViewHiddenTransformer"];
    map = [NSDictionary dictionaryWithObject:NSLocalizedString(@"DMOAuthUnreachable", nil) forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"RequestErrorLabelValue"];
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable|DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"VerifierViewHiddenTransformer"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthRequestTokenRecieved|DMOAuthAccessTokenRequesting|DMOAuthAccessTokenTimeout]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"VerifierTextFieldEnabled"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenRequesting]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"VerifierProgressIndicatorAnimate"];
    map = [NSDictionary dictionaryWithObjectsAndKeys:[NSImage imageNamed:@"Status_Declined.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenTimeout], [NSImage imageNamed:@"Status_Accepted.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAuthenticated], nil];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"VerifierStatusImageViewValue"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"LaunchBrowserButtonEnabled"];
    
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"CancelButtonEnabled"];
    map = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:map] forName:@"HelpButtonEnabled"];
}

- (void)dealloc
{
    [[DMAppController sharedAppController].oauthController removeObserver:self forKeyPath:@"oauthStateMask"];
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    self.browserLaunched = (([DMAppController sharedAppController].oauthController.oauthStateMask & ~DMOAuthUnreachable) > DMOAuthRequestTokenRecieved);
    [[DMAppController sharedAppController].oauthController addObserver:self forKeyPath:@"oauthStateMask" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    return self;
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%d->%d", [[change objectForKey:NSKeyValueChangeOldKey] unsignedIntegerValue], [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue]);
    
    const DMOAuthState reachableState = ([DMAppController sharedAppController].oauthController.oauthStateMask & ~DMOAuthUnreachable);
    self.browserLaunched = ((reachableState == DMOAuthRequestTokenRecieved && self.browserLaunched) || reachableState > DMOAuthRequestTokenRecieved);

    if ([DMAppController sharedAppController].oauthController.oauthStateMask == DMOAuthAuthenticated) {
        [self performSelector:@selector(endSheetWithSuccess) withObject:nil afterDelay:DMAuthSheetSuccessDismissDelay];
    }
}

#pragma mark IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
    self.browserLaunched = YES;
    [[NSWorkspace sharedWorkspace] openURL:[DMAppController sharedAppController].oauthController.userAuthURL];
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
