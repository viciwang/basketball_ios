//
//  WYFeedStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/9.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeedStore.h"
#import "NSManagedObjectContext+WYStore.h"
#import "WYFeedSerialization.h"
#import "TimeFormatterTransform.h"

static NSUInteger WYFeedStoreDefaultFeedPageSize = 20;
static NSUInteger WYFeedStoreDefaultFeedEntityPageSize = 18;

#define kWYStoreFeedEntityLastestIndex  @"kWYStoreFeedEntityLastestIndex"

@interface WYFeedStore ()
{
    
    NSManagedObjectContext *_temporaryContext;
}

@property (nonatomic, strong) NSManagedObjectContext *privateContext;

@end

@implementation WYFeedStore

+ (instancetype)shareStore {
    static WYFeedStore *store;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        store = [[WYFeedStore alloc] init];
    });
    return store;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _privateContext = [NSManagedObjectContext wy_createPrivateQueueManagedObjectContext];
        [_privateContext wy_setParentContext:[NSManagedObjectContext wy_rootManagedObjectContext]];
        _temporaryContext = [NSManagedObjectContext wy_createPrivateQueueManagedObjectContext];
        [_temporaryContext wy_setParentContext:[NSManagedObjectContext wy_rootManagedObjectContext]];
    }
    return self;
}

+ (void)setDefaultFeedPageSize:(NSUInteger)size {
    if (size) {
        WYFeedStoreDefaultFeedPageSize = size;
    }
}

+ (void)setDefaultFeedEntityPageSize:(NSUInteger)size {
    if (size) {
        WYFeedStoreDefaultFeedEntityPageSize = size;
    }
}

+ (NSArray *)fetchFeeds {
    return [[WYFeedStore shareStore] fetchFeeds];
}
+ (NSArray *)fetchFeedAtPage:(NSUInteger)page {
    return [[WYFeedStore shareStore] fetchFeedAtPage:page];
}

+ (NSArray *)fetchFeedEntityAtPage:(NSUInteger)page {
    return [[WYFeedStore shareStore] fetchFeedEntityAtPage:page];
}
+ (void)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block {
    [[self shareStore] fetchFeedEntity:feed atPage:page completion:block];
}

- (NSArray *)fetchFeeds {
    NSFetchRequest *request = [WYFeed wy_allObjectFetchRequestInContext:_privateContext];
    NSArray *array = [WYFeed wy_executeFetchRequest:request inManagedObjectContext:_privateContext];
    return array;
}
- (NSArray *)fetchFeedAtPage:(NSUInteger)page {
    
    NSFetchRequest *request = [WYFeed wy_fetchRequestAtObjectsRange:NSMakeRange(WYFeedStoreDefaultFeedPageSize*page, WYFeedStoreDefaultFeedPageSize) inContext:_privateContext];
    NSArray *array = [WYFeed wy_executeFetchRequest:request inManagedObjectContext:_privateContext];
    return array;
}

- (NSArray *)fetchFeedEntityAtPage:(NSUInteger)page {
    
    NSFetchRequest *request = [WYFeedEntity wy_fetchRequestAtObjectsRange:NSMakeRange(WYFeedStoreDefaultFeedEntityPageSize*page, WYFeedStoreDefaultFeedEntityPageSize) inContext:_privateContext];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sqlIndex" ascending:NO]];
    NSArray *array = [WYFeedEntity wy_executeFetchRequest:request inManagedObjectContext:_privateContext];
    return array;
}

