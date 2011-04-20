//
//  DMViewController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/17/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMListViewController.h"


//@interface DMListViewController ()
//@property (retain) id listController;
//@end

static NSString *const DMListViewControllerSelectionKVOContext = @"DMListViewControllerSelectionKVOContext";

@implementation DMListViewController
@synthesize listController = __listController;

- (void)awakeFromNib
{
    [self addObserver:self forKeyPath:@"listController.selection" options:0 context:DMListViewControllerSelectionKVOContext];
}

- (NSArray *)selectedObjects
{
    return [self.listController selectedObjects];
}

- (id)selection
{
    return [self.listController selection];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == DMListViewControllerSelectionKVOContext) {
        [self willChangeValueForKey:SelKey(selection)];
        [self didChangeValueForKey:SelKey(selection)];
        [self willChangeValueForKey:SelKey(selectedObjects)];
        [self didChangeValueForKey:SelKey(selectedObjects)];
    }
}

@end
