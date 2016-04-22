//
//  BBAppearance.h
//  Basketball
//
//  Created by Allen on 3/25/16.
//  Copyright © 2016 wgl. All rights reserved.
//

#import <UIKit/UIKit.h>

#define baseColor UIColorFromHex(0x0192c9)
#define baseFontColor [UIColor lightGrayColor]
#define assistantColor UIColorFromHex(0xd2d2d2)
#define baseRedColor UIColorFromHex(0xeb4f38)

#define baseFontOfSize(fontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:fontSize]

@interface BBAppearance : NSObject

+ (void)configAppearance;

@end