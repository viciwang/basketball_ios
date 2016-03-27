//
//  BBStepCountingMainViewController.m
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingMainViewController.h"
#import "BBStepCountingManager.h"
#import "BBStepCountingTabBarView.h"
#import "BBStepCountingStatisticViewController.h"
#import "BBStepCountingMineViewController.h"
#import "BBStepCountingHistoryViewController.h"
#import "BBStepCountingRankViewController.h"

@interface BBStepCountingMainViewController ()
<
    UIPageViewControllerDelegate,
    UIPageViewControllerDataSource,
    BBStepCountingTabBarViewDelegate
>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) BBStepCountingTabBarView *stepCountingTabBarView;
@property (nonatomic, strong) NSMutableArray *statisticsVCs;

@end

@implementation BBStepCountingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupStepCounting];
}

- (void)updateViewConstraints {
    @weakify(self);
    [self.stepCountingTabBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.equalTo(@(40));
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.pageViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.top.equalTo(self.stepCountingTabBarView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - UI

- (void)setupUI {
    self.view.backgroundColor = baseColor;
    self.stepCountingTabBarView = [[BBStepCountingTabBarView alloc]initWithDelegate:self titles:@[@"今日步数",@"排行榜"]];
    [self.view addSubview:self.stepCountingTabBarView];
    [self setupPageViewController];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)setupPageViewController {
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.view addSubview:self.pageViewController.view];
    
    self.statisticsVCs = [NSMutableArray new];
    BBStepCountingMineViewController *mineVC = [BBStepCountingMineViewController new];
    @weakify(self);
    mineVC.showHistoryStepCountBlock = ^{
        @strongify(self);
        [self showHistory];
    };
    [self.statisticsVCs addObject:mineVC];
    
    BBStepCountingRankViewController *rankVC = [BBStepCountingRankViewController new];
    [self.statisticsVCs addObject:rankVC];
    
    [self.pageViewController setViewControllers:@[self.statisticsVCs[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)setupStepCounting {
//    [[BBStepCountingManager sharedManager] startStepCounting];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stepCountingUpdate:) name:kBBNotificationStepCountingUpdate object:nil];
}

- (void)stepCountingUpdate:(NSNotification *)notifation {
//    NSDateFormatter *formate = [NSDateFormatter new];
//    formate.dateFormat = @"HH:mm:ss";
//    NSDate *date = notifation.userInfo[@"date"];
//    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@：%@",[formate stringFromDate:date],notifation.userInfo[@"steps"]]];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSUInteger index = [self.statisticsVCs indexOfObject:pageViewController.viewControllers.firstObject];
        [self.stepCountingTabBarView selectButtonAtIndex:index animate:YES];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.statisticsVCs indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.statisticsVCs[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.statisticsVCs indexOfObject:viewController];
    if (index == self.statisticsVCs.count - 1) {
        return nil;
    }
    return self.statisticsVCs[index + 1];
}

#pragma mark - BBStepCountingTabBarViewDelegate

- (void)tabBarView:(BBStepCountingTabBarView *)tabBarView didSelectedTabAtIndex:(NSUInteger)index {
    [self.pageViewController setViewControllers:@[self.statisticsVCs[index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - push 

- (void)showHistory {
    BBStepCountingHistoryViewController *vc = [BBStepCountingHistoryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
