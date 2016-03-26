//
//  BBAppearance.m
//  Basketball
//
//  Created by Allen on 3/26/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBAppearance.h"
#import <Foundation/Foundation.h>

@interface BBAppearance()

@end

@implementation BBAppearance

+ (void)configAppearance {
    
    // UIBarButtonItem
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]];
    NSDictionary *attrDict = @{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:baseFontOfSize(14)};
    [barButtonItemAppearance setTitleTextAttributes:attrDict forState:UIControlStateNormal];
    barButtonItemAppearance.tintColor = [UIColor whiteColor];
    
    // navigation bar
    UINavigationBar *barAppearance = [UINavigationBar appearance];
    [barAppearance setTintColor:[UIColor whiteColor]];
    barAppearance.backIndicatorImage = [UIImage imageNamed:@"Left Arrow 2"];
    barAppearance.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Left Arrow 2"];
    UIFont *font = [UIFont fontWithName:@"MicrosoftYaHei" size:17];
    NSDictionary *attri = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
    barAppearance.titleTextAttributes = attri;
    barAppearance.barTintColor = baseColor;
    barAppearance.translucent = NO;
}

@end