- (NSArray *)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page {
    
    NSFetchRequest *request = [WYFeedEntity wy_fetchRequestAtObjectsRange:NSMakeRange(WYFeedStoreDefaultFeedEntityPageSize*page, WYFeedStoreDefaultFeedEntityPageSize) inContext:_privateContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedLink=%@",feed.link];
    request.predicate = predicate;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sqlIndex" ascending:NO]];
    NSArray *array = [WYFeedEntity wy_executeFetchRequest:request inManagedObjectContext:_privateContext];
    return array;
}

- (void)fetchFeedEntity:(WYFeed *)feed atPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block {
    
    NSFetchRequest *request = [WYFeedEntity wy_fetchRequestAtObjectsRange:NSMakeRange(WYFeedStoreDefaultFeedEntityPageSize*page, WYFeedStoreDefaultFeedEntityPageSize) inContext:_privateContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedLink=%@",feed.link];
    request.predicate = predicate;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sqlIndex" ascending:NO]];
    [WYFeedEntity wy_executeFetchRequest:request inManagedObjectContext:_privateContext completion:block];
}

- (void)fetchFeedEntityAtPage:(NSUInteger)page completion:(WYStoreSaveCompletionBlock)block {
    NSFetchRequest *request = [WYFeedEntity wy_fetchRequestAtObjectsRange:NSMakeRange(WYFeedStoreDefaultFeedEntityPageSize*page, WYFeedStoreDefaultFeedEntityPageSize) inContext:_privateContext];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sqlIndex" ascending:NO]];
    [WYFeedEntity wy_executeFetchRequest:request inManagedObjectContext:_privateContext completion:block];
}

- (WYFeed *)temporaryFeed {
    return [WYFeed wy_createManagedObjectInContext:_temporaryContext];
}

- (WYFeedEntity *)temporaryFeedEntity {
    return [WYFeedEntity wy_createManagedObjectInContext:_temporaryContext];
}
- (NSArray *)numbersOfTemporaryFeed:(NSInteger)numbers {
    return [WYFeed wy_createNumbers:numbers managedObjectInContext:_temporaryContext];
}

- (NSArray *)numbersOfTemporaryFeedEntity:(NSInteger)numbers {
    
    return [WYFeedEntity wy_createNumbers:numbers managedObjectInContext:_temporaryContext];
}

+ (WYFeed *)feedExist:(WYFeed *)feed {
    return [[self shareStore] feedExist:feed];
}
- (WYFeed *)feedExist:(WYFeed *)feed {
    return [self feedExistWithLink:feed.link];
}

+ (WYFeed *)feedExistWithLink:(NSString *)link {
   return  [[self shareStore] feedExistWithLink:link];
}
- (WYFeed *)feedExistWithLink:(NSString *)link {
    
    __block WYFeed *result;
    [[self class] wy_saveToDiskSyncronize:^(id context) {
        NSManagedObjectContext *ctx = context;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link=%@",link];
        NSFetchRequest *request = [WYFeed wy_fetchRequestWithPridicate:predicate inContext:ctx];
        NSArray *resultArray = [WYFeed wy_executeFetchRequest:request inManagedObjectContext:ctx];
        
        result = resultArray.count?resultArray.firstObject:nil;
    } inContext:_privateContext];
    
    return result;
}

+ (void)insertFeed:(WYFeed *)feedInfo completion:(WYStoreSaveCompletionBlock)block {
    
    [[self shareStore] insertFeed:feedInfo completion:block];
}

- (void)insertFeed:(WYFeed *)feedInfo completion:(WYStoreSaveCompletionBlock)block {
    
    [self insertFeeds:@[feedInfo] completion:block];
}
- (void)insertFeeds:(NSArray *)feedInfos completion:(WYStoreSaveCompletionBlock)block {
    
    __weak WYFeedStore *weakSelf = self;
    [[self class] wy_saveToDisk:^(id context) {
        
        __strong WYFeedStore *strongSelf = weakSelf;
        NSManagedObjectContext *ctx = context;
        
        for (WYFeed *feedInfo in feedInfos) {
            WYFeed *feed = [strongSelf feedExist:feedInfo];
            //check if there is a feed with a link the same as the insert one
            //if already exist, update
            //else create a new feed
            if (!feed) {
                feed = (feedInfo.managedObjectContext==strongSelf.privateContext)?feedInfo:[WYFeed wy_createManagedObjectInContext:ctx];
            }
            
            feed.name = feedInfo.name;
            feed.link = feedInfo.link;
            feed.feedDescription = feedInfo.feedDescription;
            feed.imageURL = feedInfo.imageURL;
            feed.lastBuildDate = feedInfo.lastBuildDate;
        }
    } inContext:_privateContext completion:block];
}

+ (void)insertFeedEntity:(id)entitys forFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    
    [[self shareStore] insertFeedEntity:entitys forFeed:feed completion:block];
}

- (void)insertFeedEntity:(id)entitys forFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    
    [[self class] wy_saveToDisk:^(id context) {
        
        NSManagedObjectContext *ctx = context;
        //...
        NSMutableArray *insertArray = [NSMutableArray array];
        if ([entitys isKindOfClass:[NSArray class]]) {
            [insertArray addObjectsFromArray:entitys];
        } else if([entitys isKindOfClass:[NSDictionary class]]) {
            [insertArray addObject:entitys];
        } else {
            //block(nil, NO, );
            return ;
        }
        
        
        // 1.check the exist feed entity
        NSFetchRequest *request = [WYFeedEntity wy_fetchRequestAtObjectsRange:NSMakeRange(0, insertArray.count) inContext:ctx];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sqlIndex" ascending:NO]];
        NSArray *existObjectArray = [WYFeedEntity wy_executeFetchRequest:request inManagedObjectContext:ctx];
        if (existObjectArray && existObjectArray.count>0) {
            NSMutableArray *objectToInsert = [NSMutableArray array];
            NSMutableDictionary *linkMap = [NSMutableDictionary dictionary];
            for (WYFeedEntity *entity in existObjectArray) {
                linkMap[entity.link] = @1;
            }
            for (NSDictionary *entityInfo in insertArray) {
                if (!linkMap[entityInfo[kWYFeedSerializationEntityLinkKey]]) {
                    [objectToInsert addObject:entityInfo];
                }
            }
            insertArray = objectToInsert;
        }
        // 2. create new managed object
        NSArray *manageObjectArray = [WYFeedEntity wy_createNumbers:insertArray.count managedObjectInContext:ctx];
        
        // 3. set property of managed object
        BOOL setFeedThumbnail = false;
        WYFeedEntity *tmpObj;
        NSDictionary *tmpDic;
        //获取数据库中最后下标
        NSInteger lastedIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:kWYStoreFeedEntityLastestIndex] integerValue];
        // 最新的放最后面
        for (NSInteger i = manageObjectArray.count-1;i >= 0; i--) {
            tmpObj = manageObjectArray[i];
            tmpDic = insertArray[i];
            tmpObj.title = tmpDic[kWYFeedSerializationEntityTitleKey];
            tmpObj.link = tmpDic[kWYFeedSerializationEntityLinkKey];
            tmpObj.feedLink = feed.link;
            tmpObj.feedDescription = tmpDic[kWYFeedSerializationEntityDescriptionKey];
            tmpObj.sourceName = feed.name;
            tmpObj.publishDate = [TimeFormatterTransform transformCSTTimeToDefaultDateStringFromString:tmpDic[kWYFeedSerializationEntityPublicDateKey]];
            tmpObj.insertedDate = [NSDate date];
            tmpObj.sqlIndex = @(++lastedIndex);
            tmpObj.thumbnail = tmpDic[kWYFeedSerializationEntityThumbnailKey];
            NSArray *images = tmpObj.imageArray;
            tmpObj.thumbnail = images.count?[images firstObject]:tmpObj.thumbnail;
            if (tmpObj.thumbnail && !setFeedThumbnail) {
                feed.imageURL = tmpObj.thumbnail;
            }
        }
        // 设置数据库最后下标
        [[NSUserDefaults standardUserDefaults] setObject:@(lastedIndex) forKey:kWYStoreFeedEntityLastestIndex];
        [[NSUserDefaults standardUserDefaults] synchronize];
        block(manageObjectArray, YES,nil);
    } inContext:_privateContext completion:nil];
}

