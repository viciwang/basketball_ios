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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.headImageCell addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.nickNameCell addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.cityCell addGestureRecognizer:tap];
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
        else {
            
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
        }
    }];
}

@end
