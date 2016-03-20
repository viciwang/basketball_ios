//
//  NSPersistentStore+WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSPersistentStore(WYStore)

+ (NSURL *)wy_defaultPersistentStoreURL;

+ (NSURL *)wy_persistentStoreURLWithName:(NSString *)name;

+ (void)wy_setDefaultPersistentStoreURL;

+ (void)wy_setDefaultPersistentStoreURL:(NSURL *)url;


@end
