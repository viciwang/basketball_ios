//
//  BBGamesScoreViewController.m
//  Basketball
//
//  Created by yingwang on 16/3/8.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBGamesScoreViewController.h"
#import "BBGamesScoreViewModel.h"
#import "BBGamesScoreTableViewCell.h"
#import "LCPageViewController.h"

@interface BBGamesScoreViewController () <UITableViewDelegate,
                                          UITableViewDataSource,
                                          BBGamesScoreViewModelDelegate,
                                          MONActivityIndicatorViewDelegate>

@property (nonatomic, strong) BBGamesScoreViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIButton *leftPageButton;
@property (weak, nonatomic) IBOutlet UIButton *rightPageButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) MONActivityIndicatorView *activityView;

@end

@implementation BBGamesScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewSetup];
    
    _viewModel = [[BBGamesScoreViewModel alloc] init];
    _viewModel.delegate = self;
    [_viewModel loadGameOfToDay];
}

- (void)viewSetup {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [_mainTableView registerNib:[BBGamesScoreTableViewCell registerNib]
         forCellReuseIdentifier:@"BBGamesScoreTableViewCell"];
    _mainTableView.tableFooterView = [UIView new];
    [self hideContentView];
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
- (void)hideContentView {
    [_mainTableView setHidden:YES];
    [_headerView setHidden:YES];
    [_leftPageButton setHidden:YES];
    [_rightPageButton setHidden:YES];
}
- (void)showContentView {
    [_mainTableView setHidden:NO];
    [_headerView setHidden:NO];
    [_leftPageButton setHidden:NO];
    [_rightPageButton setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma  mark - MonActivityView
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index {
    return [UIColor orangeColor];
}
#pragma mark - button action
- (IBAction)nextPageAction:(id)sender {
    [self hideContentView];
    [_activityView startAnimating];
    [_viewModel loadGameOfNextDay];
}
- (IBAction)lastPageAction:(id)sender {
    [self hideContentView];
    [_activityView startAnimating];
    [_viewModel loadGameOfDayBefore];
}

#pragma mark - BBGamesScoreViewModel delegate
- (void)gamesScoreViewModel:(BBGamesScoreViewModel *)model queryGamesOnDate:(NSString *)date complishWithObjects:(NSArray *)objects {
    
    if (!date) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        date = [formatter stringFromDate:[NSDate date]];
    }
    
    _titileLabel.text = [NSString stringWithFormat:@"%@  NBA %lu场比赛",date, _viewModel.games.count];
    [self showContentView];
    [_activityView stopAnimating];
    [self.mainTableView reloadData];
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return _viewModel.games.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BBGamesScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBGamesScoreTableViewCell"
                                                                      forIndexPath:indexPath];
    
    cell.gameInfo = _viewModel.games[indexPath.row];
    return cell;
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