+ (void)deleteAllFeedWithCompletion:(WYStoreSaveCompletionBlock)block {
    [[self shareStore] deleteAllFeedWithCompletion:block];
}

- (void)deleteAllFeedEntityWithCompletion:(WYStoreSaveCompletionBlock)block {
    [[self class] wy_saveToDisk:^(id context) {
        
        NSManagedObjectContext *ctx = context;
        //...
        NSFetchRequest *allRequest = [WYFeedEntity wy_allObjectFetchRequestInContext:ctx];
        allRequest.returnsObjectsAsFaults = NO;
        allRequest.propertiesToFetch = nil;
        
        NSArray *resultArray = [WYFeedEntity wy_executeFetchRequest:allRequest
                                       inManagedObjectContext:ctx];
        for (NSManagedObject *obj in resultArray) {
            [ctx deleteObject:obj];
        }
        
    } inContext:_privateContext completion:block];
}
- (void)deleteAllFeedWithCompletion:(WYStoreSaveCompletionBlock)block {
    
    [[self class] wy_saveToDisk:^(id context) {
        
        NSManagedObjectContext *ctx = context;
        //...
        NSFetchRequest *allRequest = [WYFeed wy_allObjectFetchRequestInContext:ctx];
        allRequest.returnsObjectsAsFaults = NO;
        allRequest.propertiesToFetch = nil;
        
        NSArray *resultArray = [WYFeed wy_executeFetchRequest:allRequest
                                       inManagedObjectContext:ctx];
        for (NSManagedObject *obj in resultArray) {
            [ctx deleteObject:obj];
        }
        
    } inContext:_privateContext completion:block];
}
+ (void)deleteFeeds:(NSArray *)feeds completion:(WYStoreSaveCompletionBlock)block {
    [[self shareStore] deleteFeeds:feeds completion:block];
}
+ (void)deleteFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    [[self shareStore] deleteFeed:feed completion:block];
}

