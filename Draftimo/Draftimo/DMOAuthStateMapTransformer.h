//
//  DMOAuthStateMapTransformer.h
//  draftimo
//
//  Created by Kyle Macomber on 3/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMOAuthStateMapTransformer : NSValueTransformer {}
+ (id)authStateValueTransformerWithMap:(NSDictionary *)map;
@property (nonatomic, copy, readonly) NSDictionary *map;
@end
