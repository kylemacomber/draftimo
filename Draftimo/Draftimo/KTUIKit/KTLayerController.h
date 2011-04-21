//
//  KTOpenGLLayerController.h
//  KTUIKit
//
//  Created by Cathy on 27/02/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"
#import "KTController.h"

KT_EXPORT NSString *const KTLayerControllerLayerControllersKey;

@class KTViewController;

@interface KTLayerController : NSResponder <KTController> {
	@private
	KTViewController	*wViewController;
	KTLayerController	*wParentLayerController;

	NSMutableArray		*mPrimitiveLayerControllers;
	
	id					mLayer;
	id					mRepresentedObject;
	
	BOOL				mHidden;
}

@property (readwrite, nonatomic, assign) KTViewController *viewController;
@property (readonly, nonatomic, assign) KTLayerController *parentLayerController;

@property (readwrite, nonatomic, retain) id layer;
@property (readwrite, nonatomic, retain) id representedObject;

+ (id)layerControllerWithViewController:(KTViewController*)theViewController;
- (id)initWithViewController:(KTViewController*)theViewController;

#pragma mark Layer Controllers
@property (readonly, nonatomic, copy) NSArray *layerControllers;
- (void)addLayerController:(KTLayerController *)theLayerController;
- (void)removeLayerController:(KTLayerController *)theLayerController;
- (void)removeAllLayerControllers;

@end

@interface KTLayerController (KTPrivate)
- (void)_setHidden:(BOOL)theHidden patchResponderChain:(BOOL)thePatch;
KT_EXPORT void _KTLayerControllerEnumerateSubControllers(KTLayerController *theLayerController, _KTControllerEnumerationOptions theOptions, BOOL *theStopFlag, _KTControllerEnumeratorCallBack theCallBackFunction, void *theContext);
- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
@end
