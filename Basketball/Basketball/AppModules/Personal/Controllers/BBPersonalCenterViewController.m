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

@interface BBPersonalCenterViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *records;

@end

@implementation BBPersonalCenterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    [self setupTableView];
    [self fillData];
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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 150;
    [self.view addSubview:self.tableView];
}

#pragma mark - data

- (void)fillData {
    if ([BBUser currentUser]) {
        
    }
}

#pragma mark - tableview delegate

#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBPersonalCenterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalCenterCell class]) forIndexPath:indexPath];
//    [cell updateWithData:self.records[indexPath.row]];
    return cell;
}
@end
