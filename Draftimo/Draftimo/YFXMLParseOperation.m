//
//  YFXMLParseOperation.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/19/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "YFXMLParseOperation.h"
#import "DMConstants.h"
#import "DMGame.h"


@interface YFXMLParseOperation ()
@property (retain, readwrite) NSManagedObjectContext *managedObjectContext;
@property (copy) NSString *YFKey;

- (void)managedObjectContextDidSave:(NSNotification *)notification;
- (NSSet *)parseNode:(NSXMLNode *)node forEntityNamed:(NSString *)entityName;
@end

@implementation YFXMLParseOperation
@synthesize managedObjectContext = __managedObjextContext;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize method = __method;
@synthesize responseBody = __responseBody;
@synthesize delegate = __delegate;
@synthesize YFKey = __YFKey;

- (void)main
{
    DLog(@"%@", self.method);
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(YFXMLParseOperation:didSave:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.managedObjectContext];
    }
    
    if ([[self.method relativeString] isEqualToString:YFUserLeaguesMethod]) {
        self.YFKey = @"YFUserLeaguesMethod";
        
        NSError *error;
        NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:self.responseBody options:NSXMLDocumentValidate error:&error];
        if (!doc) { ALog(@"%@", error); }
        
        NSSet *games = [self parseNode:doc forEntityNamed:ClassKey(DMGame)];
        // For YFUserLeaguesMethod, the only teams returned are the user's teams, we must set them as such
        [games setValue:[NSNumber numberWithBool:YES] forKeyPath:@"leagues.teams.userTeam"];
    } else {
        ALog(@"Unrecognized Method %@", self.method);
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) { ALog(@"%@", error); }
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    if ([NSThread isMainThread]) {
        [self.delegate YFXMLParseOperation:self didSave:notification];
    } else {
        [self performSelectorOnMainThread:@selector(managedObjectContextDidSave:) withObject:notification waitUntilDone:NO];
    }
}

- (NSSet *)parseNode:(NSXMLNode *)root forEntityNamed:(NSString *)entityName
{
    NSMutableSet *entities = [NSMutableSet set];
    NSEntityDescription *const entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSString *const absEntityPath = [[entityDescription userInfo] objectForKey:self.YFKey];
    NSString *relEntityPath = absEntityPath;
    
    // Entity paths are stored as absolute paths to an XML node. 
    // However, we are passed a pointer to a specific node which needs to be parsed.
    // Thus we need the path to the entity relative to this node.
    // Note: if root == doc node, [root name] == nil
    if ([root name]) {
        NSArray *pathComponents = [absEntityPath pathComponents];
        NSUInteger const index = [pathComponents indexOfObject:[root name]];
        relEntityPath = [NSString pathWithComponents:[pathComponents subarrayWithRange:NSMakeRange(index + 1, [pathComponents count] - (index + 1))]];
    }
    
    // For each node create an entity then for each attribute with an xPath set it on the entity
    // and for each relationship with an xPath, recursively create the appropriate entities
    // and set those on the entity
    for (NSXMLNode *const node in [root nodesForXPath:relEntityPath error:nil]) {
        id entity = [[NSClassFromString(entityName) alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
        NSDictionary *const attributesByName = [entityDescription attributesByName];
        for (NSString *const attributeName in attributesByName) {
            NSString *const absAttributePath = [[[attributesByName objectForKey:attributeName] userInfo] objectForKey:self.YFKey];
            if (!absAttributePath) continue;
            
            id value = [[[node nodesForXPath:absAttributePath error:nil] lastObject] objectValue];
            if (!value) continue;
            
            NSError *error;
            if (![entity validateValue:&value forKey:attributeName error:&error]) { ALog(@"%@", error); }
            [entity setValue:value forKey:attributeName];
        }
        
        NSDictionary *const relationshipsByName = [entityDescription relationshipsByName];
        for (NSString *const relationshipName in relationshipsByName) {
            NSRelationshipDescription *const relationshipDescription = [relationshipsByName objectForKey:relationshipName];
            NSEntityDescription *const relationshipEntityDescription = [relationshipDescription destinationEntity];
            NSString *const absRelationshipPath = [[relationshipEntityDescription userInfo] objectForKey:self.YFKey];
            if (![absRelationshipPath hasPrefix:absEntityPath]) continue; //do not parse relationships pointing back up the XML tree (we've already been there)
            
            NSSet *const relationshipEntities = [self parseNode:node forEntityNamed:[relationshipEntityDescription name]];
            id value = nil;
            if (![relationshipDescription isToMany]) {
                value = [relationshipEntities anyObject];
            } else {
                value = relationshipEntities;
            }
            
            NSError *error;
            if (![entity validateValue:&value forKey:relationshipName error:&error]) { ALog(@"%@", error); }
            [entity setValue:value forKey:relationshipName];
        }
        
        [entities addObject:entity];
    }
    
    return entities;
}

@end
