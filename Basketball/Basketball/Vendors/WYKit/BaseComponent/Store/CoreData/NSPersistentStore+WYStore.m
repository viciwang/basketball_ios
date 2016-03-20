//
//  NSPersistentStore+WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSPersistentStore+WYStore.h"

static NSURL * WYDefaultPersistentStoreURL;

@implementation NSPersistentStore(WYStore)

+ (NSURL *)wy_defaultPersistentStoreURL {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [self wy_setDefaultPersistentStoreURL];
    });
    return WYDefaultPersistentStoreURL;
}

+ (NSURL *)wy_persistentStoreURLWithName:(NSString *)name {
    
    NSURL *docURL = [self wy_applicationDocumentsDirectory];
    NSURL *persistentURL = [docURL URLByAppendingPathComponent:name];
    return persistentURL;
}

+ (NSURL *)wy_applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (void)wy_setDefaultPersistentStoreURL {
    
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSURL *docURL = [self wy_applicationDocumentsDirectory];
    WYDefaultPersistentStoreURL = [docURL URLByAppendingPathComponent:[bundleName stringByAppendingPathExtension:@"sqlite"]];
}

+ (void)wy_setDefaultPersistentStoreURL:(NSURL *)url {
    
    WYDefaultPersistentStoreURL = [url copy];
}



@end
