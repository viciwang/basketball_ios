//
//  SDWebImageManager+Mutiple.h
//  LazyCat
//
//  Created by yingwang on 16/3/14.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>

@interface SDWebImageManager(Mutiple)
/**
 *	@param urls						a array of urls
 *	@param imgRet					是否在完成block中返回图片集合，考虑到有些图片比较大，所以不能存在内存里面
 *	@param options				同SDWebImageManager
 *	@param progressBlock	同SDWebImageManager
 *	@param completedBlock	同SDWebImageManager
 */
- (void)downloadImageWithURLs:(NSArray *)urls retrieveImages:(BOOL)imgRet options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(void(^)(NSArray *images, NSError *error, BOOL finished))completedBlock;
@end
