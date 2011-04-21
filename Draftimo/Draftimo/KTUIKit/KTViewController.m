//
//  KTViewController.m
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

#import "KTViewController.h"
#import "KTWindowController.h"
#import "KTLayerController.h"

NSString *const KTViewControllerViewControllersKey = @"viewControllers";
NSString *const KTViewControllerLayerControllersKey = @"layerControllers";

@interface KTViewController ()
@property (readwrite, nonatomic, assign, setter = _setParentViewController:) KTViewController *parentViewController;

@property (readonly, nonatomic) NSMutableArray *primitiveViewControllers;
@property (readonly, nonatomic) NSMutableArray *primitiveLayerControllers;

- (void)_setHidden:(BOOL)theHiddenFlag patchResponderChain:(BOOL)thePatchFlag;
@end

@implementation KTViewController
@synthesize windowController = wWindowController;
@synthesize parentViewController = wParentViewController;
@synthesize hidden = mHidden;


- (id)initWithNibName:(NSString *)theNibName bundle:(NSBundle *)theBundle windowController:(KTWindowController *)theWindowController;
{
	if ((self = [super initWithNibName:theNibName bundle:theBundle])) {
		wWindowController = theWindowController;
	}
	return self;
}

- (void)dealloc;
{
	[mPrimitiveViewControllers release];
	[mPrimitiveLayerControllers release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@ hidden:%@", [super description], [self isHidden] ? @"YES" : @"NO"];
}

- (void)setWindowController:(KTWindowController *)theWindowController;
{
	if (wWindowController == theWindowController) return;
	wWindowController = theWindowController;
	[[self viewControllers] makeObjectsPerformSelector:@selector(setWindowController:) withObject:theWindowController];
	[theWindowController _patchResponderChain];
}

- (void)setHidden:(BOOL)theHidden;
{
	[self _setHidden:theHidden patchResponderChain:YES];
}

- (void)_setHidden:(BOOL)theHidden patchResponderChain:(BOOL)thePatch;
{
	if (mHidden == theHidden) return;
	mHidden = theHidden;	
	
	for (KTViewController *aViewController in [self viewControllers]) {
		[aViewController _setHidden:theHidden patchResponderChain:NO];
	}
	
	for (KTLayerController *aLayerController in [self layerControllers]) {
		[aLayerController _setHidden:theHidden patchResponderChain:NO];
	}
	
	if (thePatch) {
		[[self windowController] _patchResponderChain];			
	}
}

#pragma mark View Controllers

- (NSMutableArray *)primitiveViewControllers;
{
	if (mPrimitiveViewControllers != nil) return mPrimitiveViewControllers;
	mPrimitiveViewControllers = [[NSMutableArray alloc] init];
	return mPrimitiveViewControllers;
}

- (NSArray *)viewControllers;
{
	return [[[self primitiveViewControllers] copy] autorelease];
}

- (NSUInteger)countOfViewControllers;
{
	return [[self primitiveViewControllers] count];
}

- (id)objectInViewControllersAtIndex:(NSUInteger)theIndex;
{
	return [[self primitiveViewControllers] objectAtIndex:theIndex];
}

// These methods are merely for mutating the |primitiveViewControllers| array. See the public |-add/removeViewController:| methods for places where connections to other view controllers are maintained and |removeObservations| is called.
- (void)insertObject:(KTViewController *)theViewController inViewControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveViewControllers] insertObject:theViewController atIndex:theIndex];
}

- (void)removeObjectFromViewControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveViewControllers] removeObjectAtIndex:theIndex];
}

#pragma mark Public View Controller API

- (void)addViewController:(KTViewController *)theViewController;
{
	if (theViewController == nil) return;
	NSParameterAssert(![[self primitiveViewControllers] containsObject:theViewController]);
	[[self mutableArrayValueForKey:KTViewControllerViewControllersKey] addObject:theViewController];
	[theViewController _setParentViewController:self];
	[[self windowController] _patchResponderChain];
}

- (void)removeViewController:(KTViewController *)theViewController;
{
	if (theViewController == nil) return;
	NSParameterAssert([[self primitiveViewControllers] containsObject:theViewController]);
	[theViewController retain];
	{
		[[self mutableArrayValueForKey:KTViewControllerViewControllersKey] removeObject:theViewController];
		[theViewController removeObservations];
		[theViewController _setParentViewController:nil];		
	}
	[theViewController release];
	[[self windowController] _patchResponderChain];
}

- (void)removeAllViewControllers;
{
	NSArray *aViewControllers = [[self primitiveViewControllers] retain];
	{
		[[self mutableArrayValueForKey:KTViewControllerViewControllersKey] removeAllObjects];
		[aViewControllers makeObjectsPerformSelector:@selector(removeObservations)];
		[aViewControllers makeObjectsPerformSelector:@selector(_setParentViewController:) withObject:nil];		
	}
	[aViewControllers release];
	[[self windowController] _patchResponderChain];
}

#pragma mark Layer Controllers

- (NSMutableArray *)primitiveLayerControllers;
{
	if (mPrimitiveLayerControllers != nil) return mPrimitiveLayerControllers;
	mPrimitiveLayerControllers = [[NSMutableArray alloc] init];
	return mPrimitiveLayerControllers;
}

- (NSArray *)layerControllers;
{
	return [[[self primitiveLayerControllers] copy] autorelease];
}

