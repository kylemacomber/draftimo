//
//  DMSelectDraftViewController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/14/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSelectDraftViewController.h"
#import "DMOAuthController.h"
#import "DMConstants.h"
#import "DMGame.h"


@implementation DMSelectDraftViewController

- (void)fetchUserGames
{
    [[DMOAuthController sharedOAuthController] performYFMethod:YFUserLeaguesMethod withParameters:nil withTarget:self andAction:@selector(parseYFXMLMethod:withResponseBody:)];
}

- (id)init
{
    self =  [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (!self) return nil;
    
    [self fetchUserGames];
    
    return self;
}

NSSet *deepParse(NSXMLNode *root, NSString *entityName, NSString *const methodName, NSManagedObjectContext *const managedObjectContext)
{
    NSMutableSet *entities = [NSMutableSet set];
    
    NSEntityDescription *const entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    NSString *const entityPath = [[entityDescription userInfo] objectForKey:methodName];
    
    for (NSXMLNode *const node in [root nodesForXPath:entityPath error:nil]) {
        id entity = [[NSClassFromString(entityName) alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:managedObjectContext];
        
        NSDictionary *const attributesByName = [entityDescription attributesByName];
        for (NSString *const attributeName in attributesByName) {
            NSString *const attributePath = [[[attributesByName objectForKey:attributeName] userInfo] objectForKey:methodName];
            if (!attributePath) continue;
            
            id value = [[[node nodesForXPath:attributePath error:nil] lastObject] objectValue];
            if (!value) continue;
            
            NSError *error;
            if (![entity validateValue:&value forKey:attributeName error:&error]) { ALog(@"%@", error); }
            [entity setValue:value forKey:attributeName];
        }
        
        NSDictionary *const relationshipsByName = [entityDescription relationshipsByName];
        for (NSString *const relationshipName in relationshipsByName) {
            NSRelationshipDescription *const relationshipDescription = [relationshipsByName objectForKey:relationshipName];
            NSEntityDescription *const relationshipEntityDescription = [relationshipDescription destinationEntity];
            NSString *const relationshipPath = [[relationshipEntityDescription userInfo] objectForKey:methodName];
            if (![relationshipPath hasPrefix:entityPath]) continue; //do not parse relationships pointing back up the XML tree (we've already been there)
            
            NSSet *const relationshipEntities = deepParse(node, [relationshipEntityDescription name], methodName, managedObjectContext);
            id value = nil;
            if (![relationshipDescription isToMany]) {
                value = [relationshipEntities anyObject];
            } else {
                value = relationshipDescription;
            }
            
            NSError *error;
            if (![entity validateValue:&value forKey:relationshipName error:&error]) { ALog(@"%@", error); }
            [entity setValue:value forKey:relationshipName];
        }
        
        [entities addObject:entity];
    }
    
    return entities;
}

- (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    DLog(@"method:%@\nresponse:%@", method, responseBody);

    NSManagedObjectContext *const managedObjectContext = [(NSPersistentDocument *)[[self.view.window windowController] document] managedObjectContext];
    
    NSError *error;
    NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:responseBody options:NSXMLDocumentValidate error:&error];
    if (!doc) {
        ALog(@"%@", error); //maybe find a way to call web service again
    }
    
    NSSet *games = deepParse(doc, NSStringFromClass([DMGame class]), @"YFUserLeaguesMethod", managedObjectContext);
    NSSet *leagues = [games valueForKeyPath:@"@distinctUnionOfSets.leagues"];
    //sort the leagues in some way
    //provide content to arrayController
    self.representedObject = leagues;
}

@end
