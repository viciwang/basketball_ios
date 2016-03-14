//
//  BBDatabaseManager.m
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBDatabaseManager.h"
#import "FMDatabase.h"

@implementation BBDatabaseManager

+ (BBDatabaseManager *)sharedManager {
    static BBDatabaseManager * _sharedDatabaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDatabaseManager = [BBDatabaseManager new];
    });
    return _sharedDatabaseManager;
}

- (BBUser *)retriveCurrentUser {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"User.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    
    if (![db open]) {
        return nil;
    }
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS \
     `User` ( \
     `id` int(10) NOT NULL, \
     `uid` char(10) NOT NULL, \
     `email` varchar(56) NOT NULL, \
     `nickName` varchar(30) NOT NULL, \
     `headImageUrl` varchar(100) NOT NULL, \
     `city` varchar(30) NOT NULL, \
     `token` char(23) NOT NULL, \
     `lastLoginTime` varchar(50) NOT NULL \
     );"];
    
    FMResultSet *result = [db executeQuery:@"SELECT * FROM User"];
    BBUser *user = nil;
    if ([result next]) {
        user = [BBUser new];
        user.uid = [result stringForColumn:@"uid"];
        user.email = [result stringForColumn:@"email"];
        user.nickName = [result stringForColumn:@"nickName"];
        user.headImageUrl = [result stringForColumn:@"headImageUrl"];
        user.city = [result stringForColumn:@"city"];
        user.token = [result stringForColumn:@"token"];
        user.lastLoginTime = [result stringForColumn:@"lastLoginTime"];
    }
    [db close];
    return user;
}

@end
