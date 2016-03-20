//
//  BBUser.m
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBUser.h"
#import "BBDatabaseManager.h"

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCurrentUser = [[BBDatabaseManager sharedManager] retriveCurrentUser];
    });
    return _sharedCurrentUser;
}

+ (void)setCurrentUser:(BBUser *)user {
    [[BBDatabaseManager sharedManager] saveCurrentUser:user];
    _sharedCurrentUser = user;
}

@end
