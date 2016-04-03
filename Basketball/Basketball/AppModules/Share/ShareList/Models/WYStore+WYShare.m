//
//  WYStore+WYShare.m
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "WYStore+WYShare.h"
#import "WYShare.h"
#import "WYShareComment.h"

@implementation WYFeedStore(WYShare)

- (NSArray *)numbersOfTemporaryShareEntity:(NSInteger)numbers {
    return [WYShare wy_createNumbers:numbers managedObjectInContext:self.tempContext];
}
- (NSArray *)numbersOfTemporaryShareCommentEntity:(NSInteger)numbers {
    return [WYShareComment wy_createNumbers:numbers managedObjectInContext:self.tempContext];
}

@end
