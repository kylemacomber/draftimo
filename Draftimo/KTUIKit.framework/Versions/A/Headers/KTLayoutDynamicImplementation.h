//
//  KTLayoutDynamicImplementation.h
//  KTUIKit
//
//  Created by Jonathan on 11/03/2009.
//  Copyright 2009 espresso served here. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTMacros.h"

//const char *const KTViewLayoutManagerIvarName = "mLayoutManager";
KT_EXPORT NSString *const KTViewLayoutManagerKey;

KT_EXPORT id layoutManagerDynamicMethodIMP(id self, SEL _cmd);

KT_EXPORT void setLayoutManagerDynamicMethodIMP(id self, SEL _cmd, id layoutManager);

KT_EXPORT id parentDynamicMethodIMP(id self, SEL _cmd);

KT_EXPORT id childrenDynamicMethodIMP(id self, SEL _cmd);

KT_EXPORT id initWithFrameDynamicIMP(id self, SEL _cmd, NSRect frame);

KT_EXPORT id initWithCoderDynamicIMP(id self, SEL _cmd, NSCoder *coder);

KT_EXPORT void encodeWithCoderDynamicIMP(id self, SEL _cmd, NSCoder *coder);

KT_EXPORT void deallocDynamicIMP(id self, SEL _cmd);
