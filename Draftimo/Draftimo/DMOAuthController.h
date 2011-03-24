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
    DMOAuthUnreachable,
    DMOAuthUnauthenticated,
    
    DMOAuthRequestTokenRequesting,
    DMOAuthRequestTokenRejected,
    DMOAuthRequestTokenRecieved,
    
    DMOAuthBrowserLaunched,
    DMOAuthVerifierCodeWaiting,
    
    DMOAuthAccessTokenRequesting,
    DMOAuthAccessTokenRefreshing,
    DMOAuthAccessTokenTimeout,
    DMOAuthAccessTokenRejected,
    
    DMOAuthAuthenticated
};
typedef NSUInteger DMOAuthState;
extern NSString *const DMOAuthStateString[];

@interface DMOAuthController : NSObject <MPOAuthAuthenticationMethodOAuthDelegate> {}

@property (nonatomic, assign, readonly) DMOAuthState oauthState;
@property (nonatomic, copy) NSString *verifierCode;

- (void)launchBrowser;
- (void)retry;
@end
