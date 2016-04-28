//
//  BBStepCountingHistoryViewController.m
//  Basketball
//
//  Created by Allen on 3/21/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingHistoryViewController.h"
#import "BBNetworkApiManager.h"
#import "MBProgressHUD.h"
#import "BBStepCountingHistoryRecord.h"
#import "BBStepCountingHistoryRecordCell.h"
#import "NSDate+Utilities.h"
#import "BBDatabaseManager.h"

@interface BBStepCountingHistoryViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) UILabel *stepCountLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BBStepCountingHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"历史记录";
    [self setupTableView];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    @weakify(self);
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    [self.stepCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(@(120));
        make.height.equalTo(@(80));
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - properties

- (UILabel *)stepCountLabel {
    if (!_stepCountLabel) {
        _stepCountLabel = [[UILabel alloc]init];
        _stepCountLabel.textColor = [UIColor whiteColor];
        _stepCountLabel.textAlignment = NSTextAlignmentCenter;
        _stepCountLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _stepCountLabel.numberOfLines = 2;
        _stepCountLabel.hidden = YES;
        _stepCountLabel.layer.cornerRadius = 8;
        _stepCountLabel.clipsToBounds = YES;
        [self.view addSubview:_stepCountLabel];
    }
    return _stepCountLabel;
}

#pragma mark - UI

- (void)setupTableView {
    self.tableView = [UITableView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBStepCountingHistoryRecordCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBStepCountingHistoryRecordCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 184;
    [self.view addSubview:self.tableView];
}

#pragma mark - data

- (void)loadData {
    @weakify(self);
    [self showLoadingHUDWithInfo:nil];
    [[BBDatabaseManager sharedManager] retriveHistoryStepCountWithCompletionHandler:^(NSArray *allMonthData) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.records = allMonthData;
        [self.tableView reloadData];
    }];
}

- (void)showStepCountLabelWithText:(NSString *)text {
    self.stepCountLabel.hidden = NO;
    self.stepCountLabel.text = text;
    if (!self.timer || self.timer.isValid) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideStepCountLabel) userInfo:nil repeats:NO];
    }
}

- (void)hideStepCountLabel {
    self.stepCountLabel.hidden = YES;
    self.timer = nil;
}

#pragma mark - tableview delegate

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBStepCountingHistoryRecordCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBStepCountingHistoryRecordCell class]) forIndexPath:indexPath];
    BBStepCountingHistoryMonthRecord *r = self.records[indexPath.row];
    @weakify(self);
    [cell updateWithData:r isLastCell:(indexPath.row == self.records.count -1) selectedHandler:^(NSUInteger descress, NSUInteger index) {
        @strongify(self);
        NSUInteger internalIndex = r.dayRecords.count - 1 - (index - descress);
        if (internalIndex >= r.dayRecords.count) {
            return;
        }
        BBStepCountingHistoryDayRecord *dr = r.dayRecords[internalIndex];
        [self showStepCountLabelWithText:[NSString stringWithFormat:@"%@\n%@",dr.date,@(dr.stepCount)]];
    }];
    return cell;
}
@end
