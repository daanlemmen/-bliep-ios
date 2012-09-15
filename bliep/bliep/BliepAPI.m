//
//  BliepAPI.m
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "BliepAPI.h"
#import "BliepJSONEngine.h"
#import "BliepJSONOperation.h"

@interface BliepAPI()
@property (nonatomic, strong) BliepJSONEngine *networkEngine;
@end		

@implementation BliepAPI

- (id)init {
    self = [super init];
    if (self) {
        self.networkEngine = [[BliepJSONEngine alloc] initWithHostName:@"www.bliep.nl"
                                                                           apiPath:@"api" customHeaderFields:nil];
        [self.networkEngine registerOperationSubclass:[BliepJSONOperation class]];
        
    }
    return self;
}

- (void)getTokenWithUsername:(NSString *)username andPassword:(NSString *)password andCompletionBlock:(BliepTokenCompletionBlock)completionBlock {
    
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:@"auth"
                              params:[NSMutableDictionary dictionaryWithObjects:@[username, password] forKeys:@[@"email", @"password"]]
                          httpMethod:@"POST" ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[NSNumber numberWithInteger:error.code] forKey:@"error_code"];
        [dict setObject:error.localizedDescription forKey:@"error"];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"success"];
        completionBlock(dict);
    }];
    
    [self.networkEngine enqueueOperation:operation];
    
}
- (void)getAccountInfoWithToken:(NSString *)token andCompletionBlock:(BliepTokenCompletionBlock)completionBlock {
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:@"account"
                                                                   params:[NSMutableDictionary dictionaryWithObjects:@[token] forKeys:@[@"token"]]
                                                               httpMethod:@"GET" ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        DLog(@"%@: %@", error, [error localizedDescription]);
    }];
    
    [self.networkEngine enqueueOperation:operation];
    
}

-(void)setStateWithState:(NSString *)state andToken:(NSString *)token andCompletionBlock:(BliepTokenCompletionBlock)completionBlock {
    
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:[NSString stringWithFormat:@"account/state/%@", state]
                                                                   params:[NSMutableDictionary dictionaryWithObjects:@[token] forKeys:@[@"token"]]
                                                               httpMethod:@"POST" ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        DLog(@"%@: %@", error, [error localizedDescription]);
    }];
    
    [self.networkEngine enqueueOperation:operation];
}
+(NSString *)getTokenFromUserDefaults {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"bliep_token"];
}
+(BOOL)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"bliep_token"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDictionary *)getAccountInfoFromUserDefaults {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cachedAccountInfo"];
}
+(BOOL)setAccountInfo:(NSDictionary *)accountInfo {
    [[NSUserDefaults standardUserDefaults] setValue:accountInfo forKey:@"cachedAccountInfo"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
