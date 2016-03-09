//
//  UIViewController+Create.h
//  wangying
//
//  Created by Ron on 16-2-24.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(Create)

+ (id)create;

+ (id)createFromXib;

+ (id)createFromStoryboardName:(NSString *)name withIdentifier:(NSString *)identifier;

@end
