//
//  LCArticleSinglePageViewController.h
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCArticleSinglePageViewController;
@protocol LCArticleSinglePageViewControllerDelegate <NSObject>

- (void)returnButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller;
- (void)refreshButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller;
- (void)loadMoreButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller;
- (void)addButtonActionOnSingPageViewController:(LCArticleSinglePageViewController *)controller;
- (void)singlePageViewController:(LCArticleSinglePageViewController *)controller didSelectedCellAtIndex:(NSInteger)index withObject:(id)object;


@end

@interface LCArticleSinglePageViewController : UIViewController

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger lastedPageIndex;
@property (nonatomic, weak) id<LCArticleSinglePageViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) id feed;

@property (nonatomic, assign) BOOL addButtonHidden;

@end
