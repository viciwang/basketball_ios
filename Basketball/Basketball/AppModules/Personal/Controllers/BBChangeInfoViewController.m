//
//  BBChangeInfoViewController.m
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBChangeInfoViewController.h"
#import "BBCommonCellView.h"
#import "BBUser.h"
#import "BBNetworkApiManager.h"
#import "MBProgressHUD.h"
#import "NYXImagesKit.h"
#import "BBPersonalInfoEditViewController.h"

@interface BBChangeInfoViewController ()
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet BBCommonCellView *headImageCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *nickNameCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *cityCell;
@property (weak, nonatomic) IBOutlet BBCommonCellView *descriptionCell;

@end

@implementation BBChangeInfoViewController

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
    [self fillData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillData {
    BBUser *user = [BBUser currentUser];
    @weakify(self);
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:user.headImageUrl] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                @strongify(self);
                CGRect rect = CGRectMake(0, 0, 30, 30);
                UIImage *temImage = [image scaleToFitSize:CGSizeMake(30, 30)];
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, [UIScreen mainScreen].scale);
                [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)*0.5] addClip];
                [temImage drawInRect:rect];
                self.headImageCell.rightImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        });
    }];
    self.nickNameCell.rightLabelText = user.nickName;
    self.cityCell.rightLabelText = user.city;
    self.descriptionCell.rightLabelText = user.personalDescription;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.headImageCell addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.nickNameCell addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.cityCell addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.descriptionCell addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        if (recognizer.view == self.headImageCell) {
            @weakify(self);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.allowsEditing = YES;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
            }];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:action1];
            [alert addAction:action2];
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (recognizer.view == self.descriptionCell) {
            BBPersonalInfoEditViewController *vc = [BBPersonalInfoEditViewController create];
            vc.currentDesc = [BBUser currentUser].personalDescription;
            @weakify(self);
            vc.endEditBlock = ^(NSString *desc) {
                @strongify(self);
                if (![desc isEqualToString:self.descriptionCell.rightLabelText]) {
                    self.descriptionCell.rightLabelText = desc;
                    [self updateInfo];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            BBCommonCellView *cellView = (BBCommonCellView *)recognizer.view;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:cellView.leftLabelText message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = cellView.rightLabelText;
            }];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textField = alert.textFields[0];
                if (![textField.text isEqualToString:cellView.rightLabelText] && textField.text.length>0) {
                    cellView.rightLabelText = textField.text;
                    [self updateInfo];
                }
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:action1];
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self showLoadingHUDWithInfo:nil];
    @weakify(self);
    [[BBNetworkApiManager sharedManager] updateHeadImageUrlWithImage:image completionBlock:^(NSString *imageUrl, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
        }
        else {
            BBUser *user = [BBUser currentUser];
            user.headImageUrl = imageUrl;
            [BBUser setCurrentUser:user];
            [self fillData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBBNotificationUserDidUpdateInfo object:nil];
        }
    }];
}

- (void)updateInfo {
    [self showLoadingHUDWithInfo:nil];
    @weakify(self);
    [[BBNetworkApiManager sharedManager] updateUserInfoWithCity:self.cityCell.rightLabelText
                                                       nickName:self.nickNameCell.rightLabelText
                                            personalDescription:self.descriptionCell.rightLabelText
                                                completionBlock:^(BBUser *user, NSError *error) {
                                                    @strongify(self);
                                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                    if (error) {
                                                        [self showErrorHUDWithInfo:error.userInfo[@"msg"]];
                                                    }
                                                    else {
                                                        [BBUser setCurrentUser:user];
                                                        [self fillData];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:kBBNotificationUserDidUpdateInfo object:nil];
                                                    }
                                                }];
}

@end
