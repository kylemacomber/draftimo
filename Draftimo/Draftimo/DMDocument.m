//
//  DMDocument.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/9/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMDocument.h"
#import "DMDocumentWindowController.h"


@interface DMDocument ()
@property (retain) NSOperationQueue *YFParseOperationQueue;


@end

@implementation DMDocument
@synthesize YFParseOperationQueue = __YFParseOperationQueue;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    DLog(@"");
    self.YFParseOperationQueue = [[NSOperationQueue alloc] init];

    return self;
}

#pragma mark NSDocument

// The init invoked to create a new document
- (id)initWithType:(NSString *)typeName error:(NSError **)outError
{
    self = [super initWithType:typeName error:outError];
    if (!self) return nil;
    
    DLog(@"");
    // When opening a new document
    [[[self managedObjectContext] persistentStoreCoordinator] addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    //DMDraft
    // Create DMDraft and insert into managedObjectContext
    
    return self;
}

// The init invoked to open existing documents
- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    self = [super initWithContentsOfURL:absoluteURL ofType:typeName error:outError];
    if (!self) return nil;
    
    DLog(@"");
    
    return self;
}

- (void)makeWindowControllers
{
    [super makeWindowControllers];
    [self addWindowController:[[DMDocumentWindowController alloc] init]];
}

#pragma mark API

- (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    YFXMLParseOperation *parseOperation = [[YFXMLParseOperation alloc] init];
    parseOperation.persistentStoreCoordinator = [[self managedObjectContext] persistentStoreCoordinator];
    parseOperation.method = method;
    parseOperation.responseBody = responseBody;
    parseOperation.delegate = self;
    
    [self.YFParseOperationQueue addOperation:parseOperation];
}

#pragma mark YFXMLParseOperationDelegate

- (void)YFXMLParseOperation:(YFXMLParseOperation *)operation didSave:(NSNotification *)notification
{
    [[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"DMLeague" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    DLog(@"%@ %@", array, error);
}

@end
