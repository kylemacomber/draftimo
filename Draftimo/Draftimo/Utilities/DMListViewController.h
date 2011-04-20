//
//  DMViewController.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/17/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DMViewController.h"


@interface DMListViewController : DMViewController {
@private
    id __listController;
}

@property (retain) IBOutlet id listController;

- (NSArray *)selectedObjects;
- (id)selection;

@end
