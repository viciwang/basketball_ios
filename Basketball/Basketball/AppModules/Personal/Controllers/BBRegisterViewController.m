//
//  BBRegisterViewController.m
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBRegisterViewController.h"
#import "BBNetworkApiManager.h"
#import "BBTabBarController.h"
#import "BBUser.h"
#import "UIWindow+Utils.h"

@interface BBRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;

@end

@implementation BBRegisterViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"快速注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction:)];
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
    
    [[BBNetworkApiManager sharedManager] registerWithEmail:self.emailTextField.text password:self.passwordTextField.text verifyCode:self.verifyCodeTextField.text completionBlock:^(BBUser *user, NSError *error) {
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
