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

+ (void)initialize
{
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolTransformerWithYesObject:[NSColor textColor] noObject:[NSColor disabledControlTextColor]] forName:@"CollectionItemLabelTextColor"];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setRepresentedObject:[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Fantasy Dojo 2011", @"league", @"Easy as 4-6-3", @"team", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"Draftimo H2H", @"league", @"Ground Rule", @"team", nil], nil]];
}

@end
