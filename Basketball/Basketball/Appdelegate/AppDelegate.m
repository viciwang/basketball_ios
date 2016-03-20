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
    [self configFLEX];
    [self configCocoaLumberjack];
#endif
    
    return YES;
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

@end
