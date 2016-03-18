//
//  BBBaseTestCase.m
//  Basketball
//
//  Created by Allen on 3/17/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBBaseTestCase.h"

@interface BBBaseTestCase()

@end

@implementation BBBaseTestCase

- (void)setUp {
    [super setUp];
    self.dispatcGroup = dispatch_group_create();
}

- (void)tearDown {
    [super tearDown];
}

- (BOOL)waitForAllGroupToBeEmptyWithTimeout:(NSTimeInterval)timeout completionBlock:(void (^)())completionBlock {
    NSDate * const end = [NSDate dateWithTimeIntervalSinceNow:timeout];
    
    __block BOOL didComplete = NO;
    dispatch_group_notify(self.dispatcGroup, dispatch_get_main_queue(), ^{
        didComplete = YES;
        if (completionBlock) {
            completionBlock();
        }
    });
    
    while ((!didComplete) && ([end timeIntervalSinceNow] >= 0)) {
        NSTimeInterval const interval = 0.002;
        if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:interval]]) {
            [NSThread sleepForTimeInterval:interval];
        }
    }
    return didComplete;
}

@end
