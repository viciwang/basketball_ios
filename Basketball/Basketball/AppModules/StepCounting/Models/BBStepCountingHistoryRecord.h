//
//  BBStepCountingHistoryRecord.h
//  Basketball
//
//  Created by Allen on 3/21/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBModel.h"

@interface BBStepCountingHistoryMonthRecord : BBModel

@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSArray *dayRecords;
@property (nonatomic, assign) NSUInteger average;

@end

@interface BBStepCountingHistoryDayRecord : BBModel

@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSUInteger stepCount;

@end
