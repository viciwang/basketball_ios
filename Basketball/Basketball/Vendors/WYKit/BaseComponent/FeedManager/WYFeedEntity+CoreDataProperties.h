//
//  WYFeedEntity+CoreDataProperties.h
//  WYKitTDemo
//
//  Created by yingwang on 16/1/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WYFeedEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYFeedEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *feedDescription;
@property (nullable, nonatomic, retain) NSNumber *hasRead;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *feedLink;
@property (nullable, nonatomic, retain) NSDate *publishDate;
@property (nullable, nonatomic, retain) NSDate *insertedDate;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *sourceName;
@property (nullable, nonatomic, retain) NSString *images;
@property (nullable, nonatomic, retain) NSNumber *sqlIndex;

@end

NS_ASSUME_NONNULL_END
