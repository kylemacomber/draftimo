//
//  DMDraft.h
//  Draftimo
//
//  Created by Kyle Macomber on 4/22/11.
//  Copyright (c) 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMLeague;

@interface DMDraft : NSManagedObject {
@private
}
@property (nonatomic, retain) DMLeague * league;

@end
