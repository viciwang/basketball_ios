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
#import "BBUser.h"
#import "BBStepCountingHistoryRecord.h"
#import "BBStepCountingRank.h"

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

#ifdef DEBUG
static NSString *_debugBaseUrl = nil;

+ (void)configDebugBaseUrl:(NSString *)baseurl {

    _debugBaseUrl = baseurl;
}

+ (NSString *)retriveDebugBaseUrl {
    return _debugBaseUrl;
}
#endif

+ (BBNetworkApiManager *)sharedManager {
    static BBNetworkApiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BBNetworkApiManager alloc]init];
    });
    return manager;
}

- (instancetype)init {
#ifdef DEBUG
    if ([BBNetworkApiManager retriveDebugBaseUrl]) {
        self = [super initWithBaseURL:[NSURL URLWithString:[BBNetworkApiManager retriveDebugBaseUrl]]];
    }
#else
    self = [super initWithBaseURL:[NSURL URLWithString:kApiBaseUrl]];
#endif
    
    if (self) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        BBUser *user = [BBUser currentUser];
        if (user) {
            [self.requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
            [self.requestSerializer setValue:user.uid forHTTPHeaderField:@"uid"];
        }
        self.responseSerializer = [BBResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/javascript", nil];
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

- (NSURLSessionDataTask *)getVerifyCodeWithEmail:(NSString *)email
                                 completionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(POST, kApiUserGetVerifyCode, (@{@"email":email}), nil, ^(NSDictionary *dict, NSError *error){
        if (responseBlock) {
            if (!error) {
                responseBlock(dict[@"verifyCode"],nil);
            }
            else {
                responseBlock(nil,error);
            }
        }
    });
}

- (NSURLSessionDataTask *)uploadImageWithImage:(UIImage *)image
                               completionBlock:(BBNetworkResponseBlock)responseBlock {
    return [self POST:kApiUserUploadHeadImage parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", @([[NSDate date] timeIntervalSince1970]).stringValue];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        if (responseBlock) {
            responseBlock(responseObject[@"data"][@"headImageUrl"],nil);
        }
    }
       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (responseBlock) {
            responseBlock(nil,error);
        }
    }];
}

- (NSURLSessionDataTask *)loginWithEmail:(NSString *)email
                                password:(NSString *)password
                         completionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(POST, kApiUserLogin ,(@{@"email":email , @"password":password}), [BBUser class], ^(BBUser *user, NSError *error){
        if (error) {
            if (responseBlock) {
                responseBlock(nil, error);
            }
        }
        else {
            [[BBNetworkApiManager sharedManager].requestSerializer setValue:user.token forHTTPHeaderField:@"token"];
            [[BBNetworkApiManager sharedManager].requestSerializer setValue:user.uid forHTTPHeaderField:@"uid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBBNotificationUserDidLogin object:nil];
            if (responseBlock) {
                responseBlock(user, error);
            }
        }
    });
}

- (NSURLSessionDataTask *)registerWithEmail:(NSString *)email
                                   password:(NSString *)password
                                 verifyCode:(NSString *)verifyCode
                            completionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(POST, kApiUserRegister ,(@{@"email":email,@"password":password,@"verifyCode":verifyCode}), [BBUser class], responseBlock);
}

- (NSURLSessionDataTask *)updateUserInfoWithCity:(NSString *)city
                                        nickName:(NSString *)nickName
                                    headImageUrl:(NSString *)headImageUrl
                                 completionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(POST, kApiUserUpdateInfo, (@{@"city":city,@"nickName":nickName,@"headImageUrl":headImageUrl}), [BBUser class], responseBlock);
}

- (NSURLSessionDataTask *)resetPasswordWithPassword:(NSString *)password completionBlock:(BBNetworkResponseBlock)responseBlock {
    return nil;
}

- (NSURLSessionDataTask *)getAverageStepCountWithCompletionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(GET, kApiStepCountingAverage, nil, nil, ^(NSDictionary *dict, NSError *error){
        if (error) {
            if (responseBlock) {
                responseBlock(nil,error);
            }
        }
        else {
            if (responseBlock) {
                responseBlock(dict[@"totalCount"],nil);
            }
        }
    });
}

- (NSURLSessionDataTask *)getHistoryStepCountWithCompletionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(GET, kApiStepCountingHistory, nil, nil, ^(NSArray *record,NSError *error){
        if (error) {
            if (responseBlock) {
                responseBlock(nil,error);
            }
        }
        else {
            if (responseBlock) {
                NSArray *records = [MTLJSONAdapter modelsOfClass:[BBStepCountingHistoryMonthRecord class] fromJSONArray:record error:&error];
                if (error) {
                    DDLogInfo(@"%@",error);
                }
                responseBlock(records,nil);
            }
        }
    });
}

- (NSURLSessionDataTask *)getStepCountRankingWithCompletionBlock:(BBNetworkResponseBlock)responseBlock {
    REQUEST(GET, kApiStepCountingRanking, nil, nil, ^(NSArray *ranking,NSError *error) {
        if (responseBlock) {
            if (error) {
                responseBlock(nil,error);
            }
            else {
                NSArray *rank = [MTLJSONAdapter modelsOfClass:[BBStepCountingRank class] fromJSONArray:ranking error:&error];
                if (error) {
                    DDLogInfo(@"%@",error);
                }
                responseBlock(rank,error);
            }
        }
    });
}

@end
