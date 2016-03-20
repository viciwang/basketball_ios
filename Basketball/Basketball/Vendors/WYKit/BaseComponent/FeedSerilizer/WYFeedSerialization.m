//
//  WYFeedSerialization.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/4.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYFeedSerialization.h"
#import "WYXMLParserManager.h"

NSString * const kWYFeedSerializationTitleKey = @"title";
NSString * const kWYFeedSerializationLinkKey = @"link";
NSString * const kWYFeedSerializationDescriptionKey = @"description";
NSString * const kWYFeedSerializationImageURLKey = @"image";
NSString * const kWYFeedSerializationLastBuildDateKey = @"lastBuildDate";
NSString * const kWYFeedSerializationEntityKey = @"item";

NSString * const kWYFeedSerializationEntityTitleKey = @"title";
NSString * const kWYFeedSerializationEntityLinkKey = @"link";
NSString * const kWYFeedSerializationEntityDescriptionKey = @"description";
NSString * const kWYFeedSerializationEntityPublicDateKey = @"pubDate";
 NSString * const kWYFeedSerializationEntityThumbnailKey = @"thumbnail";
NSString * const kWYFeedSerializationEntityImagesKey = @"images";

@implementation WYFeedSerialization

static NSDictionary* _getRSSModelMap() {
    
    return @{
             //channel required elements
             @"title":@(kWYXMLParseElementText),
             @"link":@(kWYXMLParseElementText),
             @"description":@(kWYXMLParseElementText),
             
             //channel optional elements
             @"lastBuildDate":@(kWYXMLParseElementText),
             @"image":@{
                     //image required elements
                     @"url":@(kWYXMLParseElementText)
                     },
             @"item":@{
                     //items required elements
                     @"title":@(kWYXMLParseElementText),
                     @"link":@(kWYXMLParseElementText),
                     @"description":@(kWYXMLParseElementText),
                     
                     //items optional elements
                     @"guid":@(kWYXMLParseElementText),
                     @"pubDate":@(kWYXMLParseElementText),
                     @"thumbnail":@(kWYXMLParseElementText)
                     }
             };
}

static NSString* _getRSSBaseXPath() {
    return @"/rss/channel";
}

+ (void)feedObjectWithData:(NSData *)data options:(WYFeedReadingOptions)opt complete:(WYFeedSerilizationCompletionBlock)block {
    
    WYXMLParserContext *ctx = [[WYXMLParserContext alloc] init];
    ctx.elementsMap = _getRSSModelMap();
    ctx.xpath = _getRSSBaseXPath();
    [[WYXMLParserManager manager] parseXMLWithData:data context:ctx completeBlock:^(BOOL isSuccess, id obj, NSError *error) {
        if (!obj || error) {
            block(nil,NO,error);
            return;
        }
        NSMutableDictionary *tpDic = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        if (tpDic[@"image"] && tpDic[@"image"][@"url"]) {
            tpDic[@"image"] = tpDic[@"image"][@"url"];
        } else if(tpDic[@"image"]) {
            [tpDic removeObjectForKey:@"image"];
        }
        obj = [NSDictionary dictionaryWithDictionary:tpDic];
        
        block(obj, isSuccess, error);
    }];
}


@end

@implementation WYRSSFeedSerialization


@end