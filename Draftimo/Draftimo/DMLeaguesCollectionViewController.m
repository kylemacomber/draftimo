//
//  DMLeaguesCollectionViewController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/16/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMLeaguesCollectionViewController.h"
#import "DMBoolTransformer.h"


@implementation DMLeaguesCollectionViewController
@synthesize arrayController = __arrayController;

+ (void)initialize
{
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolTransformerWithYesObject:[NSColor textColor] noObject:[NSColor disabledControlTextColor]] forName:@"CollectionItemLabelTextColor"];
}

@end
