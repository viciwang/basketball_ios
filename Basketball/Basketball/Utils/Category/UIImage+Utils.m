//
//  UIImage+Utils.m
//  Basketball
//
//  Created by yingwang on 16/3/20.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage(Utils)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
