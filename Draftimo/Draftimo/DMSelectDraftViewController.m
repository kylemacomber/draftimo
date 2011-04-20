//
//  DMSelectDraftViewController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/14/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMSelectDraftViewController.h"
#import "DMOAuthController.h"
#import "DMLeaguesCollectionViewController.h"
#import "DMLeagueDetailViewController.h"
#import "DMUnboxTransformer.h"


@interface DMSelectDraftViewController ()
@property (retain) DMLeaguesCollectionViewController *leaguesCollectionViewController;
@property (retain) DMLeagueDetailViewController *leagueDetailViewController;
@end

@implementation DMSelectDraftViewController
@synthesize leaguesCollectionView = __leaguesCollectionView;
@synthesize leagueDetailView = __leagueDetailView;
@synthesize leaguesCollectionViewController = __leaguesCollectionViewController;
@synthesize leagueDetailViewController = __leagueDetailViewController;

- (id)init
{
    self =  [super initWithNibName:ClassKey(DMSelectDraftViewController) bundle:nil];
    if (!self) return nil;

    self.leaguesCollectionViewController = [[DMLeaguesCollectionViewController alloc] init];
    self.leagueDetailViewController = [[DMLeagueDetailViewController alloc] init];
    
    return self;
}

- (void)awakeFromNib
{
	[[self.leaguesCollectionViewController view] setFrame:[self.leaguesCollectionView bounds]];
	[self.leaguesCollectionView addSubview:[self.leaguesCollectionViewController view]];
	
	[[self.leagueDetailViewController view] setFrame:[self.leagueDetailView bounds]];
	[self.leagueDetailView addSubview:[self.leagueDetailViewController view]];
    
    [self.leagueDetailViewController bind:@"representedObject" toObject:self.leaguesCollectionViewController withKeyPath:@"selectedObjects" options:[NSDictionary dictionaryWithObjectsAndKeys:@"DMUnboxTransformer", NSValueTransformerNameBindingOption, nil]];
    [self.leagueDetailViewController bind:@"representation" toObject:self.leaguesCollectionViewController withKeyPath:@"selection" options:nil];
}
@end
