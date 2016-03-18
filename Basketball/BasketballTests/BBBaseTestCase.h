//
//  BBBaseTestCase.h
//  Basketball
//
//  Created by Allen on 3/17/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <XCTest/XCTest.h>

#define WaitForAllGroupToBeEmpty(timeout,block) \
do { \
if (![self waitForAllGroupToBeEmptyWithTimeout:timeout completionBlock:block]) { \
XCTFail(@"time out waiting for group to empty"); \
} \
} while(0)

@interface BBBaseTestCase : XCTestCase

@property (nonatomic) dispatch_group_t dispatcGroup;

- (BOOL)waitForAllGroupToBeEmptyWithTimeout:(NSTimeInterval)timeout completionBlock:(void (^)())completionBlock;

@end
