//
//  KTOpenGLLayerController.m
//  KTUIKit
//
//  Created by Cathy on 27/02/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTLayerController.h"
#import "KTViewController.h"
#import "KTWindowController.h"

NSString *const KTLayerControllerLayerControllersKey = @"layerControllers";

@interface KTLayerController ()
@property (readwrite, nonatomic, assign, setter = _setParentLayerController:) KTLayerController *parentLayerController;
@property (readonly, nonatomic) NSMutableArray *primitiveLayerControllers;
@property (readonly, nonatomic) KTWindowController *_windowController; 
@end

@implementation KTLayerController

@synthesize viewController = wViewController;
@synthesize parentLayerController = wParentLayerController;

@synthesize representedObject = mRepresentedObject;
@synthesize layer = mLayer;
@synthesize hidden = mHidden;

+ (id)layerControllerWithViewController:(KTViewController *)theViewController;
{
	return [[[self alloc] initWithViewController:theViewController] autorelease];
}

- (id)initWithViewController:(KTViewController *)theViewController;
{
	if ((self = [self init])) {
		wViewController = theViewController;
	}
	return self;
}

- (void)dealloc;
{
	[mPrimitiveLayerControllers release];

	[mLayer release];
	[mRepresentedObject release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors

// -hidden is deprecated in favour of -isHidden
- (BOOL)hidden;
{
	return [self isHidden];
}

- (void)setHidden:(BOOL)theHidden;
{
	[self _setHidden:theHidden patchResponderChain:YES];
}

- (void)_setHidden:(BOOL)theHidden patchResponderChain:(BOOL)thePatch;
{
	if (mHidden == theHidden) return;
	mHidden = theHidden;	
	
	for (KTLayerController *aLayerController in [self subcontrollers]) {
		[aLayerController _setHidden:theHidden patchResponderChain:NO];
	}
	
	if (thePatch) {
		[[[self viewController] windowController] _patchResponderChain];			
	}
}

- (void)setRepresentedObject:(id)theRepresentedObject;
{
	if (mRepresentedObject == theRepresentedObject)
		return;
	[mRepresentedObject release];
	mRepresentedObject = [theRepresentedObject retain];
}

- (KTWindowController *)_windowController;
{
	return [[self viewController] windowController];
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

// These methods are merely for mutating the |primitiveViewControllers| array. See the public |-add/removeViewController:| methods for places where connections to other view controllers are maintained and |removeObservations| is called.
- (void)insertObject:(KTLayerController *)theLayerController inLayerControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveLayerControllers] insertObject:theLayerController atIndex:theIndex];
}

- (void)removeObjectFromLayerControllersAtIndex:(NSUInteger)theIndex;
{
	[[self primitiveLayerControllers] removeObjectAtIndex:theIndex];
}

#pragma mark Public LayerController API

- (void)addLayerController:(KTLayerController *)theLayerController;
{
	if (theLayerController == nil) return;
	NSParameterAssert(![[self primitiveLayerControllers] containsObject:theLayerController]);
	[[self mutableArrayValueForKey:KTLayerControllerLayerControllersKey] addObject:theLayerController];
	[theLayerController _setParentLayerController:self];
	[[self _windowController] _patchResponderChain];
}

- (void)removeLayerController:(KTLayerController *)theLayerController;
{
	if (theLayerController == nil) return;
	[theLayerController retain];
	{
		NSParameterAssert([[self primitiveLayerControllers] containsObject:theLayerController]);
		[[self mutableArrayValueForKey:KTLayerControllerLayerControllersKey] removeObject:theLayerController];
		[theLayerController removeObservations];
		[theLayerController _setParentLayerController:nil];		
	}
	[theLayerController release];
	[[self _windowController] _patchResponderChain];
}

- (void)removeAllLayerControllers;
{
	NSArray *aLayerControllers = [[self primitiveLayerControllers] retain];
	{
		[[self mutableArrayValueForKey:KTLayerControllerLayerControllersKey] removeAllObjects];
		[aLayerControllers makeObjectsPerformSelector:@selector(removeObservations)];
		[aLayerControllers makeObjectsPerformSelector:@selector(_setParentLayerController:) withObject:nil];		
	}
	[aLayerControllers release];
	[[self _windowController] _patchResponderChain];
}

#pragma mark Old Subcontroller API

- (NSArray *)subcontrollers;
{
	return [self layerControllers];
}

- (void)addSubcontroller:(KTLayerController*)theSubcontroller;
{
	[self addLayerController:theSubcontroller];
}

- (void)removeSubcontroller:(KTLayerController*)theSubcontroller;
{
	[self removeLayerController:theSubcontroller];
}

#pragma mark -
#pragma mark KVO Teardown

- (void)removeObservations
{
	[[self primitiveLayerControllers] makeObjectsPerformSelector:@selector(removeObservations)];
}

#pragma mark -
#pragma mark KTController Protocol

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

void _KTLayerControllerEnumerateSubControllers(KTLayerController *theLayerController, _KTControllerEnumerationOptions theOptions, BOOL *theStopFlag, _KTControllerEnumeratorCallBack theCallBackFunction, void *theContext)
{
	NSCParameterAssert(theStopFlag != NULL);
	if (*theStopFlag == YES) return; // I'm not convinced this early return is necessary, but it's more defensive. The breaks in the loops should be taking care that we don't continue the recursion.
	
	theCallBackFunction(theLayerController, theStopFlag, theContext);
	if (*theStopFlag == YES) return;
	
	for (KTLayerController *aLayerController in [theLayerController layerControllers]) {
		_KTLayerControllerEnumerateSubControllers(aLayerController, theOptions, theStopFlag, theCallBackFunction, theContext);
		if (*theStopFlag == YES) break;
	}
}

- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
{
	BOOL aStopFlag = NO;
	_KTLayerControllerEnumerateSubControllers(self, _KTControllerEnumerationOptionsNone, &aStopFlag, theCallBackFunction, theContext);
}

@end


