//
//  BBStepCountingHistoryRecord.m
//  Basketball
//
//  Created by Allen on 3/21/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingHistoryRecord.h"

@implementation BBStepCountingHistoryMonthRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"month":@"month",
             @"dayRecords":@"dayRecords"
             };
}

+ (NSValueTransformer *)dayRecordsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BBStepCountingHistoryDayRecord class]];
}

@end

@implementation BBStepCountingHistoryDayRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"date":@"date",
             @"stepCount":@"stepCount"
             };
}

@end
