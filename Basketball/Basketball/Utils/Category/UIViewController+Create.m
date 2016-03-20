//
//  UIViewController+Create.m
//  wangying
//
//  Created by yingwang on 16/3/7.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "UIViewController+Create.h"
#import "UIStoryboard+Addition.h"

@implementation UIViewController(Create)

+ (id)create
{
    NSString *className = NSStringFromClass([self class]);
    
    if (TARGETED_DEVICE_IS_IPAD) {
        className = [className stringByAppendingString:@"_iPad"];
    } else {
        className = [className stringByAppendingString:@"_iPhone"];
    }
    
    id newObj = [[UIStoryboard fromName:className] instantiateInitialViewController];
    return newObj;
}
+ (id)createFromXib
{
    NSString *xibName = NSStringFromClass([self class]);
    
    if (TARGETED_DEVICE_IS_IPAD) {
        xibName = [xibName stringByAppendingString:@"_iPad"];
    } else {
        xibName = [xibName stringByAppendingString:@"_iPhone"];
    }
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] firstObject];
}

+ (id)createFromStoryboardName:(NSString *)name withIdentifier:(NSString *)identifier;
{
    if (name && identifier) {
        UIStoryboard *storyboard = [UIStoryboard fromName:name];
        
        return [storyboard instantiateViewControllerWithIdentifier:identifier];
        
    }
    return nil;
}

@end
