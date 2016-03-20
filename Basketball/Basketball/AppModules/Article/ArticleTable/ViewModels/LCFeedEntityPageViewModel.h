//
//  LCFeedEntityPageViewModel.h
//  LazyCat
//
//  Created by yingwang on 16/3/13.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class LCFeedEntityPageViewModel;

@protocol LCFeedEntityPageViewModelDelegate <NSObject>

- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didReloadDataFinish:(NSError *)error;
- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didRefreshDataFinish:(NSError *)error;
- (void)pageViewModel:(LCFeedEntityPageViewModel *)model didLoadMoreDataFinish:(NSError *)error;

@end

@interface LCFeedEntityPageViewModel : BBNetworkApiManager

@property (nonatomic, strong) WYFeed *feed;
@property (nonatomic, readonly) NSArray *models;

@property (nonatomic, readonly) BOOL canSubscribeFeed;

@property (nonatomic, weak) id<LCFeedEntityPageViewModelDelegate> delegate;

- (void)reloadData;
- (void)refreshData;
- (void)loadMoreData;

@end
