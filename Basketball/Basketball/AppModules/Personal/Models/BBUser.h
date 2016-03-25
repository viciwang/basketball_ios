//
//  BBUser.h
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBModel.h"

@interface BBUser : BBModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImageUrl;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *lastLoginTime;
@property (nonatomic, copy) NSString *personalDescription;

+ (BBUser *)currentUser;

+ (void)setCurrentUser:(BBUser *)user;

@end
