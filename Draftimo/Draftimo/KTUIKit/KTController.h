
#import <Cocoa/Cocoa.h>
#import "KTMacros.h"

@protocol KTController;

typedef void (*_KTControllerEnumeratorCallBack)(NSResponder <KTController> * /* controller */, BOOL * /*theStopFlag*/, void * /* context */);

enum {
	_KTControllerEnumerationOptionsNone = 0,

	_KTControllerEnumerationOptionsIgnoreViewControllers = 1 << 0,
	_KTControllerEnumerationOptionsIgnoreLayerControllers = 1 << 1,
	_KTControllerEnumerationOptionsIncludeHiddenControllers = 1 << 2,
	
	// Unused for now, depth first is currently the default (and will likely remain so if we don't want to break lots of assumed behaviour in client code).
	_KTControllerEnumerationOptionsDepthFirst = 1 << 3,
	_KTControllerEnumerationOptionsBreadthFirst = 1 << 4
};
typedef NSUInteger _KTControllerEnumerationOptions;


@protocol KTController <NSObject>
- (NSArray *)descendants;
- (void)removeObservations;
@property (readwrite, nonatomic, assign, getter = isHidden) BOOL hidden;

- (void)_enumerateSubControllers:(_KTControllerEnumeratorCallBack)theCallBackFunction context:(void *)theContext;
@end