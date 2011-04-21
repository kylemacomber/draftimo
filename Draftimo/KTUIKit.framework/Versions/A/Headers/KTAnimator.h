//
//  KTAnimator.h
//  KTUIKit
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 Cathy Shive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"

@class KTAnimator;
@interface NSObject (KTANimatorDelegateMethods)
- (void)animatorDidStartAnimating:(KTAnimator*)theAnimator;
- (void)animator:(KTAnimator*)theAnimator didStartAnimation:(NSDictionary*)theAnimation;
- (void)animator:(KTAnimator*)theAnimator didUpdateAnimation:(NSDictionary*)theAnimation;
- (void)animator:(KTAnimator*)theAnimator didEndAnimation:(NSDictionary*)theAnimation;
- (void)animatorDidEndAllAnimations:(KTAnimator*)theAnimator;
@end

KT_EXPORT NSString *const KTAnimatorAnimationNameKey;
KT_EXPORT NSString *const KTAnimatorAnimationObjectKey;
KT_EXPORT NSString *const KTAnimatorAnimationKeyPathKey;
KT_EXPORT NSString *const KTAnimatorAnimationDurationKey;
KT_EXPORT NSString *const KTAnimatorAnimationSpeedKey;
KT_EXPORT NSString *const KTAnimatorAnimationStartValueKey;
KT_EXPORT NSString *const KTAnimatorAnimationEndValueKey;
KT_EXPORT NSString *const KTAnimatorAnimationLocationKey;
KT_EXPORT NSString *const KTAnimatorAnimationTypeKey;
KT_EXPORT NSString *const KTAnimatorFloatAnimation;
KT_EXPORT NSString *const KTAnimatorRectAnimation;
KT_EXPORT NSString *const KTAnimatorPointAnimation;
KT_EXPORT NSString *const KTAnimatorAnimationCurveKey;

typedef enum
{
	kKTAnimationType_EaseInAndOut = 0,
	kKTAnimationType_EaseIn,
	kKTAnimationType_EaseOut,
	kKTAnimationType_Linear
	
}KTAnimationType;


@interface KTAnimator : NSObject 
{
	NSTimer *					mAnimationTimer;
	NSMutableArray *			mAnimationQueue;
	id							wDelegate;
	CGFloat						mFramesPerSecond;
	BOOL						mDoubleDuration;
}

@property (nonatomic, readwrite, assign) CGFloat framesPerSecond;
@property (nonatomic, readwrite, assign) id delegate;
- (void)animateObject:(NSMutableDictionary*)theAnimationProperties;
- (void)removeAllAnimations;
- (void)doubleDurationOfAllAnimations;
@end
