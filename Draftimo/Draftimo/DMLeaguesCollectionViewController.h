//
//  DMLeaguesCollectionViewController.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/16/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTViewController.h"


@interface DMLeaguesCollectionViewController : KTViewController {
@private
    NSArrayController *__arrayController;
    NSImageView *__docImageView;
}

@property (retain) IBOutlet NSArrayController *arrayController;
@property (retain) IBOutlet NSImageView *docImageView;
@end
