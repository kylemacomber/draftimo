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
#import "DMDraft.h"


@interface DMSelectDraftViewController ()
@property (retain) DMLeaguesCollectionViewController *leaguesCollectionViewController;
@property (retain) DMLeagueDetailViewController *leagueDetailViewController;

- (void)managedObjectContextDidChange:(NSNotification *)notification;
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

    self.leaguesCollectionViewController = [[DMLeaguesCollectionViewController alloc] initWithNibName:@"DMLeaguesCollectionViewController" bundle:nil];
    [self addViewController:self.leaguesCollectionViewController];
    self.leagueDetailViewController = [[DMLeagueDetailViewController alloc] initWithNibName:@"DMLeagueDetailViewController" bundle:nil];
    [self addViewController:self.leagueDetailViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[[self windowController] document] managedObjectContext]];
    
    return self;
}

- (void)awakeFromNib
{
    [[self.leaguesCollectionViewController view] setFrame:[self.leaguesCollectionView bounds]];
    [self.leaguesCollectionView addSubview:[self.leaguesCollectionViewController view]];
	
    [[self.leagueDetailViewController view] setFrame:[self.leagueDetailView bounds]];
    [self.leagueDetailView addSubview:[self.leagueDetailViewController view]];
    
    [self.leagueDetailViewController bind:@"representedObject" toObject:self.leaguesCollectionViewController.arrayController withKeyPath:@"selectedObjects" options:[NSDictionary dictionaryWithObjectsAndKeys:@"DMUnboxTransformer", NSValueTransformerNameBindingOption, nil]];
}

- (void)managedObjectContextDidChange:(NSNotification *)notification
{
    [self.leaguesCollectionViewController.arrayController fetch:nil];
}

#pragma mark Responder Chain

- (IBAction)setupNextButtonClicked:(id)sender
{
    NSManagedObjectContext *managedObjectContext = [[[self windowController] document] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"DMDraft" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    ZAssert([array count] == 1, @"Fetch doesn't return one DMDraft %@", error);
    
    DMDraft *draft = [array lastObject];
    draft.league = [self.leaguesCollectionViewController.arrayController.selectedObjects lastObject];
    DLog(@"%@", draft);
}

@end
