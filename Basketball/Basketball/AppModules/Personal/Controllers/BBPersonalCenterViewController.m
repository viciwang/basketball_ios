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
#import "BBNetworkApiManager.h"
#import "MBProgressHUD.h"
#import "UIWindow+Utils.h"
#import "BBLoginViewController.h"
#import "BBNavigationController.h"

@interface BBPersonalCenterViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BBPersonalTableViewHeaderCell *headerView;
@property (nonatomic, strong) UITableViewCell *logoutCell;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellIconString;

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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf2f1ef);
    [self.view addSubview:self.tableView];
    
    self.cellTitles = @[@"运动数据",@"运动数据",@"运动数据"];
    self.cellIconString = @[@"Contact Card 1",@"Contact Card 1",@"Contact Card 1"];
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 1) {
        
    }
    else if(section == 2) {
        @weakify(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self logoutAction];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action0];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - tableview datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return self.cellTitles.count;
        }
        case 2: {
            return 1;
        }
            
        default:
            return 0;
            break;
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
    else if(indexPath.section == 1) {
        BBPersonalCenterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalCenterCell class]) forIndexPath:indexPath];
        cell.icon.image = [UIImage imageNamed:self.cellIconString[indexPath.row]];
        cell.descriptionLabel.text = self.cellTitles[indexPath.row];
        cell.isLastIndexInSection = indexPath.row == self.cellTitles.count - 1;
        return cell;
    }
    
    else {
        return self.logoutCell;
    }
    
}

#pragma mark - properties

- (UITableViewCell *)logoutCell {
    if (!_logoutCell) {
        _logoutCell = [[UITableViewCell alloc]init];
        UILabel *label = [UILabel new];
        label.text = @"退出";
        label.font = [UIFont systemFontOfSize:15];
        [_logoutCell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_logoutCell.contentView);
        }];
    }
    return _logoutCell;
}

#pragma mark - action 

- (void)logoutAction {
    [self showLoadingHUDWithInfo:nil];
    @weakify(self);
    [[BBNetworkApiManager sharedManager] logoutWithCompletionBlock:^(id responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
        }
        else {
            BBNavigationController *nav = [[BBNavigationController alloc] initWithRootViewController:[BBLoginViewController create]];
            [[UIApplication sharedApplication].keyWindow bb_checkoutRootViewController:nav];
        }
    }];
}
@end
