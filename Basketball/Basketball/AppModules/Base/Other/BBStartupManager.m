//
//  BBStartupManager.m
//  Basketball
//
//  Created by Allen on 4/22/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBStartupManager.h"
#import "BBLoginViewController.h"
#import "BBUser.h"
#import "BBStepCountingManager.h"
#import "BBDatabaseManager.h"

@implementation BBStartupManager

+ (BBStartupManager *)sharedManager
{
    static BBStartupManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [BBStartupManager new];
        [_manager addNotificationObsever];
    });
    return _manager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start
{
    if ([BBUser currentUser]) {
        [[BBDatabaseManager sharedManager] resetCurrentUserDatabase];
        // 计步
        [[BBStepCountingManager sharedManager] start];
    }
}

#pragma mark - notification

- (void)addNotificationObsever
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenDidExpired:) name:kBBNotificationTokenExpired object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:kBBNotificationUserDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:kBBNotificationUserDidLogout object:nil];
}

- (void)tokenDidExpired:(NSNotification *)notification
{
    [BBLoginViewController showLoginViewControllerWithCompletionBlock:^{
        
    }];
}

- (void)userDidLogin:(NSNotification *)notification
{
    [self start];
}

- (void)userDidLogout:(NSNotification *)notification
{
    [[BBStepCountingManager sharedManager] stop];
}
@end
