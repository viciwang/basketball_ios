//
//  BBStepCountingStatisticViewController.h
//  Basketball
//
//  Created by Allen on 3/4/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBBaseViewController.h"

typedef NS_ENUM(NSUInteger, BBStepCountingStatisticType) {
    BBStepCountingStatisticTypeToday,
    BBStepCountingStatisticTypeThisWeek,
    BBStepCountingStatisticTypeThisMonth,
    BBStepCountingStatisticTypeThisYear
};

@interface BBStepCountingStatisticViewController : BBBaseViewController

- (instancetype)initWithStatisticsType:(BBStepCountingStatisticType)type;

@end
