//
//  BBShareCommentCell.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareCommentCell.h"
#import "WYShareComment.h"

@interface BBShareCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;


@end

@implementation BBShareCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCommentEntity:(WYShareComment *)commentEntity {
    _commentEntity = commentEntity;
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_commentEntity.headImageUrl] placeholderImage:[UIImage imageNamed:@"ATL_logo.png"]];
    _nickNameLabel.text = _commentEntity.nikcName;
    if ([_commentEntity.isReply boolValue]) {
        _contentTextView.text = [NSString stringWithFormat:@"回复 %@ 的评论： %@", _commentEntity.replyUserName,_commentEntity.content];
    } else {
        _contentTextView.text = _commentEntity.content;
    }
}

@end
