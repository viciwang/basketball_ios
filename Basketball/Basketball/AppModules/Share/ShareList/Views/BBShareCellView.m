//
//  BBShareCellView.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareCellView.h"
#import "BBImageLayoutView.h"
#import "WYShare.h"

@interface BBShareCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *approveLabel;

@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet BBImageLayoutView *mainImageLayoutViiew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *shadowView1;
@property (weak, nonatomic) IBOutlet UIView *shadowView2;

@end

@implementation BBShareCellView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.shadowView1.layer.cornerRadius = 3;
    self.shadowView1.layer.masksToBounds = YES;
    self.shadowView2.layer.cornerRadius = 3;
    self.shadowView2.layer.masksToBounds = YES;
}

- (void)setShareEntity:(WYShare *)shareEntity {
    _shareEntity = shareEntity;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_shareEntity.headImageUrl] placeholderImage:[UIImage imageNamed:@"ATL_logo.png"]];
    _nickNameLabel.text = _shareEntity.nickName;
    //_dateLabel.text = _shareEntity.publicDate;
    _commentLabel.text = [NSString stringWithFormat:@"%lu",[_shareEntity.commentCount integerValue]];
    _approveLabel.text = [NSString stringWithFormat:@"%lu",[_shareEntity.approveCount integerValue]];
    _mainTextView.text = _shareEntity.content;
    _mainImageLayoutViiew.images = _shareEntity.imageDictionary[@"origin"];
    [_mainImageLayoutViiew layoutImageView];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
