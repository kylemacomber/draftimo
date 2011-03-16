//
//  DraftimoAppDelegate.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/8/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MPOAuth/MPOAuth.h>

@interface DMAppController : NSObject <NSApplicationDelegate> {

}

+ (DMAppController *)sharedAppController;

@property (nonatomic, retain, readonly) MPOAuthAPI *oauthAPI;

- (void)refreshOAuthAPI;

@end
