//
//  DMMapTransformer.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMMapTransformer : NSValueTransformer {}
+ (id)authStateTransformerWithMap:(NSDictionary *)map;
@property (nonatomic, copy, readonly) NSDictionary *map;
@end
