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
    [super updateViewConstraints];
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

#pragma mark - tableview delegate

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBStepCountingHistoryRecordCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBStepCountingHistoryRecordCell class]) forIndexPath:indexPath];
    [cell updateWithData:self.records[indexPath.row]];
    return cell;
}
@end
