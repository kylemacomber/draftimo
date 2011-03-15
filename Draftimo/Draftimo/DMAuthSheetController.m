//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthSheetController.h"
#import "DMAppController.h"

@interface DMAuthSheetController ()
- (void)revealInstruction2Box:(BOOL)reveal;
@end

@implementation DMAuthSheetController
@synthesize instruction1Box;
@synthesize instruction2Box;
@synthesize verifierTextField;
@synthesize cancelButton;
@synthesize continueButton;

- (void)dealloc
{
    instruction1Box = nil;
    instruction2Box = nil;
    verifierTextField = nil;
    cancelButton = nil;
    continueButton = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenReceived:) name:MPOAuthNotificationRequestTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTokenRejected:) name:MPOAuthNotificationRequestTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRejected:) name:MPOAuthNotificationAccessTokenRejected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRefreshed:) name:MPOAuthNotificationAccessTokenRefreshed object:nil];
    
    // This is kind of hacky but it has to be done
    id authMethod = [DMAppController sharedAppController].oauthAPI.authenticationMethod;
    if ([authMethod isKindOfClass: [MPOAuthAuthenticationMethodOAuth class]]) {
        [(MPOAuthAuthenticationMethodOAuth *)authMethod setDelegate:self];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
    [[DMAppController sharedAppController].oauthAPI authenticate];
    BOOL reveal = [self.instruction2Box isHidden];
    [self revealInstruction2Box:reveal];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"");
    [[NSApplication sharedApplication] endSheet:[self window] returnCode:DMAuthCancel];
}

- (IBAction)continueButtonClicked:(id)sender
{
    DLog(@"");
}

#pragma NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    DLog(@"%@", obj);
    //!!!: TODO
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    DLog(@"%@", obj);
    [[DMAppController sharedAppController].oauthAPI authenticate];
}

#pragma MPOAuthAuthenticationMethodOAuthDelegate

- (NSString *)oauthVerifierForCompletedUserAuthorization
{
	return [self.verifierTextField stringValue];
}

#pragma MPOAuthNotifications

- (void)requestTokenReceived:(NSNotification *)notification
{
	DLog(@"");
}

- (void)requestTokenRejected:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenReceived:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenRejected:(NSNotification *)notification
{
	DLog(@"");
}

- (void)accessTokenRefreshed:(NSNotification *)notification
{
	DLog(@"");
}

#pragma Private Methods

- (void)revealInstruction2Box:(BOOL)reveal
{
    
    CGFloat animationDistance = [self.instruction2Box frame].size.height + NSMinY(self.instruction1Box.frame) - NSMaxY(self.instruction2Box.frame);
    CGRect frame = [self.window frame];
    if (reveal) {
        frame.size.height += animationDistance;
        frame.origin.y -= animationDistance;
    } else {
        frame.size.height -= animationDistance;
        frame.origin.y += animationDistance;
    }
    [self.window setFrame:frame display:YES animate:YES];
    [self.instruction2Box setHidden:!reveal];
}

@end
