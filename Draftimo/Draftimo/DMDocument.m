//
//  DMDocument.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMDocument.h"
#import "DMDocumentWindowController.h"
#import "YFXMLParseOperation.h"


@interface DMDocument ()
@property (retain) NSOperationQueue *YFParseOperationQueue;
@end

@implementation DMDocument
@synthesize YFParseOperationQueue = __YFParseOperationQueue;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.YFParseOperationQueue = [[NSOperationQueue alloc] init];

    return self;
}

- (void)makeWindowControllers
{
    [super makeWindowControllers];
    [self addWindowController:[[DMDocumentWindowController alloc] init]];
}

- (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    YFXMLParseOperation *parseOperation = [[YFXMLParseOperation alloc] init];
    parseOperation.managedObjectContext = self.managedObjectContext;
    parseOperation.method = method;
    parseOperation.responseBody = responseBody;
    [self.YFParseOperationQueue addOperation:parseOperation];
}

@end
