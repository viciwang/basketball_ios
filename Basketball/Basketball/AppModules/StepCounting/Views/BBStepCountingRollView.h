//
//  BBStepCountingRollView.h
//  Basketball
//
//  Created by Allen on 3/18/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBView.h"

@interface BBStepCountingRollView : BBView

- (void)refreshWithTodayStep:(NSUInteger)steps average:(NSUInteger)average;

- (void)refreshWithTodayStep:(NSUInteger)steps;

@end
