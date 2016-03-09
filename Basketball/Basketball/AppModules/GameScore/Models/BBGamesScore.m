//
//  BBGamesScore.m
//  Basketball
//
//  Created by yingwang on 16/3/7.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBGamesScore.h"

@implementation BBGamesScore

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"hostTeam":@"hostTeam",
             @"hostTeamId":@"hostTeamId",
             @"guestTeam":@"guestTeam",
             @"guestTeamId":@"guestTeamId",
             @"hostScore":@"hostScore",
             @"guestScore":@"guestScore",
             @"hostTeamWin":@"hostTeamWin",
             @"status":@"status",
             @"statusDescription":@"statusDesc",
             @"startTime":@"startTime",
             @"processTime":@"processTime",
             @"gamesDate":@"gamesDate"
             };
}

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
//    if ([key isEqualToString:@"createdAt"]) {
//        return [NSValueTransformer valueTransformerForName:<#(nonnull NSString *)#>];
//    }
//    
//    return nil;
//}




@end
