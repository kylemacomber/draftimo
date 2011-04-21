//
//  KTWindowController.m
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

#import "KTWindowController.h"
#import "KTViewController.h"
#import "KTLayerController.h"

NSString *const KTWindowControllerViewControllersKey = @"viewControllers";

@interface KTWindowController ()
@property (readonly, nonatomic) NSMutableArray *primitiveViewControllers;
@end

@implementation KTWindowController

- (void)dealloc;
{
	[mPrimitiveViewControllers release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

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

- (void)insertObject:(KTViewController *)theViewController inViewControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveViewControllers] insertObject:theViewController atIndex:theIndex];
}

- (void)removeObjectFromViewControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveViewControllers] removeObjectAtIndex:theIndex];
}

#pragma mark Public View Controller API

- (void)addViewController:(KTViewController *)theViewController
{
	if (theViewController == nil) return;
	NSParameterAssert(![[self primitiveViewControllers] containsObject:theViewController]);
	[[self mutableArrayValueForKey:KTWindowControllerViewControllersKey] addObject:theViewController];
	[self _patchResponderChain];
}

- (void)removeViewController:(KTViewController *)theViewController
{
	if(theViewController == nil) return;
	[theViewController retain];
	{
		[[self mutableArrayValueForKey:KTWindowControllerViewControllersKey] removeObject:theViewController];
		[theViewController removeObservations];
	}
	[theViewController release];
	[self _patchResponderChain];
}

- (void)removeAllViewControllers
{
	NSArray *aViewControllers = [[self viewControllers] retain];
	{
		[[self mutableArrayValueForKey:KTWindowControllerViewControllersKey] removeAllObjects];
		[aViewControllers makeObjectsPerformSelector:@selector(removeObservations)];
	}
	[aViewControllers release];
	[self _patchResponderChain];
}

#pragma mark Descendants

- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
{
	BOOL aStopFlag = NO;
	for (KTViewController *aViewController in [self viewControllers]) {
		_KTViewControllerEnumerateSubControllers(aViewController, _KTControllerEnumerationOptionsNone, &aStopFlag, theCallBackFunction, theContext);
		if (aStopFlag == YES) break;
	}
}

#pragma mark -
#pragma mark KVO Teardown

- (void)removeObservations
{
	[[self viewControllers] makeObjectsPerformSelector:@selector(removeObservations)];
}

#pragma mark -
#pragma mark Responder Chain

// When patching the responder chain we don't include hidden controllers. These have their next responder set to nil. |_KTResponderChainContext| stores the first non-hidden view controller so the window controller can later set it's next responder to the first non-hidden view controller.
struct __KTResponderChainContext {
	NSResponder <KTController> *firstController;
	NSResponder <KTController> *previousController;
};
typedef struct __KTResponderChainContext _KTResponderChainContext;

NS_INLINE _KTResponderChainContext _KTResponderChainContextMake(void) {
	return (_KTResponderChainContext){.firstController = nil, .previousController = nil};
}

void _KTPatchResponderChainEnumeratorCallBack(NSResponder <KTController> *theController, BOOL *theStopFlag, void *theContext) {

	[theController setNextResponder:nil]; // All controllers have their next responder cleared out. Originally, the window controller manually set the last non-hidden controller's next responder to nil, now it doesn't have to.
	if ([theController isHidden]) { // Skip all hidden controllers, these should not respond to selectors passed up the chain.
		return;	
	}
	
	_KTResponderChainContext *aContext = (_KTResponderChainContext *)theContext;
	if ((aContext->firstController) == nil) {
		aContext->firstController = theController;
	}

	// The first time we reach here, aPreviousController will be nil, so this becomes a no-op.
	NSResponder <KTController> *aPreviousController = (aContext->previousController);
	[aPreviousController setNextResponder:theController];
	aContext->previousController = theController;
}

- (void)_patchResponderChain
{
	NSAutoreleasePool *aPool = [[NSAutoreleasePool alloc] init];
	_KTResponderChainContext aContext = _KTResponderChainContextMake();
	[self _enumerateSubControllers:&_KTPatchResponderChainEnumeratorCallBack context:&aContext];	
	[self setNextResponder:aContext.firstController]; // |firstController| is the first controller for which |hidden| returned NO.
	[aPool drain];
}

@end