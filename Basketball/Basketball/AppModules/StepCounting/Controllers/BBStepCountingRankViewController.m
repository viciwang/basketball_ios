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
#import "BBStepCountingRankHeadView.h"

@interface BBStepCountingRankViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BBStepCountingRankResponse *ranksResponse;

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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBStepCountingRankHeadView class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBStepCountingRankHeadView class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [[BBNetworkApiManager sharedManager] getStepCountRankingWithCompletionBlock:^(BBStepCountingRankResponse *response, NSError *error) {
        @strongify(self);
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.ranksResponse = response;
        [self.tableView reloadData];
    }];
}

#pragma mark - tableview delegate

#pragma mark - tableview datasource



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145;
    }
    else {
        return 65;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.ranksResponse) {
        return 0;
    }
    if (section == 0) {
        return 1;
    }
    else {
        return self.ranksResponse.ranks.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BBStepCountingRankHeadView *v = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBStepCountingRankHeadView class]) forIndexPath:indexPath];
        [v updateWithData:self.ranksResponse.myRank rate:(self.ranksResponse.ranks.count - self.ranksResponse.myRank.rank)/@(self.ranksResponse.ranks.count).floatValue];
        return v;
    }
    else {
        BBStepCountingRankCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBStepCountingRankCell class]) forIndexPath:indexPath];
        [cell updateWithData:self.ranksResponse.ranks[indexPath.row]];
        return cell;
    }
}
@end
