//
//  WYXMLDocument.m
//  WYKitTDemo
//
//  Created by yingwang on 16/1/3.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYXMLDocument.h"
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/xpath.h>
#import <libxml/xmlreader.h>

static NSString * const kWYXMLDocumentErrorDomain = @"kWYXMLDocumentErrorDomain";

@interface WYXMLDocument ()
{
    xmlDocPtr _privateDoc;
}


@end

@implementation WYXMLDocument

- (instancetype)initWithData:(NSData *)xmlData {
    self = [super init];
    if (self) {
        _privateDoc = xmlParseMemory((const char*)xmlData.bytes, (int)xmlData.length);
        
        NSAssert(_privateDoc!=NULL, @"WYXMLDocument: parse xml data failed");
        if (!_privateDoc) {
            return nil;
        }
    }
    return self;
}

- (NSArray *)readAllElementWithBaseXPath:(NSString *)xpath {
    return [self readElement:nil baseXPath:xpath];
}

- (NSArray *)readElement:(NSDictionary *)element baseXPath:(NSString *)xpath {
    
    NSMutableArray *elements;
    NSDictionary *eleDic;
    
    CFDictionaryRef desElementDictionary;
    
    xmlXPathContextPtr pathCtxt;
    xmlXPathObjectPtr pathObj;
    
    NSError *error;
    
    elements = [NSMutableArray array];
    pathCtxt = xmlXPathNewContext(_privateDoc);
    NSAssert(pathCtxt!=NULL, @"WYXMLDocument: craete xpath context failed");
    if (!pathCtxt) {
        return nil;
    }
    
    pathObj = xmlXPathEvalExpression((const xmlChar*)[xpath UTF8String], pathCtxt);
    NSAssert(pathObj!=NULL, @"WYXMLDocument: craete xpath object failed");
    if (!pathObj) {
        return nil;
    }
    //put elements in a dictionary as a hash table, which more effectively than array when searching
    if (element&&element.count) {
        desElementDictionary = _getCFDictionaryFromNSDictionary(element, &error);
    }
    
    if (!error) {
        //enumerate result elements base on the xpath
        for (int i=0; i<pathObj->nodesetval->nodeNr; i++) {
            eleDic = [self _getDestinationElements:desElementDictionary baseNode:(xmlNodePtr)pathObj->nodesetval->nodeTab[i]];
            [elements addObject:eleDic];
        }
    }
    
    xmlXPathFreeContext(pathCtxt);
    xmlXPathFreeObject(pathObj);
    return elements;
}

static WYXMLParseElementOption _getElementOption(CFTypeRef obj) {
    
    if (!obj) {
        return kWYXMLParseElementUnknow;
    }
    
    CFTypeID objType = CFGetTypeID(obj);
    if (CFNumberGetTypeID()==objType) {
        WYXMLParseElementOption option;
        CFNumberGetValue(obj, kCFNumberIntType, &option);
        return option;
    } else if(CFDictionaryGetTypeID()==objType) {
        return kWYXMLParseElementSubelement;
    }
    return kWYXMLParseElementUnknow;
}

