//
//  BBStepCountingManager.h
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBStepCountingManager : NSObject

+ (BBStepCountingManager *)sharedManager;

- (void)startStepCounting;

- (void)stopStepCounting;

@end
