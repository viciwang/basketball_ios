//
//  BBStepCountingManager.h
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QueryResultBlock)(NSArray *steps, NSUInteger todayTotalStep);

@interface BBStepCountingManager : NSObject

+ (BBStepCountingManager *)sharedManager;

- (void)startStepCounting;

- (void)stopStepCounting;

- (void)queryStepsOfToday:(QueryResultBlock)resultBlock;

//- (void)queryStepsOfThisWeek:(QueryResultBlock)resultBlock;
//
//- (void)queryStepsOfThisMonth:(QueryResultBlock)resultBlock;
//
//- (void)queryStepsOfThisYear:(QueryResultBlock)resultBlock;

@end
