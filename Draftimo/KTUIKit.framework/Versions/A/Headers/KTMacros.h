//
//  KTMacros.h
//  KTUIKit
//
//  Created by Jonathan on 23/11/2010.
//  Copyright 2010 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef KT_EXPORT
#define KT_EXPORT extern
#endif // KT_EXPORT

// In the case that we're compiling against the 10.5 SDK, we need to define this as the 10.6 SDK does.
#ifndef __has_feature
#define __has_feature(x) 0     // Compatibility with non-clang compilers.
#endif

// In the case that we're compiling against the 10.5 SDK, we need to define this as the 10.6 SDK does.
#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

// In the case that we're compiling against the 10.5 SDK, we need to define this as the 10.6 SDK does.
#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif
