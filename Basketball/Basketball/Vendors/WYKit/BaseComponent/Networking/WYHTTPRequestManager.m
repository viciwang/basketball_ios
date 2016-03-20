//
//  WYHTTPRequestManager.m
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYHTTPRequestManager.h"

@interface WYHTTPRequestManager ()
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation WYHTTPRequestManager
+ (instancetype)manager {
    static WYHTTPRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] initWithBaseURL:nil];
    });
    return manager;
}
- (instancetype)init {
    return [self initWithBaseURL:nil];
}
- (instancetype)initWithBaseURL:(NSURL *)baseURL {
    return [self initWithBaseURL:baseURL sessionConfiguration:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self = [super initWithConfigation:configuration];
    if (self) {
        self.baseURL = baseURL;
    }
    return self;
}
- (NSURL *)absoluteURLWithURLComponent:(NSString *)component {
    NSURL *absoluteURL = [NSURL URLWithString:component relativeToURL:_baseURL];
    return absoluteURL;
}
- (void)GET:(NSString *)urlComponent parameter:(id)parameter completionBlock:(WTHTTPRequestCompletionBlock)block {
    
    NSURL *absoluteURL = [self absoluteURLWithURLComponent:urlComponent];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:absoluteURL];
    request.HTTPMethod = @"GET";
    NSURLSessionTask *dataTask = [self dataTaskWithRequest:request completionBlock:^(id data, BOOL success, NSError *error) {
        block(data,success,error);
    }];
    [dataTask resume];
}
@end
