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

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}

@end
