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

@interface BBStepCountingManager ()

@property (nonatomic, strong) id<BBStepCountingService> stepCountingService;

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

- (void)startStepCounting {
    [self.stepCountingService startStepCountingWithHandler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kBBNotificationStepCountingUpdate object:nil userInfo:@{@"date":timestamp,@"steps":@(numberOfSteps)}];
        }
    }];
}

- (void)queryStepsOfToday:(QueryResultBlock)resultBlock {
    __block NSMutableArray *result = [[NSMutableArray alloc]init];
    __block NSUInteger count = 0;
    __block NSUInteger totalSteps = 0;
    for (NSUInteger index = 0; index < 24; index++) {
        [result addObject:@(0)];
    }
    NSDate *beginDate = [[NSDate date]dateAtStartOfDay] ;
    for (NSUInteger index = 0; index < 24; index++) {
        [self.stepCountingService queryStepCountingFromDate:[beginDate dateByAddingHours:index] endDate:[beginDate dateByAddingHours:index+1] handler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            result[timestamp.hour] = @(numberOfSteps);
            count++;
            totalSteps += numberOfSteps;
            if (count >= 24) {
                resultBlock(result, totalSteps);
            }
        }];
    }
}

@end
