//
//  DMSelectDraftViewController.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/14/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class DMLeaguesCollectionViewController, DMLeagueDetailViewController;
@interface DMSelectDraftViewController : NSViewController {
@private
    NSView *__leaguesCollectionView;
    NSView *__leagueDetailView;
    DMLeaguesCollectionViewController *__leaguesCollectionViewController;
    DMLeagueDetailViewController *__leagueDetailViewController;
}

@property (retain) IBOutlet NSView *leaguesCollectionView;
@property (retain) IBOutlet NSView *leagueDetailView;
@end
