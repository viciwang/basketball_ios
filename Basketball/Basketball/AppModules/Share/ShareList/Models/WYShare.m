//
//  WYShare.m
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "WYShare.h"
#import <objc/runtime.h>

static NSString const * const shareImageDictionary = @"shareImageDictionary";
@implementation WYShare

- (NSDictionary *)imageDictionary {
    return objc_getAssociatedObject(self, (__bridge const void *)(shareImageDictionary));
}
- (void)setImageDictionary:(NSDictionary *)imageDictionary {
    objc_setAssociatedObject(self, (__bridge const void *)(shareImageDictionary), imageDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// Insert code here to add functionality to your managed object subclass

@end
