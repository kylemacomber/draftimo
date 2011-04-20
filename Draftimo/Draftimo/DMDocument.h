//
//  DMDocument.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMDocument : NSPersistentDocument {
@private
    NSOperationQueue *__YFParseOperationQueue;
}

- (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody;
@end
