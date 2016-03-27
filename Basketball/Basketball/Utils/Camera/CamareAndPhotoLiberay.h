//
//  CamareAndPhotoLiberay.h
//  MicroReader
//
//  Created by 王颖 on 14/11/1.
//  Copyright (c) 2014年 RR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CamareAndPhotoLiberay : NSObject

+ (BOOL) isCameraAvailable;

+ (BOOL) isFrontCameraAvailable;

+ (BOOL) isRearCameraAvailable;

+ (BOOL) doesCameraSupportShootingVideos;

+ (BOOL) doesCameraSupportTakingPhotos;

+ (BOOL) isPhotoLibraryAvailable;

+ (BOOL) canUserPickVideosFromPhotoLibrary;

+ (BOOL) canUserPickPhotosFromPhotoLibrary;

@end
