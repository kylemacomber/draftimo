//
//  YFXMLParseOperation.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/19/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol YFXMLParseOperationDelegate;
@interface YFXMLParseOperation : NSOperation {
@private
    NSManagedObjectContext *__managedObjectContext;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSURL *__method;
    NSString *__responseBody;
    id <YFXMLParseOperationDelegate> __delegate;
    
    NSString *__YFKey;
}

@property (retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (copy) NSURL *method;
@property (copy) NSString *responseBody;
@property (assign) id <YFXMLParseOperationDelegate> delegate;
@end

@protocol YFXMLParseOperationDelegate <NSObject>
- (void)YFXMLParseOperation:(YFXMLParseOperation *)operation didSave:(NSNotification *)notification;
@end
