//
//  BBUser.m
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBUser.h"

static BBUser * _sharedCurrentUser;

@implementation BBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid":@"uid",
             @"email":@"email",
             @"nickName":@"nickName",
             @"headImageUrl":@"headImageUrl",
             @"city":@"city",
             @"token":@"token",
             @"lastLoginTime":@"lastLoginTime"
             };
}

+ (BBModel *)currentUser {
    return _sharedCurrentUser;
}

+ (void)setCurrentUser:(BBUser *)user {
    _sharedCurrentUser = user;
}

@end
