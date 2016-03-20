//
//  BBStepCountingMineViewController.m
//  Basketball
//
//  Created by Allen on 3/18/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingMineViewController.h"
#import "BBStepCountingRollView.h"
#import "BBStepCountingChartView.h"
#import "BBStepCountingManager.h"
#import "BBNetworkApiManager.h"

@interface BBStepCountingMineViewController ()

@property (nonatomic, strong) BBStepCountingRollView *rollView;
@property (nonatomic, strong) BBStepCountingChartView *chartView;
@property (nonatomic, strong) UIButton *showHistoryButton;

@end

@implementation BBStepCountingMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.rollView];
    [self.view addSubview:self.chartView];
    [self.view addSubview:self.showHistoryButton];
    [self.showHistoryButton addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.rollView refreshWithPercent:0.85];
}

- (void)updateViewConstraints {
    @weakify(self);
    [self.rollView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.rollView.mas_height);
        make.top.equalTo(self.view.mas_top);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(self.view).multipliedBy(0.5);
    }];
    [self.chartView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.rollView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.4);
    }];
    [self.showHistoryButton mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.1);
    }];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - properties

- (BBStepCountingRollView *)rollView {
    if (!_rollView) {
        _rollView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BBStepCountingRollView class]) owner:nil options:nil].firstObject;
    }
    return _rollView;
}

- (BBStepCountingChartView *)chartView {
    if (!_chartView) {
        _chartView = [BBStepCountingChartView new];
    }
    return _chartView;
}

- (UIButton *)showHistoryButton {
    if (!_showHistoryButton) {
        _showHistoryButton = [UIButton new];
        _showHistoryButton.backgroundColor = [UIColor redColor];
        [_showHistoryButton setTitle:@"查看历史数据" forState:UIControlStateNormal];
        [_showHistoryButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_showHistoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _showHistoryButton;
}

#pragma mark - action

- (void)showHistory:(UIButton *)button {
    
}

#pragma mark - load data

- (void)loadData {
    @weakify(self);
    [self showLoadingHUDWithInfo:nil];
    [[BBNetworkApiManager sharedManager] getStepCountingAverageWithCompletionBlock:^(NSNumber *average, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
        }
        else {
            [[BBStepCountingManager sharedManager] queryStepsOfToday:^(NSArray *steps, NSUInteger totalSteps) {
                @strongify(self);
                [self.chartView refreshWithData:steps];
                [self.rollView refreshWithTodayStep:totalSteps average:average.unsignedIntegerValue];
            }];
        }
    }];
}
@end
