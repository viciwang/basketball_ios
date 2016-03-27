//
//  BBImageLayoutView.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBImageLayoutView.h"

@interface BBImageLayoutView ()

@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation BBImageLayoutView

- (void)layoutImageView {
    
    static NSArray * DefaultLayouts;
    if (!DefaultLayouts) {
        DefaultLayouts = @[@[@(1)],
                           @[@(1),@(1)],
                           @[@(1),@(2)],
                           @[@(2),@(2)],
                           @[@(2),@(3)],
                           @[@(3),@(3)],
                           @[@(2),@(3),@(2)],
                           @[@(2),@(3),@(3)],
                           @[@(3),@(3),@(3)],
                           ];
    }
    
    if (_images.count == 0) {
        return;
    }
    
    for (UIImageView *imgView in _imageViews) {
        imgView.hidden = YES;
    }
    
    NSArray *cols = DefaultLayouts[_images.count-1];
    if (!_imageViews) {
        _imageViews = [NSMutableArray arrayWithCapacity:9];
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    
    CGFloat w, h;
    w = viewWidth/cols.count;
    NSInteger idx = 0;
    for (NSInteger c = 0; c < cols.count; ++c) {
        h = viewHeight/[cols[c] integerValue];
        for (NSInteger r = 0; r < [cols[c] integerValue]; ++r) {
            CGRect frame = CGRectMake(c*w, r*h, w, h);
            UIImageView *imgView;
            if (idx <_imageViews.count) {
                imgView = _imageViews[idx];
                [imgView setFrame:frame];
                imgView.hidden = NO;
            } else {
                imgView = [[UIImageView alloc] initWithFrame:frame];
                [self addSubview:imgView];
                [_imageViews addObject:imgView];
            }
            ++idx;
        }
    }
    
    idx = 0;
    for (UIImageView *imgView in _imageViews) {
        if (idx >= _images.count) {
            break;
        }
        [imgView sd_setImageWithURL:[NSURL URLWithString:_images[idx++]]];
    }
}

@end
