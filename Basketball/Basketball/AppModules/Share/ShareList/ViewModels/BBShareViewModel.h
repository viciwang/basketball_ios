//
//  BBShareViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class BBShareViewModel;
@protocol BBShareViewModelDelegate <NSObject>

- (void)viewModel:(BBShareViewModel *)viewModel didLoadDataFinish:(NSError *)error;
- (void)viewModel:(BBShareViewModel *)viewModel didApproveShareFinishStatus:(BOOL)isUserApprove approveCount:(NSInteger)aprCount error:(NSError *)error;
@end
@interface BBShareViewModel : BBNetworkApiManager

@property (nonatomic, weak) id<BBShareViewModelDelegate> delegate;
@property (nonatomic, readonly) NSArray *shareArray;

- (void)loadData;
+ (void)approveForShareId:(NSString *)shareId deApprove:(BOOL)deApprove;
@end
