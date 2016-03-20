//
//  LCPageViewController.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCPageViewController.h"
#import "LCFeedEntityPageViewModel.h"
#import "LCArticleSinglePageViewController.h"
#import "LCArticleContentViewController.h"
#import "StatusBarAttentions.h"

@interface LCPageViewController () <UIPageViewControllerDataSource,
                                    UIPageViewControllerDelegate,
                                    LCFeedEntityPageViewModelDelegate,
                                    LCArticleSinglePageViewControllerDelegate,
                                    MONActivityIndicatorViewDelegate>
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) LCFeedEntityPageViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *pageControllers;

@property (nonatomic, strong) MONActivityIndicatorView *activityView;
@end

@implementation LCPageViewController

- (NSMutableArray *)pageControllers {
    if (!_pageControllers) {
        _pageControllers = [NSMutableArray array];
    }
    return _pageControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPageView];
    [self setupActivityView];
    
    [_activityView startAnimating];
    _viewModel = [[LCFeedEntityPageViewModel alloc] init];
    _viewModel.feed = _feed;
    _viewModel.delegate = self;
    [_viewModel reloadData];
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
}
- (void)setupPageView {
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options: options];
    [_pageController.view setBackgroundColor:[UIColor whiteColor]];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    _pageController.delegate = self;
    [[_pageController view] setFrame:self.view.bounds];
    [self.view addSubview:_pageController.view];
}
#pragma mark - view model delegate
- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didReloadDataFinish:(NSError *)error {
    
    [_activityView stopAnimating];
    if (error) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"还没有最新内容，稍等噢～"
                                      withProcessBlock:nil byCompletetion:nil];
        return;
    }
    [self resetPageViewControllers];
}
- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didRefreshDataFinish:(NSError *)error {
    // 没有最新数据
    if (error.code == 304) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"还没有最新内容，稍等噢～"
                                      withProcessBlock:nil byCompletetion:nil];
    } else if(error) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:error.domain
                                      withProcessBlock:nil byCompletetion:nil];
    } else {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"刷新成功，快查看有什么新内容～"
                                      withProcessBlock:nil byCompletetion:nil];
        [self resetPageViewControllers];
    }
}
- (void)resetPageViewControllers {
    _pageControllers = [NSMutableArray array];
    for (int i = 0; i<_viewModel.models.count; i += 6) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:6];
        for (int j=i; j<_viewModel.models.count && j<i+6; ++j) {
            [array addObject:_viewModel.models[j]];
        }
        LCArticleSinglePageViewController *pctr = [LCArticleSinglePageViewController create];
        pctr.delegate = self;
        pctr.pageIndex = i/6;
        pctr.feed = self.feed;
        pctr.addButtonHidden = !_viewModel.canSubscribeFeed;
        pctr.pageIndex = _pageControllers.count+1;
        pctr.lastedPageIndex = _viewModel.models.count%6?_viewModel.models.count/6+1:_viewModel.models.count/6;
        pctr.models = [NSArray arrayWithArray:array];
        [self.pageControllers addObject:pctr];
    }
    [_pageController setViewControllers:@[_pageControllers[0]]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:YES
                             completion:nil];
}
- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didLoadMoreDataFinish:(NSError *)error {
    if (error.code == 404) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"已经是最后一页，向前翻页或刷新查看其他内容～"
                                      withProcessBlock:nil byCompletetion:nil];
    } else if(error) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:error.domain
                                      withProcessBlock:nil byCompletetion:nil];
    } else {
        // 因为最后一个controller的feed entity数可能还不够6个，所以从最后一个开始补齐
        NSInteger lastIdx = _pageControllers.count - 1;
        if(lastIdx == -1)return;
        for (NSInteger i = lastIdx*6; i < _viewModel.models.count; i += 6,++lastIdx) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:6];
            for (NSInteger j=i; j<_viewModel.models.count && j<i+6; ++j) {
                [array addObject:_viewModel.models[j]];
            }
            // 最后一个controller 已经创建，只需把新的数组给它
            if (lastIdx == _pageControllers.count-1) {
                LCArticleSinglePageViewController *pctr = [_pageControllers lastObject];
                pctr.models = [NSArray arrayWithArray:array];
            } else {
                // 新建controller
                LCArticleSinglePageViewController *pctr = [LCArticleSinglePageViewController create];
                pctr.delegate = self;
                pctr.pageIndex = i/6;
                pctr.feed = self.feed;
                pctr.pageIndex = lastIdx+1;
                pctr.addButtonHidden = !_viewModel.canSubscribeFeed;
                pctr.lastedPageIndex = _viewModel.models.count%6?_viewModel.models.count/6+1:_viewModel.models.count/6;
                pctr.models = [NSArray arrayWithArray:array];
                [self.pageControllers addObject:pctr];
            }
        }
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"加载成功，快翻页查看更多内容～"
                                      withProcessBlock:nil byCompletetion:nil];
    }
    
}
#pragma mark - single page view delgate
- (void)singlePageViewController:(LCArticleSinglePageViewController *)controller didSelectedCellAtIndex:(NSInteger)index withObject:(id)object {
    LCArticleContentViewController *ctr = [LCArticleContentViewController create];
    ctr.article = object;
    ctr.feed = _feed;
    [self.navigationController pushViewController:ctr animated:YES];
}
- (void)returnButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller {
    [[WYFeedManager shareManager].store saveModifyCompletion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller {
    
    [_viewModel refreshData];
}
- (void)loadMoreButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller {
    [_viewModel loadMoreData];
}
- (void)addButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller {
    [[[WYFeedManager shareManager] store] insertFeed:_feed completion:^(id obj, BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeSpring
                                                      withText:@"订阅失败～"
                                              withProcessBlock:nil byCompletetion:nil];
            } else {
                [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                                      withText:@"订阅成功～"
                                              withProcessBlock:nil byCompletetion:nil];
                
                [_pageControllers enumerateObjectsUsingBlock:^(LCArticleSinglePageViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.addButtonHidden = YES;
                }];
            }
        });
        
    }];
}
#pragma mark - pageViewController delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    LCArticleSinglePageViewController *ctr = (LCArticleSinglePageViewController *)viewController;
    NSInteger index = ctr.pageIndex;
    if(index>=_pageControllers.count){
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"点击右下角加载图标加载下一页内容～"
                                      withProcessBlock:nil byCompletetion:nil];
    return nil;
    }
    return _pageControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    LCArticleSinglePageViewController *ctr = (LCArticleSinglePageViewController *)viewController;
    NSInteger index = ctr.pageIndex;
    if(index<=1) {
        [FRSBAttentionManager showBarAttentionWithType:kFRSBAttentionAnimationTypeAlpha
                                              withText:@"点击刷新图标加载最新内容～"
                                      withProcessBlock:nil byCompletetion:nil];
        return nil;
    }
    return _pageControllers[index-2];
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
