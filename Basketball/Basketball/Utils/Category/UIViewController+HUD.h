//
//  UIViewController+HUD.h
//  Basketball
//
//  Created by Allen on 15/9/14.
//
//

#import <Foundation/Foundation.h>

@interface UIViewController(HUD)

- (id)showLoadingHUDWithInfo:(NSString *)info;
- (id)showSuccessHUDWithInfo:(NSString *)info;
- (id)showErrorHUDWithInfo:(NSString *)info;
- (id)showInfoHUD:(NSString *)info;

@end
