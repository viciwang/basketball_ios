//
//  SDWebImageManager+Mutiple.m
//  LazyCat
//
//  Created by yingwang on 16/3/14.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "SDWebImageManager+Mutiple.h"

@implementation SDWebImageManager(Mutiple)
- (void)downloadImageWithURLs:(NSArray *)urls retrieveImages:(BOOL)imgRet options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(void (^)(NSArray *, NSError *, BOOL))completedBlock {
    NSInteger imageCount = urls.count;
    __block NSInteger completeCount = 0;
    __block NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
    
    [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        [self downloadImageWithURL:url
                           options:options
                          progress:nil
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                             completeCount += 1;
                             if (finished) {
                                 if (image && imgRet) {
                                     [images addObject:image];
                                 }
                                 if (progressBlock) {
                                     progressBlock(completeCount,imageCount);
                                 }
                                 if (completeCount == imageCount && completedBlock) {
                                     completedBlock(images,nil,YES);
                                 }
                             }
                         }];
    }];
}

@end
