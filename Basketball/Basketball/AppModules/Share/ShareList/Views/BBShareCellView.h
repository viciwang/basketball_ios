//
//  BBShareCellView.h
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYShare;
@class BBShareCellView;
@protocol BBShareCellViewDelegate  <NSObject>

- (void)shareCellView:(BBShareCellView *)cellView didTouchCommentForShare:(WYShare *)shareEnt;
- (void)shareCellView:(BBShareCellView *)cellView didTouchApproveForShare:(WYShare *)shareEnt;

@end

@interface BBShareCellView : UIView
@property (nonatomic, strong) WYShare *shareEntity;
@property (nonatomic, weak) id<BBShareCellViewDelegate> delegate;
@end
