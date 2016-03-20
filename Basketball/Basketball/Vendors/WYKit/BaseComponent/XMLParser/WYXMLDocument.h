//
//  WYXMLDocument.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/3.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, WYXMLParseElementOption) {
    
    kWYXMLParseElementAll = 1 << 0,
    kWYXMLParseElementText = 1 << 1,
    kWYXMLParseElementSubelement = 1 << 2,
    kWYXMLParseElementUnknow = 1 << 3
};

@interface WYXMLDocument : NSObject

- (instancetype)initWithData:(NSData *)xmlData;

/**
 *	read a set of element base on the given path
 *
 *	@param xpath	the given path
 *
 *	@return an array contained mutip dictionary which included all subElement of the xpath
 */
- (NSArray *)readAllElementWithBaseXPath:(NSString *)xpath;
/**
 *	read a part of element base on the given path
 *
 *	@param element	a part of element, if nil, return all element
 *	@param xpath		the give path
 *
 *	@return an array contained mutip dictionary which included all subElement of the xpath
 */
- (NSArray *)readElement:(NSDictionary *)element baseXPath:(NSString *)xpath;

@end
