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

@class Reachability;
@interface DMOAuthController : NSObject <MPOAuthAuthenticationMethodOAuthDelegate> {
@private
    DMOAuthState __oauthStateMask;
    NSURL *__userAuthURL;
    NSString *__verifierCode;
    
    MPOAuthAPI *__oauthAPI;
    Reachability *__YAuthReachable;
    Reachability *__YFReachable;
    NSMutableArray *__waitingOperations;
    NSString *__cachedRequestToken;
    NSString *__cachedRequestTokenSecret;
}

+ (DMOAuthController *)sharedOAuthController;

@property (assign, readonly) DMOAuthState oauthStateMask;
@property (copy, readonly) NSURL *userAuthURL;
@property (copy) NSString *verifierCode;

- (BOOL)oauthStateMaskMatches:(DMOAuthState)state; //returns (self.oauthStateMask & state) == state
- (void)performYFMethod:(NSString *)theMethod withParameters:(NSDictionary *)theParameters withTarget:(id)theTarget andAction:(SEL)theAction;
@end
