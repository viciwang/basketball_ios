//
//  LCArticlePageView+Style.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticlePageView+Style.h"

@implementation LCArticlePageView(Style)

+ (LCArticlePageView *)loadPageViewFromNibWithStyle:(LCArticlePageViewStyle)style {
    
    LCArticlePageView *view;
    NSString *name = NSStringFromClass([self class]);
    if (style == kLCArticlePageViewStyleA) {
        name = [name stringByAppendingString:@"1"];
    } else if (style == kLCArticlePageViewStyleB) {
        name = [name stringByAppendingString:@"2"];
    }
    if (TARGETED_DEVICE_IS_IPAD) {
        name = [name stringByAppendingString:@"_iPad"];
    } else {
        name = [name stringByAppendingString:@"_iPhone"];
    }
    view = [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
    return view;
}

@end
