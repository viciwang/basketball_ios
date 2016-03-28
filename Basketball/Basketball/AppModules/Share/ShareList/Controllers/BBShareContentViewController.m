//
//  BBShareContentViewController.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareContentViewController.h"
#import "BBShareCommentCell.h"
#import "BBShareCellView.h"
#import "BBShareContentViewModel.h"

@interface BBShareContentViewController ()<UITableViewDelegate, UITableViewDataSource, BBShareContentViewModelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) BBShareCellView *contentView;
@property (nonatomic, strong) BBShareContentViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarbottomConstraint;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation BBShareContentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"浏览";
    _contentView = [BBShareCellView loadFromNib];
    _contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65);
    _contentView.shareEntity = _shareEntity;
    _mainTableView.tableHeaderView = _contentView;
    [_mainTableView reloadData];
    
    _viewModel = [[BBShareContentViewModel alloc] init];
    _viewModel.delegate = self;
    _viewModel.shareEntity = _shareEntity;
    [_viewModel loadCommentData];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingGestureAction:)];
    [self.view addGestureRecognizer:_tapGesture];
    _tapGesture.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - key board observation
- (void)keyBoardShowNotification:(NSNotification *)notification {
    
    CGSize size = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.5 animations:^{
        _toolBarbottomConstraint.constant = size.height;
    }];
    _tapGesture.enabled = YES;
}
- (void)keyBoardHideNotification:(NSNotification *)notification {
    
    [UIView animateWithDuration:0.5 animations:^{
        _toolBarbottomConstraint.constant = 0;
    }];
    _tapGesture.enabled = NO;
}
#pragma mark - button action
- (void)endEditingGestureAction:(UITapGestureRecognizer *)gesture {
    [_commentTextField endEditing:YES];
}
- (IBAction)commentButtonAction:(id)sender {
    [_viewModel addComment:_commentTextField.text replyUserId:nil userName:nil];
    [_commentTextField endEditing:YES];
    [_commentTextField setText:nil];
}
#pragma mark - view model delegate
- (void)viewModel:(BBShareContentViewModel *)viewModel getShareCommentFinish:(NSError *)error {
    if(!error) {
        [_mainTableView reloadData];
    }
}
- (void)viewModel:(BBShareContentViewModel *)viewModel addShareCommentFinish:(NSError *)error {
    if (!error) {
        [_viewModel loadCommentData];
    }
    [_mainTableView reloadData];
}
#pragma mark - table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(self.view.bounds)/4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _viewModel.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBShareCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath:indexPath];
    cell.commentEntity = _viewModel.commentArray[indexPath.row];
    return cell;
}
#pragma mark - table view delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"评论";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
