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
@property (nonatomic, strong) FMDatabase *currentUserDatabase;

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

- (FMDatabase *)currentUserDatabase {
    if (!_currentUserDatabase) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"CurrentUser.sqlite"];
        NSLog(@"数据库物理地址：%@",writableDBPath);
        _currentUserDatabase = [FMDatabase databaseWithPath:writableDBPath];
        [_currentUserDatabase open];
        [_currentUserDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS \
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
        
        [_currentUserDatabase close];
    }
    return _currentUserDatabase;
}

- (void)resetCurrentUserDatabase {
    NSString *uid = [BBUser currentUser].uid;
    if (!uid) {
        _localDatabase = nil;
        return;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Basketball.sqlite",uid]];
    NSLog(@"数据库物理地址：%@",writableDBPath);
    _localDatabase = [FMDatabase databaseWithPath:writableDBPath];
    [_localDatabase open];
    [_localDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS \
     `StepCountDailyList` ( \
     `date` DATE NOT NULL, \
     `stepCount` int NOT NULL \
     );"];
    
    [_localDatabase close];
}

- (BBUser *)retriveCurrentUser {
    
    if (![self.currentUserDatabase open]) {
        return nil;
    }
    
    FMResultSet *result = [self.currentUserDatabase executeQuery:@"SELECT * FROM User"];
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
        user.personalDescription = [result stringForColumn:@"personalDescription"];
    }
    [self.currentUserDatabase close];
    return user;
}

- (BOOL)saveCurrentUser:(BBUser *)user {
    
    if (![self.currentUserDatabase open]) {
        return NO;
    }
    
    if (![self.currentUserDatabase executeStatements:@"DELETE FROM User"]) {
        DDLogInfo(@"清空用户表出错：%@",[self.localDatabase lastErrorMessage]);
        return NO;
    }
    BOOL success = NO;
    if (user) {
        BOOL success = [self.currentUserDatabase executeUpdate:@"INSERT INTO User (uid, email, nickName, headImageUrl, city, token, lastLoginTime, personalDescription) VALUES (?,?,?,?,?,?,?,?)",user.uid,user.email,user.nickName,user.headImageUrl,user.city,user.token,user.lastLoginTime,user.personalDescription];
        if (!success) {
            DDLogInfo(@"sqlite保存出错：%@",[self.currentUserDatabase lastErrorMessage]);
        }
    }
    else {
        success = YES;
    }
    [self.currentUserDatabase close];
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
            [self.localDatabase executeUpdate:@"INSERT INTO StepCountDailyList (stepCount, date) VALUES (?,?)",@(dayRecord.stepCount) , dayRecord.date];
        }
        if (i != monthRecord.dayRecords.count) {
            break;
        }
    }
    [self.localDatabase close];
    return YES;
}

- (NSString *)lastDateSavedStepCountData {
    if (![self.localDatabase open]) {
        return @"1970-01-01";
    }
    FMResultSet *result = [self.localDatabase executeQuery:@"SELECT `date` FROM StepCountDailyList  ORDER BY `date` DESC;"];
    NSString *date = @"1970-01-01";
    if ([result next]) {
        date = [result stringForColumnIndex:0];
    }
    [self.localDatabase close];
    return date;
}

- (NSInteger)retriveAverageStepCount {
    if (![self.localDatabase open]) {
        return 0;
    }
    FMResultSet *result = [self.localDatabase executeQuery:@"SELECT avg(stepCount) FROM StepCountDailyList"];
    NSInteger num = 0;
    if ([result next]) {
        num = [result longForColumnIndex:0];
    }
    [self.localDatabase close];
    return  num;
}

- (void)retriveHistoryStepCountWithCompletionHandler:(void (^)(NSArray *))handler
{
    if (![self.localDatabase open]) {
        if (handler) {
            handler(nil);
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FMResultSet *result = [self.localDatabase executeQuery:@"SELECT `stepCount`,`date` FROM StepCountDailyList ORDER BY `date` DESC;"];
        
        NSMutableArray *allMonthData = [NSMutableArray new];
        NSMutableArray *dayRecords = [NSMutableArray new];
        BBStepCountingHistoryDayRecord *record;
        while ([result next]) {
            record = [BBStepCountingHistoryDayRecord new];
            record.stepCount = [result intForColumnIndex:0];
            record.date = [result stringForColumnIndex:1];
            [dayRecords addObject:record];
            if ([[record.date substringFromIndex:8] isEqualToString:@"01"]) {
                BBStepCountingHistoryMonthRecord *month = [BBStepCountingHistoryMonthRecord new];
                month.dayRecords = dayRecords;
                month.month = [record.date substringToIndex:7];
                [allMonthData addObject:month];
                dayRecords = [NSMutableArray new];
            }
        }
        
        BBStepCountingHistoryMonthRecord *month = [BBStepCountingHistoryMonthRecord new];
        month.dayRecords = dayRecords;
        month.month = [record.date substringToIndex:7];
        [allMonthData addObject:month];
        
        for (BBStepCountingHistoryMonthRecord *r in allMonthData) {
            r.average = ((NSNumber *)[r valueForKeyPath:@"dayRecords.@avg.stepCount"]).doubleValue;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(handler) {
                handler(allMonthData);
            }
        });
        [self.localDatabase close];
    });
}

@end
