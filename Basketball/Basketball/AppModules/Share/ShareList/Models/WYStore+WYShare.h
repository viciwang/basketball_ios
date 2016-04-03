//
//  WYStore+WYShare.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "WYFeedStore.h"

@interface WYFeedStore(WYShare)

- (NSArray *)numbersOfTemporaryShareEntity:(NSInteger)numbers;
- (NSArray *)numbersOfTemporaryShareCommentEntity:(NSInteger)numbers;
@end
