//
//  WYFeedManager.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/12.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeedManager.h"
#import "WYFeed.h"

#import "WYHTTPRequestManager.h"
#import "WYFeedSerialization.h"

#import "SDWebImageManager+Mutiple.h"

@interface WYFeedUpdateCommand : NSOperation

@property (nonatomic, strong) WYFeedStore *store;
@property (nonatomic, strong) SDWebImageManager *imgManager;

@property (nonatomic, strong) WYFeedManageProgressBlock totalProgress;
@property (nonatomic, strong) WYFeedManageProgressBlock singleProgress;
@property (nonatomic, strong) WYFeedManageCompletionBlock completionUpdataBlock;
@property (nonatomic, strong) NSArray *feedSet;
@property (nonatomic, assign) BOOL downloadComplete;
@property (nonatomic, assign) NSUInteger completeFeedCount;
@property (nonatomic, assign) BOOL downloadImages;

+ (instancetype)updateFeeds:(NSArray *)feedSet downloadImage:(BOOL)downloadImg totalProgress:(WYFeedManageProgressBlock)totalProgress singleProgress:(WYFeedManageProgressBlock)singleProgress completionBlock:(WYFeedManageCompletionBlock)completionBlock;

@end

@interface WYFeedManager ()

@property (nonatomic, strong) WYFeedStore *privateStore;
@property (nonatomic, strong) NSOperationQueue *privateOperationQueue;

@end

@implementation WYFeedManager

+ (instancetype)shareManager {
    
    static WYFeedManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[WYFeedManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _privateStore = [[WYFeedStore alloc] init];
    }
    return self;
}

- (WYFeedStore *)store {
    return _privateStore;
}

- (NSOperationQueue *)privateOperationQueue {
    
    static dispatch_once_t pridicate;
    dispatch_once(&pridicate, ^{
        if (!_privateOperationQueue) {
            _privateOperationQueue = [[NSOperationQueue alloc] init];
            _privateOperationQueue.maxConcurrentOperationCount = 1;
        }
    });
    return _privateOperationQueue;
}

- (void)getFeedWithLink:(NSString *)link completion:(WYFeedManageCompletionBlock)block {
    
    __weak WYFeedManager *weakSelf = self;
    // 1.fetch data
    [[WYHTTPRequestManager manager] GET:link parameter:nil completionBlock:^(id respondObj, BOOL success, NSError *error) {
        if (!success) {
            block(nil, NO, error);
            return;
        }
        
        if (!respondObj) {
            block(nil, NO, nil);
            return;
        }
        __weak WYFeedManager *weakManager = weakSelf;
        // 2. parse date
        [WYFeedSerialization feedObjectWithData:respondObj options:0 complete:^(id obj, BOOL success, NSError *error) {

            __strong WYFeedManager *strongSelf = weakManager;
            WYFeed *feed = [strongSelf.privateStore temporaryFeed];
            feed.name = obj[kWYFeedSerializationTitleKey];
            feed.link = link;//obj[kWYFeedSerializationLinkKey];
            feed.feedDescription = obj[kWYFeedSerializationDescriptionKey];
            feed.imageURL = obj[kWYFeedSerializationImageURLKey];
            //feed.lastBuildDate = obj[kWYFeedSerializationLastBuildDateKey];
            NSArray *feedEntityInfo = obj[kWYFeedSerializationEntityKey];
            if (feedEntityInfo) {
                NSArray *entityArray = [strongSelf.privateStore numbersOfTemporaryFeedEntity:feedEntityInfo.count];
                [feedEntityInfo enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *  stop) {
                    WYFeedEntity *entity = entityArray[idx];
                    entity.title = obj[kWYFeedSerializationEntityTitleKey];
                    entity.link = obj[kWYFeedSerializationEntityLinkKey];
                    entity.feedLink = feed.link;
                    entity.feedDescription = obj[kWYFeedSerializationEntityDescriptionKey];
                    //tmpObj.publishDate = tmpDic[kWYFeedSerializationEntityPublicDateKey];
                    entity.thumbnail = obj[kWYFeedSerializationEntityThumbnailKey];
                }];
                feed.feedEntity = entityArray;
            }
            
            block(feed, YES, nil);
        }];
    }];
}


- (void)updateFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block {

    __weak WYFeedManager *weakSelf = self;
    // 1.fetch data
    [[WYHTTPRequestManager manager] GET:feed.link parameter:nil completionBlock:^(id respondObj, BOOL success, NSError *error) {
        
        if (!success) {
            block(nil, NO, error);
            return;
        }
        
        if (!respondObj) {
            block(nil, YES, nil);
            return;
        }
        // 2. parse date
        [WYFeedSerialization feedObjectWithData:respondObj options:0 complete:^(id obj, BOOL success, NSError *error) {
            __strong WYFeedManager *strongSelf = weakSelf;
            
            [strongSelf.privateStore insertFeedEntity:obj[kWYFeedSerializationEntityKey] forFeed:feed completion:block];
        }];
    }];
}

- (void)deleteFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block {
    
    [_privateStore deleteFeed:feed completion:^(id obj, BOOL success, NSError *error) {
        block(obj, success, error);
    }];
}

