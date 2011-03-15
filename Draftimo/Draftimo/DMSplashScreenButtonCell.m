//
//  DMSplashScreenButtonCell.m
//  Draftimo
//
//  Created by Kyle Macomber on 3/12/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSplashScreenButtonCell.h"
#import <BWToolkitFramework/BWTransparentButtonCell.h>

static NSImage *buttonLeft, *buttonFill, *buttonRight;

@implementation DMSplashScreenButtonCell

+ (void)initialize
{
    buttonLeft = [NSImage imageNamed:@"SplashScreenButtonLeft.png"];
    buttonFill = [NSImage imageNamed:@"SplashScreenButtonCenter.png"];
    buttonRight = [NSImage imageNamed:@"SplashScreenButtonRight.png"];
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSDrawThreePartImage(frame, buttonLeft, buttonFill, buttonRight, NO, NSCompositeSourceOver, 1, YES);
    if ([self isHighlighted]) {
        [[NSGraphicsContext currentContext] saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 1.0f) xRadius:5.0f yRadius:5.0f] setClip];
        [[NSColor colorWithCalibratedWhite:0.0f alpha:0.10f] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [[NSGraphicsContext currentContext] restoreGraphicsState];
    }
}

@end
