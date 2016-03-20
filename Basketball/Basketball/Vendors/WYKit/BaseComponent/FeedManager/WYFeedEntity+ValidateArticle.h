//
//  WYFeedEntity+VaildateArticle.h
//  LazyCat
//
//  Created by yingwang on 16/3/12.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeedEntity.h"

@interface WYFeedEntity(ValidateArticle)

@property (nonatomic, strong) NSArray *imageArray;

- (BOOL)isArticleContentValid;

@end
