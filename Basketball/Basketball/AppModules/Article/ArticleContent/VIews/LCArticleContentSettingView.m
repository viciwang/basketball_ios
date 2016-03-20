//
//  LCArticleContentSettingView.m
//  LazyCat
//
//  Created by yingwang on 16/3/14.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "LCArticleContentSettingView.h"
#import "WYTeleTextView.h"

#define kMainNewsViewFontSizePara  @"kMainNewsViewFontSizePara"
#define NEWS_FONT_STYTLE @"NEWS_FONT_STYTLE"

@interface LCArticleContentSettingView () 

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIView *settingView;

@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fontStyleSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *fontSizeSegment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewMinY;

@end

@implementation LCArticleContentSettingView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    //_mainViewMinY.constant = CGRectGetHeight(_shadowView.frame);
    //self.hidden = YES;
    //_shadowView.alpha = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap2];
    [_shadowView addGestureRecognizer:tap];
    
    WYTeleTextViewFontSize size = [[[NSUserDefaults standardUserDefaults] objectForKey:kMainNewsViewFontSizePara] integerValue];
    NSString *fontStyle = [[NSUserDefaults standardUserDefaults] objectForKey:NEWS_FONT_STYTLE];
    NSInteger styleIdx = 0;
    if ([fontStyle isEqualToString:WYTeleTextViewSongFontType]) {
        styleIdx = 1;
    } else if([fontStyle isEqualToString:WYTeleTextViewKaiFontType]) {
        styleIdx = 2;
    }
    
    NSInteger sizeIdx = 1;
    switch (size) {
        case WYTeleTextViewFontSizeSmall:
            sizeIdx = 0;
            break;
        case WYTeleTextViewFontSizeLarge:
            sizeIdx = 2;
            break;
        default:
            break;
    }
    
    _fontSizeSegment.selectedSegmentIndex = sizeIdx;
    _fontStyleSegment.selectedSegmentIndex = styleIdx;
    _slider.value = [UIScreen mainScreen].brightness;
    
    [_fontSizeSegment addTarget:self action:@selector(fontSizeChange:) forControlEvents:UIControlEventValueChanged];
    [_fontStyleSegment addTarget:self action:@selector(fontStyleChange:) forControlEvents:UIControlEventValueChanged];
    [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderChange:(UISlider *)slider {
    if(slider){
        [UIScreen mainScreen].brightness = slider.value;
    }
}

- (void)notifyDelegate {
    if (_delegate && [_delegate respondsToSelector:@selector(settingViewDidChangeFontArrtibute:)]) {
        [_delegate settingViewDidChangeFontArrtibute:self];
    }
}

- (void)fontSizeChange:(UISegmentedControl *)seg {
    if(seg){
        
        
        CGFloat fontSizePara;
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                fontSizePara = WYTeleTextViewFontSizeSmall;
                break;
            case 1:
                fontSizePara = WYTeleTextViewFontSizeMiddle;
                break;
            case 2:
                fontSizePara = WYTeleTextViewFontSizeLarge;
                break;
            default:
                break;
        }
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:fontSizePara] forKey:kMainNewsViewFontSizePara];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self hide];
        [self notifyDelegate];
    }
}

- (void)fontStyleChange:(UISegmentedControl *)seg {
    if(seg){
        
        
        NSString *fontStylePara;
        
        switch (seg.selectedSegmentIndex) {
            case 0:
                fontStylePara = [WYTeleTextViewMSYHFontType copy];
                break;
            case 1:
                fontStylePara = [WYTeleTextViewSongFontType copy];
                break;
            case 2:
                fontStylePara = [WYTeleTextViewKaiFontType copy];
                break;
            default:
                break;
        }
        [[NSUserDefaults standardUserDefaults] setObject:fontStylePara forKey:NEWS_FONT_STYTLE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self hide];
        [self notifyDelegate];
    }
}

- (void)show {
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        _shadowView.alpha = 0.5;
        _mainViewMinY.constant = CGRectGetHeight(_shadowView.frame)-CGRectGetHeight(_settingView.frame);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } ];
}
- (void)hide {
    [UIView animateWithDuration:0.5 animations:^{
        _mainViewMinY.constant = CGRectGetHeight(_shadowView.frame)+40;
        _shadowView.alpha = 0;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
