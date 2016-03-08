//
//  BBGamesScoreViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/8.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBGamesScoreViewModel.h"
#import "BBNetworkAddress.h"
#import "BBGamesScore.h"

@interface BBGamesScoreViewModel ()

@property (nonatomic, strong) NSMutableDictionary *gamesInfo;
@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, strong) NSArray *currentGames;

@end

#define kTodayGamesInfoKey  @"TodayGamesInfoKey"

@implementation BBGamesScoreViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentPageIndex = 0;
        _gamesInfo = [NSMutableDictionary new];
    }
    return self;
}

- (NSArray *)games {
    
    return _currentGames;
}

- (void)queryGamesDataAtDate:(NSString *)date {
    
    if (date && date.length && _gamesInfo[date]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(gamesScoreViewModel:queryGamesOnDate:complishWithObjects:)]) {
            
            _currentGames = _gamesInfo[date];
            [_delegate gamesScoreViewModel:self queryGamesOnDate:date complishWithObjects:_gamesInfo[date]];
        }
        
    } else {
        
        NSDictionary *parameters = nil;
        if (date) {
            parameters = @{@"date":date};
        }
        @weakify(self);
        [self GET:kApiGamesScoreAddress
       parameters:parameters
         progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             @strongify(self);
             
             NSArray *result = responseObject[@"data"];
             NSArray *resultArray = [BBGamesScore modelsFromJSONArray:result];
             
             if (date) {
                 self.gamesInfo[date] = resultArray;
             }
             
             self.currentGames = resultArray;
             if (_delegate && [_delegate respondsToSelector:@selector(gamesScoreViewModel:queryGamesOnDate:complishWithObjects:)]) {
                 [_delegate gamesScoreViewModel:self queryGamesOnDate:date complishWithObjects:resultArray];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             NSLog(@"failure!");
         }];

    }
}

- (void)loadGameOfToDay {
    
    _currentPageIndex = 0;
    [self pageChange];
}

- (void)loadGameOfDayBefore {
    
    _currentPageIndex -= 1;
    [self pageChange];
}

- (void)loadGameOfNextDay {
    
    _currentPageIndex += 1;
    [self pageChange];
}

- (void)pageChange {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // n day ago
    NSDate *currentDay = [NSDate dateWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] + _currentPageIndex*24*3600)];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDay];
    
    if (!_currentPageIndex) {
        dateString = nil;
    }
    [self queryGamesDataAtDate:dateString];
}

@end
