//
//  WYURLSessionManager.h
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WYURLSessionCompletionBlock)(id data,BOOL success,NSError *error);

@interface WYURLSessionManager : NSObject
/**
 *	@author FrEk, 15-12-08 16:12:57
 *
 *	Create a manager with default configuration
 *
 *	@return a new manager
 */
+ (instancetype)manager;
/**
 *	@author FrEk, 15-12-08 16:12:31
 *
 *	Create a new manager with destination configuration
 *
 *	@param configation	configuration info
 *
 *	@return a new manager
 */
- (instancetype)initWithConfigation:(NSURLSessionConfiguration *)configuration;
/**
 *	@author FrEk, 15-12-08 16:12:27
 *
 *	Create a data task with a url request
 *
 *	@param request	the destination URL Request
 *	@param block		completion block
 *
 *	@return a new data task
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionBlock:(WYURLSessionCompletionBlock)block;

@end
