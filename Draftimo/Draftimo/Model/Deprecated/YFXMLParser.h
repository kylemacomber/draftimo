//
//  YFXMLParser.h
//  Draftimo
//
//  Created by Kyle Macomber on 3/31/11.
//  Copyright 2011 Kyle Macomber. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YFXMLParser : NSObject {}
+ (void)parseYFXMLMethod:(NSURL *)method withResponseBody:(NSString *)responseBody;
@end
