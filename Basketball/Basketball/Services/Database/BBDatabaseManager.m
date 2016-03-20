//
//  BBDatabaseManager.m
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBDatabaseManager.h"
#import "FMDatabase.h"

@interface BBDatabaseManager ()

@property (nonatomic, strong) FMDatabase *localDatabase;

@end

@implementation BBDatabaseManager

+ (BBDatabaseManager *)sharedManager {
    static BBDatabaseManager * _sharedDatabaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDatabaseManager = [BBDatabaseManager new];
    });
    return _sharedDatabaseManager;
}

- (FMDatabase *)localDatabase {
    if(!_localDatabase) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Basketball.sqlite"];
        _localDatabase = [FMDatabase databaseWithPath:writableDBPath];
        [_localDatabase open];
        [_localDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS \
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
        [_localDatabase close];
    }
    return _localDatabase;
}

- (BBUser *)retriveCurrentUser {

    if (![self.localDatabase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.localDatabase executeQuery:@"SELECT * FROM User"];
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
    [self.localDatabase close];
    return user;
}

- (BOOL)saveCurrentUser:(BBUser *)user {
    
    if (![self.localDatabase executeStatements:@"TRUNCATE TABLE User"]) {
        return NO;
    }
    
    if (![self.localDatabase open] || !user) {
        return NO;
    }

    BOOL success = [self.localDatabase executeUpdate:@"INSERT INTO User (uid, email, nickName, headImageUrl, city, token, lastLoginTime) VALUES (?,?,?,?,?,?,?)",user.uid,user.email,user.nickName,user.headImageUrl,user.city,user.token,user.lastLoginTime];
    if (!success) {
        DDLogInfo(@"sqlite保存出错：%@",[self.localDatabase lastErrorMessage]);
    }
    [self.localDatabase close];
    return success;
}

@end
