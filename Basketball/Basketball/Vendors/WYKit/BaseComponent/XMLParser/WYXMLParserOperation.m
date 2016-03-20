//
//  FKXMLParserOperation.m
//  MicroReader
//
//  Created by yingwang on 15/11/6.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYXMLParserOperation.h"
#import "WYXMLParserManager.h"


@interface WYXMLModel : NSObject

@end

typedef void(^WYXMLParserOperationPrivateProcessBlock)(id obj);

@implementation WYXMLParserContext
@end

@interface WYXMLParserOperation ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSData *parserData;
@property (nonatomic, strong) NSDictionary *resultDictionary;
@property (nonatomic, strong) WYXMLParserContext *parseContext;

@property (nonatomic, copy) WYXMLParserOperationCompleteBlock privateBlock;
@property (nonatomic, strong) NSMutableArray *itemsStack;

@property (nonatomic, assign) NSTimeInterval startTimeReference;
@end

@implementation WYXMLParserOperation

+ (instancetype)operationForParsingXMLData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)block {
    return [[self alloc] initWithData:data context:nil completeBlock:block];
}
+ (instancetype)operationForParsingXMLData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)block {
    return [[self alloc] initWithData:data context:ctx completeBlock:block];
}

static char *privateQueueName = "com.oninbest.WYKit.WYXMLParserOperation.PrivateQueue";
static char *completionQueueName = "com.oninbest.WYKit.WYXMLParserOperation.CompletionQueue";

- (instancetype)initWithData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)block {
    self = [super init];
    if (self) {
        _parserData = data;
        _parseContext = ctx;
        _privateBlock = [block copy];
        _processQueue = dispatch_queue_create(privateQueueName, DISPATCH_QUEUE_CONCURRENT);
        _completeQueue = dispatch_get_main_queue();//dispatch_queue_create(completionQueueName, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
- (void)start {
    if (!_parserData) {
        NSError *error = [NSError errorWithDomain:@"data to parse is empty." code:404 userInfo:nil];
        dispatch_async(_completeQueue, ^{
            _privateBlock(false,nil,error);
        });
        return;
    }
    if (![self initializeCollectionSet]) {
        NSError *error = [NSError errorWithDomain:@"unkonw error." code:404 userInfo:nil];
        dispatch_async(_completeQueue, ^{
            _privateBlock(false,nil,error);
        });
        return;
    }
    self.startTimeReference = [NSDate timeIntervalSinceReferenceDate];
}
- (void)end {
    dispatch_async(_completeQueue, ^{
        _privateBlock(false,self.resultDictionary,nil);
    });
    
}
- (BOOL)initializeCollectionSet {
    _itemsStack = [NSMutableArray array];
    if (_itemsStack) {
        return true;
    } else {
        return false;
    }
}
- (void)occurError:(NSError *)error {
    _privateBlock(false,nil,error);
}
#pragma mark - 
#pragma mark -
- (void)processBlock:(WYXMLParserOperationPrivateProcessBlock)block async:(BOOL)isAsync {
    if (isAsync) {
        dispatch_async(_processQueue, ^{
            block(nil);
        });
    } else {
        block(nil);
    }
}

#pragma mark -
- (void)addNodeWithName:(NSString *)name attributes:(NSDictionary *)attributeDict {
    
    NSMutableDictionary *node = [NSMutableDictionary dictionary];
    [node setObject:name forKey:WYXMLParserXMLItemNameKey];
    if (attributeDict) {
        [node setObject:attributeDict forKey:WYXMLParserXMLAttributeKey];
    }
    [self.itemsStack addObject:node];
}
- (void)addContentForCurrentNodeWithString:(NSString *)contentString {
    
    if (!contentString) {
        return;
    }
    
    contentString = [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([contentString isEqualToString:@" "]||[contentString isEqualToString:@""])
        return;
    NSMutableDictionary *childNode = [self.itemsStack lastObject];
    NSString *content = nil;
    content = childNode[WYXMLParserXMLContentKey];
    if (!content) {
        [childNode setValue:contentString forKey:WYXMLParserXMLContentKey];
    } else {
        content = [content stringByAppendingString:contentString];
        [childNode setValue:content forKey:WYXMLParserXMLContentKey];
    }
}
- (BOOL)accomplishNodeWithName:(NSString *)nodeName {
    NSDictionary *childNode = [self.itemsStack lastObject];
    
    if (![childNode[WYXMLParserXMLItemNameKey] isEqualToString:nodeName]) {
        [self occurError:[NSError errorWithDomain:@"validation error." code:404 userInfo:nil]];
        return false;
    }
    
    [self.itemsStack removeLastObject];
    NSMutableDictionary *rootNode = [self.itemsStack lastObject];

    //如果是根节点
    if (!rootNode) {
        self.resultDictionary = childNode;
        NSArray *arr = self.resultDictionary[WYXMLParserXMLSubitemKey][0][WYXMLParserXMLSubitemKey];
        NSLog(@"child item count : %lu",(unsigned long)arr.count);
        [self end];
        return true;
    }
    
    NSMutableArray *array = rootNode[WYXMLParserXMLSubitemKey];
    if (!array) {
        array = [NSMutableArray array];
        [rootNode setObject:array forKey:WYXMLParserXMLSubitemKey];
    }
    [array addObject:childNode];
    return true;
}
@end

@implementation WYCocoaXMLParserOperation
- (void)start {
    
    dispatch_async(self.processQueue, ^{
        [super start];
        
        self.parser = [[NSXMLParser alloc] initWithData:self.parserData];
        self.parser.delegate = self;
        
        [self.parser parse];
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
        NSLog(@"parser time : %f",end);
    });
}

#pragma mark - XML Delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (!self.resultDictionary) {
        [self occurError:[NSError errorWithDomain:@"no content" code:402 userInfo:nil]];
        return;
    }
    self.privateBlock(true,self.resultDictionary,nil);
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    
    NSString *CDATAString = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    [self addContentForCurrentNodeWithString:CDATAString];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [self addContentForCurrentNodeWithString:string];
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self addNodeWithName:elementName attributes:attributeDict];

}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [self accomplishNodeWithName:elementName];
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    [self occurError:validationError];
}
@end

