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

- (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody
{
    DLog(@"method:%@\nresponse:%@", method, responseBody);
}

@end
