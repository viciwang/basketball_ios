//
//  BBDatabaseManager.h
//  Basketball
//
//  Created by Allen on 3/13/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBUser.h"

@interface BBDatabaseManager : NSObject

+ (BBDatabaseManager *)sharedManager;

- (void)resetCurrentUserDatabase;

- (NSInteger)retriveAverageStepCount;

- (BBUser *)retriveCurrentUser;

- (BOOL)saveCurrentUser:(BBUser *)user;

- (BOOL)saveStepCountData:(NSArray *)stepCountData;

- (void)retriveHistoryStepCountWithCompletionHandler:(void (^)(NSArray *allMonthData))handler;

- (NSString *)lastDateSavedStepCountData;

@end
