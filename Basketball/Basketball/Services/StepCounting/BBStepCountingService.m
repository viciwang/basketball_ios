//
//  BBStepCountingService.m
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingService.h"
#import <CoreMotion/CoreMotion.h>

@interface BBStepCountingService ()

@property (nonatomic, strong) CMPedometer *pedmeter;

@end

@implementation BBStepCountingService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pedmeter = [CMPedometer new];
    }
    return self;
}

- (void)startStepCountingWithHandler:(StepCountingUpdateBlock)handler {
    [self.pedmeter startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        if (handler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(pedometerData.numberOfSteps.unsignedIntegerValue, pedometerData.endDate, error);
            });            
        }
    }];
}

@end
