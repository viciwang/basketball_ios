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

#ifdef DEBUG

+ (void)configDebugBaseUrl:(NSString *)baseurl;

#endif

+ (BBNetworkApiManager *)sharedManager;

- (NSURLSessionDataTask *)getVerifyCodeWithEmail:(NSString *)email
                                 completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)uploadImageWithImage:(UIImage *)image
                               completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)loginWithEmail:(NSString *)email
                                password:(NSString *)password
                         completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)logoutWithCompletionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)registerWithEmail:(NSString *)email
                                   password:(NSString *)password
                                 verifyCode:(NSString *)verifyCode
                            completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)updateUserInfoWithCity:(NSString *)citSSy
                                        nickName:(NSString *)nickName
                                    headImageUrl:(NSString *)headImageUrl
                                 completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)resetPasswordWithPassword:(NSString *)password
                                    completionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)getAverageStepCountWithCompletionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)getHistoryStepCountWithCompletionBlock:(BBNetworkResponseBlock)responseBlock;

- (NSURLSessionDataTask *)getStepCountRankingWithCompletionBlock:(BBNetworkResponseBlock)responseBlock;

@end
