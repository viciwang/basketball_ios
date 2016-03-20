//
//  LCArticlePageView.h
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCArticlePageView;
@protocol LCArticlePageViewDelegate <NSObject>

- (void)articlePageView:(LCArticlePageView *)pageView didSelectedCellAtIndex:(NSInteger)idx withObject:(id)object;

@end

@interface LCArticlePageView : UIView

@property (nonatomic, weak) id<LCArticlePageViewDelegate> delegate;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) id feed;
@property (nonatomic, assign) NSUInteger pageStyle;

- (void)reloadData;

@end
