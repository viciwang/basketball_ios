//
//  BBStepCountingTabBarView.h
//  Basketball
//
//  Created by Allen on 3/4/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBStepCountingTabBarView;

@protocol BBStepCountingTabBarViewDelegate <NSObject>

- (void)tabBarView:(BBStepCountingTabBarView *)tabBarView didSelectedTabAtIndex:(NSUInteger)index;

@end

@interface BBStepCountingTabBarView : UIView

- (instancetype)initWithDelegate:(id<BBStepCountingTabBarViewDelegate>) delegate titles:(NSArray *)titles;

- (void)selectButtonAtIndex:(NSUInteger)index animate:(BOOL)animate;

@end
