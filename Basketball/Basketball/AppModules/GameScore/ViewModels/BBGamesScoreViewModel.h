//
//  BBGamesScoreViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/8.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBNetworkApiManager.h"

@class BBGamesScoreViewModel;
@protocol BBGamesScoreViewModelDelegate <NSObject>

- (void)gamesScoreViewModel:(BBGamesScoreViewModel *)model queryGamesOnDate:(NSString *)date complishWithObjects:(NSArray *)objects;

@end

@interface BBGamesScoreViewModel : BBNetworkApiManager

@property (nonatomic, weak) id<BBGamesScoreViewModelDelegate> delegate;
@property (nonatomic, readonly) NSArray *games;

- (void)queryGamesDataAtDate:(NSString *)date;

- (void)loadGameOfToDay;
- (void)loadGameOfDayBefore;
- (void)loadGameOfNextDay;

@end
