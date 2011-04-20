//
//  YFXMLParseOperation.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/19/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YFXMLParseOperation : NSOperation {
@private
    NSManagedObjectContext *__managedObjextContext;
    NSURL *__method;
    NSString *__responseBody;
    
    NSString *__YFKey;
}

@property (retain) NSManagedObjectContext *managedObjectContext;
@property (copy) NSURL *method;
@property (copy) NSString *responseBody;
@end
