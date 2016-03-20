//
//  WYTextScrollView.m
//  LazyCat
//
//  Created by yingwang on 16/3/11.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "WYTextScrollView.h"

@interface WYTextScrollView () <WYTeleTextViewLayoutDelegate>

@end

@implementation WYTextScrollView


- (void)setupTextViewWithTextData:(NSData *)textData images:(NSArray *)images {
    self.pagingEnabled  = YES;
    //    CGRect bounds = self.bounds;
    //    bounds.origin = CGPointMake(0, 0);
    //    self.bounds = bounds;
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height -= 65;
    rect.origin = CGPointMake(0, -20);
    self.textView = [[WYTeleTextView alloc] initWithFrame:rect textData:textData images:images documentType:NSHTMLTextDocumentType];
    //    NSLog(@"tt %@",NSStringFromCGRect(self.bounds));
    //    NSLog(@"tt %@",NSStringFromCGRect(self.frame));
    self.textView.layoutDelegate = self;
    [self addSubview:self.textView];
    //    self.layer.borderColor = [UIColor redColor].CGColor;
    //    self.layer.borderWidth = 2;
    //    _textView.layer.borderColor = [UIColor blueColor].CGColor;
    //    _textView.layer.borderWidth = 2;
}

#pragma mark - delegate
- (void)teleTextView:(WYTeleTextView *)textView configContentSize:(CGSize)size {
//    CGRect bounds = self.bounds;
//    bounds.origin = CGPointMake(0, 0);
//    self.bounds = bounds;
    size.height = CGRectGetHeight(self.bounds)-20;
//    NSLog(@"w size = %@",NSStringFromCGSize(size));
//    NSLog(@"w bounds = %@",NSStringFromCGRect(self.bounds));
//    NSLog(@"w frame = %@",NSStringFromCGRect(self.frame));
    self.contentSize = size;
}

@end
