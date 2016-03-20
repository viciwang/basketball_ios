//
//  UIViewController+HUD.m
//  Basketball
//
//  Created by Allen on 15/9/14.
//
//

#define HUD_OPACITY 0.8
#define HUD_SHOW_DURING 2.0

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController(HUD)

- (id)showLoadingHUDWithInfo:(NSString *)info {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = info;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = HUD_OPACITY;
    [self.view addSubview:hud];
    [hud show:YES];
    return hud;
}

- (id)showSuccessHUDWithInfo:(NSString *)info {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = info;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hud_success"]];
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = HUD_OPACITY;
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:HUD_SHOW_DURING];
    return hud;
}

- (id)showErrorHUDWithInfo:(NSString *)info {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = info;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = HUD_OPACITY;
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:HUD_SHOW_DURING];
    return hud;
}

- (id)showInfoHUD:(NSString *)info {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = info;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = HUD_OPACITY;
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:HUD_SHOW_DURING];
    return hud;
}

@end