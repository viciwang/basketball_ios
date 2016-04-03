//
//  BBShareCell.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareCell.h"


@implementation BBShareCell

- (void)awakeFromNib {
    _mainView = [BBShareCellView loadFromNib];
    [self addSubview:_mainView];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _mainView.frame = self.bounds;
}

@end
