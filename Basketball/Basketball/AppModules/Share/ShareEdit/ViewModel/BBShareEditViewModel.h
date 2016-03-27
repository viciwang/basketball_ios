//
//  BBShareEditViewModel.h
//  Basketball
//
//  Created by yingwang on 16/3/27.
//  Copyright © 2016年 wgl. All rights reserved.
//

#import "BBNetworkApiManager.h"

@interface BBShareEditViewModel : BBNetworkApiManager
- (void)uploadShareContent:(NSString *)contentText images:(NSArray *)images;
@end
