//
//  BBStepCountingRankCell.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingRankCell.h"

@interface BBStepCountingRankCell()

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;

@end

@implementation BBStepCountingRankCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithData:(BBStepCountingRank *)record {
    self.rankLabel.text = @(record.rank).stringValue;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:record.headImageUrl] placeholderImage:[UIImage imageNamed:@"HOU_logo"]];
    self.nickNameLabel.text = record.nickName;
    self.personalDescriptionLabel.text = record.personalDescription;
    self.stepCountLabel.text = @(record.stepCount).stringValue;
}

@end
