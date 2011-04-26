//
//  PlayerFetcherOperation.h
//  PlayerFetcher
//
//  Created by Kyle Macomber on 4/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const MLBSportKey;
extern NSString *const NFLSportKey;
extern NSString *const NBASportKey;
extern NSString *const NHLSportKey;

@interface PlayerFetcherOperation : NSOperation {
@private
    NSString *__sportKey;
    NSURL *__baseURL;
    NSUInteger __index;
    id __credentials;
}

- (id)initWithSport:(NSString *)sportKey;

@end
