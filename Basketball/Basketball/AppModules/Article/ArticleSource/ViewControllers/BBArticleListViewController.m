//
//  BBArticleListViewController.m
//  Basketball
//
//  Created by yingwang on 16/3/19.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBArticleListViewController.h"
#import "BBArticleListViewModel.h"
#import "BBArticleListViewCell.h"
#import "LCPageViewController.h"

@interface BBArticleListViewController () <UITableViewDelegate,UITableViewDataSource,BBArticleListViewModelDelegate,MONActivityIndicatorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) BBArticleListViewModel *viewModel;
@property (nonatomic, strong) MONActivityIndicatorView *activityView;
@end

@implementation BBArticleListViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_mainTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView.tableFooterView = [UIView new];
    [self setupActivityView];
    _viewModel = [[BBArticleListViewModel alloc] init];
    _viewModel.delegate = self;
    [_viewModel loadData];
    // Do any additional setup after loading the view.
}

- (void)setupActivityView {
    _activityView = [[MONActivityIndicatorView alloc]init];
    _activityView.delegate = self;
    _activityView.numberOfCircles = 3;
    _activityView.radius = 10;
    _activityView.internalSpacing = 3;
    [self.view addSubview:_activityView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    [_activityView startAnimating];
}

#pragma mark - view model delegate
- (void)viewModel:(BBArticleListViewModel *)viewModel didLoadDataFinish:(NSError *)error {
    [_mainTableView reloadData];
    [_activityView stopAnimating];
}
#pragma mark - table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(self.view.bounds)/3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.feeds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBArticleListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell" forIndexPath:indexPath];
    cell.feed = _viewModel.feeds[indexPath.row];
    return cell;
}
#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LCPageViewController *ctr = [[LCPageViewController alloc] init];
    ctr.feed = _viewModel.feeds[indexPath.row];
    [self.navigationController pushViewController:ctr animated:YES];
}
# pragma  mark - MonActivityView
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index {
    return [UIColor orangeColor];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
