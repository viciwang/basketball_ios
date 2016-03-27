//
//  BBStepCountingRankViewController.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStepCountingRankViewController.h"
#import "BBNetworkApiManager.h"
#import "BBStepCountingRankCell.h"
#import "BBRefreshHeader.h"

@interface BBStepCountingRankViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *ranks;

@end

@implementation BBStepCountingRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"排行榜";
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBStepCountingRankCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBStepCountingRankCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 65;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = baseColor;
    [self.view addSubview:self.tableView];
    @weakify(self);
    self.tableView.mj_header = [BBRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
}

#pragma mark - data

- (void)loadData {
    @weakify(self);
    [self showLoadingHUDWithInfo:nil];
    [[BBNetworkApiManager sharedManager] getStepCountRankingWithCompletionBlock:^(NSArray *ranks, NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.ranks = ranks;
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview delegate

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ranks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBStepCountingRankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBStepCountingRankCell class]) forIndexPath:indexPath];
    [cell updateWithData:self.ranks[indexPath.row]];
    return cell;
}
@end
