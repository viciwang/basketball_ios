//
//  BBShareContentViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/28.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class WYShare;
@class BBShareContentViewModel;

@protocol BBShareContentViewModelDelegate <NSObject>

- (void)viewModel:(BBShareContentViewModel *)viewModel getShareCommentFinish:(NSError *)error;
- (void)viewModel:(BBShareContentViewModel *)viewModel addShareCommentFinish:(NSError *)error;

@end

@interface BBShareContentViewModel : BBNetworkApiManager

@property (nonatomic, strong) WYShare *shareEntity;
@property (nonatomic, readonly) NSArray *commentArray;
@property (nonatomic, weak) id<BBShareContentViewModelDelegate> delegate;

- (void)loadCommentData;
- (void)addComment:(NSString *)content replyUserId:(NSString *)replyUserId userName:(NSString *)userName;
@end
