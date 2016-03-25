//
//  BBTabBarController.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBTabBarController.h"
#import "BBNetworkApiManager.h"
#import "BBStepCountingMainViewController.h"
#import "BBGamesScoreViewController.h"
#import "BBArticleListViewController.h"
#import "BBPersonalCenterViewController.h"

@interface BBTabBarController ()

@property (nonatomic, strong) BBGamesScoreViewController *gamesScoreViewController;

@end

@implementation BBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithRed:1/255.0 green:146/255.0 blue:201/255.0 alpha:1];
    self.tabBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(segueForArticleView:) name:@"KKKSSS" object:nil];
    [self setupChildViewControllers];
}

- (void)segueForArticleView:(NSNotification *)notification {
    [self.navigationController pushViewController:notification.object animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup SubViewController

- (void)setupChildViewControllers {
    
    _gamesScoreViewController = [BBGamesScoreViewController create];
    
    [self addChildViewController:_gamesScoreViewController title:@"比分" defaultImage:[UIImage imageNamed:@"gameScore_normal"]
                   selectedImage:[UIImage imageNamed:@"gameScore_selected"]];
    [self addChildViewController:[BBArticleListViewController create] title:@"新闻" defaultImage:[UIImage imageNamed:@"article_normal"]
                   selectedImage:[UIImage imageNamed:@"article_selected"]];
    [self addChildViewController:[BBStepCountingMainViewController new] title:@"分享" defaultImage:[UIImage imageNamed:@"share_normal"]
                   selectedImage:[UIImage imageNamed:@"share_selected"]];
    [self addChildViewController:[BBPersonalCenterViewController new] title:@"个人" defaultImage:[UIImage imageNamed:@"user_normal"]
                   selectedImage:[UIImage imageNamed:@"user_selected"]];
}

- (void)addChildViewController:(UIViewController *)childController
                         title:(NSString *)title
                  defaultImage:(UIImage *)defaultImage
                 selectedImage:(UIImage *)selectedImage {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                      image:[defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    BBNavigationController *childNav = [[BBNavigationController alloc]initWithRootViewController:childController];
    childNav.navigationBar.translucent = YES;
    [childNav.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:1/255.0 green:146/255.0 blue:201/255.0 alpha:1]];
    childNav.tabBarItem = item;
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    NSDictionary *attri = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    childNav.navigationBar.titleTextAttributes = attri;
    [self addChildViewController:childNav];
    // 设置title
    childController.title = title;
}

@end
