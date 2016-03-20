//
//  UIWindow+Utils.m
//  Basketball
//
//  Created by Allen on 3/20/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "UIWindow+Utils.h"

@implementation UIWindow(Utils)

- (void)bb_checkoutRootViewController:(UIViewController *)viewcontroller {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = viewcontroller;
    
    CATransition *transition = [CATransition animation];
    transition.type = @"fade";
    transition.subtype = kCATransitionFromLeft;
    [window.layer addAnimation:transition forKey:nil];
}

@end
