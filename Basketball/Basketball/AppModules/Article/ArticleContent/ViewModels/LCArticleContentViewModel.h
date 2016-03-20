//
//  LCArticleContentViewModel.h
//  LazyCat
//
//  Created by yingwang on 16/3/11.
//  Copyright © 2016年 yingwang. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class LCArticleContentViewModel;
@protocol LCArticleContentViewModelDelegate <NSObject>

- (void)articleContentViewModel:(LCArticleContentViewModel *)model didLoadDataFinishWithError:(NSError *)error;

@end
@interface LCArticleContentViewModel : BBNetworkApiManager

@property (nonatomic, strong) WYFeedEntity *article;
@property (nonatomic, strong) WYFeed *feed;
@property (nonatomic, readonly) NSArray *images;
@property (nonatomic, readonly) NSData *content;
@property (nonatomic, weak) id<LCArticleContentViewModelDelegate> delegate;

- (void)reloadData;

@end
