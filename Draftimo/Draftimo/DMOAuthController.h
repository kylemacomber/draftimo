//
//  DMOAuthController.h
//  draftimo
//
//  Created by Kyle Macomber on 3/22/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MPOAuth/MPOAuth.h>


enum {
    DMOAuthUnreachable              = 0,
    DMOAuthUnauthenticated          = 1 << 0,

    DMOAuthRequestTokenRequesting   = 1 << 1,
    DMOAuthRequestTokenRejected     = 1 << 2,
    DMOAuthRequestTokenRecieved     = 1 << 3,
    
    DMOAuthBrowserLaunched          = 1 << 4,
    DMOAuthVerifierCodeWaiting      = 1 << 5,
    
    DMOAuthAccessTokenRequesting    = 1 << 6,
    DMOAuthAccessTokenRefreshing    = 1 << 7,
    DMOAuthAccessTokenTimeout       = 1 << 8,
    DMOAuthAccessTokenRejected      = 1 << 9,
    
    DMOAuthAuthenticated            = 1 << 10
};
typedef NSUInteger DMOAuthState;

@interface DMOAuthController : NSObject <MPOAuthAuthenticationMethodOAuthDelegate> {}

@property (nonatomic, assign, readonly) DMOAuthState oauthState;
@property (nonatomic, copy) NSString *verifierCode;

- (void)launchBrowser;
- (void)retry;
@end
