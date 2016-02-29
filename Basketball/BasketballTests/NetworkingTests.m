//
//  NetworkingTests.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBNetworkApiManager.h"

@interface BasketballTests : XCTestCase

@end

@implementation BasketballTests

- (void)setUp {
    [super setUp];
    
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

- (void)testGETMethod {
    [[BBNetworkApiManager shareManager] requestSampleWithCompetionBlock:^(id responseObject, NSError *error) {
        
    }];
}

@end