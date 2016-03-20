//
//  BBResponseSerializer.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBResponseSerializer.h"

NSString * const BBURLResponseSerializationErrorDomain = @"com.basketball.Basketball.error.serialization.response";

@implementation BBResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error {
    id responseObject = [super responseObjectForResponse:response data:data error:error];
    DDLogInfo(@"接口访问：%@ \n 返回：%@，\n出错：%@",response.URL, responseObject, *error);
    if (!(*error)) {
        NSUInteger code = [responseObject[@"code"] unsignedIntegerValue];
        NSString *errorMsg = responseObject[@"msg"]?responseObject[@"msg"]:@"出错了";
        switch (code) {
            case 99:{
                *error = [[NSError alloc] initWithDomain:BBURLResponseSerializationErrorDomain code:code userInfo:@{@"msg":errorMsg}];
                break;
            }
            case 1:{
                *error = [[NSError alloc] initWithDomain:BBURLResponseSerializationErrorDomain code:code userInfo:@{@"msg":errorMsg}];
                break;
            }
            default:
                break;
        }
    }
    else {
        *error = [[NSError alloc] initWithDomain:(*error).domain code:(*error).code userInfo:@{@"msg":@"网络错误"}];
    }
    return responseObject;
}

@end
