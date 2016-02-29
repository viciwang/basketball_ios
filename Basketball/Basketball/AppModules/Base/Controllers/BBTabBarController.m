//
//  BBTabBarController.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBTabBarController.h"

@interface BBTabBarController ()

@end

@implementation BBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildViewControllers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup SubViewController

- (void)setupChildViewControllers {
    UIImage *defaultImage = [UIImage imageNamed:@"icon_default_avatar"];
    UIImage *selectedImage = [UIImage imageNamed:@"icon_great"];
    [self addChildViewController:[BBBaseViewController new] title:@"运动" defaultImage:defaultImage selectedImage:selectedImage];
    [self addChildViewController:[BBBaseViewController new] title:@"运动" defaultImage:defaultImage selectedImage:selectedImage];
    [self addChildViewController:[BBBaseViewController new] title:@"运动" defaultImage:defaultImage selectedImage:selectedImage];
    [self addChildViewController:[BBBaseViewController new] title:@"个人" defaultImage:defaultImage selectedImage:selectedImage];
}

- (void)addChildViewController:(UIViewController *)childController
                         title:(NSString *)title
                  defaultImage:(UIImage *)defaultImage
                 selectedImage:(UIImage *)selectedImage {
    UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                      image:[defaultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    BBNavigationController *childNav = [[BBNavigationController alloc]initWithRootViewController:childController];
    childNav.tabBarItem = item;
    [self addChildViewController:childNav];
    // 设置title
    childController.title = title;
}

@end
