//
//  WYShare+CoreDataProperties.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WYShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYShare (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *shareId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSDate *publicDate;
@property (nullable, nonatomic, retain) NSNumber *approveCount;
@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *locationName;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *headImageUrl;
@property (nullable, nonatomic, retain) NSData *images;
@property (nullable, nonatomic, retain) NSNumber *isApprove;
@property (nullable, nonatomic, retain) NSNumber *isUserShare;

@end

NS_ASSUME_NONNULL_END
