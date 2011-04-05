//
//  DMAuctionDraft.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/4/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DMDraft.h"


@interface DMAuctionDraft : DMDraft {
@private
}
@property (nonatomic, retain) NSDecimalNumber * minimumBid;
@property (nonatomic, retain) NSDecimalNumber * teamBudget;

@end
