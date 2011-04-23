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

- (void)awakeFromNib
{
    [self.arrayController addObserver:self forKeyPath:@"selectionIndexes" options:0 context:NULL];
    [self.arrayController setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"leagueID" ascending:YES]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Prevent empty selection
    if (![[self.arrayController selectionIndexes] count]) {
        [self.arrayController setSelectionIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
}

@end
