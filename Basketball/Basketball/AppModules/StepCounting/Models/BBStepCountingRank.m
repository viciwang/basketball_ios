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
             @"nickName":@"nickName",
             @"headImageUrl":@"headImageUrl",
             @"personalDescription": @"personalDescription",
             @"rank":@"rank"
             };
}

@end

@implementation BBStepCountingRankResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"myRank":@"myRank",
             @"ranks":@"ranks"
             };
}

//+ (NSValueTransformer *)myRankJSONTransformer {
//    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[BBStepCountingRank class]];
//}


+ (NSValueTransformer *)ranksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BBStepCountingRank class]];
}

@end
