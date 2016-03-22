//
//  BBLoginViewController.m
//  Basketball
//
//  Created by Allen on 3/20/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBLoginViewController.h"
#import "RACReturnSignal.h"
#import "BBNetworkApiManager.h"
#import "BBUser.h"
#import "UIWindow+Utils.h"
#import "BBTabBarController.h"

@interface BBLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation BBLoginViewController

+ (void)showLoginViewControllerWithCompletionBlock:(voidBlock)complectionBlock {
    BBLoginViewController *loginVC = [BBLoginViewController create];
    BBNavigationController *nav = [[BBNavigationController alloc] initWithRootViewController:loginVC];
    loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:loginVC action:@selector(dismissLoginVC:)];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:^{
        if (complectionBlock) {
            complectionBlock();
        }
    }];
}

- (void)dismissLoginVC:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"快速注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction:)];
}

#pragma mark - signal

- (void)setupSignal {
    @weakify(self);
    RAC(self.loginButton, enabled) = [[RACSignal combineLatest:@[self.emailTextField.rac_textSignal,self.passwordTextField.rac_textSignal]]
                                      flattenMap:^RACStream *(id value) {
                                          @strongify(self);
                                          BOOL shouldEnable = self.emailTextField.text.length > 0;
                                          shouldEnable = shouldEnable && (self.passwordTextField.text.length > 0);
                                          return [RACReturnSignal return:@(shouldEnable)];
                                      }];
}

#pragma mark - action 

- (IBAction)loginAction:(id)sender {
    [self showLoadingHUDWithInfo:nil];
    @weakify(self);
    [[BBNetworkApiManager sharedManager] loginWithEmail:self.emailTextField.text password:self.passwordTextField.text completionBlock:^(BBUser *user, NSError *error) {
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

- (IBAction)forgetPasswordAction:(id)sender {
    
}

- (void)registerAction:(UIButton *)sender {
    
}
@end
