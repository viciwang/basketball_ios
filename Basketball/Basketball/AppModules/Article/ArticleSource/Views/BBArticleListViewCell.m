//
//  BBArticleListViewCell.m
//  Basketball
//
//  Created by yingwang on 16/3/19.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBArticleListViewCell.h"

@interface BBArticleListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BBArticleListViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFeed:(WYFeed *)feed {
    
    _feed = feed;
    _titleLabel.text = _feed.name;
    [_mainImageView sd_setImageWithURL:[NSURL URLWithString:_feed.imageURL]
                      placeholderImage:[UIImage imageNamed:@"article_thumbnail.png"]];
}

@end
