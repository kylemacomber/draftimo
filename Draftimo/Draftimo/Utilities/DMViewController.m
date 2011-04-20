//
//  DMViewController.m
//  Draftimo
//
//  Created by Kyle Macomber on 4/17/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import "DMViewController.h"


static NSString *const DMListViewControllerRepresentationKVOContext = @"DMListViewControllerRepresentationKVOContext";

@implementation DMViewController
@synthesize representation = __representation;

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (!self) return nil;
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    DLog(@"%@ %@", keyPath, object);
    if (context == DMListViewControllerRepresentationKVOContext) {
        [self willChangeValueForKey:SelKey(representation)];
        [self didChangeValueForKey:SelKey(representation)];
    }
}

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
    DLog(@"%@ %@ %@", binding, observable, keyPath);
    [super bind:binding toObject:observable withKeyPath:keyPath options:options];
    
    // Because -[NSArrayController selection] returns a proxy object that doesn't change when the selection changes
    // the binding doesn't update the UI (probably) because of an optimization in the binding code that says if the
    // object doesn't change don't launch a KVO notification. Well we need that notification
    if ([binding isEqualToString:NSStringFromSelector(@selector(representation))]) {
        [observable addObserver:self forKeyPath:keyPath options:0 context:DMListViewControllerRepresentationKVOContext];
    }
}

@end
