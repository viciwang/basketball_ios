//
//  BBstepCountingRankHeadView.m
//  Basketball
//
//  Created by Allen on 3/27/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingRankHeadView.h"
#import "BBStepCountingRank.h"

@interface BBStepCountingRankHeadView()

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end

@implementation BBStepCountingRankHeadView

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateWithData:(BBStepCountingRank *)record rate:(CGFloat)rate{
    self.rankLabel.text = @(record.rank).stringValue;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:record.headImageUrl] placeholderImage:[UIImage imageNamed:@"HOU_logo"]];
    self.nickNameLabel.text = record.nickName;
    self.stepCountLabel.text = @(record.stepCount).stringValue;
    self.rateLabel.text = [NSString stringWithFormat:@"%@",@(@(rate*100).integerValue).stringValue];
}


@end
