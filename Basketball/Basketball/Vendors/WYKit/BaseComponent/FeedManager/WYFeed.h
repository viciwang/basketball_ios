//
//  WYFeed.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYFeed : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, strong) NSArray *feedEntity;

@end

NS_ASSUME_NONNULL_END

#import "WYFeed+CoreDataProperties.h"
