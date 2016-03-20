//
//  LCArticleTextBoxView.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticleTextBoxView.h"

@implementation LCArticleTextBoxView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.numberOfLines = 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
