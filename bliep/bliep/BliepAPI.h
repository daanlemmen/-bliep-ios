//
//  BliepAPI.h
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    BliepConnectionTypeToken,
    BliepConnectionTypeAccount,
    BliepConnectionTypeChangeAccountState,
}BliepConnectionType;
typedef void(^BliepTokenCompletionBlock)(NSDictionary *dict);

@interface BliepAPI : NSObject <NSURLConnectionDataDelegate>

- (void)getTokenWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(BliepTokenCompletionBlock)completionBlock;
- (void)getAccountInfoWithToken:(NSString *)token andCompletionBlock:(BliepTokenCompletionBlock)completionBlock;
-(void)setStateWithState:(NSString *)state andToken:(NSString *)token andCompletionBlock:(BliepTokenCompletionBlock)completionBlock;
+(NSString *)getTokenFromUserDefaults;
+(BOOL)setToken:(NSString *)token;
+(NSDictionary *)getAccountInfoFromUserDefaults;
+(BOOL)setAccountInfo:(NSDictionary *)accountInfo;
@end
