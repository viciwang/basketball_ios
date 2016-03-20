//
//  FKXMLParserOperation.h
//  MicroReader
//
//  Created by yingwang on 15/11/6.
//  Copyright © 2015年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYXMLDocument.h"

typedef void(^WYXMLParserOperationCompleteBlock)(BOOL isSuccess,id obj,NSError *error);

@interface WYXMLParserContext : NSObject

@property (nonatomic, strong) NSString *xpath;
@property (nonatomic, strong) NSDictionary *elementsMap;

@end

@interface WYXMLParserOperation : NSObject

@property (nonatomic, strong) dispatch_queue_t completeQueue;
@property (nonatomic, strong) dispatch_queue_t processQueue;

+ (instancetype)operationForParsingXMLData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)block;
+ (instancetype)operationForParsingXMLData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)block;
- (void)start;

@end

@interface WYLibXMLParserOperation : WYXMLParserOperation
@end

@interface WYCocoaXMLParserOperation : WYXMLParserOperation
@end

@interface WYTreeNodeXMLParserOperation : WYXMLParserOperation
@end