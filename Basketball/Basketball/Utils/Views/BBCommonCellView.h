//
//  BBCommonCellView.h
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBCommonCellView : UIView

@property (nonatomic, strong) IBInspectable UIImage *leftImage;
@property (nonatomic, copy) IBInspectable NSString *leftImageString;
@property (nonatomic, copy) IBInspectable NSString *leftLabelText;
@property (nonatomic, copy) IBInspectable NSString *rightLabelText;
@property (nonatomic, strong) IBInspectable UIImage *rightImage;
@property (nonatomic, copy) IBInspectable NSString *rightImageString;
@property (nonatomic, assign) IBInspectable BOOL shouldShowdisclosureIndicator;
@property (nonatomic, assign) IBInspectable BOOL shouldShowTopLine;
@property (nonatomic, assign) IBInspectable CGFloat topLineLeftSpace;
@property (nonatomic, assign) IBInspectable CGFloat topLineRightSpace;
@property (nonatomic, assign) IBInspectable BOOL shouldShowBottomLine;
@property (nonatomic, assign) IBInspectable CGFloat bottomLineLeftSpace;
@property (nonatomic, assign) IBInspectable CGFloat bottomLineRightSpace;
//@property (nonatomic, assign) 
//@property (nonatomic, copy) IBInspectable NSString *rightLabelText;

@end
