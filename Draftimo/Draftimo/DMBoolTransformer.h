//
//  DMBoolTransformer.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMBoolTransformer : NSValueTransformer {}
+ (id)boolValueTransformerForObject:(id)object;
@property (nonatomic, retain, readonly) id object;
@end
