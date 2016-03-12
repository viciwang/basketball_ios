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

#define REQUEST(METHOD, URLString, PARAMETERS, MODEL_CLASS, RESPONSE_BLOCK) \
{ \
    @weakify(self); \
    NSURLSessionDataTask *dataTask = [self METHOD:URLString parameters:PARAMETERS progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { \
        @strongify(self); \
        [self handleSuccessTask:task responseObject:responseObject responseModelClass:MODEL_CLASS completionBlock:RESPONSE_BLOCK]; \
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { \
        @strongify(self); \
        [self handleFailTask:task error:error completionBlock:RESPONSE_BLOCK]; \
    }]; \
    return dataTask; \
}

@interface BBNetworkApiManager ()

@property (nonatomic, strong) dispatch_queue_t parseQueue;

@end

@implementation BBNetworkApiManager

+ (BBNetworkApiManager *)sharedManager {
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

- (instancetype)init {
    
    self = [super initWithBaseURL:[NSURL URLWithString:kApiBaseUrl]];
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [BBResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        self.parseQueue = dispatch_queue_create("com.basketball.Basketball.parseQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
#pragma mark - common action

// 此方法用上面的宏（REQUEST）代替
/**
 *  get方法
 *
 *  @param URLString     地址（去除host），如请求网址为http://localhost:8000/address/street,
                         这里URLString只需传 @"address/street"
 *  @param parameters    请求参数，可为nil
 *  @param modelClass    BBModel类或其子类，用于从接口返回的字典生成model实例，可为nil；
                         如果为nil，则直接返回原始字典
 *  @param responseBlock 回调block
 *
 *  @return NSURLSessionDataTask实例
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   modelClass:(Class)modelClass
              completionBlock:(BBNetworkResponseBlock)responseBlock {
    
    @weakify(self);
    NSURLSessionDataTask *dataTask = [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify(self);
        [self handleSuccessTask:task responseObject:responseObject responseModelClass:modelClass completionBlock:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify(self);
        [self handleFailTask:task error:error completionBlock:responseBlock];
    }];
    return dataTask;
}

- (void)handleSuccessTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject responseModelClass:(Class)modelClass completionBlock:(BBNetworkResponseBlock)responseBlock {
    dispatch_async(self.parseQueue, ^{
        id dataObject = nil;
        if (modelClass) {
            NSAssert([modelClass isSubclassOfClass:[BBModel class]], @"model类应该是BBModel的子类");
            dataObject = [modelClass createFromJSONDictionary:responseObject[@"data"]];
        }
        else {
            dataObject = responseObject[@"data"];
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
    
    NSDictionary *dict = @{@"userName":@"allen",
                           @"phone":@"15625043034"};
    // REQUEST参数含义参见上面的 GET:parameters:modelClass:completionBlock: 参数说明

    // get方法示例
    REQUEST(GET, kApiTestAddress, dict, nil, responseBlock);
    
    // post方法示例
    REQUEST(POST, kApiTestAddress, dict, [BBModel class], responseBlock);
}

@end
