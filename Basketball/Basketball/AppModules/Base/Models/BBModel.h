//
//  BBModel.h
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface BBModel : MTLModel <MTLJSONSerializing>

+ (instancetype)createFromJSONDictionary:(NSDictionary *)dict;

@end
