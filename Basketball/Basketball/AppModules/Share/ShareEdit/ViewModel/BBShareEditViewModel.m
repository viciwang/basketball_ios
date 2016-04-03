//
//  BBShareEditViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareEditViewModel.h"
#import "BBShareViewController.h"

@implementation BBShareEditViewModel

- (void)uploadShareContent:(NSString *)contentText images:(NSArray *)images {
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    [postDictionary setObject:date forKey:@"publicDate"];
    [postDictionary setObject:contentText forKey:@"content"];
    [postDictionary setObject:@"广东广州" forKey:@"locationName"];
    [postDictionary setObject:@(images.count) forKey:@"imgCount"];

    [self POST:kApiAddShare parameters:postDictionary constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSInteger idx = 0; idx < images.count; ++idx) {
                NSString *key = [NSString stringWithFormat:@"img_%lu", idx+1];
                [formData appendPartWithFileData:UIImagePNGRepresentation(images[idx]) name:key fileName:@"upload.png" mimeType:@"image/png"];
            }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshShareNotification object:nil];
        if ([_delegate respondsToSelector:@selector(viewModel:didUploadDataFinish:)]) {
            [_delegate viewModel:self didUploadDataFinish:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_delegate respondsToSelector:@selector(viewModel:didUploadDataFinish:)]) {
            [_delegate viewModel:self didUploadDataFinish:error];
        }
    }];
}

@end
