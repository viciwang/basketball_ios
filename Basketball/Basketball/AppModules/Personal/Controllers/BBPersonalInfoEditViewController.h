//
//  BBPersonalInfoEditViewController.h
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import "BBBaseViewController.h"

@interface BBPersonalInfoEditViewController : BBBaseViewController

@property (nonatomic, copy) NSString *currentDesc;

@property(nonatomic, copy) void (^endEditBlock)(NSString *description);

@end
