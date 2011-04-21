//
//  DMAuthSheetController.m
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
#import "KTViewController.h"


static NSTimeInterval const DMAuthSheetSuccessDismissDelay = 2.0;

@interface DMAuthSheetController ()
@property (assign, readwrite) BOOL browserLaunched;

@property (retain) KTViewController *requestErrorViewController;
@property (retain) KTViewController *requestingViewController;
@property (retain) KTViewController *verifierViewController;

- (NSView *)contentViewForState:(DMOAuthState)state;
- (void)endSheetWithSuccess;
@end

@implementation DMAuthSheetController
@synthesize box = __box;
//** Private
@synthesize browserLaunched = __browserLaunched;
@synthesize requestErrorViewController = __requestErrorViewController;
@synthesize requestingViewController = __requestingViewController;
@synthesize verifierViewController = __verifierViewController;

+ (void)initialize
{
    NSDictionary *map;
    
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolTransformerWithYesObject:[NSColor textColor] noObject:[NSColor disabledControlTextColor]] forName:@"VerifierInstructionLabelTextColor"];
    
    map = [NSDictionary dictionaryWithObject:NSLocalizedString(@"DMOAuthUnreachable", nil) forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable]];
    [NSValueTransformer setValueTransformer:[DMOAuthStateMapTransformer authStateTransformerWithMap:map] forName:@"RequestErrorLabelValue"];
    
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
    self = [super initWithWindowNibName:ClassKey(DMAuthSheetController)];
    if (!self) return nil;
    
    self.browserLaunched = (([DMOAuthController sharedOAuthController].oauthStateMask & ~DMOAuthUnreachable) > DMOAuthRequestTokenRecieved);
    
    self.requestErrorViewController = [[KTViewController alloc] initWithNibName:@"DMAuthRequestErrorViewController" bundle:nil];
    self.requestingViewController = [[KTViewController alloc] initWithNibName:@"DMAuthRequestingViewController" bundle:nil];
    self.verifierViewController = [[KTViewController alloc] initWithNibName:@"DMAuthVerifierViewController" bundle:nil];
    [self addViewController:self.requestErrorViewController];
    [self addViewController:self.requestingViewController];
    [self addViewController:self.verifierViewController];
    
    [[DMOAuthController sharedOAuthController] addObserver:self forKeyPath:@"oauthStateMask" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    return self;
}

- (void)awakeFromNib
{
    DMOAuthState const state = [DMOAuthController sharedOAuthController].oauthStateMask;
    [self.box setContentView:[self contentViewForState:state]];
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%d->%d", [[change objectForKey:NSKeyValueChangeOldKey] unsignedIntegerValue], [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue]);
    
    DMOAuthState const state = [DMOAuthController sharedOAuthController].oauthStateMask;
    NSView *const newContentView = [self contentViewForState:state];
    if ([self.box contentView] != newContentView) {
        [self.box setContentView:newContentView];
    }
    
    DMOAuthState const reachableState = (state & ~DMOAuthUnreachable);
    self.browserLaunched = ((reachableState == DMOAuthRequestTokenRecieved && self.browserLaunched) || reachableState > DMOAuthRequestTokenRecieved);

    if (state == DMOAuthAuthenticated) {
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
    [[NSApplication sharedApplication] endSheet:[self window] returnCode:NSCancelButton];
}

- (IBAction)helpButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma mark Private Methods

- (NSView *)contentViewForState:(DMOAuthState)state
{
    if ((state & DMOAuthUnreachable) == DMOAuthUnreachable) {
        return [self.requestErrorViewController view];
    }
    
    if ((state & (DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting)) == state) {
        return [self.requestingViewController view];
    }
    
    return [self.verifierViewController view];
}

- (void)endSheetWithSuccess
{
    [[NSApplication sharedApplication] endSheet:self.window returnCode:NSOKButton];
}

@end
