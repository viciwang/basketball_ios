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
@property (nonatomic, strong) NSDateFormatter *formatter;
@end

@implementation BBShareViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pShareArray = [NSMutableArray array];
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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
              share.publicDate = [_formatter dateFromString:dicArray[idx][@"publicDate"]];
              share.nickName = dicArray[idx][@"nickName"];
              share.locationName = dicArray[idx][@"locationName"];
              share.isUserShare = dicArray[idx][@"isUserShare"];
              share.isApprove = dicArray[idx][@"isApprove"];
              share.headImageUrl = dicArray[idx][@"headImageUrl"];
              share.approveCount = @([dicArray[idx][@"approveCount"] integerValue]);
              share.commentCount = @([dicArray[idx][@"commentCount"] integerValue]);
              share.content = dicArray[idx][@"content"];
              share.imageDictionary = dicArray[idx][@"images"];
          }
          _pShareArray = [NSMutableArray array];
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

- (void)approveForShareId:(NSString *)shareId deApprove:(BOOL)deApprove {
    
    
    NSString *publicDate = [_formatter stringFromDate:[NSDate date]];
    NSDictionary *postDictionary = @{@"shareId":shareId,
                                     @"publicDate":publicDate
                                     };
    [self POST:deApprove?kApiDeApproveShare:kApiApproveShare parameters:postDictionary progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary *responseDictionary = responseObject[@"data"];
           if ([_delegate respondsToSelector:@selector(viewModel:didApproveShareFinishStatus:approveCount:error:)]) {
               [_delegate viewModel:self
        didApproveShareFinishStatus:[responseDictionary[@"isApprove"] boolValue]
                       approveCount:[responseDictionary[@"approveCount"] integerValue]
                              error:nil];
           }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([_delegate respondsToSelector:@selector(viewModel:didApproveShareFinishStatus:approveCount:error:)]){
            [_delegate viewModel:self
     didApproveShareFinishStatus:0
                    approveCount:0
                           error:error];
        }
    }];
}



@end
