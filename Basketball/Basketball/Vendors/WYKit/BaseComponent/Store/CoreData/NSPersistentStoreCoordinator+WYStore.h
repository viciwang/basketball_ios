//
//  NSPersistentStoreCoordinator+WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSPersistentStoreCoordinator(WYStore)

+ (instancetype)wy_defaultPersistentStoreCoordinator;

+ (void)wy_setDefaultPersistentStoreCoordinator;

+ (void)wy_setDefaultPersistentStoreCoordinatorWithModel:(NSManagedObjectModel *)model;

- (NSPersistentStore *)wy_addStore;
- (NSPersistentStore *)wy_addStoreWithName:(NSString *)storeName;
- (NSPersistentStore *)wy_addStoreWithName:(NSString *)storeName type:(NSString *)type configuration:(NSString *)configuration option:(NSDictionary *)opt;


@end
