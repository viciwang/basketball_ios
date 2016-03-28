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
#import "BBNetworkApiManager.h"

@interface BBShareCellView () <BBImageLayoutViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *approveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *approveImageView;

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
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(-3, -3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 3;
    
    _mainTextView.layer.cornerRadius = 3;
    _mainTextView.layer.masksToBounds = YES;
    
    _mainImageLayoutViiew.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnComment:)];
    [_shadowView2 addGestureRecognizer:tapGesture];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnApprove:)];
    [_shadowView1 addGestureRecognizer:tapGesture];
}

- (void)setShareEntity:(WYShare *)shareEntity {
    _shareEntity = shareEntity;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_shareEntity.headImageUrl] placeholderImage:[UIImage imageNamed:@"ATL_logo.png"]];
    _nickNameLabel.text = _shareEntity.nickName;
    //_dateLabel.text = _shareEntity.publicDate;
    NSString *imageName = [_shareEntity.isApprove boolValue]?@"share_approve_select":@"share_approve";
    _approveImageView.image = [UIImage imageNamed:imageName];
    _commentLabel.text = [NSString stringWithFormat:@"%lu",[_shareEntity.commentCount integerValue]];
    _approveLabel.text = [NSString stringWithFormat:@"%lu",[_shareEntity.approveCount integerValue]];
    _mainTextView.text = _shareEntity.content;
    _mainImageLayoutViiew.images = _shareEntity.imageDictionary[@"thumbnail"];
    [_mainImageLayoutViiew layoutImageView];
}

#pragma mark - gesture event
- (void)touchOnApprove:(UITapGestureRecognizer *)tapGesture {
    if ([_delegate respondsToSelector:@selector(shareCellView:didTouchApproveForShare:)]) {
        [_delegate shareCellView:self didTouchApproveForShare:_shareEntity];
    }
    [[BBNetworkApiManager sharedManager] approveForShareId:_shareEntity.shareId
                                                 deApprove:[_shareEntity.isApprove boolValue]
                                           completionBlock:^(id responseObject, NSError *error) {
                                               BOOL isApprove = [responseObject[@"isApprove"] boolValue];
                                               NSInteger approveCount = [responseObject[@"approveCount"] integerValue];
                                               _approveLabel.text = [NSString stringWithFormat:@"%lu",approveCount];
                                               NSString *imageName = isApprove?@"share_approve_select":@"share_approve";
                                               _approveImageView.image = [UIImage imageNamed:imageName];
                                               _shareEntity.approveCount = @(approveCount);
                                               _shareEntity.isApprove = @(isApprove);
    }];
}
- (void)touchOnComment:(UITapGestureRecognizer *)tapGesture {
    if ([_delegate respondsToSelector:@selector(shareCellView:didTouchCommentForShare:)]) {
        [_delegate shareCellView:self didTouchCommentForShare:_shareEntity];
    }
}

#pragma mark - image layout view delegate
- (void)imageLayoutView:(BBImageLayoutView *)layoutView didLayoutFinish:(CGFloat)height {
    _imageViewHeightConstraint.constant = height;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
