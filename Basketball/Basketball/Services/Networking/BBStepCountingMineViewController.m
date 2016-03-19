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

@interface BBStepCountingMineViewController ()

@property (nonatomic, strong) BBStepCountingRollView *rollView;
@property (nonatomic, strong) BBStepCountingChartView *chartView;

@end

@implementation BBStepCountingMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.rollView];
    [self.view addSubview:self.chartView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.rollView refreshWithPercent:0.85];
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
        make.height.equalTo(self.view).multipliedBy(0.3);
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
        _rollView = [BBStepCountingRollView new];
        _rollView.backgroundColor = [UIColor redColor];
    }
    return _rollView;
}

- (BBStepCountingChartView *)chartView {
    if (!_chartView) {
        _chartView = [BBStepCountingChartView new];
    }
    return _chartView;
}
@end
