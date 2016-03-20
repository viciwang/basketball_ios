//
//  WYFeed+CoreDataProperties.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WYFeed.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYFeed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *feedDescription;
@property (nullable, nonatomic, retain) NSString *imageURL;
@property (nullable, nonatomic, retain) NSDate *lastBuildDate;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
