//
//  BBPersonalCenterCell.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBPersonalCenterCell.h"

@implementation BBPersonalCenterCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsLastIndexInSection:(BOOL)isLastIndexInSection {
    _isLastIndexInSection = isLastIndexInSection;
    if (isLastIndexInSection) {
        [[self viewWithTag:10] removeFromSuperview];
    }
    else {
        if (![self viewWithTag:10]) {
            UIView *view = [UIView new];
            view.backgroundColor = UIColorFromHex(0xc8c7cc);
            [self addSubview:view];
            @weakify(self);
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.height.equalTo(@(1));
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.bottom.equalTo(self);
            }];
        }
    }
}

@end
