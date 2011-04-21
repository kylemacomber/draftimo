//
//  KTTabItem.h
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"

KT_EXPORT NSString *const KTTabItemLabelKey;
KT_EXPORT NSString *const KTTabItemIdentifierKey;

KT_EXPORT NSString *const KTTabItemTabViewControllerKey;
KT_EXPORT NSString *const KTTabItemViewControllerKey;

KT_EXPORT NSString *const KTTabItemUserInfoKey;

@class KTTabViewController;
@class KTViewController;

@interface KTTabItem : NSObject {
	@private
	NSString *				mLabel;
	id						wIdentifier;
	KTTabViewController *	wTabViewController;
	KTViewController *		wViewController;
	NSMutableDictionary *	mUserInfo;
}

- (id)initWithViewController:(KTViewController*)theViewController;

@property (nonatomic, readwrite, copy) NSString * label;
@property (nonatomic, readwrite, assign) id identifier;

@property (nonatomic, readwrite, assign) KTTabViewController * tabViewController;
@property (nonatomic, readwrite, assign) KTViewController * viewController;

@property (nonatomic, readonly) NSMutableDictionary *userInfo;
@end
