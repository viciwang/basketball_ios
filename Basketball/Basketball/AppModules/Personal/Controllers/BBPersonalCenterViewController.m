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
#import "BBChangeInfoViewController.h"
#import "BBCommonCellView.h"
#import "BBStepCountingMainViewController.h"
#import "BBStepCountingRankViewController.h"
#import "BBStepCountingHistoryViewController.h"
#import "BBStepCountingMineViewController.h"
#import "BBAboutUsViewController.h"

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
@property (nonatomic, strong) UIView *titleBannerView;

@end

@implementation BBPersonalCenterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"";
    [self setupNavigationBar];
    [self setupTableView];
    [self setupObserver];
//    [self setupBackground];
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
    
    [self.titleBannerView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(150-SCREEN_HEIGHT);
        make.height.mas_equalTo(SCREEN_HEIGHT);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [super updateViewConstraints];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - noti

- (void)setupObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:kBBNotificationUserDidUpdateInfo object:nil];
}

- (void)updateInfo:(NSNotification *)noti {
    [self.tableView reloadData];
}

#pragma mark - UI

- (void)setupNavigationBar {
    
}

- (void)setupTableView {
    self.tableView = [UITableView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBPersonalCenterCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBPersonalCenterCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BBPersonalTableViewHeaderCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([BBPersonalTableViewHeaderCell class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromHex(0xf2f1ef);
    [self.view addSubview:self.tableView];
    
    self.cellTitles = @[@[@"个人描述"],@[@"今天步数",@"步数排行榜",@"历史数据"],@[@"清除缓存",@"关于我们"],@[@"退出"]];
    self.cellIconString = @[@[@"no_image"],@[@"Run",@"Rank",@"History"],@[@"Trash",@"Info"],@[@"no_image"]];
    
    self.titleBannerView = [UIView new];
    self.titleBannerView.backgroundColor = baseColor;
    [self.tableView insertSubview:self.titleBannerView atIndex:0];
}

- (void)setupBackground {
    UIImageView *imageView = [UIImageView new];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.view insertSubview:imageView belowSubview:self.tableView];
    [self.view insertSubview:effectView aboveSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[BBUser currentUser].headImageUrl]];
    @weakify(self);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 1) {
        switch (row) {
            case 0: {
                BBStepCountingMineViewController *vc = [BBStepCountingMineViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{
                BBStepCountingRankViewController *vc = [BBStepCountingRankViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{
                BBStepCountingHistoryViewController *vc = [BBStepCountingHistoryViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    else if(section == 2) {
        switch (row) {
            case 0: {
                [self clearCache];
                break;
            }
            case 1: {
                [self.navigationController pushViewController:[BBAboutUsViewController create] animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    else if(section == 3) {
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
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.row;
    if (indexPath.section == 0) {
        BBPersonalTableViewHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalTableViewHeaderCell class]) forIndexPath:indexPath];
        [cell fillDataWithUser:[BBUser currentUser]];
        @weakify(self);
        cell.changeInfoBlock = ^{
            @strongify(self);
            [self.navigationController pushViewController:[BBChangeInfoViewController create] animated:YES];
        };
        return cell;
    }
    else if(indexPath.section == 1 || indexPath.section == 2) {
        BBPersonalCenterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BBPersonalCenterCell class]) forIndexPath:indexPath];
        cell.commonCellView.leftImage = [UIImage imageNamed:self.cellIconString[indexPath.section][row]];
        cell.commonCellView.leftLabelText = self.cellTitles[indexPath.section][row];
        cell.commonCellView.shouldShowTopLine = YES;
        if (row != 0) {
            cell.commonCellView.topLineLeftSpace = 10;
            cell.commonCellView.topLineRightSpace = 10;
        }
        else {
            cell.commonCellView.topLineLeftSpace = 0;
            cell.commonCellView.topLineRightSpace = 0;
        }
        
        cell.commonCellView.shouldShowBottomLine = (row == self.cellTitles.count - 1);
        cell.commonCellView.bottomLineLeftSpace = 0;
        cell.commonCellView.bottomLineRightSpace = 0;
        
        cell.commonCellView.shouldShowdisclosureIndicator = YES;
        
        // 清除缓存
        if (indexPath.section == 2 && indexPath.row == 0) {
            NSInteger size = ([SDImageCache sharedImageCache].getSize + [[NSURLCache sharedURLCache] currentDiskUsage])/ 1024 / 1024.0;// byte -> kb -> mb
            cell.commonCellView.rightLabelText = [NSString stringWithFormat:@"%@M", @(size)];
        }
        return cell;
    }
    
    else {
        return self.logoutCell;
    }
    
}

#pragma mark - scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView setNeedsUpdateConstraints];
    [self.tableView updateFocusIfNeeded];
}

#pragma mark - properties

- (UITableViewCell *)logoutCell {
    if (!_logoutCell) {
        _logoutCell = [[UITableViewCell alloc]init];
        _logoutCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [BBUser setCurrentUser:nil];
        BBNavigationController *nav = [[BBNavigationController alloc] initWithRootViewController:[BBLoginViewController create]];
        [[UIApplication sharedApplication].keyWindow bb_checkoutRootViewController:nav];
    }];
}

- (void)clearCache
{
    @weakify(self);
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self showInfoHUD:@"缓存清理成功"];
                [self.tableView reloadData];
            });
        });
    }];
}

@end
