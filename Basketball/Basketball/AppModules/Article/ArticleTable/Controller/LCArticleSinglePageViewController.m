//
//  LCArticleSinglePageViewController.m
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticleSinglePageViewController.h"
#import "LCArticlePageView.h"
#import "LCArticlePageView+Style.h"

@interface LCArticleSinglePageViewController () <LCArticlePageViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIView *articleView;

@property (strong, nonatomic) LCArticlePageView *pageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation LCArticleSinglePageViewController

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
}
- (void)setFeed:(id)feed {
    _feed = feed;
    _pageView.feed = _feed;
}
- (void)setModels:(NSArray *)models {
    _models = models;
    _pageView.models = _models;
}
- (void)setAddButtonHidden:(BOOL)addButtonHidden {
    _addButtonHidden = addButtonHidden;
    _addButton.hidden = addButtonHidden;
}

- (void)awakeFromNib {
    static LCArticlePageViewStyle style = kLCArticlePageViewStyleB;
    style = style==kLCArticlePageViewStyleA?kLCArticlePageViewStyleB:kLCArticlePageViewStyleA;
    _pageView = [LCArticlePageView loadPageViewFromNibWithStyle:style];
    _pageView.pageStyle = style;
    _pageView.delegate = self;
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"%@",NSStringFromCGRect(self.articleView.bounds));
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *indexString = [NSString stringWithFormat:@"%lu/%lu",_pageIndex,_lastedPageIndex];
    _pageLabel.text = indexString;
    _addButton.hidden = _addButtonHidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    NSLog(@"%@",NSStringFromCGRect(self.articleView.bounds));
    _pageView.frame = self.articleView.bounds;
    _pageView.feed = _feed;
    _pageView.models = self.models;
    [self.articleView addSubview:_pageView];
    [_pageView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action
- (IBAction)returnButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(returnButtonActionOnSingPageViewController:)]) {
        [_delegate returnButtonActionOnSingPageViewController:self];
    }
}
- (IBAction)refreshButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(refreshButtonActionOnSingPageViewController:)]) {
        [_delegate refreshButtonActionOnSingPageViewController:self];
    }
}
- (IBAction)loadMoreButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loadMoreButtonActionOnSingPageViewController:)]) {
        [_delegate loadMoreButtonActionOnSingPageViewController:self];
    }
}
- (IBAction)addButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(addButtonActionOnSingPageViewController:)]) {
        [_delegate addButtonActionOnSingPageViewController:self];
    }
}

#pragma mark - page view delegate
- (void)articlePageView:(LCArticlePageView *)pageView didSelectedCellAtIndex:(NSInteger)idx withObject:(id)object {
    if (_delegate && [_delegate respondsToSelector:@selector(singlePageViewController:didSelectedCellAtIndex:withObject:)]) {
        [_delegate singlePageViewController:self didSelectedCellAtIndex:idx withObject:object];
    }
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
