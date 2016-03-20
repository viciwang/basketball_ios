//
//  FKNetworkingManager.m
//  MicroReader
//
//  Created by yingwang on 15/10/28.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYNetworkingManager.h"

@interface WYNetworkingManager ()<NSURLSessionDelegate>
{
    NSURL *_baseURL;
    NSURLSessionConfiguration *_privateConfiguration;
    NSURLSession *_privateSession;
    NSURLSessionTask *_privateTask;
    
    dispatch_queue_t _privateCompletionQueue;
    NSOperationQueue *_privateDelegateQueue;
    NSURLSessionTask *_task;
}
@end

@implementation WYNetworkingManager

+ (instancetype)managerWithBaseURL:(NSURL *)url {
    return [[self alloc] initWithBaseURL:url];
}

+ (instancetype)shareManager {
    
    static WYNetworkingManager *manager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    return [self initWithBaseURL:nil];
}
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _baseURL = url;
        _privateCompletionQueue = dispatch_queue_create("privateCompletionQueue", DISPATCH_QUEUE_CONCURRENT);
        _privateDelegateQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)configureSession {
    _privateConfiguration = [[NSURLSessionConfiguration alloc] init];
    _privateSession = [NSURLSession sessionWithConfiguration:_privateConfiguration delegate:self delegateQueue:_privateDelegateQueue];
    
}
- (void)fetchDataWithURLComponent:(NSString *)urlComponent parameter:(id)par completion:(WYRequestCompletionBlock)block {
    NSURL *url = _baseURL?[_baseURL URLByAppendingPathComponent:urlComponent]:[NSURL URLWithString:urlComponent];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   _task = [_privateSession dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        dispatch_async(_privateCompletionQueue, ^{
            block(data,1,error);
        });
    }];
    [_task resume];
}
- (void)GET:(NSString *)urlComponent parameter:(id)par completion:(WYRequestCompletionBlock)block {
    [self fetchDataWithURLComponent:urlComponent parameter:par completion:block];
}
@end
