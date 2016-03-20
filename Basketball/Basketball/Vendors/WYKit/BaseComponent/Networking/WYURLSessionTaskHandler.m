//
//  WYURLSessionTaskHandler.m
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYURLSessionTaskHandler.h"

@interface WYURLSessionTaskHandler ()
@property (nonatomic, copy) WYURLSessionCompletionBlock completionBlock;
@end
@implementation WYURLSessionTaskHandler

- (instancetype)initWithCompletionBlock:(WYURLSessionCompletionBlock)block {
    self = [super init];
    if (self) {
        self.completionBlock = block;
        
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
}

@end

@implementation WYURLSessionDataTaskHandler

- (instancetype)initWithCompletionBlock:(WYURLSessionCompletionBlock)block {
    self = [super initWithCompletionBlock:block];
    if (self) {
        self.receiveData = [NSMutableData data];
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [super URLSession:session task:task didCompleteWithError:error];
    
    if (error) {
        dispatch_group_async(self.completionGroup, self.completionQueue, ^{
            self.completionBlock(nil,false,error);
        });
    } else {
        dispatch_group_async(self.completionGroup, self.completionQueue, ^{
            NSData *data = nil;
            if(self.receiveData){
                data = [NSData dataWithData:self.receiveData];
            }
            self.completionBlock(data,true,nil);
        });
    }
}

@end