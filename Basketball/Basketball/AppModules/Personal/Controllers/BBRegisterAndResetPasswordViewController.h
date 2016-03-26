//
//  BBRegisterViewController.h
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBBaseViewController.h"

typedef NS_ENUM(NSUInteger, BBRegisterAndResetPasswordViewControllerType) {
    BBRegisterAndResetPasswordViewControllerTypeRegister,
    BBRegisterAndResetPasswordViewControllerTypeResetPassword
};

@interface BBRegisterAndResetPasswordViewController : BBBaseViewController

+ (BBRegisterAndResetPasswordViewController *)createWithType:(BBRegisterAndResetPasswordViewControllerType)type;

@end
