//
//  WYShare.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYShare : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, strong) NSDictionary *imageDictionary;

@end

NS_ASSUME_NONNULL_END

#import "WYShare+CoreDataProperties.h"
