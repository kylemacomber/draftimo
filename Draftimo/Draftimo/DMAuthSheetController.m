//
//  DMAuthWindowController.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMAuthSheetController.h"
#import "DMAppController.h"
#import "DMColoredView.h"

@interface DMAuthSheetController ()
enum {
    DMNavigationAnimationPush,
    DMNavigationAnimationPop
};
typedef NSUInteger DMNavigationAnimation;
static void navigationAnimations(DMNavigationAnimation pushOrPop, NSArray *leftViews, NSArray *rightViews, CGFloat distance, NSArray *auxiliaryAnimations);
@end

@implementation DMAuthSheetController
@synthesize instructionBox;
@synthesize verifierTextField;
@synthesize verifierProgressIndicator;
@synthesize verifierConfirmationImageView;
@synthesize cancelButton;
@synthesize continueButton;
@synthesize nextInstructionButton;
@synthesize previousInstructionButton;
@synthesize authorizeView;
@synthesize authorizeLabel;
@synthesize verifyView;
@synthesize verifyLabel;
@synthesize errorLabel;

- (void)dealloc
{
    verifierTextField = nil;
    cancelButton = nil;
    continueButton = nil;
    //TODO:nil out IBOutlets
    
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenReceived:) name:MPOAuthNotificationAccessTokenReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessTokenRejected:) name:MPOAuthNotificationAccessTokenRejected object:nil];
    
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
    
    [self.instructionBox addSubview:self.verifyView];
    [self.instructionBox addSubview:self.authorizeView];
    NSRect frame = self.verifyView.frame;
    frame.origin.x = NSMaxX(self.authorizeView.frame);
    self.verifyView.frame = frame;
}

#pragma mark IBActions

- (IBAction)launchBrowserButtonClicked:(id)sender
{
    DLog(@"");
    [[DMAppController sharedAppController].oauthAPI authenticate];    
    [self nextInstructionButtonClicked:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    DLog(@"");
    [[NSApplication sharedApplication] endSheet:[self window] returnCode:DMAuthCancel];
}

- (IBAction)doneButtonClicked:(id)sender
{
    DLog(@"");
}

- (IBAction)nextInstructionButtonClicked:(id)sender
{
    if (sender) { DLog(@""); }
    [self.previousInstructionButton setHidden:NO];
    NSArray *const leftViews = [NSArray arrayWithObjects:self.authorizeView, self.authorizeLabel, nil];
    NSArray *const rightViews = [NSArray arrayWithObjects:self.verifyView, self.verifyLabel, nil];
    CGFloat const distance = self.authorizeView.frame.size.width;
    NSArray *const auxiliaryAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.previousInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil], [NSDictionary dictionaryWithObjectsAndKeys:self.nextInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey, nil], nil];
    navigationAnimations(DMNavigationAnimationPush, leftViews, rightViews, distance, auxiliaryAnimations);
}

- (IBAction)previousInstructionButtonClicked:(id)sender
{
    DLog(@"");
    //Auth Housekeeping
    [[DMAppController sharedAppController].oauthAPI discardCredentials];
    [NSObject cancelPreviousPerformRequestsWithTarget:[DMAppController sharedAppController].oauthAPI selector:@selector(authenticate) object:nil];
    [self.verifierTextField setStringValue:@""];
    
    //Animation
    [self.nextInstructionButton setHidden:NO];
    NSArray *const leftViews = [NSArray arrayWithObjects:self.authorizeView, self.authorizeLabel, nil];
    NSArray *const rightViews = [NSArray arrayWithObjects:self.verifyView, self.verifyLabel, nil];
    CGFloat const distance = self.authorizeView.frame.size.width;
    NSArray *const auxiliaryAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.previousInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey, nil], [NSDictionary dictionaryWithObjectsAndKeys:self.nextInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil], nil];
    navigationAnimations(DMNavigationAnimationPop, leftViews, rightViews, distance, auxiliaryAnimations);
}

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    DLog(@"%@", obj);
    [NSObject cancelPreviousPerformRequestsWithTarget:[DMAppController sharedAppController].oauthAPI selector:@selector(authenticate) object:nil];
    [[DMAppController sharedAppController].oauthAPI performSelector:@selector(authenticate) withObject:nil afterDelay:3.0];
    
    [self.verifierProgressIndicator startAnimation:nil];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    DLog(@"%@", obj);
    [[DMAppController sharedAppController].oauthAPI authenticate];
}

#pragma mark MPOAuthAuthenticationMethodOAuthDelegate

- (NSString *)oauthVerifierForCompletedUserAuthorization
{
	return [self.verifierTextField stringValue];
}

#pragma mark MPOAuthNotifications

- (void)accessTokenReceived:(NSNotification *)notification
{
	DLog(@"");
    [self.verifierProgressIndicator stopAnimation:nil];
    [self.verifierConfirmationImageView setImage:[NSImage imageNamed:@"Status_Accepted.png"]];
    [self.verifierConfirmationImageView setHidden:NO];
    
    [self.verifierTextField resignFirstResponder];
    [[NSApplication sharedApplication] endSheet:self.window returnCode:DMAuthSuccess];
}

- (void)accessTokenRejected:(NSNotification *)notification
{
	DLog(@"");
    [self.verifierProgressIndicator stopAnimation:nil];
    [self.verifierConfirmationImageView setImage:[NSImage imageNamed:@"Status_Declined.png"]];
    [self.verifierConfirmationImageView setHidden:NO];
}

#pragma mark Private Functions

void navigationAnimations(DMNavigationAnimation pushOrPop, NSArray *leftViews, NSArray *rightViews, CGFloat distance, NSArray *auxiliaryAnimations)
{
    NSMutableArray *const animations = [NSMutableArray arrayWithArray:auxiliaryAnimations];
    
    if (pushOrPop == DMNavigationAnimationPush) { 
        distance = -distance;
        for (NSView *view in rightViews) { [view setHidden:NO]; }
    } else /*DMNavigationAnimationPop*/ {
        for (NSView *view in leftViews) { [view setHidden:NO]; }
    }
    
    __block NSString *fadeEffect = (pushOrPop == DMNavigationAnimationPush) ? NSViewAnimationFadeOutEffect : NSViewAnimationFadeInEffect;
    void (^animBlock)(id, NSUInteger, BOOL *) = ^(id view, NSUInteger idx, BOOL *stop) {
        NSRect frame = ((NSView *)view).frame;
        frame.origin.x += distance;
        [animations addObject:[NSDictionary dictionaryWithObjectsAndKeys:view, NSViewAnimationTargetKey, [NSValue valueWithRect:frame], NSViewAnimationEndFrameKey, fadeEffect, NSViewAnimationEffectKey, nil]];
    };
    
    [leftViews enumerateObjectsUsingBlock:animBlock];
    fadeEffect = (pushOrPop == DMNavigationAnimationPush) ? NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect;
    [rightViews enumerateObjectsUsingBlock:animBlock];
    
    NSTimeInterval const duration = ((fabsf(distance)/150.0) * [[NSUserDefaults standardUserDefaults] doubleForKey:@"NSWindowResizeTime"]) / 2.0; //NSWindowResizeTime determines how quickly to resize by 150 px
    NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations:animations];
    [anim setDuration:duration];
    [anim startAnimation];
    [anim release];
}



@end
