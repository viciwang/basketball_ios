//
//  BBStepCountingManager.m
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingManager.h"
#import "BBStepCountingService.h"
#import "NSDate+Utilities.h"
#import "BBNetworkApiManager.h"
#import "BBDatabaseManager.h"

#define kUploadInterval 60

@interface BBStepCountingManager ()

@property (nonatomic, strong) id<BBStepCountingService> stepCountingService;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BBStepCountingManager

+ (BBStepCountingManager *)sharedManager {
    static BBStepCountingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BBStepCountingManager new];
        manager.stepCountingService = [BBStepCountingService new];
    });
    return manager;
}

- (void)dealloc {
    [_timer invalidate];
}

- (void)start {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kUploadInterval target:self selector:@selector(uploadStepCountData:) userInfo:nil repeats:YES];
    [[BBNetworkApiManager sharedManager] getHistoryStepCountAfterDate:[[[BBDatabaseManager sharedManager] lastDateSavedStepCountData]dayString]
                                                      completionBlock:^(NSArray *array, NSError *error) {
                                                          if (!error) {
                                                              [[BBDatabaseManager sharedManager] saveStepCountData:array];
                                                          }
    }];
}

- (void)uploadStepCountData:(NSTimer *)timer {
    NSDate *now = [[NSDate date] dateBySubtractingMinutes:[NSDate date].minute];
    [self queryStepsOfHour:now resultBlock:^(NSUInteger stepCount, NSError *error) {
        if (!error) {
            [[BBNetworkApiManager sharedManager] uploadStepDataWithStepCount:stepCount startTime:[now stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]  completionBlock:^(id responseObject, NSError *error) {
                
            }];
        }
    }];
}

- (void)queryStepsOfHour:(NSDate *)beginOfHour  resultBlock:(QueryHourResultBlock)resultBlock {
    [self.stepCountingService queryStepCountingFromDate:beginOfHour endDate:[beginOfHour dateByAddingHours:1] handler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        resultBlock(numberOfSteps,error);
    }];
}

- (void)queryStepsOfToday:(QueryTodayResultBlock)resultBlock {
    __block NSMutableArray *result = [[NSMutableArray alloc]init];
    __block NSUInteger count = 0;
    __block NSUInteger totalSteps = 0;
    for (NSUInteger index = 0; index < 24; index++) {
        [result addObject:@(0)];
    }
    NSDate *beginDate = [[NSDate date]dateAtStartOfDay];
    for (NSUInteger index = 0; index < 24; index++) {
        [self.stepCountingService queryStepCountingFromDate:[beginDate dateByAddingHours:index] endDate:[beginDate dateByAddingHours:index+1] handler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            result[timestamp.hour] = @(numberOfSteps);
            count++;
            totalSteps += numberOfSteps;
            if (count >= 24) {
                resultBlock(result, totalSteps,nil);
            }
        }];
    }
}

- (void)queryAverageStepCountWithCompletionBlock:(void (^)(NSInteger, NSError *))completionBlock {
    NSInteger stepCount = [[BBDatabaseManager sharedManager] retriveAverageStepCount];
    if (stepCount > 0) {
        completionBlock(stepCount, nil);
        return;
    }
    [[BBNetworkApiManager sharedManager] getAverageStepCountWithCompletionBlock:^(NSNumber *average, NSError *error) {
        if (completionBlock) {
            completionBlock(average.integerValue,error);
        }
    }];
}

- (void)startStepCountingUpdateWithHandler:(StepCountingUpdateBlock)handler {
    [self.stepCountingService startStepCountingUpdateWithHandler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        if (handler) {
            handler(numberOfSteps,timestamp,error);
        }
    }];
}

- (void)stopStepCountingUpdate {
    [self.stepCountingService stopStepCountingUpdate];
}

@end
