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

	NSArray *mTopLevelNibObjects;
	
	BOOL mViewLoaded;
}

@property (readwrite, nonatomic, assign) KTWindowController *windowController;
@property (readonly, nonatomic, assign) KTViewController *parentViewController;

//@property (readwrite, nonatomic, assign) BOOL hidden;

/**
	Can be used to determine if the view for this view contorller is loaded or not. It is important to note the order of setup here. This is set to yet after the view itself is loaded (after [super loadView] returns), but directly before |-viewDidLoad| is called. This ordering ensures that calls to |viewLoaded| inside |-viewDidLoad| return YES.
 */
@property (nonatomic, readonly, getter = isViewLoaded) BOOL viewLoaded;


/*!
 @method     viewControllerWithWindowController:
 @abstract   Returns an autoreleased view controller
 @discussion The default implementation of this method calls both +[KSViewController nibName] and +[KSViewController nibBundle], both of which may return nil.
 */
+ (id)viewControllerWithWindowController:(KTWindowController *)theWindowController;

- (id)initWithNibName:(NSString *)theName bundle:(NSBundle *)theBundle windowController:(KTWindowController *)windowController;
- (BOOL)loadNibNamed:(NSString *)theNibName bundle:(NSBundle *)theBundle;

#pragma mark View Loading

/*!
 @method     nibName
 @abstract   Returns the nib name for the view controller's |view| property.
 @discussion The default implementation returns nil. Subclasses can override this behaviour, but this is only necessary when a nib is used (when not creating the view manually in -[KSViewController loadView]).
 */
+ (NSString *)nibName;

/*!
 @method     nibBundle
 @abstract   Returns the bundle in which the nib can be found.
 @discussion By default this returns +[NSBundle bundleForClass:self]. Subclasses can override this method to deviate from default behaviour.
 */
+ (NSBundle *)nibBundle;

/**
 @method viewClass
 @abstract Returns the NSView class, or a subclass thereof, that will be loaded if the view controller cannot determine a nibName to load.
 @discussion NSView, or a subclass thereof.
 */
+ (Class)viewClass;


/*!
 @method     viewWillLoad/viewDidLoad
 @abstract   Called before/after the view is loaded
 @discussion This class overrides -[NSViewController loadView] to load its view, calling -viewWillLoad and -viewDidLoad during its implementation. If -loadView is overridden in a subclass, then these methods will have to be manually invoked and |viewLoaded| must be set beofre -loadView returns. The default implementations do nothing.
 */
- (void)viewWillLoad;
- (void)viewDidLoad;

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
- (void)_setHidden:(BOOL)theHidden patchResponderChain:(BOOL)thePatch;
KT_EXPORT void _KTViewControllerEnumerateSubControllers(KTViewController *theViewController, _KTControllerEnumerationOptions theOptions, BOOL *theStopFlag, _KTControllerEnumeratorCallBack theCallBackFunction, void *theContext);
- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
- (void)_enumerateSubControllersWithOptions:(_KTControllerEnumerationOptions)theOptions callBack:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
@end
