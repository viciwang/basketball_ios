//
//  BBStepCountingRank.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingRank.h"

@implementation BBStepCountingRank

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"uid":@"uid",
             @"stepCount":@"stepCount",
             @"nickName":@"nickName"
             };
}

@end
