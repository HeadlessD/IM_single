//
//  NSString.m
//  Qianbao
//
//  Created by zhangtie on 13-5-6.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import "NSString+NIMFormat.h"
//#import "RegexKitLite.h"

@implementation NSString(NIMFormat)

+ (NSString*)nim_strToShowText:(NSString*)sourStr
{
    return [NSString nim_strToShowText:sourStr defaultStr:@""];
}

+ (NSString*)nim_strToShowText:(NSString*)sourStr defaultStr:(id)defaultStr
{
    if(!sourStr)
    {
        return defaultStr;
    }
    
    return sourStr;
}


+ (NSString*)nim_formatNumString:(NSString*)str_count forMaxNum:(NSInteger)maxNum
{
    NSString *result = nil;
    if(!str_count)
        result = @"";
    else
    {
        if ([str_count intValue] > maxNum)
            result = [NSString stringWithFormat:@"%ld+", (long)maxNum];
        else
            result = str_count;
    }
    return [[NSString alloc]initWithString:result];
}

+ (NSString*)nim_formatProgress:(CGFloat)fprogress
{
//    NSString *result = [NSString stringWithFormat:@"%.2f", fprogress];
//    NSString *regex = @"^\\d+.00+";
//    BOOL isMath = [result isMatchedByRegex:regex];
//    if(isMath)
//    {
//        result = [NSString stringWithFormat:@"%.0f", fprogress];
//    }
    return nil;
}

+ (NSString*)nim_formatUrl:(NSString*)strUrl
{
    NSString *newStrUrl = [strUrl lowercaseString];
    
    if(!strUrl)
    {
        return nil;
    }
    else
    {
        NSString *httpHead  = @"http://";
        NSString *httpsHead = @"https://";
        BOOL hasHttp  = [newStrUrl hasPrefix:httpHead];
        BOOL hasHttps = [newStrUrl hasPrefix:httpsHead];
        if((!hasHttp) && (!hasHttps))
        {
            NSString *newUrl = [NSString stringWithFormat:@"%@%@", httpHead, strUrl];
            return newUrl;
        }
        else
        {
            return strUrl;
        }
    }
}

- (BOOL)nim_isNumberString
{
    if(!self)
        return NO;
    
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [self isEqualToString:filtered];
    
    return basic;
}


+ (NSString *)nim_yyyy_MM_ddToMM_dd:(NSString *)yyyy_MM_dd
{
    return [NSString nim_toMM_ddByFormat:@"yyyy-MM-dd" time:yyyy_MM_dd];
}

+ (NSString *)nim_yyyy_MM_dd_HH_mm_ssToMM_dd:(NSString *)yyyy_MM_dd_HH_mm_ss
{
    return [NSString nim_toMM_ddByFormat:@"yyyy-MM-dd HH:mm:ss" time:yyyy_MM_dd_HH_mm_ss];
}


+ (NSString *)nim_toMM_ddByFormat:(NSString *)byFormat time:(NSString *)time
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:byFormat];
    
    NSDate *date = [format dateFromString:time];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    
    NSDateFormatter *newformat = [[NSDateFormatter alloc] init];
    [newformat setDateFormat:@"MM-dd"];
    
    return [newformat stringFromDate:localeDate];
}

+ (NSString *)nim_toMM_dd:(NSString *)time
{
    NSString *temp = [NSString nim_yyyy_MM_dd_HH_mm_ssToMM_dd:time];
    
    if(temp.length == 0)
    {
        temp = [NSString nim_yyyy_MM_ddToMM_dd:time];
    }
    
    if(temp.length == 0)
    {
        temp = time;
    }
    
    return temp;
}

@end
