//
//  LCArticlePageView+Style.h
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticlePageView.h"

typedef NS_ENUM(NSUInteger, LCArticlePageViewStyle) {
    kLCArticlePageViewStyleA = 1 << 0,
    kLCArticlePageViewStyleB = 1 << 1
};

@interface LCArticlePageView(Style)

+ (LCArticlePageView *)loadPageViewFromNibWithStyle:(LCArticlePageViewStyle)style;

@end
