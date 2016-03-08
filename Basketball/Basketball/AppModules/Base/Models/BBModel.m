//
//  BBModel.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBModel.h"

@implementation BBModel

+ (instancetype)createFromJSONDictionary:(NSDictionary *)dict {
    return [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:dict error:nil];
}

+ (NSArray *)modelsFromJSONArray:(NSArray *)array {
    
    NSError *error;
    NSArray *result = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:array error:&error];
    return result;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

@end
