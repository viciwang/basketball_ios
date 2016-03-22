//
//  StepCountingTests.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBBaseTestCase.h"
#import "BBUser.h"
#import "BBNetworkApiManager.h"

@interface StepCountingTests : BBBaseTestCase

@end

@implementation StepCountingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStepCounting {
    //先登录获取token
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] loginWithEmail:@"1214362919@qq.com" password:@"1234" completionBlock:^(id responseObject, NSError *error) {
        if (error) {
            XCTAssertFalse("error");
        }
        dispatch_group_leave(self.dispatcGroup);
    }];
    
    WaitForAllGroupToBeEmpty(100, nil);
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] getAverageStepCountWithCompletionBlock:^(id responseObject, NSError *error) {
        if (error) {
            XCTAssertFalse("");
        }
        else {
            DDLogInfo(@"%@",responseObject);
        }
        dispatch_group_leave(self.dispatcGroup);
    }];
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] getHistoryStepCountWithCompletionBlock:^(id responseObject, NSError *error) {
        if (error) {
            XCTAssertFalse("");
        }
        else {
            DDLogInfo(@"%@",responseObject);
        }
        dispatch_group_leave(self.dispatcGroup);
    }];
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] getStepCountRankingWithCompletionBlock:^(id responseObject, NSError *error) {
        if (error) {
            XCTAssertFalse(@"error");
        }
        else {
            DDLogInfo(@"%@",responseObject);
        }
        dispatch_group_leave(self.dispatcGroup);
    }];
    
    WaitForAllGroupToBeEmpty(100, nil);
}

@end
