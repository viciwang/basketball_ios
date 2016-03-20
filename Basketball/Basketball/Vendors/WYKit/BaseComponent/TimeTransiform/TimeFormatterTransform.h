//
//  TimeFormatterTransform.h
//  MicroReader
//
//  Created by FreedomKing on 14-10-16.
//  Copyright (c) 2014年 RR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeFormatterTransform : NSObject

+ (NSDate *)transformCSTTimeToDefaultDateStringFromString:(NSString *)descriptionTime;

+ (NSString *)transformCSTTimeToDateStringFromString:(NSDate *)descriptionTime;


@end
