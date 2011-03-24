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
enum {
    DMNavigationAnimationPush,
    DMNavigationAnimationPop
};
typedef NSUInteger DMNavigationAnimation;

static void navigationAnimations(DMNavigationAnimation pushOrPop, NSArray *leftViews, NSArray *rightViews, CGFloat distance, NSArray *auxiliaryAnimations);
- (void)pushVerifyView;
- (void)popVerifyView;
@property (nonatomic, assign) BOOL verifyViewPushed;
@end

@implementation DMAuthSheetController
@synthesize instructionBox;
@synthesize previousInstructionButton;
//Authorize View
@synthesize authorizeView;
@synthesize authorizeLabel;
//Verify View
@synthesize verifyView;
@synthesize verifyLabel;
//Private
@synthesize verifyViewPushed;

- (void)dealloc
{
    self.instructionBox = nil;
    self.previousInstructionButton = nil;
    self.authorizeView = nil;
    self.authorizeLabel = nil;
    self.verifyView = nil;
    self.verifyLabel = nil;
    self.verifyViewPushed = NO;
    [super dealloc];
}

- (id)init
{
    self = [super initWithWindowNibName:@"DMAuthSheet"];
    if (!self) return nil;
    
    [[DMAppController sharedAppController] addObserver:self forKeyPath:@"oauthController.oauthState" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //Position verifyView and authorizeView for push/pop
    [self.instructionBox addSubview:self.verifyView];
    [self.instructionBox addSubview:self.authorizeView];
    NSRect frame = self.verifyView.frame;
    frame.origin.x = NSMaxX(self.authorizeView.frame);
    self.verifyView.frame = frame;
}

#pragma KVO

//TODO: check if set oauthState to be the same thing, does it trigger a KVO notification
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%@->%@", DMOAuthStateString[[[change objectForKey:NSKeyValueChangeOldKey] unsignedIntegerValue]], DMOAuthStateString[[[change objectForKey:NSKeyValueChangeNewKey] unsignedIntegerValue]]);
    
    if ([DMAppController sharedAppController].oauthController.oauthState == DMOAuthRequestTokenRecieved) {
        [self pushVerifyView];
    }
    
    // If the UI is ahead of the oauthState we need to pop
    if (self.verifyViewPushed && [DMAppController sharedAppController].oauthController.oauthState < DMOAuthRequestTokenRecieved) {
        [self popVerifyView];
    }
    
    if ([DMAppController sharedAppController].oauthController.oauthState == DMOAuthAuthenticated) {
        [[NSApplication sharedApplication] endSheet:self.window returnCode:DMAuthSuccess]; //TODO: or rather do this after a small delay?
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

- (IBAction)previousInstructionButtonClicked:(id)sender
{
    DLog(@"");
    [self popVerifyView];
}

#pragma mark Private Methods

- (void)pushVerifyView
{
    [self.previousInstructionButton setHidden:NO];
    NSArray *const leftViews = [NSArray arrayWithObjects:self.authorizeView, self.authorizeLabel, nil];
    NSArray *const rightViews = [NSArray arrayWithObjects:self.verifyView, self.verifyLabel, nil];
    CGFloat const distance = self.authorizeView.frame.size.width;
    NSArray *const auxiliaryAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.previousInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeInEffect, NSViewAnimationEffectKey, nil], nil];
    navigationAnimations(DMNavigationAnimationPush, leftViews, rightViews, distance, auxiliaryAnimations);
    self.verifyViewPushed = YES;
}

- (void)popVerifyView
{
    NSArray *const leftViews = [NSArray arrayWithObjects:self.authorizeView, self.authorizeLabel, nil];
    NSArray *const rightViews = [NSArray arrayWithObjects:self.verifyView, self.verifyLabel, nil];
    CGFloat const distance = self.authorizeView.frame.size.width;
    NSArray *const auxiliaryAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:self.previousInstructionButton, NSViewAnimationTargetKey, NSViewAnimationFadeOutEffect, NSViewAnimationEffectKey, nil], nil];
    navigationAnimations(DMNavigationAnimationPop, leftViews, rightViews, distance, auxiliaryAnimations);
    self.verifyViewPushed = NO;
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
    
    NSTimeInterval const duration = 5.0;//((fabsf(distance)/150.0) * [[NSUserDefaults standardUserDefaults] doubleForKey:@"NSWindowResizeTime"]) / 2.0; //NSWindowResizeTime determines how quickly to resize by 150 px
    NSViewAnimation *anim = [[NSViewAnimation alloc] initWithViewAnimations:animations];
    [anim setDuration:duration];
    [anim startAnimation];
    [anim release];
}

@end