- (NSUInteger)countOfLayerControllers;
{
	return [[self primitiveLayerControllers] count];
}

- (id)objectInLayerControllersAtIndex:(NSUInteger)theIndex;
{
	return [[self primitiveLayerControllers] objectAtIndex:theIndex];
}

- (void)insertObject:(KTLayerController *)theLayerController inLayerControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveLayerControllers] insertObject:theLayerController atIndex:theIndex];
}

- (void)removeObjectFromLayerControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveLayerControllers] removeObjectAtIndex:theIndex];
}

- (void)addLayerController:(KTLayerController *)theLayerController;
{
	if (theLayerController == nil) return;
	NSParameterAssert(![[self primitiveLayerControllers] containsObject:theLayerController]);
	[[self mutableArrayValueForKey:KTViewControllerLayerControllersKey] addObject:theLayerController];
	[[self windowController] _patchResponderChain];
}

- (void)removeLayerController:(KTLayerController *)theLayerController;
{
	if (theLayerController == nil) return;
	NSParameterAssert([[self primitiveLayerControllers] containsObject:theLayerController]);
	[theLayerController retain];
	{
		[[self mutableArrayValueForKey:KTViewControllerLayerControllersKey] addObject:theLayerController];
		[theLayerController removeObservations];
	}
	[theLayerController release];
	[[self windowController] _patchResponderChain];
}

#pragma mark -
#pragma mark Descedants

static void _KTDescendantsAggregate(NSResponder <KTController> *theController, BOOL *theStopFlag, void *theContext) {
	CFMutableArrayRef aContext = (CFMutableArrayRef)theContext;
	CFArrayAppendValue(aContext, theController);
}

- (NSArray *)descendants
{
	CFMutableArrayRef aMutableDescendants = CFArrayCreateMutable(kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
	[self _enumerateSubControllers:&_KTDescendantsAggregate context:aMutableDescendants];	
	CFArrayRef aDescendants = CFArrayCreateCopy(kCFAllocatorDefault, aMutableDescendants);
	CFRelease(aMutableDescendants);
	return [NSMakeCollectable(aDescendants) autorelease];
}

// As the view controllers are stored in a tree structure, if we want to stop the enumeration, we need to be able to pass the stop flag down through each invocation.
void _KTViewControllerEnumerateSubControllers(KTViewController *theViewController, _KTControllerEnumerationOptions theOptions, BOOL *theStopFlag, _KTControllerEnumeratorCallBack theCallBackFunction, void *theContext)
{
	NSCParameterAssert(theStopFlag != NULL);
	if (*theStopFlag == YES) return; // I'm not convinced this early return is necessary, but it's more defensive. The breaks in the loops should be taking care that we don't continue the recursion.
	
	theCallBackFunction(theViewController, theStopFlag, theContext);
	if (*theStopFlag == YES) return;
	
	/*
	 1) Enumerate our child view controllers
	 2) Enumerate our child layer controllers
	 // FIXME: The problem we have here is that we can enumerate (depth-first) down the whole tree of view controllers before conceptually moving back to the start (with self as the root) and doing the same for layer controllers. I wonder if, for each level we should enumerate all the child controllers, before moving down to the next level. The enumeration order is incorrect here, making layer controllers second-class citizens.
	 */
	
	BOOL aShouldIncludeHiddenControllers = ((theOptions & _KTControllerEnumerationOptionsIncludeHiddenControllers) != 0);
	
	BOOL aShouldIgnoreViewControllers = ((theOptions & _KTControllerEnumerationOptionsIgnoreViewControllers) != 0);
	if (!aShouldIgnoreViewControllers) {
		NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
		for (KTViewController *aViewController in [theViewController viewControllers]) {
			if (!aShouldIncludeHiddenControllers && [aViewController isHidden]) continue;
			_KTViewControllerEnumerateSubControllers(aViewController, theOptions, theStopFlag, theCallBackFunction, theContext);
			if (*theStopFlag == YES) break;
		}
		[aPool drain];
	}
	
	if (*theStopFlag == YES) return;
	
	BOOL aShouldIgnoreLayerControllers = ((theOptions & _KTControllerEnumerationOptionsIgnoreLayerControllers) != 0);
	if (!aShouldIgnoreLayerControllers) {
		NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
		for (KTLayerController *aLayerController in [theViewController layerControllers]) {
			if (!aShouldIncludeHiddenControllers && [aLayerController isHidden]) continue;
			_KTLayerControllerEnumerateSubControllers(aLayerController, theOptions, theStopFlag, theCallBackFunction, theContext);
			if (*theStopFlag == YES) break;
		}
		[aPool drain];
	}
}

- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
{
	[self _enumerateSubControllersWithOptions:_KTControllerEnumerationOptionsNone callBack:theCallBackFunction context:theContext];
}

- (void)_enumerateSubControllersWithOptions:(_KTControllerEnumerationOptions)theOptions callBack:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
{
	BOOL aStopFlag = NO;
	_KTViewControllerEnumerateSubControllers(self, theOptions, &aStopFlag, theCallBackFunction, theContext);
}

#pragma mark -
#pragma mark KVO Teardown

- (void)removeObservations
{
	[[self viewControllers] makeObjectsPerformSelector:@selector(removeObservations)];
	[[self layerControllers] makeObjectsPerformSelector:@selector(removeObservations)];
}

@end
