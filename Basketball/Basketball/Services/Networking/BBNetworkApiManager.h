//
//  BBNetworkApiManager.h
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^BBNetworkResponseBlock)(id responseObject, NSError *error);

@interface BBNetworkApiManager : AFHTTPSessionManager

+ (BBNetworkApiManager *)sharedManager;

- (NSURLSessionDataTask *)getVerifyCodeWithEmail:(NSString *)email
                                 completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)uploadImageWithImage:(UIImage *)image
                               completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)loginWithEmail:(NSString *)email
                                password:(NSString *)password
                         completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)registerWithEmail:(NSString *)email
                                   password:(NSString *)password
                                 verifyCode:(NSString *)verifyCode
                            completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)updateUserInfoWithCity:(NSString *)city
                                        nickName:(NSString *)nickName
                                    headImageUrl:(NSString *)headImageUrl
                                 completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)resetPasswordWithPassword:(NSString *)password
                                    completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)getStepCountingAverageWithCompletionBlock:(BBNetworkResponseBlock)responseBlock;
@end
