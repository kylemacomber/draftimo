//
//  KTLevelIndicator.h
//  KTUIKit
//
//  Created by Cathy Shive on 11/10/08.
//  Copyright 2008 Cathy Shive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTViewLayout.h"

@class KTLayoutManager;

@interface KTLevelIndicator : NSLevelIndicator <KTViewLayout>
{
	KTLayoutManager *		mLayoutManager;
}
@end
