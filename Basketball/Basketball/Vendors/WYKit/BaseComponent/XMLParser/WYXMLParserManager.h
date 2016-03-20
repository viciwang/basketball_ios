//
//  FKXMLParserManager.h
//  MicroReader
//
//  Created by yingwang on 15/11/6.
//  Copyright © 2015年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYXMLParserOperation.h"

FOUNDATION_EXTERN NSString * const WYXMLParserXMLItemNameKey;
FOUNDATION_EXTERN NSString * const WYXMLParserXMLSubitemKey;
FOUNDATION_EXTERN NSString * const WYXMLParserXMLAttributeKey;
FOUNDATION_EXTERN NSString * const WYXMLParserXMLContentKey;



@interface WYXMLParserManager : NSObject

+ (instancetype)manager;

/**
 *	A syncornized methor to parser XML Data
 *
 *	@param data	The XML Data to parser
 *	@param ctx                 context
 *	@return A result set for XML
 */
+ (id)parseXMLWithData:(NSData *)data;
+ (id)parseXMLWithData:(NSData *)data context:(WYXMLParserContext *)ctx;
/**
 *	An asyncornized class methor to parser XML Data
 *
 *	@param data					The data to parser
 *	@param completeBlock	Completion Block
 */
+ (void)parseXMLWithData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
/**
 *	An asyncornized class methor to parser XML from a HTTP URL
 *
 *	@param url						The HTTP URL destinate to the XML
 *	@param completeBlock	Completion Block
 */
+ (void)parserXMLWithURL:(NSString *)url completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
/**
 *	An asyncornized class methor to parser XML Data
 *
 *	@param data					The data to parser
 *	@param ctx                 context
 *	@param completeBlock	Completion Block
 */
+ (void)parseXMLWithData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
/**
 *	A syncornized methor to parser XML Data
 *
 *	@param data	The XML Data to parser
 *	@return A result dictionary for XML
 */
- (NSDictionary *)parseXMLWithData:(NSData *)data;
/**
 *	An asyncornized methor to parser XML Data
 *
 *	@param data					The data to parser
 *	@param completeBlock	Completion Block
 */
- (void)parseXMLWithData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
/**
 *	An asyncornized class methor to parser XML Data
 *
 *	@param data					The data to parser
 *	@param ctx                 context
 *	@param completeBlock	Completion Block
 */
- (void)parseXMLWithData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
/**
 *	An asyncornized methor to parser XML from a HTTP URL
 *
 *	@param url						The HTTP URL destinate to the XML
 *	@param completeBlock	Completion Block
 */
- (void)parserXMLWithURL:(NSString *)url completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock;
@end
