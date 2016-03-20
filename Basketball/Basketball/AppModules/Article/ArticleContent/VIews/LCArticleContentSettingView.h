//
//  LCArticleContentSettingView.h
//  LazyCat
//
//  Created by yingwang on 16/3/14.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCArticleContentSettingView;
@protocol LCArticleContentSettingViewDelegate <NSObject>

- (void)settingViewDidChangeFontArrtibute:(LCArticleContentSettingView *)view;

@end

@interface LCArticleContentSettingView : UIView

@property (weak, nonatomic) id<LCArticleContentSettingViewDelegate> delegate;

- (void)show;
- (void)hide;
@end
