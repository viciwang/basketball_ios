//
//  BBDatabaseManager.m
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBDatabaseManager.h"
#import "FMDatabase.h"
#import "BBStepCountingHistoryRecord.h"
#import "NSDate+Utilities.h"

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
        NSLog(@"数据库物理地址：%@",writableDBPath);
        _localDatabase = [FMDatabase databaseWithPath:writableDBPath];
        [_localDatabase open];
        [_localDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS \
         `User` ( \
         `uid` char(10) NOT NULL, \
         `email` varchar(56) NOT NULL, \
         `nickName` varchar(30) NOT NULL, \
         `headImageUrl` varchar(100) NOT NULL, \
         `city` varchar(30) NOT NULL, \
         `token` char(23) NOT NULL, \
         `lastLoginTime` varchar(50) NOT NULL, \
         `personalDescription` varchar(180) \
         );"];
        
        [_localDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS \
         `StepCountDailyList` ( \
         `date` DATE NOT NULL, \
         `stepCount` int NOT NULL \
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
    
    if (![self.localDatabase open]) {
        return NO;
    }
    
    if (![self.localDatabase executeStatements:@"DELETE FROM User"]) {
        DDLogInfo(@"清空用户表出错：%@",[self.localDatabase lastErrorMessage]);
        return NO;
    }
    BOOL success = NO;
    if (user) {
        BOOL success = [self.localDatabase executeUpdate:@"INSERT INTO User (uid, email, nickName, headImageUrl, city, token, lastLoginTime) VALUES (?,?,?,?,?,?,?)",user.uid,user.email,user.nickName,user.headImageUrl,user.city,user.token,user.lastLoginTime];
        if (!success) {
            DDLogInfo(@"sqlite保存出错：%@",[self.localDatabase lastErrorMessage]);
        }
    }
    else {
        success = YES;
    }
    [self.localDatabase close];
    return success;
}

- (BOOL)saveStepCountData:(NSArray *)stepCountData {
    if (![self.localDatabase open]) {
        return NO;
    }
    FMResultSet *result = [self.localDatabase executeQuery:@"SELECT `date` FROM StepCountDailyList ORDER BY `date` DESC;"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    if ([result next]) {
        date = [result dateForColumn:0];
    }
    NSDateFormatter *formate = [NSDateFormatter new];
    formate.dateFormat = @"yyyy-MM-dd";
    for (NSUInteger index = 0 ; index<stepCountData.count; index++) {
        BBStepCountingHistoryMonthRecord *monthRecord = stepCountData[index];
        NSUInteger i;
        for (i = 0; i<monthRecord.dayRecords.count; i++) {
            BBStepCountingHistoryDayRecord *dayRecord = monthRecord.dayRecords[i];
            NSDate *lastDate = [formate dateFromString:dayRecord.date];
            if ([date isLaterThanDate:lastDate]) {
                break;
            }
            [self.localDatabase executeUpdate:@"INSERT INTO StepCountDailyCount (stepCount, startTime) VALUES (?,?)",dayRecord.stepCount , dayRecord.date];
        }
        if (i != monthRecord.dayRecords.count) {
            break;
        }
    }
    [self.localDatabase close];
    return YES;
}

- (NSDate *)lastDateSavedStepCountData {
    if (![self.localDatabase open]) {
        return [NSDate dateWithTimeIntervalSince1970:0];
    }
    FMResultSet *result = [self.localDatabase executeQuery:@"SELECT `date` FROM StepCountDailyList  ORDER BY `date` DESC;"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    if ([result next]) {
        date = [result dateForColumn:0];
    }
    [self.localDatabase close];
    return date;
}

@end
