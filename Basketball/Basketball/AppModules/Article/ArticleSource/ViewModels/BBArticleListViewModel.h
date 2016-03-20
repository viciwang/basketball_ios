//
//  BBArticleListViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/20.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class BBArticleListViewModel;
@protocol BBArticleListViewModelDelegate <NSObject>

- (void)viewModel:(BBArticleListViewModel *)viewModel didLoadDataFinish:(NSError *)error;

@end
@interface BBArticleListViewModel : BBNetworkApiManager

@property (nonatomic, weak) id<BBArticleListViewModelDelegate> delegate;
@property (nonatomic, strong) NSArray *feeds;

- (void)loadData;

@end
