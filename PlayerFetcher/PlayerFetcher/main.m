//
//  main.m
//  PlayerFetcher
//
//  Created by Kyle Macomber on 4/25/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerFetcherOperation.h"


int main (int argc, const char * argv[])
{
    NSOperationQueue *fetcherQueue = [[NSOperationQueue alloc] init];
    [fetcherQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    [fetcherQueue addOperation:[[PlayerFetcherOperation alloc] initWithSport:MLBSportKey]];
    [fetcherQueue addOperation:[[PlayerFetcherOperation alloc] initWithSport:NFLSportKey]];
    [fetcherQueue addOperation:[[PlayerFetcherOperation alloc] initWithSport:NBASportKey]];
    [fetcherQueue addOperation:[[PlayerFetcherOperation alloc] initWithSport:NHLSportKey]];
    [fetcherQueue waitUntilAllOperationsAreFinished];
    
    return 0;
}


