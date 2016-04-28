//
//  BBRegisterViewController.m
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBRegisterAndResetPasswordViewController.h"
#import "BBNetworkApiManager.h"
#import "BBTabBarController.h"
#import "BBUser.h"
#import "UIWindow+Utils.h"
#import "NSString+NSHash.h"

@interface BBRegisterAndResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (nonatomic, assign) BBRegisterAndResetPasswordViewControllerType type;

@end

@implementation BBRegisterAndResetPasswordViewController

+ (BBRegisterAndResetPasswordViewController *)createWithType:(BBRegisterAndResetPasswordViewControllerType)type {
    BBRegisterAndResetPasswordViewController *vc = [BBRegisterAndResetPasswordViewController create];
    vc.type = type;
    return vc;
}

#pragma mark - life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSignal];
    [self setupUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ui

- (void)setupUI {
    if (self.type == BBRegisterAndResetPasswordViewControllerTypeRegister) {
        self.title = @"注册";
    }
    else {
        self.title = @"重置密码";
        self.passwordTextField.placeholder = @"新密码";
        [self.registerButton setTitle:@"重置" forState:UIControlStateNormal];
    }
}

#pragma mark - signal

- (void)setupSignal {
    @weakify(self);
    [[RACSignal combineLatest:@[self.emailTextField.rac_textSignal,self.passwordTextField.rac_textSignal,self.verifyCodeTextField.rac_textSignal]]
    subscribeNext:^(id value) {
        @strongify(self);
        if( self.emailTextField.text.length>0 &&
           self.passwordTextField.text.length > 0 &&
           self.verifyCodeTextField.text.length>0) {
            self.registerButton.backgroundColor = baseColor;
            self.registerButton.userInteractionEnabled = YES;
        }
        else {
            self.registerButton.backgroundColor = [UIColor lightGrayColor];
            self.registerButton.userInteractionEnabled = NO;
        }
        if (self.emailTextField.text.length>0) {
            self.verifyCodeButton.backgroundColor = baseColor;
            self.verifyCodeButton.userInteractionEnabled = YES;
        }
        else {
            self.verifyCodeButton.backgroundColor = [UIColor lightGrayColor];
            self.verifyCodeButton.userInteractionEnabled = NO;
        }
    }];
}

#pragma mark - action

- (IBAction)registerAction:(id)sender {
    [self showLoadingHUDWithInfo:nil];
    @weakify(self);
    
    if (self.type == BBRegisterAndResetPasswordViewControllerTypeRegister) {
        [[BBNetworkApiManager sharedManager] registerWithEmail:self.emailTextField.text password:[self.passwordTextField.text MD5] verifyCode:self.verifyCodeTextField.text completionBlock:^(BBUser *user, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
            }
            else {
                [BBUser setCurrentUser:user];
                [[UIApplication sharedApplication].keyWindow bb_checkoutRootViewController:[BBTabBarController new]];
            }
        }];
    }
    else {
        [[BBNetworkApiManager sharedManager] resetPasswordWithEmail:self.emailTextField.text password:[self.passwordTextField.text MD5] verifyCode:self.verifyCodeTextField.text completionBlock:^(BBUser *user, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
            }
            else {
                [self showSuccessHUDWithInfo:@"重置成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kBBNotificationUserDidResetPassword object:nil userInfo:@{@"email":self.emailTextField.text}];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}

- (IBAction)verifyCodeAction:(id)sender {
    [[BBNetworkApiManager sharedManager] getVerifyCodeWithEmail:self.emailTextField.text completionBlock:^(NSString *verifyCode, NSError *error) {
        if (!error) {
            [self showInfoHUD:@"验证码已发送"];
        }
        else {
            [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
        }
    }];
}
@end
