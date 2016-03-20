//
//  WYURLSessionTaskHandler.h
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYURLSessionManager.h"

@interface WYURLSessionTaskHandler : NSObject
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, assign) dispatch_queue_t completionQueue;
@property (nonatomic, assign) dispatch_group_t completionGroup;

- (instancetype)initWithCompletionBlock:(WYURLSessionCompletionBlock)block;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
@end

@interface WYURLSessionDataTaskHandler : WYURLSessionTaskHandler
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data;
@end