//----------------------------------libxml parser---------------------------------------------
#import <libxml/parser.h>
#import <libxml/tree.h>

static void startElementNsSAX2         (void *ctx,
                                     const xmlChar *localname,
                                     const xmlChar *prefix,
                                     const xmlChar *URI,
                                     int nb_namespaces,
                                     const xmlChar **namespaces,
                                     int nb_attributes,
                                     int nb_defaulted,
                                     const xmlChar **attributes);
static void	endElementNsSAX2		(void * ctx,
                                         const xmlChar * localname,
                                         const xmlChar * prefix,
                                         const xmlChar * URI);
static void	charactersSAX           (void * ctx,
                                     const xmlChar * ch,
                                     int len);
static void	cdataBlockSAX           (void * ctx,
                                     const xmlChar * value,
                                     int len);
static void errorEncounteredSAX(void * ctx, const char * msg, ...);



static xmlSAXHandler WYLibXMLParserSAXHandlerStruct = {
    NULL,                       /* internalSubset */
    NULL,                       /* isStandalone   */
    NULL,                       /* hasInternalSubset */
    NULL,                       /* hasExternalSubset */
    NULL,                       /* resolveEntity */
    NULL,                       /* getEntity */
    NULL,                       /* entityDecl */
    NULL,                       /* notationDecl */
    NULL,                       /* attributeDecl */
    NULL,                       /* elementDecl */
    NULL,                       /* unparsedEntityDecl */
    NULL,                       /* setDocumentLocator */
    NULL,                       /* startDocument */
    NULL,                       /* endDocument */
    NULL,                       /* startElement*/
    NULL,                       /* endElement */
    NULL,                       /* reference */
    charactersSAX,              /* characters */
    NULL,                       /* ignorableWhitespace */
    NULL,                       /* processingInstruction */
    NULL,                       /* comment */
    NULL,                       /* warning */
    errorEncounteredSAX,        /* error */
    NULL,                       /* fatalError //: unused error() get all the errors */
    NULL,                       /* getParameterEntity */
    cdataBlockSAX,                       /* cdataBlock */
    NULL,                       /* externalSubset */
    XML_SAX2_MAGIC,             //
    NULL,
    startElementNsSAX2,            /* startElementNs */
    endElementNsSAX2,              /* endElementNs */
    NULL,                       /* serror */
};
@interface WYLibXMLParserOperation ()
@property (nonatomic, strong) NSMutableData *currentBuffer;

@end
@implementation WYLibXMLParserOperation

- (void)start {
    dispatch_async(self.processQueue, ^{
        [super start];
        
        _currentBuffer = [NSMutableData data];
        //1. parse by context
//            xmlParserCtxtPtr context = xmlCreatePushParserCtxt(&WYLibXMLParserSAXHandlerStruct, (__bridge void *)(self), NULL, 0, NULL);
//            xmlParseChunk(context, (const char *)self.parserData.bytes, (int)self.parserData.length, 0);
//            // Signal the context that parsing is complete by passing "1" as the last parameter.
//            xmlParseChunk(context, NULL, 0, 1);
//            self.privateBlock(true,self.resultDictionary,nil);
//            NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
//            NSLog(@"parser time : %f",end);
//            xmlFreeParserCtxt(context);

        //2.parse by doc
//        xmlDocPtr doc = xmlSAXParseMemoryWithData(&WYLibXMLParserSAXHandlerStruct, (const char*)self.parserData.bytes, (int)self.parserData.length, 0, (__bridge void*)(self));
//        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
//        NSLog(@"parser time : %f",end);
//        if (doc==NULL) {
//            //error occur
//            if (!self.resultDictionary) {
//                [self occurError:[NSError errorWithDomain:@"no content" code:402 userInfo:nil]];
//                return;
//            }
//        } else {
//            self.privateBlock(true,self.resultDictionary,nil);
//        }
//        
//        xmlFreeDoc(doc);
        
        //3. parse by xpath
        WYXMLDocument *doc = [[WYXMLDocument alloc] initWithData:self.parserData];
        NSDictionary *format = @{
                                 @"image":@{
                                            @"url":@(kWYXMLParseElementText)
                                         },
                                 @"title":@(kWYXMLParseElementText),
                                 @"item":@(kWYXMLParseElementAll)
                                 };
        self.resultDictionary = [doc readElement:format
                                       baseXPath:@"/rss/channel"][0];
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
        NSLog(@"parser time : %f",end);
        if (!self.resultDictionary) {
            [self occurError:[NSError errorWithDomain:@"no content" code:402 userInfo:nil]];
            return;
        } else {
            self.privateBlock(true,self.resultDictionary,nil);
        }
    });
}

