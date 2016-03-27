//
//  BBShareEditViewController.h
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBBaseViewController.h"

@class BBShareEditViewController;
@protocol BBShareEditViewControllerDelegate <NSObject>

- (void)shareEditViewController:(BBShareEditViewController *)viewController endEditingText:(NSString *)text images:(NSArray *)images;

@end

@interface BBShareEditViewController : UITableViewController

@property (nonatomic, weak) id<BBShareEditViewControllerDelegate> delegate;

@end
