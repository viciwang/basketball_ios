//
//  BBStepCountingStatisticViewController.m
//  Basketball
//
//  Created by Allen on 3/4/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingStatisticViewController.h"

@interface BBStepCountingStatisticViewController ()

@property (nonatomic, assign) BBStepCountingStatisticType statisticsType;
@end

@implementation BBStepCountingStatisticViewController

- (instancetype)initWithStatisticsType:(BBStepCountingStatisticType)type {
    self = [super init];
    if (self) {
        self.statisticsType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(arc4random()%0xffffff);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
