//
//  BBPersonalViewController.m
//  Basketball
//
//  Created by Allen on 3/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBPersonalCenterViewController.h"
#import "BBPersonalCenterCell.h"
#import "BBUser.h"
#import "BBPersonalTableViewHeaderCell.h"

@interface BBPersonalCenterViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BBPersonalTableViewHeaderCell *headerView;

@end

@implementation BBPersonalCenterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setupTableView];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBPersonalCenterCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBPersonalCenterCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBPersonalTableViewHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBPersonalTableViewHeaderCell class])];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableview delegate

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BBPersonalTableViewHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalTableViewHeaderCell class]) forIndexPath:indexPath];
        [cell fillDataWithUser:[BBUser currentUser]];
        @weakify(self);
        cell.changeInfoBlock = ^{
            @strongify(self);
            [self.navigationController pushViewController:[BBBaseViewController new] animated:YES];
        };
        return cell;
    }
    else {
        BBPersonalCenterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalCenterCell class]) forIndexPath:indexPath];
        cell.backgroundColor = UIColorFromHex(arc4random()%0xffffff);
        //    [cell updateWithData:self.records[indexPath.row]];
        return cell;
    }
}
@end
