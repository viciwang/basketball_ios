//
//  StatusBarAttentions.h
//  MicroReader
//
//  Created by FreedomKing on 14/12/17.
//  Copyright (c) 2014年 RR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRSBAttentionsWindow : UIWindow
@end
@interface FRSBAttention : NSObject
@end
typedef NS_ENUM(NSInteger, FRSBAttentionType){
    kFRSBAttentionTypeCollectSuccess,
    kFRSBAttentionTypeCollectFailure,
    kFRSBAttentionTypeAddSucces,
    kFRSBAttentionTypeAddFailure,
    kFRSBAttentionTypeDeleteSuccessed,
    kFRSBAttentionTypeDeleteFailure,
    kFRSBAttentionTypeDownloadSuccessed,
    kFRSBAttentionTypeDownloadFailure,
    kFRSBAttentionTypeSynChronizedSuccessed,
    kFRSBAttentionTypeSynChronizedFailure,
    kFRSBAttentionTypeSaveSuccessed,
    kFRSBAttentionTypeSaveFailure
};
typedef NS_ENUM(NSInteger, FRSBAttentionAnimationType){
    kFRSBAttentionAnimationTypeSpring,
    kFRSBAttentionAnimationTypeVelocity,
    kFRSBAttentionAnimationTypeAlpha
};


@interface FRSBAttentionManager : NSObject

@property (nonatomic) BOOL isShowing;

@property (nonatomic) FRSBAttentionsWindow *basicWindow;

@property (nonatomic) FRSBAttention *attention;

+(void)showBarAttentionWithType:(FRSBAttentionAnimationType)type
                       withText:(NSString *)text
               withProcessBlock:(void(^)(void))processBlock
                 byCompletetion:(void(^)(void))completetionBlock;

+(FRSBAttentionsWindow *)getwindow;
@end