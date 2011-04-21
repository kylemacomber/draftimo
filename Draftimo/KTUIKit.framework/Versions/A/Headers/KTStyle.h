/*
 *  KTStyledView.h
 *  KTUIKit
 *
 *  Created by Cathy Shive on 11/2/08.
 *  Copyright 2008 Cathy Shive. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"

@class KTStyleManager;

@protocol KTStyle <NSObject>
@property (readwrite, nonatomic, retain) KTStyleManager *styleManager;
- (void)setNeedsDisplay:(BOOL)theBool;
- (NSWindow *)window;
@end