//
//  NSManagedObjectModel+WYStore.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "NSManagedObjectModel+WYStore.h"

static NSManagedObjectModel* WYDefaultManagedObjectModel;

@implementation NSManagedObjectModel(WYStore)

+ (instancetype)wy_defaultModel {
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [self wy_setDefaultModel];
    });
    return WYDefaultManagedObjectModel;
}

+ (void)wy_setDefaultModel {
    
    NSString *bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    [self wy_setDefaultModelWithName:bundleName];
}

+ (void)wy_setDefaultModelWithName:(NSString *)name {
    
    NSArray *namePart = [name componentsSeparatedByString:@"."];
    NSString *resource = [namePart firstObject];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:resource withExtension:@"momd"];//namePart.count>1? [namePart lastObject] : @"momd"];
    WYDefaultManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

@end
