//
//  WYFeed.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeed.h"
#import <objc/runtime.h>

static NSString const * const feedEntityKey = @"feedEntity";
@implementation WYFeed


// Insert code here to add functionality to your managed object subclass
- (NSArray *)feedEntity {
    return objc_getAssociatedObject(self, (__bridge const void *)(feedEntityKey));
}
- (void)setFeedEntity:(NSArray *)feedEntity {
    objc_setAssociatedObject(self, (__bridge const void *)(feedEntityKey), feedEntity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