- (void)deleteFeeds:(NSArray *)feeds completion:(WYStoreSaveCompletionBlock)block {
    __weak WYFeedStore *weakSelf = self;
    [[self class] wy_saveToDisk:^(id context) {
        __strong WYFeedStore *strongSelf = weakSelf;
        NSManagedObjectContext *ctx = context;
        for (WYFeed *feed in feeds) {
            WYFeed *contextFeed = feed;
            if (feed.managedObjectContext!=strongSelf.privateContext) {
                contextFeed = [strongSelf.privateContext objectWithID:feed.objectID];
            }
            
            [self deleteAllEntityInFeed:contextFeed completion:nil];
            [ctx deleteObject:contextFeed];
        }
    } inContext:_privateContext completion:block];
}
- (void)deleteFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    
    [self deleteFeeds:@[feed] completion:block];
}

+ (void)deleteAllEntityInFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    [[self shareStore] deleteAllEntityInFeed:feed completion:block];
}

- (void)deleteAllEntityInFeed:(WYFeed *)feed completion:(WYStoreSaveCompletionBlock)block {
    
    [[self class] wy_saveToDisk:^(id context) {
        
        NSManagedObjectContext *ctx = context;
        //...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feedLink=%@",feed.link];
        NSFetchRequest *allRequest = [WYFeedEntity wy_fetchRequestWithPridicate:predicate inContext:ctx];
        allRequest.returnsObjectsAsFaults = NO;
        allRequest.propertiesToFetch = nil;
        
        NSArray *resultArray = [WYFeedEntity wy_executeFetchRequest:allRequest
                                       inManagedObjectContext:ctx];
        for (NSManagedObject *obj in resultArray) {
            [ctx deleteObject:obj];
        }
        
    } inContext:_privateContext completion:block];
}

- (void)saveModifyCompletion:(WYStoreSaveCompletionBlock)block {
    
    [[self class] wy_saveToDisk:nil
                      inContext:_privateContext
                     completion:block];
}

@end
