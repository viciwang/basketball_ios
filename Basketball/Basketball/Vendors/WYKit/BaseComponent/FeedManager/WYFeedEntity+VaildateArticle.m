//
//  WYFeedEntity+VaildateArticle.m
//  LazyCat
//
//  Created by yingwang on 16/3/12.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeedEntity+ValidateArticle.h"
#import <objc/runtime.h>

static NSString const * const kImageArrayKey = @"kImageArrayKey";

@implementation WYFeedEntity(ValidateArticle)

- (void)setImageArray:(NSArray *)imageArray {
    if (!self.images || !self.thumbnail) {
        if (!imageArray.count) {
            self.images = @"noImages";
        } else {
            self.images = [imageArray componentsJoinedByString:@","];
            //因为腾讯的网页爬出来的第一张图片显示不了
            self.thumbnail = [self.sourceName isEqualToString:@"腾讯NBA"]&&imageArray.count>1?imageArray[1]:[imageArray firstObject];
        }
    }
    objc_setAssociatedObject(self, (__bridge const void *)(kImageArrayKey), imageArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)imageArray {
    NSArray *array = objc_getAssociatedObject(self, (__bridge const void *)(kImageArrayKey));
    if (array) {
        return array;
    }
    
    if (self.images && [self.images isEqualToString:@"noImages"]) {
        NSArray *images = [NSArray array];
        [self setImageArray:images];
        return images;
    } else if(self.images) {
        NSArray *images = [self.images componentsSeparatedByString:@","];
        [self setImageArray:images];
        return images;
    }
    
    NSArray *images = [self getImageUrlArray];
    [self setImageArray:images];
    
    return images;
}

- (BOOL)isArticleContentValid {
    if (self.feedDescription.length > 200) {
        return YES;
    }
    return NO;
}



- (NSArray *)getImageUrlArray {
    
    if (!self.feedDescription) {
        return [NSArray array];
    }
    NSString *content = [NSString stringWithString:self.feedDescription];
    
    NSString*urlPattern = @"<img[^>]+?src=[\"']?([^>'\"]+)[\"']?";
    NSError*error = [NSError new];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error ];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    //match 这块内容非常强大
    NSUInteger count = [regex numberOfMatchesInString:content options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0,[content length])];//匹配到的次数
    
    if(count > 0)
    {
        NSArray* matches = [regex matchesInString:content options:NSMatchingReportCompletion
                                            range:NSMakeRange(0,[content length])];
        NSInteger row=count-1;
        for (NSTextCheckingResult *match in [matches reverseObjectEnumerator]) {
            
            NSInteger count = [match numberOfRanges];//匹配项
            for(NSInteger index = 0;index < count;index++){
                if(index == 1) {
                    
                    NSRange halfRange = [match rangeAtIndex:index];
                    NSString *img = [content substringWithRange:halfRange];
                    [temp insertObject:img atIndex:0];
                } else if(index == 0) {
                    NSRange halfRange = [match rangeAtIndex:index];
                    while (![[content substringWithRange:NSMakeRange(halfRange.length+halfRange.location-1, 1)] isEqualToString:@">"]) {
                        halfRange.length+=1;
                    }
                    NSString *img = [content substringWithRange:halfRange];
                    self.feedDescription = [self.feedDescription stringByReplacingCharactersInRange:halfRange
                                                                                         withString:[NSString stringWithFormat:@"imgOfLazyCat%lu",row]];
                    row--;
                }
            }
        }//遍历后可以看到三个range，1、为整体。2、为([\\w-]+\\.)匹配到的内容。3、(/?[\\w./?%&=-]*)匹配到的内容
    }
    return [NSArray arrayWithArray:temp];
}

@end
