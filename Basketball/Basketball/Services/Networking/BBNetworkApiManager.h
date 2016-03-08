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

+ (BBNetworkApiManager *)shareManager;

- (NSURLSessionDataTask *)requestSampleWithCompetionBlock:(BBNetworkResponseBlock)responseBlock;

@end
