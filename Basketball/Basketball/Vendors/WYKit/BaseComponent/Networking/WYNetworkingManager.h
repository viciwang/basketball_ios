//
//  FKNetworkingManager.h
//  MicroReader
//
//  Created by yingwang on 15/10/28.
//  Copyright © 2015年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WYRequestCompletionBlock)(id respondObj,BOOL success,NSError *error);

@interface WYNetworkingManager : NSObject

+ (instancetype)shareManager;

- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)GET:(NSString *)urlComponent parameter:(id)par completion:(WYRequestCompletionBlock)block;

@end
