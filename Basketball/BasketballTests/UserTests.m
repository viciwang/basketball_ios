//
//  UserTests.m
//  Basketball
//
//  Created by Allen on 3/14/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBNetworkApiManager.h"
#import "BBBaseTestCase.h"
#import <malloc/malloc.h>
#import <objc/runtime.h>
#import "BBUser.h"

@interface UserTests : BBBaseTestCase

@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testUserApi {
    
    NSString *email = @"1214362912@qq.com";
    __block NSString *verifyCode = @"123456";
    NSString *password = @"123456";
    NSString *city = @"上海";
    NSString *nickName = @"代码整洁之道";
    __block NSString *headImageUrl = nil;
    
    // 验证码
    dispatch_group_enter(self.dispatcGroup);
    @weakify(self);
    [[BBNetworkApiManager sharedManager]getVerifyCodeWithEmail:email
                                               completionBlock:^(NSString *code, NSError *error) {
                                                   @strongify(self);
                                                   dispatch_group_leave(self.dispatcGroup);
                                                   if (error) {
                                                       XCTAssert(false);
                                                   }
                                                   else {
                                                       XCTAssert(code.length == 6);
                                                       verifyCode = code;
                                                   }
    }];
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] uploadImageWithImage:[UIImage imageNamed:@"HOU_logo"] completionBlock:^(NSString *urlString, NSError *error) {
        @strongify(self);
        dispatch_group_leave(self.dispatcGroup);
        if (error) {
            XCTAssert(false);
        }
        else {
            XCTAssert([urlString hasPrefix:@"http://"]);
            headImageUrl = urlString;
        }
    }];
    
    WaitForAllGroupToBeEmpty(100, nil);
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] registerWithEmail:email
                                                  password:password
                                                verifyCode:verifyCode
                                           completionBlock:^(BBUser *user, NSError *error) {
                                               if (error) {
                                                   XCTAssert(false);
                                               }
                                               else {
                                                   XCTAssert([user.email isEqualToString:email]);
                                               }
                                               dispatch_group_leave(self.dispatcGroup);
                                           }];
    
    WaitForAllGroupToBeEmpty(100, nil);
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] loginWithEmail:email
                                               password:password
                                        completionBlock:^(BBUser *user, NSError *error) {
                                            if (error) {
                                                XCTAssert(false);
                                            }
                                            else {
                                                
                                            }
                                            dispatch_group_leave(self.dispatcGroup);
                                        }];
    
    WaitForAllGroupToBeEmpty(100, nil);
    
    dispatch_group_enter(self.dispatcGroup);
    [[BBNetworkApiManager sharedManager] updateUserInfoWithCity:city
                                                       nickName:nickName
                                                   headImageUrl:headImageUrl
                                                completionBlock:^(BBUser *user, NSError *error) {
                                                    if (error) {
                                                        XCTAssert(false);
                                                    }
                                                    else {
                                                        XCTAssert([user.headImageUrl isEqualToString:headImageUrl] &&
                                                                  [user.nickName isEqualToString:nickName] &&
                                                                  [user.city isEqualToString:city]);
                                                    }
                                                    dispatch_group_leave(self.dispatcGroup);
                                                }];
    WaitForAllGroupToBeEmpty(100, nil);
    
}


@end
