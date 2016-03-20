//
//  StatusBarAttentions.m
//  MicroReader
//
//  Created by FreedomKing on 14/12/17.
//  Copyright (c) 2014年 RR. All rights reserved.
//

#import "StatusBarAttentions.h"

@interface FRSBAttentionsWindow ()
@property (nonatomic) UILabel *titleLabel;
-(id)initWithFrame:(CGRect)frame;
@end

@implementation FRSBAttentionsWindow
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
//    for (UIView *subview in self.subviews) {
//        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
//            return YES;
//        }
//    }
//    return NO;
//}
@end

//static NSString    *kCollectionSuccessedString = @"收藏成功...";
//static NSString    *kCollectionFailureString = @"收藏失败...";
//static NSString    *kDeleteFailureString = @"删除失败...";
//static NSString    *kDeleteSuccessedString = @"删除成功...";
//static NSString    *kAddNewsFailureString = @"添加失败...";
//static NSString    *kAddNewsSuccessedString = @"添加成功...";
//static NSString    *kDownloadFailureString = @"下载失败...";
//static NSString    *kDownloadSuccessedString = @"下载成功...";
//static NSString    *kSynChronizedSuccessedString = @"同步成功...";
//static NSString    *kSynChronizedFailureString = @"同步失败...";
//static NSString    *kSaveSuccessedString = @"保存成功...";
//static NSString    *kSaveFailureString = @"保存失败...";

@interface FRSBAttention ()
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *statusBackView;
@property (nonatomic) NSString *attentionText;
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) FRSBAttentionAnimationType attentionType;

-(id)initWithFRSBAnimateType:(FRSBAttentionAnimationType)type withText:(NSString *)text withViewFrame:(CGRect)frame;
@end
static NSString *kStatuBarBackgroundColor = @"kStatuBarBackgroundColor";
static NSString *kStatuBarTitleTextColor = @"kStatuBarTitleTextColor";
@implementation FRSBAttention

-(id)initWithFRSBAnimateType:(FRSBAttentionAnimationType)type withText:(NSString *)text withViewFrame:(CGRect)frame{
    self = [super init];
    if(self){
        _statusBackView = [[UIView alloc]initWithFrame:frame];
        _statusBackView.backgroundColor = [UIColor orangeColor];
        _attentionType = type;
        _attentionText = text;
        [self configView];
        [self setViewColor];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setViewColor {
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor blackColor];
}
-(void)configView{
    NSString * title = _attentionText;
//    switch (_attentionType) {
//        case kFRSBAttentionTypeCollectFailure:
//            title = kCollectionFailureString;
//            break;
//        case kFRSBAttentionTypeAddFailure:
//            title = kAddNewsFailureString;
//            break;
//        case kFRSBAttentionTypeAddSucces:
//            title = kAddNewsSuccessedString;
//            break;
//        case kFRSBAttentionTypeCollectSuccess:
//            title = kCollectionSuccessedString;
//            break;
//        case kFRSBAttentionTypeDeleteFailure:
//            title = kDeleteFailureString;
//            break;
//        case kFRSBAttentionTypeDeleteSuccessed:
//            title = kDeleteSuccessedString;
//            break;
//        case kFRSBAttentionTypeDownloadFailure:
//            title = kDownloadFailureString;
//            break;
//        case kFRSBAttentionTypeDownloadSuccessed:
//            title = kDownloadSuccessedString;
//            break;
//        case kFRSBAttentionTypeSynChronizedFailure:
//            title = kSynChronizedFailureString;
//            break;
//        case kFRSBAttentionTypeSynChronizedSuccessed:
//            title = kSynChronizedSuccessedString;
//            break;
//        case kFRSBAttentionTypeSaveSuccessed:
//            title = kSaveSuccessedString;
//            break;
//        case kFRSBAttentionTypeSaveFailure:
//            title = kSaveFailureString;
//            break;
//        default:
//            break;
//    }
    
    CGRect rect = self.statusBackView.frame;
    rect.origin = CGPointZero;
    _label = [[UILabel alloc]initWithFrame:rect];
    NSLog(@"%f,%f,%f,%f",self.statusBackView.frame.size.height,self.statusBackView.frame.size.width,self.statusBackView.frame.origin.x,self.statusBackView.frame.origin.y);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"MicrosoftYaHei" size:12];
    _label.text = title;
    
    [_statusBackView addSubview:_label];
}
@end


