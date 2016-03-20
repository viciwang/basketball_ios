//
//  WYFeedSerialization.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/4.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const kWYFeedSerializationTitleKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationLinkKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationDescriptionKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationImageURLKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationLastBuildDateKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityKey;

FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityTitleKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityLinkKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityDescriptionKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityPublicDateKey;
FOUNDATION_EXTERN NSString * const kWYFeedSerializationEntityThumbnailKey;

typedef NS_OPTIONS(NSInteger, WYFeedReadingOptions) {
    WYFeedReadingDefault = (1UL << 0)
};
typedef void(^WYFeedSerilizationCompletionBlock)(id obj, BOOL success, NSError *error);

@interface WYFeedSerialization : NSObject

+ (void)feedObjectWithData:(NSData *)data options:(WYFeedReadingOptions)opt complete:(WYFeedSerilizationCompletionBlock)block;

@end

@interface WYRSSFeedSerialization : WYFeedSerialization

@end