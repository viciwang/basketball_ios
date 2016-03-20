//
//  BBArticleListViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/20.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBArticleListViewModel.h"


@interface BBArticleListViewModel()



@end

@implementation BBArticleListViewModel

- (void)loadData {
    
    if (NO) {
        _feeds = [[WYFeedManager shareManager].store fetchFeeds];
        if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
            [_delegate viewModel:self didLoadDataFinish:nil];
        }
    } else {
        [self GET:kArticleSourceAddress
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSInteger code = [responseObject[@"code"] integerValue];
              if (code!=200) {
                  _feeds = [[WYFeedManager shareManager].store fetchFeeds];
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
                          [_delegate viewModel:self didLoadDataFinish:nil];
                      }
                  });
                  return ;
              }
              NSArray *articles = responseObject[@"data"];
              NSArray *feeds = [[WYFeedManager shareManager].store numbersOfTemporaryFeed:articles.count];
              [articles enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  WYFeed *feed = feeds[idx];
                  feed.name = obj[@"name"];
                  feed.link = obj[@"link"];
                  feed.imageURL = obj[@"imageURL"];
              }];
              if (feeds.count) {
                  [[WYFeedManager shareManager].store insertFeeds:feeds completion:^(id obj, BOOL success, NSError *error) {
                      
                      _feeds = [[WYFeedManager shareManager].store fetchFeeds];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
                              [_delegate viewModel:self didLoadDataFinish:nil];
                          }
                      });
                  }];
              }
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              _feeds = [[WYFeedManager shareManager].store fetchFeeds];
              dispatch_async(dispatch_get_main_queue(), ^{
                  if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
                      [_delegate viewModel:self didLoadDataFinish:nil];
                  }
              });
          }];
//        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:kLCArticleNotFirstTimeOpen];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSArray *feeds = [[WYFeedManager shareManager].store numbersOfTemporaryFeed:4];
//        WYFeed *feed1 = feeds[0];
//        feed1.name = @"虎扑NBA";
//        feed1.link = @"http://voice.hupu.com/generated/voice/news_nba.xml";
//        WYFeed *feed2 = feeds[1];
//        feed2.name = @"腾讯NBA";
//        feed2.link = @"http://sports.qq.com/basket/nba/nbarep/rss_nbarep.xml";
//        WYFeed *feed3 = feeds[2];
//        feed3.name = @"搜狐NBA";
//        feed3.link = @"http://rss.sports.sohu.com/rss/nba.xml";
//        WYFeed *feed4 = feeds[3];
//        feed4.name = @"FOX NBA";
//        feed4.link = @"http://api.foxsports.com/v1/rss?partnerKey=zBaFxRyGKCfxBagJG9b8pqLyndmvo7UU&tag=nba";
//        [[WYFeedManager shareManager].store insertFeeds:feeds completion:^(id obj, BOOL success, NSError *error) {
//            
//            _feeds = [[WYFeedManager shareManager].store fetchFeeds];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
//                    [_delegate viewModel:self didLoadDataFinish:nil];
//                }
//            });
//        }];
    }
}

@end
