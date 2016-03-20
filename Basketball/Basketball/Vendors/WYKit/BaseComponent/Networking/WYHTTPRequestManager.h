//
//  WYHTTPRequestManager.h
//  MicroReader
//
//  Created by yingwang on 15/12/8.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYURLSessionManager.h"

typedef void(^WTHTTPRequestCompletionBlock)(id responseObject,BOOL success,NSError *error);

@interface WYHTTPRequestManager : WYURLSessionManager

+ (instancetype)manager;
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

- (void)GET:(NSString *)urlComponent parameter:(id)parameter completionBlock:(WTHTTPRequestCompletionBlock)block;

@end
