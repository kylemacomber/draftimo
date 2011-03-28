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
#import "NSDictionary-Utilities.h"


static NSTimeInterval const DMAuthSheetSuccessDismissDelay = 2.0;

@interface DMAuthSheetController ()
- (void)endSheetWithSuccess;
@end

@implementation DMAuthSheetController
@synthesize requestProgressIndicator;
@synthesize requestErrorView;
@synthesize requestErrorLabel;

@synthesize verifierView;
@synthesize verifierInstructionLabel1;
@synthesize verifierInstructionLabel2;
@synthesize verifierTextField;
@synthesize verifierProgressIndicator;
@synthesize verifierStatusImageView;

@synthesize launchBrowserButton;
@synthesize cancelButton;
@synthesize helpButton;

- (void)dealloc
{
    [[DMAppController sharedAppController].oauthController removeObserver:self forKeyPath:@"oauthState"];
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    [[DMAppController sharedAppController].oauthController addObserver:self forKeyPath:@"oauthState" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    return self;
}

- (void)awakeFromNib
{
    [self.verifierTextField bind:@"value" toObject:[DMAppController sharedAppController].oauthController withKeyPath:@"verifierCode" options:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSRaisesForNotApplicableKeysBindingOption, [NSNumber numberWithBool:YES], NSContinuouslyUpdatesValueBindingOption, nil]];
    
    void (^const authStateBind) (id, NSString *, NSDictionary *, NSDictionary *) = ^(id object, NSString *binding, NSDictionary *mapping, NSDictionary *otherOptions) {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSRaisesForNotApplicableKeysBindingOption, nil];
        [options addEntriesFromDictionary:otherOptions];
        [options setObject:[DMOAuthStateMapTransformer authStateValueTransformerWithMap:mapping] forKey:NSValueTransformerBindingOption];
        [object bind:binding toObject:[DMAppController sharedAppController].oauthController withKeyPath:@"oauthState" options:[options dictionaryByAddingEntriesFromDictionary:options]];
    };
    
    authStateBind(self.requestProgressIndicator, @"animate", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting]],  [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:NSNullPlaceholderBindingOption]);
    authStateBind(self.requestErrorView, @"hidden", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~(DMOAuthUnreachable|DMOAuthRequestTokenRejected)]], nil);
    authStateBind(self.requestErrorLabel, @"value", [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"DMOAuthUnreachable", nil), [NSNumber numberWithUnsignedInteger:DMOAuthUnreachable], NSLocalizedString(@"DMOAuthRequestTokenRejected", nil), [NSNumber numberWithUnsignedInteger:DMOAuthRequestTokenRejected], nil], [NSDictionary dictionaryWithObject:NSLocalizedString(@"Error", nil) forKey:NSNullPlaceholderBindingOption]/*Does this work without NSAllowsNullArgumentBindingOption? NSNumber numberWithBool:YES*/);
    
    authStateBind(self.verifierView, @"hidden", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable|DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting|DMOAuthRequestTokenRejected]], nil);
    authStateBind(self.verifierTextField, @"enabled", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~(DMOAuthUnreachable|DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting|DMOAuthRequestTokenRejected|DMOAuthRequestTokenRecieved|DMOAuthAuthenticated)]], nil);
    authStateBind(self.verifierProgressIndicator, @"animate", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenRequesting]], [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:NSNullPlaceholderBindingOption]);
    authStateBind(self.verifierStatusImageView, @"value", [NSDictionary dictionaryWithObjectsAndKeys:[NSImage imageNamed:@"Status_Declined.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAccessTokenTimeout|DMOAuthAccessTokenRejected], [NSImage imageNamed:@"Status_Accepted.png"], [NSNumber numberWithUnsignedInteger:DMOAuthAuthenticated], nil], [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:NSConditionallySetsEnabledBindingOption]);
    
    NSDictionary *const instructionColorMap = [NSDictionary dictionaryWithObject:[NSColor disabledControlTextColor] forKey:[NSNumber numberWithUnsignedInteger:DMOAuthUnreachable|DMOAuthUnauthenticated|DMOAuthRequestTokenRequesting|DMOAuthRequestTokenRejected|DMOAuthRequestTokenRecieved]];
    NSDictionary *const instructionColorOptions = [NSDictionary dictionaryWithObject:[NSColor controlTextColor] forKey:NSNullPlaceholderBindingOption];
    authStateBind(self.verifierInstructionLabel1, @"textColor", instructionColorMap, instructionColorOptions);
    authStateBind(self.verifierInstructionLabel2, @"textColor", instructionColorMap, instructionColorOptions);
    
    authStateBind(self.launchBrowserButton, @"enabled", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]], nil);
    authStateBind(self.cancelButton, @"enabled", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]], nil);
    authStateBind(self.helpButton, @"enabled", [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithUnsignedInteger:~DMOAuthAuthenticated]], nil);
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%d->%d", [[change objectForKey:NSKeyValueChangeOldKey] unsignedIntegerValue], [[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue]);
    
    if ([DMAppController sharedAppController].oauthController.oauthState == DMOAuthAuthenticated) {
        [self performSelector:@selector(endSheetWithSuccess) withObject:nil afterDelay:DMAuthSheetSuccessDismissDelay];
    }
}

#pragma mark IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
    [[DMAppController sharedAppController].oauthController launchBrowser];
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

- (IBAction)retryRequestButtonClicked:(id)sender
{
    DLog(@"");
    [[DMAppController sharedAppController].oauthController retry];
}

#pragma mark Private Methods

- (void)endSheetWithSuccess
{
    [[NSApplication sharedApplication] endSheet:self.window returnCode:DMAuthSuccess];
}

@end