typedef void (^FRSBAnimationCompletetionBlock)(BOOL isSuccess);
typedef void (^FRSBAnimationProcessBlock)(void);

static CGFloat timeInterval = 0.5;
static CGFloat displayDelay = 2;
static CGFloat dampingVetical = 2.0;
static CGFloat dampingRate = 0.1;

@interface FRSBAttentionManager (){
    @private
    BOOL isShowing;
}
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) FRSBAttentionAnimationType animationType;
@end

@implementation FRSBAttentionManager

@synthesize isShowing = isShowing;

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(instancetype)init{
    self = [super init];
    if(self){
        CGRect rect = [UIScreen mainScreen].bounds;
        
        _basicWindow = [[FRSBAttentionsWindow alloc]initWithFrame:rect];
        //_basicWindow.windowLevel = UIWindowLevelStatusBar;
//        if(_basicWindow.window == nil){
//            _rootViewController = [[UIViewController alloc]init];
//            _basicWindow.rootViewController = _rootViewController;
//        }
        //_basicWindow.rootViewController.view.clipsToBounds = YES;
    }
    return self;
}

FRSBAnimationCompletetionBlock animationOutCompletetionBlock(FRSBAttentionManager *manager){
    [manager setIsShowing:0];
    return ^void(BOOL success){
        manager.basicWindow.windowLevel = UIWindowLevelNormal + 1;
//        [manager.basicWindow.rootViewController.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//            [(UIView *)obj removeFromSuperview];
//        }];
        [manager.attention.statusBackView removeFromSuperview];
    };
    
}
FRSBAnimationProcessBlock attentionOutwardAnimationBlock(FRSBAttentionManager *manager){
    return ^void{
        [manager.attention.statusBackView setFrame:[manager getFrame2WithType:manager.animationType]];
        if(manager.animationType == kFRSBAttentionAnimationTypeAlpha)
            manager.attention.statusBackView.alpha = 0;
    };
}
FRSBAnimationProcessBlock attentionOutwardSetupAnimationBlock(FRSBAttentionManager *manager){
    return ^void{
        FRSBAttentionAnimationType animationType = manager.animationType;
        switch (animationType) {
            case kFRSBAttentionAnimationTypeAlpha:
            case kFRSBAttentionAnimationTypeVelocity:
                [UIView animateWithDuration:timeInterval
                                      delay:displayDelay
                                    options:0
                                 animations:attentionOutwardAnimationBlock(manager)
                                 completion:animationOutCompletetionBlock(manager)];
                break;
            case kFRSBAttentionAnimationTypeSpring:
                [UIView animateWithDuration:timeInterval
                                      delay:displayDelay
                     usingSpringWithDamping:dampingRate
                      initialSpringVelocity:dampingVetical
                                    options:0 animations:attentionOutwardAnimationBlock(manager)
                                 completion:animationOutCompletetionBlock(manager)];
            default:
                break;
        }
    };
}

