//
//  BliepJSONOperation.m
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "BliepJSONOperation.h"

@implementation BliepJSONOperation

- (void)operationSucceeded {
    NSDictionary *response = [self responseJSON];
    BOOL val = [[response objectForKey:@"success"] boolValue];
    if (!val) {
        [super operationFailedWithError:[NSError errorWithDomain:[response objectForKey:@"error"]
                                                            code:[[response objectForKey:@"error_code"] intValue] userInfo:nil]];
    } else {
        [super operationSucceeded];
   
    }
}

@end
