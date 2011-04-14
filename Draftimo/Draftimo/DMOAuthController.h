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
    DMOAuthUnreachable              = 1,
    DMOAuthUnauthenticated          = 1 << 1,

    DMOAuthRequestTokenRequesting   = 1 << 2,
    DMOAuthRequestTokenRecieved     = 1 << 3,
    
    DMOAuthAccessTokenRequesting    = 1 << 4,
    DMOAuthAccessTokenTimeout       = 1 << 5,
    
    DMOAuthAccessTokenRefreshing    = 1 << 6,
    DMOAuthAuthenticated            = 1 << 7
};
typedef NSUInteger DMOAuthState;
// All DMOAuthStates are mutually exclusive *except* DMOAuthUnreachable. DMOAuthUnreachable may be combined with any other state, trumping it until the connection resumes.

@interface DMOAuthController : NSObject <MPOAuthAuthenticationMethodOAuthDelegate> {}

@property (nonatomic, assign, readonly) DMOAuthState oauthStateMask;
@property (nonatomic, copy, readonly) NSURL *userAuthURL;
@property (nonatomic, copy) NSString *verifierCode;

- (BOOL)oauthStateMaskMatches:(DMOAuthState)state; //returns (self.oauthStateMask & state) == state
- (void)performYFMethod:(NSString *)theMethod withParameters:(NSDictionary *)theParameters withTarget:(id)theTarget andAction:(SEL)theAction;
@end
