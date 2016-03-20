//
//  FKXMLParserManager.m
//  MicroReader
//
//  Created by yingwang on 15/11/6.
//  Copyright © 2015年 RR. All rights reserved.
//

#import "WYXMLParserManager.h"
#import "WYHTTPRequestManager.h"

NSString * const WYXMLParserXMLItemNameKey = @"kWYXMLParserXMLItemNameKey";
NSString * const WYXMLParserXMLSubitemKey = @"kWYXMLParserXMLSubitemKey";
NSString * const WYXMLParserXMLAttributeKey = @"kWYXMLParserXMLAttributeKey";
NSString * const WYXMLParserXMLContentKey = @"WYXMLParserXMLContentKey";

typedef void(^WYXMLParserManagerPrivateProcessBlock)(id obj);
@interface WYXMLParserManager()
{
    dispatch_queue_t _privateQueue;
    dispatch_queue_t _completionQueue;
    WYHTTPRequestManager *_manager;
}
@end

@implementation WYXMLParserManager

+ (instancetype)manager {
    static WYXMLParserManager *practice;
    static dispatch_once_t queue;
    dispatch_once(&queue, ^{
        if (!practice) {
            practice = [[self alloc]init];
        }
    });
    return practice;
}

static char *privateQueueName = "com.oninbest.WYKit.WYXMLParserManager.PrivateQueue";
static char *completionQueueName = "com.oninbest.WYKit.WYXMLParserManager.CompletionQueue";

- (instancetype)init {
    self = [super init];
    if (self) {
        _privateQueue = dispatch_queue_create(privateQueueName, DISPATCH_QUEUE_CONCURRENT);
        _completionQueue = dispatch_get_main_queue();
        _manager = [[WYHTTPRequestManager alloc] init];
    }
    return self;
}

#pragma mark - 
- (void)processBlock:(WYXMLParserManagerPrivateProcessBlock)block async:(BOOL)isAsync {
    if (isAsync) {
        dispatch_async(_privateQueue, ^{
            block(nil);
        });
    } else {
        block(nil);
    }
}

#pragma mark -

+ (void)parseXMLWithData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {
    [[self manager] parseXMLWithData:data completeBlock:completeBlock];
}
+ (void)parseXMLWithData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {
    [[self manager] parseXMLWithData:data context:ctx completeBlock:completeBlock];
}
+ (void)parserXMLWithURL:(NSString *)url completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {
    [[self manager] parserXMLWithURL:url completeBlock:completeBlock];
}
- (void)parseXMLWithData:(NSData *)data completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {
    return [self parseXMLWithData:data context:nil completeBlock:completeBlock];
}
- (void)parseXMLWithData:(NSData *)data context:(WYXMLParserContext *)ctx completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {

    WYXMLParserOperation *operation = [WYTreeNodeXMLParserOperation operationForParsingXMLData:data context:ctx completeBlock:completeBlock];
    operation.processQueue = _privateQueue;
    operation.completeQueue = _completionQueue;
    [operation start];
}
- (void)parserXMLWithURL:(NSString *)url completeBlock:(WYXMLParserOperationCompleteBlock)completeBlock {
    
    /*NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [self parseXMLWithData:data completeBlock:completeBlock];
    return;*/
    [_manager GET:url parameter:nil completionBlock:^(id respondObj, BOOL success, NSError *error) {
        if (!success && !respondObj) {
            completeBlock(false,nil,error);
            return ;
        }
        [self parseXMLWithData:respondObj completeBlock:completeBlock];
    }];
}

@end
