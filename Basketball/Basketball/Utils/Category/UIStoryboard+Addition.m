//
//  UIStoryboard+Addition.m
//  wangying
//
//  Created by Ron on 15-12-31.
//  Copyright (c) 2013年 HGG. All rights reserved.
//

#import "UIStoryboard+Addition.h"

@implementation UIStoryboard(Addition)

+ (UIStoryboard*)fromName:(NSString*)name
{
    return [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
}

@end
