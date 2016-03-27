//
//  BBShareViewModel.m
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareViewModel.h"
#import "WYStore+WYShare.h"
#import "WYShare.h"
#import "WYFeedManager.h"

@interface BBShareViewModel ()

@property (nonatomic, strong) NSMutableArray *pShareArray;

@end

@implementation BBShareViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pShareArray = [NSMutableArray array];
    }
    return self;
}
- (NSArray *)shareArray {
    return _pShareArray;
}
- (void)loadData {
    
    [self GET:kApiGetShare parameters:@{@"pageIdx":@(0),@"pageSize":@(20)} progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSArray *dicArray = responseObject[@"data"];
          NSArray *tmpShareEnt = [[WYFeedManager shareManager].store numbersOfTemporaryShareEntity:dicArray.count];
          for (NSInteger idx = 0; idx < dicArray.count; ++idx) {
              WYShare *share = tmpShareEnt[idx];
              share.shareId = dicArray[idx][@"shareId"];
              share.userId = dicArray[idx][@"userId"];
              share.publicDate = [NSDate date];//[idx][@"publicDate"];
              share.nickName = dicArray[idx][@"nickName"];
              share.locationName = dicArray[idx][@"locationName"];
              share.isUserShare = dicArray[idx][@"isUserShare"];
              share.isApprove = dicArray[idx][@"isApprove"];
              share.headImageUrl = dicArray[idx][@"headImageUrl"];
              share.approveCount = @(0);//dicArray[idx][@"approveCount"];
              share.commentCount = @(0);//dicArray[idx][@"commentCount"];
              share.content = dicArray[idx][@"content"];
              share.imageDictionary = dicArray[idx][@"images"];
          }
          [_pShareArray addObjectsFromArray:tmpShareEnt];
          if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
              [_delegate viewModel:self didLoadDataFinish:nil];
          }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if ([_delegate respondsToSelector:@selector(viewModel:didLoadDataFinish:)]) {
              [_delegate viewModel:self didLoadDataFinish:error];
          }
      }];
}

@end
