//
//  BBShareEditViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareEditViewModel.h"

@implementation BBShareEditViewModel

- (void)uploadShareContent:(NSString *)contentText images:(NSArray *)images {
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
//    [postDictionary setObject:date forKey:@"publicDate"];
//    [postDictionary setObject:contentText forKey:@"content"];
//    [postDictionary setObject:@"广东广州" forKey:@"locationName"];
//    [postDictionary setObject:@(images.count) forKey:@"imgCount"];
    
//    for (NSInteger idx = 0; idx < images.count; ++idx) {
//        NSString *key = [NSString stringWithFormat:@"img_%lu", idx];
//        [postDictionary setObject:images[idx] forKey:key];
//    }
    
    NSError *error;
    NSData *paraData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [self POST:kApiAddShare parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[date dataUsingEncoding:NSUTF8StringEncoding] name:@"publicDate"];
//        [formData appendPartWithFormData:[contentText dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
//        [formData appendPartWithFormData:[@"广东广州" dataUsingEncoding:NSUTF8StringEncoding] name:@"locationName"];
//        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%lu",0] dataUsingEncoding:NSUTF8StringEncoding] name:@"imgCount"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
    }];
}

@end