static CFDictionaryRef _getCFDictionaryFromNSDictionary(NSDictionary *originDictionary,__autoreleasing NSError **error) {
    
    if (!originDictionary) {
        return NULL;
    }
    __block CFMutableDictionaryRef resultDictionary = NULL;
    
    resultDictionary = CFDictionaryCreateMutable(kCFAllocatorDefault, (CFIndex)originDictionary.count, &kCFTypeDictionaryKeyCallBacks, NULL);
    
    [originDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            CFNumberRef num = (__bridge void*)obj;
            CFDictionarySetValue(resultDictionary, (__bridge CFStringRef)key, num);
        } else if([obj isKindOfClass:[NSDictionary class]]) {
            
            CFDictionarySetValue(resultDictionary, (__bridge CFStringRef)key, _getCFDictionaryFromNSDictionary(obj,error));
            if (*error) {
                resultDictionary = NULL;
                *stop = YES;
            }
        } else {
            static NSString *errormsg = @"Can not parse a value unless NSString or NSDictionary";
            NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:errormsg, NSLocalizedDescriptionKey, nil];
            *error = [NSError errorWithDomain:kWYXMLDocumentErrorDomain code:-1 userInfo:errorInfo];
            *stop = YES;
            resultDictionary = NULL;
        }
    }];
    
    return resultDictionary;
}
// 递归遍历把所有数组，字典，字符串的值串联成字符串
- (NSString *)_convertValueToString:(id)value {
    __block NSString *result = @"";
    if ([value isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            result = [result stringByAppendingString:[self _convertValueToString:obj]];
        }];
    } else if([value isKindOfClass:[NSArray class]]) {
        [(NSArray *)value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            result = [result stringByAppendingString:[self _convertValueToString:obj]];
        }];
    } else if([value isKindOfClass:[NSString class]]) {
        result = [result stringByAppendingString:value];
    }
    return  [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (id)_getDestinationElements:(CFDictionaryRef)elements baseNode:(xmlNodePtr)node {
    
    if(!node||!node->children)
        return nil;
    //if the cur node just contained a text node or a cdata node,
    //that means it is a element without any children but a seq of text,
    //so return the text
    if(node->children->type==XML_TEXT_NODE&&!node->children->next) {
        return [NSString stringWithUTF8String:(const char*)xmlNodeGetContent(node->children)];
    }
    if(node->children->type==XML_CDATA_SECTION_NODE&&!node->children->next) {
        return [NSString stringWithUTF8String:(const char*)xmlNodeGetContent(node->children)];
    }
    
    NSMutableDictionary *elementsDic = [NSMutableDictionary dictionary];
    
    xmlNodePtr childNode = node->children;
    
    id value;
    while (childNode) {
        value = nil;
        const xmlChar* elementName = childNode->name;
        //a cdata node only return the cdata text
        if(childNode->type==XML_TEXT_NODE
           ||childNode->type==XML_CDATA_SECTION_NODE) {
            elementName = (const xmlChar*)"text";
            value = [NSString stringWithUTF8String:(const char*)childNode->content];
        }
        else if (childNode->type==XML_ELEMENT_NODE) {
            
            if(!elements) {
                value = [self _getDestinationElements:NULL
                                             baseNode:childNode];
            } else {
                CFStringRef str = CFStringCreateWithCString(kCFAllocatorDefault, (const char*)elementName, kCFStringEncodingUTF8);
                CFTypeRef obj = CFDictionaryGetValue(elements, str);
                WYXMLParseElementOption opt = _getElementOption(obj);
                switch (opt) {
                    case kWYXMLParseElementSubelement:
                        value = [self _getDestinationElements:obj
                                                     baseNode:childNode];
                        break;
                    case kWYXMLParseElementAll:
                    case kWYXMLParseElementText:
                        obj = NULL;
                        value = [self _getDestinationElements:obj
                                                     baseNode:childNode];
                        value = [self _convertValueToString:value];
                        break;
                    default:
                        break;
                }
            }
        }
        if (value) {
            NSString *nodeName = [NSString stringWithUTF8String:(const char*)elementName];
            id tpValue = elementsDic[nodeName];
            if (tpValue) {
                //if a key has more than one value contained it in array
                if ([tpValue isKindOfClass:[NSMutableArray class]]) {
                    NSMutableArray *array = tpValue;
                    [array addObject:value];
                    value = array;
                } else if([tpValue isKindOfClass:[NSString class]]){
                    value = [(NSString *)tpValue stringByAppendingString:value];
                } else {
                    NSMutableArray *array = [NSMutableArray arrayWithObjects:tpValue, value, nil];
                    value = array;
                }
            }
            [elementsDic setObject:value forKey:nodeName];
        }
        childNode = childNode->next;
    }
    
    return elementsDic;
}
//构建字符串哈希表优化
//- (BOOL)_isElement:(const char*)name memberOfElements:(NSDictionary *)elements {
//   
//    if (!elements||elements.count<1) {
//        return NO;
//    }
//    __block BOOL result = NO;
//    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        const char* givenName = [(NSString *)obj UTF8String];
//        if (!strcmp(givenName, name)) {
//            result = YES;
//            *stop = YES;
//        }
//    }];
//    return result;
//}

- (void)dealloc {
    _privateDoc!=NULL?:xmlFreeDoc(_privateDoc);
}

@end
