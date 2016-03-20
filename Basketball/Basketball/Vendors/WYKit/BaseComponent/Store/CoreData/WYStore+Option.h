//
//  WYStore+Option.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/6.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#ifndef WYStore_Option_h
#define WYStore_Option_h


#endif /* WYStore_Option_h */

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, WYStoreOperationOption) {
    
    WYStoreOperationSync = 1ul << 0,
    WYStoreOperationAsync = 1ul << 1,
};