- (void)saveFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block {
    
    [_privateStore saveModifyCompletion:^(id obj, BOOL success, NSError *error) {
        block(obj, success, error);
    }];
}

//- (void)updateFeed:(WYFeed *)feed completion:(WYFeedManageCompletionBlock)block {
//    [self updateFeeds:@[feed]
//        totalProgress:nil
//       singleProgress:nil
//      completionBlock:block];
//}
- (void)updateFeeds:(NSArray *)feedSet downloadImages:(BOOL)downloadImg totalProgress:(WYFeedManageProgressBlock)totalProgress singleProgress:(WYFeedManageProgressBlock)singleProgress completionBlock:(WYFeedManageCompletionBlock)completionBlock {
    
    WYFeedUpdateCommand *command = [WYFeedUpdateCommand updateFeeds:feedSet downloadImage:downloadImg
                                                      totalProgress:totalProgress
                                                     singleProgress:singleProgress
                                                    completionBlock:completionBlock];
    command.store = _privateStore;
    [self.privateOperationQueue addOperation:command];
}

@end



@implementation WYFeedUpdateCommand

+ (instancetype)updateFeeds:(NSArray *)feedSet downloadImage:(BOOL)downloadImg totalProgress:(WYFeedManageProgressBlock)totalProgress singleProgress:(WYFeedManageProgressBlock)singleProgress completionBlock:(WYFeedManageCompletionBlock)completionBlock {
    
    WYFeedUpdateCommand *command = [[self alloc] init];
    command.totalProgress = totalProgress;
    command.singleProgress = singleProgress;
    command.completionUpdataBlock = completionBlock;
    command.feedSet = feedSet;
    command.downloadImages = downloadImg;
    
    return command;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _completeFeedCount = 0;
        _imgManager = [[SDWebImageManager alloc] init];
    }
    return self;
}

- (void)setCompleteFeedCount:(NSUInteger)completeFeedCount {
    
    
    if (_completeFeedCount!=completeFeedCount && _totalProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _totalProgress(-1, (float)completeFeedCount/_feedSet.count,nil);
        });
    }
    
    if (completeFeedCount == _feedSet.count) {
        
        if (_completionUpdataBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _completionUpdataBlock(nil, YES, nil);
            });
        }
        _downloadComplete = YES;
    }
    
    _completeFeedCount = completeFeedCount;
}

- (void)start {
    
    if (!_feedSet || !_feedSet.count) {
        return;
    }
    
    WYFeedUpdateCommand *weakSelf = self;
    for(NSUInteger index = 0; index < _feedSet.count; index++) {
        WYFeed *feed = _feedSet[index];
        [[WYHTTPRequestManager manager] GET:feed.link parameter:nil completionBlock:^(id respondObj, BOOL success, NSError *error) {
            __strong WYFeedUpdateCommand *strongSelf = weakSelf;
            if (!success) {
                strongSelf.completeFeedCount = strongSelf.completeFeedCount + 1;
                strongSelf.singleProgress?strongSelf.singleProgress(index, 0, error):nil;
                return;
            }
            
            if (!respondObj) {
                strongSelf.completeFeedCount = strongSelf.completeFeedCount + 1;
                strongSelf.singleProgress?strongSelf.singleProgress(index, 1.0, nil):nil;
                return;
            }
            strongSelf.singleProgress?strongSelf.singleProgress(index, 0.3, nil):nil;
            // 2. parse date
            [WYFeedSerialization feedObjectWithData:respondObj options:0 complete:^(id obj, BOOL success, NSError *error) {
                
                __strong WYFeedUpdateCommand *strongSelf = weakSelf;
                strongSelf.singleProgress?strongSelf.singleProgress(index, 0.6, nil):nil;
                // 3.insert data to local sql
                [strongSelf.store insertFeedEntity:obj[kWYFeedSerializationEntityKey] forFeed:feed completion:^(id obj, BOOL success, NSError *error) {
                    __strong WYFeedUpdateCommand *strongSelf = weakSelf;
                    
                    if(!_downloadImages) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            strongSelf.completeFeedCount = strongSelf.completeFeedCount + 1;
                            strongSelf.singleProgress?strongSelf.singleProgress(index, 1.0, nil):nil;
                        });
                    } else {
                        // 4.download images
                        NSArray *entitys = (NSArray *)obj;
                        [entitys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            WYFeedEntity *entity = (WYFeedEntity *)obj;
                            NSArray *images = entity.imageArray;
                            
                            [_imgManager downloadImageWithURLs:images retrieveImages:NO
                                                       options:SDWebImageContinueInBackground|SDWebImageRetryFailed
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 strongSelf.singleProgress?strongSelf.singleProgress(index, (0.35*receivedSize)/expectedSize, nil):nil;
                                                             });
                                                         } completed:^(NSArray *images, NSError *error, BOOL finished) {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                strongSelf.completeFeedCount = strongSelf.completeFeedCount + 1;
                                                                strongSelf.singleProgress?strongSelf.singleProgress(index, 1.0, nil):nil;
                                                            });
                                                        }];
                        }];
                        
                    }
                }];
            }];
        }];
    }
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    while (!_downloadComplete) {
        [runloop runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    }
}

@end