//
//  BBStepCountingManager.h
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QueryTodayResultBlock)(NSArray *steps, NSUInteger todayTotalStep,NSError *error);
typedef void(^QueryHourResultBlock)(NSUInteger stepCount,NSError *error);

@interface BBStepCountingManager : NSObject

+ (BBStepCountingManager *)sharedManager;

- (void)start;
//
//- (void)stopStepCounting;

- (void)queryStepsOfToday:(QueryTodayResultBlock)resultBlock;

//- (void)queryStepsOfThisWeek:(QueryResultBlock)resultBlock;
//
//- (void)queryStepsOfThisMonth:(QueryResultBlock)resultBlock;
//
//- (void)queryStepsOfThisYear:(QueryResultBlock)resultBlock;

@end
