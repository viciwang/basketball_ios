//
//  BBStepCountingManager.m
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingManager.h"
#import "BBStepCountingService.h"

@interface BBStepCountingManager ()

@property (nonatomic, strong) id<BBStepCountingService> stepCountingService;

@end

@implementation BBStepCountingManager

+ (BBStepCountingManager *)sharedManager {
    static BBStepCountingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BBStepCountingManager new];
        manager.stepCountingService = [BBStepCountingService new];
    });
    return manager;
}

- (void)startStepCounting {
    [self.stepCountingService startStepCountingWithHandler:^(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        if (!error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:BBNotificationStepCountingUpdate object:nil userInfo:@{@"date":timestamp,@"steps":@(numberOfSteps)}];
        }
    }];
}

- (void)stopStepCounting {
    
}

@end
