//
//  BBNetworkApiManager.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"
#import "BBNetworkAddress.h"
#import "BBResponseSerializer.h"
#import "BBModel.h"

#define REQUEST(METHOD, ADDRESS, PARAMETER, MODEL_CLASS, RESPONSE_BLOCK) \
@weakify(self); \
NSURLSessionDataTask *dataTask = [self METHOD:ADDRESS parameters:PARAMETER progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { \
    @strongify(self); \
    [self handleSuccessTask:task responseObject:responseObject responseModelClass:MODEL_CLASS completionBlock:RESPONSE_BLOCK]; \
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
    @strongify(self); \
    [self handleFailTask:task error:error completionBlock:RESPONSE_BLOCK]; \
}]; \
return dataTask;

@interface BBNetworkApiManager ()

@property (nonatomic, strong) dispatch_queue_t parseQueue;

@end

@implementation BBNetworkApiManager

+ (BBNetworkApiManager *)shareManager {
    static BBNetworkApiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BBNetworkApiManager alloc]initWithBaseURL:[NSURL URLWithString:kApiBaseUrl]];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [BBResponseSerializer serializer];
        manager.parseQueue = dispatch_queue_create("com.basketball.Basketball.parseQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return manager;
}

#pragma mark - common action

- (void)handleSuccessTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject responseModelClass:(Class)modelClass completionBlock:(BBNetworkResponseBlock)responseBlock {
    id dataObject = nil;
    dispatch_async(self.parseQueue, ^{
        if (modelClass) {
            [modelClass createFromJSONDictionary:responseObject[@"data"]];
        }
        else {
            NSAssert([modelClass isSubclassOfClass:[BBModel class]], @"model类应该是BBModel的子类");
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (responseBlock) {
                responseBlock(dataObject,nil);
            }
        });
    });
}

- (void)handleFailTask:(NSURLSessionDataTask *)task error:(NSError *)error completionBlock:(BBNetworkResponseBlock)responseBlock {
    if (responseBlock) {
        responseBlock(nil, error);
    }
}

#pragma mark - request

- (NSURLSessionDataTask *)requestSampleWithCompetionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(GET, kApiTestAddress, nil, nil, responseBlock);
}

@end
