//
//  KTView.h
//  KTUIKit
//
//  Created by Cathy Shive on 05/20/2008.
//
// Copyright (c) Cathy Shive
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "KTUIKit" by Cathy Shive" will do.

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"
#import "KTViewProtocol.h"
#import "KTLayoutManager.h"
#import "KTStyleManager.h"

KT_EXPORT NSString *const KTViewViewLayoutManagerKey;
KT_EXPORT NSString *const KTViewStyleManagerKey;
KT_EXPORT NSString *const KTViewLabelKey;

@interface KTView : NSView <KTView, KTViewLayout> {
	@private
	KTLayoutManager *mLayoutManager;
	KTStyleManager	*mStyleManager;
	NSString		*mLabel;
	BOOL			mOpaque;
	BOOL			mMouseDownCanMoveWindow;
	BOOL			mAcceptsFirstMouse;
	BOOL			mCanBecomeKeyView;
	BOOL			mCanBecomeFirstResponder;
	BOOL			mDrawAsImage;
	NSImage			*mCachedImage;
	
	BOOL			mDrawDebuggingRect;
}

@property (nonatomic, readwrite, assign) BOOL opaque;
@property (nonatomic, readwrite, assign) BOOL mouseDownCanMoveWindow;
@property (nonatomic, readwrite, assign) BOOL acceptsFirstMouse;
@property (nonatomic, readwrite, assign) BOOL canBecomeKeyView;
@property (nonatomic, readwrite, assign) BOOL canBecomeFirstResponder;
@property (nonatomic, readwrite, assign) BOOL drawAsImage;
@property (nonatomic, readonly) NSImage * cachedImage;
@property (nonatomic, readwrite, assign) BOOL drawDebuggingRect;
- (void)drawInContext:(CGContextRef)theContext;


@end
