//
//  DMUnboxTransformer.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/18/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>

//  This class takes a set or an array and does the following:
//  for count == 0 return nil
//  for count == 1 return unboxed object
//  for count >= 2 return entire collection

@interface DMUnboxTransformer : NSValueTransformer {
@private
    
}

@end