- (CGRect)getFrame0WithType:(FRSBAttentionAnimationType) type{
    CGFloat width;
    CGFloat heigth;
    CGFloat originX;
    CGFloat originY;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    width = size.width;
    heigth = 20.0;
    
    switch (type) {
        case kFRSBAttentionAnimationTypeSpring:
            originX = -8;
            originY = 0;
            break;
        case kFRSBAttentionAnimationTypeVelocity:
            originX = 0;
            originY = -heigth;
            break;
        case kFRSBAttentionAnimationTypeAlpha:
            originX = 0;
            originY = 0;
            break;
        default:
            break;
    }
    
    return CGRectMake(originX, originY, width, heigth);
}
- (CGRect)getFrame1WithType:(FRSBAttentionAnimationType) type{
    CGFloat width;
    CGFloat heigth;
    CGFloat originX;
    CGFloat originY;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    width = size.width;
    heigth = 20.0;
    
    switch (type) {
        case kFRSBAttentionAnimationTypeSpring:
            originX = 0;
            originY = 0;
            break;
        case kFRSBAttentionAnimationTypeVelocity:
            originX = 0;
            originY = 0;
            break;
        case kFRSBAttentionAnimationTypeAlpha:
            originX = 0;
            originY = 0;
            break;
        default:
            break;
    }
    
    return CGRectMake(originX, originY, width, heigth);
}
- (CGRect)getFrame2WithType:(FRSBAttentionAnimationType) type{
    CGFloat width;
    CGFloat heigth;
    CGFloat originX;
    CGFloat originY;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    width = size.width;
    heigth = 20.0;
    
    switch (type) {
        case kFRSBAttentionAnimationTypeSpring:
            originX = width;
            originY = 0;
            break;
        case kFRSBAttentionAnimationTypeVelocity:
            originX = 0;
            originY = -heigth;
            break;
        case kFRSBAttentionAnimationTypeAlpha:
            originX = 0;
            originY = 0;
            break;
        default:
            break;
    }
    
    return CGRectMake(originX, originY, width, heigth);
}

- (void)displayBarAttentionWithType:(FRSBAttentionAnimationType)type
                           withText:(NSString *)text
                   withProcessBlock:(void(^)(void))processBlock
                     byCompletetion:(void(^)(void))completetionBlock{
    FRSBAttentionAnimationType animationType;
    animationType = type;
    
    self.animationType = animationType;
    _attention = [[FRSBAttention alloc]initWithFRSBAnimateType:animationType
                                                      withText:text
                                                 withViewFrame:[self getFrame0WithType:animationType]];
    
    _basicWindow.windowLevel = UIWindowLevelStatusBar;
    [_basicWindow.rootViewController.view addSubview:_attention.statusBackView];
    
    if(animationType == kFRSBAttentionAnimationTypeAlpha)
        _attention.statusBackView.alpha = 0;
    
    FRSBAnimationProcessBlock beginExtranceBlock = ^void{
        [_attention.statusBackView setFrame:[self getFrame1WithType:animationType]];
        if(animationType == kFRSBAttentionAnimationTypeAlpha)
            _attention.statusBackView.alpha = 1;
    };
    __weak __block typeof(self) weakself = self;
    FRSBAnimationCompletetionBlock extranceCompletetionBlock = ^void(BOOL isSuccess){
        attentionOutwardSetupAnimationBlock(weakself)();
    };
    
    switch (animationType) {
        case kFRSBAttentionAnimationTypeAlpha:
        case kFRSBAttentionAnimationTypeVelocity:
            [UIView animateWithDuration:timeInterval
                             animations:beginExtranceBlock
                             completion:extranceCompletetionBlock];
            break;
        case kFRSBAttentionAnimationTypeSpring:
            [UIView animateWithDuration:timeInterval
                                  delay:0.0
                 usingSpringWithDamping:dampingRate
                  initialSpringVelocity:dampingVetical
                                options:0
                             animations:beginExtranceBlock
                             completion:extranceCompletetionBlock];
        default:
            break;
    }
}
+(FRSBAttentionsWindow *)getwindow{
    return [[self manager] basicWindow];
}
+ (void)showBarAttentionWithType:(FRSBAttentionAnimationType)type
                        withText:(NSString *)text
                withProcessBlock:(void (^)(void))processBlock
                  byCompletetion:(void (^)(void))completetionBlock{
    if(![[self manager] isShowing]){
        [[self manager] setIsShowing:1];
        [[self manager] displayBarAttentionWithType:type
                                           withText:text withProcessBlock:processBlock
                                     byCompletetion:completetionBlock];
    }
}

@end
