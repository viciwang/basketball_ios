//
//  BBStepCountingMainViewController.m
//  Basketball
//
//  Created by Allen on 3/3/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingMainViewController.h"
#import "BBStepCountingManager.h"

@interface BBStepCountingMainViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation BBStepCountingMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupStepCounting];
}

- (void)updateViewConstraints {
    @weakify(self);
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.textView.superview);
    }];
    [super updateViewConstraints];
}

#pragma mark - UI

- (void)setupUI {
    self.textView = [UITextView new];
    self.textView.text = @"begin";
    self.textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.textView];
    
    [self.view updateConstraintsIfNeeded];
}

- (void)setupStepCounting {
    [[BBStepCountingManager sharedManager] startStepCounting];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stepCountingUpdate:) name:BBNotificationStepCountingUpdate object:nil];
}

- (void)stepCountingUpdate:(NSNotification *)notifation {
    NSDateFormatter *formate = [NSDateFormatter new];
    formate.dateFormat = @"HH:mm:ss";
    NSDate *date = notifation.userInfo[@"date"];
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@：%@",[formate stringFromDate:date],notifation.userInfo[@"steps"]]];
}

@end
