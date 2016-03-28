//
//  WYShareComment+CoreDataProperties.h
//  Basketball
//
//  Created by yingwang on 16/3/28.
//  Copyright © 2016年 wgl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WYShareComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYShareComment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *commentId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *shareId;
@property (nullable, nonatomic, retain) NSDate *publicDate;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSNumber *isReply;
@property (nullable, nonatomic, retain) NSString *replyUserName;
@property (nullable, nonatomic, retain) NSString *replyUserId;
@property (nullable, nonatomic, retain) NSString *nikcName;
@property (nullable, nonatomic, retain) NSString *headImageUrl;

@end

NS_ASSUME_NONNULL_END
