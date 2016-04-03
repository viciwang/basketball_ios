//
//  AppDelegate.m
//  Basketball
//
//  Created by Allen on 2/29/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "AppDelegate.h"
#import "BBTabBarController.h"
#import "FLEXManager.h"
#import "BBDatabaseManager.h"
#import "BBNetworkApiManager.h"
#import "BBNavigationController.h"
#import "BBLoginViewController.h"
#import "BBAppearance.h"
#import "BBStepCountingManager.h"

@interface AppDelegate ()

@end

#ifdef DEBUG
const int ddLogLevel = DDLogLevelVerbose;
#else
const int ddLogLevel = DDLogLevelWarning;
#endif

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *controller = nil;
    if (![BBUser currentUser]) {
        controller = [[BBNavigationController alloc]initWithRootViewController:[BBLoginViewController create]];
    }
    else {
        controller = [BBTabBarController new];
    }
    
    // 初始化页面
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
    // debug
#if DEBUG
    NSLog(@"当前用户：\n%@",[BBUser currentUser]);
    [self configFLEX];
    [self configCocoaLumberjack];
    [self configBaseUrl];
#endif
    
    [self addNotificationObsever];
    [self setupUI];
    
    // 计步
    [[BBStepCountingManager sharedManager] start];
    
    return YES;
}

#pragma mark - notification

- (void)addNotificationObsever {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenDidExpired) name:kBBNotificationTokenExpired object:nil];
    
}

- (void)tokenDidExpired {
    [BBLoginViewController showLoginViewControllerWithCompletionBlock:^{
        
    }];
}

#pragma mark - UI

- (void)setupUI {
    [BBAppearance configAppearance];
}

#pragma mark - debug

- (void)configFLEX {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    gesture.numberOfTouchesRequired = 2;
    gesture.numberOfTapsRequired = 2;
    [self.window addGestureRecognizer:gesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        [[FLEXManager sharedManager] showExplorer];
    }
}

- (void)configCocoaLumberjack {
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
}

- (void)configBaseUrl {
    NSString *baseurl = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DebugBaseUrl"];
    if(baseurl) {
        NSLog(@"设置baseurl为：%@",baseurl);
        [BBNetworkApiManager configDebugBaseUrl:baseurl];
    }
}

@end
