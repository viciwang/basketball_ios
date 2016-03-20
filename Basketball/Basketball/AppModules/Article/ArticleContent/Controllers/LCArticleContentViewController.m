//
//  LCArticleContentViewController.m
//  LazyCat
//
//  Created by yingwang on 16/3/11.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticleContentViewController.h"
#import "WYTextScrollView.h"
#import "LCArticleContentViewModel.h"
#import "NewsRecourceViewController.h"
#import "LCArticleContentSettingView.h"
#import "TimeFormatterTransform.h"

@interface LCArticleContentViewController () <LCArticleContentViewModelDelegate,
                                              WYTeleTextViewDelegate,
                                              MONActivityIndicatorViewDelegate,
                                              LCArticleContentSettingViewDelegate>

// tool bar component
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *htmlButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (weak, nonatomic) IBOutlet UIView *toolBarView;

// text view
@property (weak, nonatomic) IBOutlet WYTextScrollView *textScrollView;

// setting view
@property (strong, nonatomic) LCArticleContentSettingView *settingView;

// view model
@property (strong, nonatomic) LCArticleContentViewModel *viewModel;

@property (nonatomic, strong) MONActivityIndicatorView *activityView;
@end

@implementation LCArticleContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configSettingView];
    [self configActivityView];
    [_activityView startAnimating];
    
    _textScrollView.textView.delegate = self;
    
    _viewModel = [[LCArticleContentViewModel alloc] init];
    _viewModel.feed = _feed;
    _viewModel.delegate = self;
    _viewModel.article = _article;
    [_viewModel reloadData];
    
}
- (void)configSettingView {
    
    _settingView = [LCArticleContentSettingView loadFromNibGeneral];
    _settingView.delegate = self;
    _settingView.frame = self.view.bounds;
    NSLog(@"frame = %@",NSStringFromCGRect(self.view.bounds));
    [self.view addSubview:_settingView];
    [self.view bringSubviewToFront:_toolBarView];
    _settingView.hidden = YES;
}
- (void)configActivityView {
    _activityView = [[MONActivityIndicatorView alloc]init];
    _activityView.delegate = self;
    _activityView.numberOfCircles = 3;
    _activityView.radius = 7;
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
#pragma mark - view model delegate
- (void)articleContentViewModel:(LCArticleContentViewModel *)model didLoadDataFinishWithError:(NSError *)error {
    
    [_activityView startAnimating];
    
    [_textScrollView setupTextViewWithTextData:_viewModel.content images:_viewModel.images];
    _textScrollView.textView.delegate = self;
    _textScrollView.textView.title = _article.title;
    _textScrollView.textView.source = _article.sourceName;
    _textScrollView.textView.pubData = [TimeFormatterTransform transformCSTTimeToDateStringFromString:_article.publishDate];
    [_textScrollView.textView reloadData];
    
}
# pragma  mark - MonActivityView
- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index {
    return [UIColor orangeColor];
}
#pragma mark - text delegate
- (void)reloadComplishOnTeleTextView:(WYTeleTextView *)textView {
    [_activityView stopAnimating];
}
#pragma mark - tool bar button action
- (IBAction)returnButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)collectionButtonAction:(id)sender {
}

- (IBAction)shareButtonAction:(id)sender {
}
- (IBAction)htmlButtonAction:(id)sender {
    
    NewsRecourceViewController *cc = [NewsRecourceViewController create];
    cc.webAddress = _article.link;
    [self.navigationController pushViewController:cc animated:YES];
}
- (IBAction)settingButtonAction:(id)sender {
    
    [_settingView show];
//    _textScrollView.textView.fontSize = WYTeleTextViewFontSizeLarge;
//    [_textScrollView.textView reloadData];
}

#pragma mark - setting view delegate
- (void)settingViewDidChangeFontArrtibute:(LCArticleContentSettingView *)view {
    if (view == _settingView) {
        [_textScrollView.textView reloadData];
    }
}
@end
