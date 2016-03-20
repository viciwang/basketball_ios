//
//  UINavigationBar+Adition.m
//  MicroReader
//
//  Created by yingwang on 15/6/3.
//  Copyright (c) 2015年 RR. All rights reserved.
//

#import "UINavigationBar+Addition.h"
#import <objc/runtime.h>

@implementation UINavigationBar(Addition)

static char overlayKey;

- (UIView *)overlay {
    return objc_getAssociatedObject(self,&overlayKey);
}
- (void)setOverlay:(UIView *)overlay {
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)color {
    
    if(!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.overlay = [[UIView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = color;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
