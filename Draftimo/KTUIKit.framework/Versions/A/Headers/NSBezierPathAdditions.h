//
//  NSBezierPathCategory.h
//
//  Created by Cathy Shive on 12/21/07.
//  Copyright 2007 Cathy Shive. All rights reserved.
//

// http://developer.apple.com/samplecode/Reducer/listing20.html

#import <Cocoa/Cocoa.h>


@interface NSBezierPath (RoundRect)
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(CGFloat)radius;
- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(CGFloat)radius;

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
+ (NSBezierPath *)bezierPathWithTopRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
+ (NSBezierPath *)bezierPathWithBottomRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
+ (NSBezierPath *)bezierPathWithTopRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theRadius;
+ (NSBezierPath *)bezierPathWithBottomRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theRadius;
- (void)appendBezierPathWithLeftRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
- (void)appendBezierPathWithRightRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
- (void)appendBezierPathWithTopRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
- (void)appendBezierPathWithBottomRoundedRect:(NSRect)theRect cornerRadius:(CGFloat)theCornerRadius;
@end
