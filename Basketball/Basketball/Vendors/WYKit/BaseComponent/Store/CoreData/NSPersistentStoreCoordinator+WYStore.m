//
//  NSPersistentStoreCoordinator+WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSPersistentStoreCoordinator+WYStore.h"
#import "NSManagedObjectModel+WYStore.m"
#import "NSPersistentStore+WYStore.h"

static NSPersistentStoreCoordinator *WYPersistentStoreCoordinator;

@implementation NSPersistentStoreCoordinator(WYStore)

+ (instancetype)wy_defaultPersistentStoreCoordinator {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [self wy_setDefaultPersistentStoreCoordinator];
        [WYPersistentStoreCoordinator wy_addStore];
    });
    
    return WYPersistentStoreCoordinator;
}

+ (void)wy_setDefaultPersistentStoreCoordinator {
    
        NSManagedObjectModel *model = [NSManagedObjectModel wy_defaultModel];
        [self wy_setDefaultPersistentStoreCoordinatorWithModel:model];
}

+ (void)wy_setDefaultPersistentStoreCoordinatorWithModel:(NSManagedObjectModel *)model {
    WYPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
}

- (NSPersistentStore *)wy_addStore {
    
    NSURL *defaultStoreURL = [NSPersistentStore wy_defaultPersistentStoreURL];
    return [self wy_addStoreWithURL:defaultStoreURL type:NSSQLiteStoreType configuration:nil option:nil];
}

- (NSPersistentStore *)wy_addStoreWithName:(NSString *)storeName type:(NSString *)type configuration:(NSString *)configuration option:(NSDictionary *)opt {
    
    NSURL *storeURL = [NSPersistentStore wy_persistentStoreURLWithName:storeName];
    
    return [self wy_addStoreWithURL:storeURL type:type configuration:configuration option:opt];
}

- (NSPersistentStore *)wy_addStoreWithURL:(NSURL *)storeURL type:(NSString *)type configuration:(NSString *)configuration option:(NSDictionary *)opt {
    
    NSError *error = nil;
    
    NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:configuration
                                                            URL:storeURL
                                                        options:opt
                                                          error:&error];
    
    
    return store;
}

@end
