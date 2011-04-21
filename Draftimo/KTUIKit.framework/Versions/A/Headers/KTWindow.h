//
//  KTWindow.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/16/08.
//  Copyright 2008 Cathy Shive. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface KTWindow : NSWindow 
{
	BOOL		mCanBecomeKeyWindow;
}

- (void)setCanBecomeKeyWindow:(BOOL)theBool;
@end
