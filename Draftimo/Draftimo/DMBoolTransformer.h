//
//  DMBoolTransformer.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/28/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DMBoolTransformer : NSValueTransformer {}
+ (id)boolTransformerWithYesObject:(id)yesObject noObject:(id)noObject;
@property (nonatomic, retain, readonly) id yesObject;
@property (nonatomic, retain, readonly) id noObject;
@end
