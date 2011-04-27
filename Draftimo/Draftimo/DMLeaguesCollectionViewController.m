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
@synthesize docImageView = __docImageView;

+ (void)initialize
{
    [NSValueTransformer setValueTransformer:[DMBoolTransformer boolTransformerWithYesObject:[NSImage imageNamed:@"CollectionViewSelection.png"] noObject:nil] forName:@"CollectionItemSelectedImage"];
}

- (void)awakeFromNib
{
    [self.docImageView setImage:[[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kGenericDocumentIcon)]];
    
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
