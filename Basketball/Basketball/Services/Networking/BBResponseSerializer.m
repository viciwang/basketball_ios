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
    if (!error) {
        NSUInteger code = [responseObject[@"code"] unsignedIntegerValue];
        switch (code) {
            case 99:{
                *error = [[NSError alloc] initWithDomain:BBURLResponseSerializationErrorDomain code:code userInfo:responseObject[@"msg"]];
            }
            default:
                break;
        }
    }
    return responseObject;
}

@end
