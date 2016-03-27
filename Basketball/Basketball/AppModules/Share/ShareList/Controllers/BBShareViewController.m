//
//  BBShareViewController.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareViewController.h"
#import "BBShareViewFlowLayout.h"
#import "BBShareCell.h"
#import "BBShareContentViewController.h"
#import "BBShareEditViewController.h"

@interface BBShareViewController () <UICollectionViewDelegate,UICollectionViewDataSource, BBShareEditViewControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *editShareButton;

@end

@implementation BBShareViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden  = YES;
    BBShareViewFlowLayout *layout = [[BBShareViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [_collectionView registerNib:[BBShareCell registerNib] forCellWithReuseIdentifier:@"shareCell"];
    [_collectionView setBackgroundColor:[UIColor grayColor]];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];
    
    CGRect butRect = CGRectMake(CGRectGetWidth(self.view.bounds) - 55, 30, 40, 40);
    _editShareButton = [[UIButton alloc] initWithFrame:butRect];
    [_editShareButton setImage:[UIImage imageNamed:@"share_camera"] forState:UIControlStateNormal];
    [_editShareButton addTarget:self action:@selector(editShareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editShareButton];
    // Do any additional setup after loading the view.
}

#pragma mark - button action
- (void)editShareButtonAction:(id)sender {
    BBShareEditViewController *vc = [BBShareEditViewController create];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}
#pragma mark - share edit vc delegate
- (void)shareEditViewController:(BBShareEditViewController *)viewController endEditingText:(NSString *)text images:(NSArray *)images {
    
}
#pragma mark cell的数量
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"shareCell";
    BBShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    return cell;
}

#pragma mark cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth(self.view.bounds) - 60, CGRectGetHeight(self.view.bounds) - 65);
}
#pragma mark cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBShareContentViewController *vc = [BBShareContentViewController create];
    [self.navigationController pushViewController:vc animated:YES];
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
