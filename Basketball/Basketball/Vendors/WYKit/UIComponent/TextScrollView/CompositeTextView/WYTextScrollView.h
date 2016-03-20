//
//  WYTextScrollView.h
//  LazyCat
//
//  Created by yingwang on 16/3/11.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYTeleTextView.h"

@interface WYTextScrollView : UIScrollView

@property (nonatomic, strong) WYTeleTextView *textView;

- (void)setupTextViewWithTextData:(NSData *)textData images:(NSArray *)images;

@end
