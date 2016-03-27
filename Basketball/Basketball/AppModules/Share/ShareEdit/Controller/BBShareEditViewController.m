//
//  BBShareEditViewController.m
//  Basketball
//
//  Created by yingwang on 16/3/24.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBShareEditViewController.h"
#import "CamareAndPhotoLiberay.h"
#import "BBShareEditViewImageCell.h"
#import "BBShareEditViewModel.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface BBShareEditViewController () < UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
// view model
@property (nonatomic, strong) BBShareEditViewModel *viewModel;
// camera
@property (nonatomic, strong) UIImagePickerController *controllerAlbum;
@property (nonatomic, strong) UIImagePickerController *controllerCamera;
//data
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation BBShareEditViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    _viewModel = [[BBShareEditViewModel alloc] init];
    [_viewModel uploadShareContent:@"fjhdkjfhksdhfkjdsgkgshgjk" images:nil];
    
    _images = [NSMutableArray arrayWithCapacity:9];
    _controllerAlbum = [[UIImagePickerController alloc]init];
    _controllerCamera = [[UIImagePickerController alloc]init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView.collectionViewLayout = layout;
    [_collectionView reloadData];
    [self selectPickRigion];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)donButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(shareEditViewController:endEditingText:images:)]) {
        [_delegate shareEditViewController:self endEditingText:_contentTextView.text images:nil];
    }
}
#pragma mark - table view datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat colCellWidth = (CGRectGetWidth(self.view.bounds)-50)/5;
    CGFloat cellHeight = 115 + (_images.count>4?(2*colCellWidth+5):colCellWidth);
    return cellHeight;
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    return cell;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
// collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count+1;
}

#pragma mark cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"imageCell";
    BBShareEditViewImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row < _images.count) {
        cell.imageView.image = _images[indexPath.row];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"share_edit_add_image"];
    }
    
    return cell;
}

#pragma mark cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWidth = (CGRectGetWidth(self.view.bounds)-50)/5;
    CGFloat cellHeight = cellWidth;
    return CGSizeMake(cellWidth,cellHeight);
}
#pragma mark - collectionview select item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _images.count) {
        if (_images.count == 9) {//不能超过9张图片
            UIAlertController *alc = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能超过9张图片" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alc addAction:actionConfirm];
            [self presentViewController:alc animated:YES completion:nil];
        } else {
            [self selectPickRigion];
        }
    }
}
#pragma mark - photo setting and camare delegate

- (void)selectPickRigion {
    
    NSLog(@"pick");
    
    NSInteger type;
    
    type = 1;
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self ClickControlAction:type];
    }];
    [alert addAction:actionCamera];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self ClickShowPhotoAction:type];
    }];
    [alert addAction:actionAlbum];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)ClickShowPhotoAction:(NSInteger)type {
    
    NSLog(@"tapimage");
    if ([CamareAndPhotoLiberay isPhotoLibraryAvailable])
    {
        UIImagePickerController *controller;
        
        if(type==1)
            controller = _controllerCamera;
        else
            controller = _controllerAlbum;
        controller.allowsEditing=YES;
        [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];// 设置类型
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        if ([CamareAndPhotoLiberay canUserPickPhotosFromPhotoLibrary]){
            [mediaTypes addObject:( NSString *)kUTTypeImage];
        }
        
        [controller setMediaTypes:mediaTypes];
        [controller setDelegate:self];// 设置代理
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
- (void)ClickControlAction:(NSInteger)type{
    // 判断有摄像头，并且支持拍照功能
    if ([CamareAndPhotoLiberay isCameraAvailable] && [CamareAndPhotoLiberay doesCameraSupportTakingPhotos]){
        // 初始化图片选择控制器
        UIImagePickerController *controller;
        if(type==1)
            controller = _controllerCamera;
        else
            controller = _controllerAlbum;
        [controller setSourceType:UIImagePickerControllerSourceTypeCamera];// 设置类型
        
        
        // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType, nil];
        [controller setMediaTypes:arrMediaTypes];
        
        [controller setAllowsEditing:YES];// 设置是否可以管理已经存在的图片或者视频
        [controller setDelegate:self];// 设置代理
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    } else {
        NSLog(@"Camera is not available.");
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [_images addObject:image];
    [self.tableView reloadData];
    [_collectionView reloadData];
}
@end