@end

static void startElementNsSAX2          (void * ctx,
                                         const xmlChar * localname,
                                         const xmlChar * prefix,
                                         const xmlChar * URI,
                                         int nb_namespaces,
                                         const xmlChar ** namespaces,
                                         int nb_attributes,
                                         int nb_defaulted,
                                         const xmlChar ** attributes) {
    

    xmlParserCtxtPtr context = (xmlParserCtxtPtr)ctx;
    WYLibXMLParserOperation *operation = (__bridge WYLibXMLParserOperation*)context->_private;

    NSString *string = [[NSString alloc] initWithBytes:(const char*)localname length:strlen((const char*)localname) encoding:NSUTF8StringEncoding];
    [operation addNodeWithName:string attributes:nil];
}

static void	endElementNsSAX2            (void * ctx,
                                         const xmlChar * localname,
                                         const xmlChar * prefix,
                                         const xmlChar * URI) {
    

    xmlParserCtxtPtr context = (xmlParserCtxtPtr)ctx;
    WYLibXMLParserOperation *operation = (__bridge WYLibXMLParserOperation*)context->_private;
    if (operation.currentBuffer.length) {
        NSString *content = [[NSString alloc] initWithData:operation.currentBuffer encoding:NSUTF8StringEncoding];
        [operation addContentForCurrentNodeWithString:content];
        operation.currentBuffer.length = 0;
    }
    NSString *string = [[NSString alloc] initWithBytes:(const char*)localname length:strlen((const char*)localname) encoding:NSUTF8StringEncoding];
    [operation accomplishNodeWithName:string];
}

static void	charactersSAX           (void * ctx,
                                     const xmlChar * ch,
                                     int len) {
    xmlParserCtxtPtr context = (xmlParserCtxtPtr)ctx;
    WYLibXMLParserOperation *operation = (__bridge WYLibXMLParserOperation*)context->_private;
    [operation.currentBuffer appendBytes:(const char*)ch length:len];
//    NSString *string = [[NSString alloc] initWithBytes:(const char*)ch length:len encoding:NSUTF8StringEncoding];
//    [operation addContentForCurrentNodeWithString:string];
}

static void	cdataBlockSAX           (void * ctx,
                                     const xmlChar * value,
                                     int len) {

    xmlParserCtxtPtr context = (xmlParserCtxtPtr)ctx;
    WYLibXMLParserOperation *operation = (__bridge WYLibXMLParserOperation*)context->_private;
    [operation.currentBuffer appendBytes:(const char*)value length:len];
//    NSString *string = [[NSString alloc] initWithBytes:(const char*)value length:len encoding:NSUTF8StringEncoding];
//    [operation addContentForCurrentNodeWithString:string];
}
static void errorEncounteredSAX(void * ctx, const char * msg, ...) {
    
    xmlParserCtxtPtr context = (xmlParserCtxtPtr)ctx;
    WYLibXMLParserOperation *operation = (__bridge WYLibXMLParserOperation*)context->_private;
     NSString *string = [NSString stringWithUTF8String:msg];
    NSError *validationError = [[NSError alloc] initWithDomain:string code:0 userInfo:nil];
    [operation occurError:validationError];
}

@implementation WYTreeNodeXMLParserOperation

- (void)start {
    [super start];
    
    dispatch_async(self.processQueue, ^{
        [super start];

        //3. parse by xpath
        WYXMLDocument *doc = [[WYXMLDocument alloc] initWithData:self.parserData];
//        NSDictionary *format = @{
//                                 @"image":@{
//                                         @"url":@(kWYXMLParseElementText)
//                                         },
//                                 @"title":@(kWYXMLParseElementText),
//                                 @"item":@(kWYXMLParseElementAll)
//                                 };
//        self.resultDictionary = [doc readElement:format
//                                       baseXPath:@"/rss/channel"][0];

        self.resultDictionary = [doc readElement:self.parseContext.elementsMap
                                       baseXPath:self.parseContext.xpath][0];
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate] - self.startTimeReference;
        NSLog(@"parser time : %f",end);
        if (!self.resultDictionary) {
            [self occurError:[NSError errorWithDomain:@"no content" code:402 userInfo:nil]];
            return;
        } else {
            dispatch_async(self.completeQueue, ^{
                self.privateBlock(true,self.resultDictionary,nil);
            });
        }
    });
}

@end