//
//  WYFeedStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/9.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYStore.h"
#import "WYFeed.h"
#import "WYFeedEntity.h"
#import "WYFeedEntity+ValidateArticle.h"

@interface WYFeedStore : WYStore

@property (nonatomic, readonly) NSManagedObjectContext *tempContext;

+ (void)setDefaultFeedPageSize:(NSUInteger)size;
+ (void)setDefaultFeedEntityPageSize:(NSUInteger)size;

+ (NSArray *)fetchFeeds;
+ (NSArray *)fetchFeedAtPage:(NSUInteger)page;
+ (NSArray *)fetchFeedEntityAtPage:(NSUInteger)page;
+ (void)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block;

- (WYFeed *)temporaryFeed;
- (WYFeed *)temporaryFeedEntity;
- (NSArray *)numbersOfTemporaryFeed:(NSInteger)numbers;
- (NSArray *)numbersOfTemporaryFeedEntity:(NSInteger)numbers;


+ (WYFeed *)feedExist:(WYFeed *)feed;
+ (WYFeed *)feedExistWithLink:(NSString *)link;

+ (void)insertFeed:(WYFeed *)feedInfo completion:(WYStoreSaveCompletionBlock)block;
+ (void)insertFeedEntity:(id)entitys forFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block;

+ (void)deleteAllFeedWithCompletion:(WYStoreSaveCompletionBlock)block;
+ (void)deleteFeeds:(NSArray *)feeds completion:(WYStoreSaveCompletionBlock)block;
+ (void)deleteFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block;

+ (void)deleteAllEntityInFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block;

- (NSArray *)fetchFeeds;
- (NSArray *)fetchFeedAtPage:(NSUInteger)page;
- (NSArray *)fetchFeedEntityAtPage:(NSUInteger)page;
- (NSArray *)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page;
- (void)fetchFeedEntityAtPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block;
- (void)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block;


- (WYFeed *)feedExist:(WYFeed *)feed;
- (WYFeed *)feedExistWithLink:(NSString *)link;

- (void)insertFeed:(WYFeed *)feedInfo completion:(WYStoreSaveCompletionBlock)block;
- (void)insertFeeds:(NSArray *)feedInfos completion:(WYStoreSaveCompletionBlock)block;
- (void)insertFeedEntity:(id)entitys forFeed:(WYFeed *) feed completion:(WYStoreSaveCompletionBlock)block;

- (void)deleteAllFeedWithCompletion:(WYStoreSaveCompletionBlock)block;
- (void)deleteAllFeedEntityWithCompletion:(WYStoreSaveCompletionBlock)block;
- (void)deleteFeeds:(NSArray *)feeds completion:(WYStoreSaveCompletionBlock)block;
- (void)deleteFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block;

- (void)deleteAllEntityInFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block;

- (void)saveModifyCompletion:(WYStoreSaveCompletionBlock)block;

@end
