//
//  BBGamesScore.h
//  Basketball
//
//  Created by yingwang on 16/3/7.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBModel.h"

@interface BBGamesScore : BBModel

@property (nonatomic, strong) NSString *hostTeam;
@property (nonatomic, strong) NSString *hostTeamId;

@property (nonatomic, strong) NSString *guestTeam;
@property (nonatomic, strong) NSString *guestTeamId;

@property (nonatomic, strong) NSString *hostScore;
@property (nonatomic, strong) NSString *guestScore;

@property (nonatomic, strong) NSNumber *hostTeamWin;

@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSString *statusDescription;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *processTime;
@property (nonatomic, strong) NSString *gamesDate;




@end
