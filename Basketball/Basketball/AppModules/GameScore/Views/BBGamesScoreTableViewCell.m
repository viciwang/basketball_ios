//
//  BBGamesScoreTableViewCell.m
//  Basketball
//
//  Created by yingwang on 16/3/8.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBGamesScoreTableViewCell.h"
#import "BBGamesScore.h"



@interface BBGamesScoreTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *leftScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
@implementation BBGamesScoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameInfo:(BBGamesScore *)gameInfo {
    
    _gameInfo = gameInfo;
    
    _leftTitleLabel.text = gameInfo.hostTeam;
    _rightTitleLabel.text = gameInfo.guestTeam;
    
    [_leftImageView setImage:[UIImage imageNamed:[self convertImageNameForId:gameInfo.hostTeamId]]];
    [_rightImageView setImage:[UIImage imageNamed:[self convertImageNameForId:gameInfo.guestTeamId]]];
    
    _leftScoreLabel.text = gameInfo.hostScore;
    _rightScoreLabel.text = gameInfo.guestScore;
    
    _statusLabel.text = gameInfo.statusDescription;
    _timeLabel.text = [gameInfo.status integerValue]==-1?gameInfo.startTime:gameInfo.processTime;
}

- (NSString *)convertImageNameForId:(NSString *)imageId {
    
    static NSDictionary  *teamLogoName;
    if (!teamLogoName) {
        teamLogoName = @{@"1":@"CLE_logo.png",
                         @"2":@"TOR_logo.png",
                         @"3":@"BOS_logo.png",
                         @"4":@"MIA_logo.png",
                         @"5":@"ATL_logo.png",
                         @"6":@"CHA_logo.png",
                         @"7":@"IND_logo.png",
                         @"8":@"CHI_logo.png",
                         @"9":@"DET_logo.png",
                         @"10":@"WAS_logo.png",
                         @"11":@"ORL_logo.png",
                         @"12":@"MIL_logo.png",
                         @"13":@"NYK_logo.png",
                         @"14":@"BKN_logo.png",
                         @"15":@"PHI_logo.png",
                         @"16":@"GSW_logo.png",
                         @"17":@"SAS_logo.png",
                         @"18":@"OKC_logo.png",
                         @"19":@"LAC_logo.png",
                         @"20":@"MEM_logo.png",
                         @"21":@"DAL_logo.png",
                         @"22":@"POR_logo.png",
                         @"23":@"HOU_logo.png",
                         @"24":@"UTA_logo.png",
                         @"25":@"SAC_logo.png",
                         @"26":@"DEN_logo.png",
                         @"27":@"NOP_logo.png",
                         @"28":@"MIN_logo.png",
                         @"29":@"PHX_logo.png",
                         @"30":@"LAL_logo.png"
                         };
    }
    return teamLogoName[imageId];
}

@end
