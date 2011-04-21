//
//  KTColorWell.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/23/08.
//  Copyright 2008 Cathy Shive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"
#import "KTViewLayout.h"

KT_EXPORT NSString *const KTColorWellDidActivateNotification;

@class KTLayoutManager;

@interface KTColorWell : NSColorWell <KTViewLayout>
{
	KTLayoutManager *		mLayoutManager;
}

@end
