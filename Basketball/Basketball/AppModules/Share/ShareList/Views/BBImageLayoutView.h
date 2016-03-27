//
//  BBImageLayoutView.h
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBImageLayoutView;
@protocol BBImageLayoutViewDelegate <NSObject>

- (void)imageLayoutView:(BBImageLayoutView *)layoutView didLayoutFinish:(CGFloat)height;

@end
@interface BBImageLayoutView : UIView

@property (nonatomic, weak) id<BBImageLayoutViewDelegate> delegate;
@property (nonatomic, strong) NSArray *images;

@end
