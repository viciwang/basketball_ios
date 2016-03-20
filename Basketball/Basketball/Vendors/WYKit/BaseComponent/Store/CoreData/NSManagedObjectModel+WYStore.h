//
//  NSManagedObjectModel+WYStore.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/5.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectModel(WYStore)

+ (void)wy_setDefaultModelWithName:(NSString *)name;

+ (instancetype)wy_defaultModel;

+ (void)wy_setDefaultModel;

@end
