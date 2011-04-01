//
//  NSKeyValueCoding-Additions.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (NSKeyValueCoding_Additions)
- (NSDictionary *)validateValuesForKeysWithDictionary:(NSDictionary *)keyedValues error:(NSError **)outError;
@end
