//
//  BBStepCountingService.h
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StepCountingUpdateBlock)(NSUInteger numberOfSteps, NSDate *timestamp, NSError *error);

@protocol BBStepCountingService <NSObject>

- (void)startStepCountingWithHandler:(StepCountingUpdateBlock)handler;

- (void)queryStepCountingFromDate:(NSDate *)beginDate endDate:(NSDate *)endDate handler:(StepCountingUpdateBlock)handler;

@end

@interface BBStepCountingService : NSObject <BBStepCountingService>

@end
