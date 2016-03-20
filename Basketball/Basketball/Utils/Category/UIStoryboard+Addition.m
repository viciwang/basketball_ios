//
//  UIStoryboard+Addition.m
//  Basketball
//
//  Created by yingwang on 16/3/7.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "UIStoryboard+Addition.h"

@implementation UIStoryboard(Addition)

+ (UIStoryboard*)fromName:(NSString*)name
{
    return [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
}

@end
