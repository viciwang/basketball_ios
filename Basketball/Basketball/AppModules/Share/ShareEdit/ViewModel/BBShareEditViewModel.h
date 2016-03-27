//
//  BBShareEditViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"

@class BBShareEditViewModel;
@protocol BBShareEditViewModelDelegate <NSObject>

- (void)viewModel:(BBShareEditViewModel *)viewModel didUploadDataFinish:(NSError *)error;
@end

@interface BBShareEditViewModel : BBNetworkApiManager
@property (nonatomic, weak) id<BBShareEditViewModelDelegate> delegate;
- (void)uploadShareContent:(NSString *)contentText images:(NSArray *)images;
@end
