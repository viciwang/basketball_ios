//
//  TimeFormatterTransform.m
//  MicroReader
//
//  Created by FreedomKing on 14-10-16.
//  Copyright (c) 2014年 RR. All rights reserved.
//

#import "TimeFormatterTransform.h"

@implementation TimeFormatterTransform

+(NSDate *)transformCSTTimeToDefaultDateStringFromString:(NSString *)descriptionTime {
    
    NSInteger length=descriptionTime.length-6;
    descriptionTime=[descriptionTime substringWithRange:NSMakeRange(0, length)];
    
    NSDateFormatter *year=[[NSDateFormatter alloc]init];
    [year setDateFormat:@"yyyy"];
    
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"]];
    
    [dateformatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"]];
    
    [dateformatter setDateFormat:@"E, d LLL yyyy H:m:s"];
    
    NSDate *descDate=[dateformatter dateFromString:descriptionTime];
    
    return descDate;
    
}

+(NSString *)transformCSTTimeToDateStringFromString:(NSDate *)descriptionTime
{
    //NSLog(@"%@",descriptionTime);
    
    NSDate * senddate=[NSDate date];
    
    NSDateFormatter *year=[[NSDateFormatter alloc]init];
    [year setDateFormat:@"yyyy"];
    
    NSInteger yearCurrent=[[year stringFromDate:senddate] integerValue];
    NSInteger yearDescription=[[year stringFromDate:descriptionTime] integerValue];
    
    NSDateFormatter *monthFormatter=[[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MM月dd号"];
    NSString *month=[monthFormatter stringFromDate:descriptionTime];
    
    int interval=(int)[senddate timeIntervalSinceDate:descriptionTime];
    
    NSString *dateString;
    
    if(interval<60)
        dateString=@"刚刚";
    else if(interval<3600)
        dateString=[NSString stringWithFormat:@"%i 分钟前",interval/60];
    else if(interval<3600*24)
        dateString=[NSString stringWithFormat:@"%i 小时前",interval/3600];
    else if(interval<3600*24*2)
        dateString=[NSString stringWithFormat:@"昨天"];
    else if(interval<3600*24*3)
        dateString=[NSString stringWithFormat:@"前天"];
    else if(yearCurrent==yearDescription)
        dateString=month;
    else
    {
        [monthFormatter setDateFormat:@"yyyy年MM月dd号"];
        dateString=[monthFormatter stringFromDate:descriptionTime];
    }
    return dateString;
}

@end
