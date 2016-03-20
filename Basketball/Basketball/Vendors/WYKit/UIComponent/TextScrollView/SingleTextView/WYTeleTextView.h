//
//  WYTeleTextView.h
//  WYKitTDemo
//
//  Created by yingwang on 16/3/1.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYTeleTextView;
@protocol WYTeleTextViewLayoutDelegate <NSObject>
- (void)teleTextView:(WYTeleTextView *)textView configContentSize:(CGSize)size;
@end
@protocol WYTeleTextViewDelegate <NSObject>

- (void)reloadComplishOnTeleTextView:(WYTeleTextView *)textView;
@end

typedef NS_ENUM(NSUInteger, WYTeleTextViewFontSize) {
    
    WYTeleTextViewFontSizeSmall,
    WYTeleTextViewFontSizeMiddle,
    WYTeleTextViewFontSizeLarge,
    WYTeleTextViewFontSizeExtraLarge,
    WYTeleTextViewFontSizeExtraSmall
};

FOUNDATION_EXTERN NSString const * WYTeleTextViewMSYHFontType;
FOUNDATION_EXTERN NSString const * WYTeleTextViewSongFontType;
FOUNDATION_EXTERN NSString const * WYTeleTextViewKaiFontType;

@interface WYTeleTextView : UIView
// data
@property (nonatomic, readonly, strong) id text;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *pubData;
@property (nonatomic, strong) NSString *imagePrefix;

// component
@property (nonatomic, weak) NSString *fontType;
@property (nonatomic, assign) WYTeleTextViewFontSize fontSize;

// layout
@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic, assign) CGFloat rightPadding;
@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) CGFloat bottomPadding;

// delegate
@property (nonatomic, weak) id<WYTeleTextViewLayoutDelegate> layoutDelegate;
@property (nonatomic, weak) id<WYTeleTextViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame textData:(NSData *)textData images:(NSArray *)images documentType:(NSString *)docType;

- (void)changeAttribute;
- (void)reloadData;

@end
