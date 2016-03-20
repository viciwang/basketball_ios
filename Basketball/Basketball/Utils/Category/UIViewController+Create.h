//
//  UIViewController+Create.h
//  wangying
//
//  Created by yingwang on 16/3/7.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(Create)

+ (id)create;

+ (id)createFromXib;

+ (id)createFromStoryboardName:(NSString *)name withIdentifier:(NSString *)identifier;

@end
