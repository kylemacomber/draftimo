//
//  KTViewController.h
//  View Controllers
//
//  Created by Jonathan Dann and Cathy Shive on 14/04/2008.
//
// Copyright (c) 2008 Jonathan Dann and Cathy Shive
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
// For example, "Contains "View Controllers" by Jonathan Dann and Cathy Shive" will do.

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"
#import "KTController.h"

KT_EXPORT NSString *const KTViewControllerViewControllersKey;
KT_EXPORT NSString *const KTViewControllerLayerControllersKey;

@class KTWindowController;
@class KTLayerController;

@interface KTViewController : NSViewController <KTController> {
	@private
	KTWindowController *wWindowController;
	KTViewController *wParentViewController;
	
	NSMutableArray *mPrimitiveViewControllers;
	NSMutableArray *mPrimitiveLayerControllers;

	BOOL mHidden;
}

@property (readonly, nonatomic, assign) KTWindowController *windowController;
@property (readonly, nonatomic, assign) KTViewController *parentViewController;

#pragma mark View Controllers

@property (readonly, nonatomic, copy) NSArray *viewControllers;
- (void)addViewController:(KTViewController *)theViewController;
- (void)removeViewController:(KTViewController *)theViewController;
- (void)removeAllViewControllers;

#pragma mark Layer Controllers

@property (readonly, nonatomic, copy) NSArray *layerControllers;
- (void)addLayerController:(KTLayerController *)theLayerController;
- (void)removeLayerController:(KTLayerController *)theLayerController;

@end

@interface KTViewController (KTPrivate)
@property (readwrite, nonatomic, assign) KTWindowController *windowController;
- (void)_setHidden:(BOOL)theHidden patchResponderChain:(BOOL)thePatch;
KT_EXPORT void _KTViewControllerEnumerateSubControllers(KTViewController *theViewController, _KTControllerEnumerationOptions theOptions, BOOL *theStopFlag, _KTControllerEnumeratorCallBack theCallBackFunction, void *theContext);
- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
- (void)_enumerateSubControllersWithOptions:(_KTControllerEnumerationOptions)theOptions callBack:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
@end
