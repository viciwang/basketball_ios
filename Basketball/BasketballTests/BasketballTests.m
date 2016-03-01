//
//  BasketballTests.m
//  BasketballTests
//
//  Created by Allen on 3/1/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BBNetworkApiManager.h"

@interface BasketballTests : XCTestCase

@end

@implementation BasketballTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [[BBNetworkApiManager shareManager] requestSampleWithCompetionBlock:^(id responseObject, NSError *error) {
        
    }];
    NSLog(@"ok *********");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
