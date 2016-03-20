//
//  WYFeedManager.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/12.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYFeedStore.h"

typedef void(^WYFeedManageProgressBlock)(NSInteger index, float progress, NSError *error);
typedef void(^WYFeedManageCompletionBlock)(id obj, BOOL success, NSError *error);

@class WYFeed;
@class WYFeedStore;

@interface WYFeedManager : NSObject

@property (nonatomic, readonly) WYFeedStore *store;

+ (instancetype)shareManager;

- (void)getFeedWithLink:(NSString *)link completion:(WYFeedManageCompletionBlock)block;
//- (void)getFeedEntity:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block;
- (void)updateFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block;
- (void)deleteFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block;
- (void)saveFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block;
- (void)updateFeeds:(NSArray *)feedSet downloadImages:(BOOL)downloadImg totalProgress:(WYFeedManageProgressBlock)totalProgress singleProgress:(WYFeedManageProgressBlock)singleProgress completionBlock:(WYFeedManageCompletionBlock)completionBlock;

@end
