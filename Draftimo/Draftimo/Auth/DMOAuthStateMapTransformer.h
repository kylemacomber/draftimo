//
//  DMOAuthStateMapTransformer.h
//  draftimo
//
//  Created by Kyle Macomber on 3/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMMapTransformer.h"


@interface DMOAuthStateMapTransformer : DMMapTransformer {}
+ (id)authStateTransformerWithMap:(NSDictionary *)aMap;
@end
