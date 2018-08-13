//
//  NSString.h
//  Qianbao
// ****************************** note:  ******************************
// 该扩展用于字符串过滤格式化
//  1.处理字符串用于显示到界面上
//  2.处理数字字符串，指定最大上限值，如果指定最大值为99，现字符串为@"129" 则返回@"99+"
// ****************************** note:  ******************************
//  Created by zhangtie on 13-5-6.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAlphaNum           @"0123456789"

@interface NSString(NIMFormat)

+ (NSString*)nim_strToShowText:(NSString*)sourStr;

+ (NSString*)nim_strToShowText:(NSString*)sourStr defaultStr:(id)defaultStr;

+ (NSString*)nim_formatNumString:(NSString*)str_count forMaxNum:(NSInteger)maxNum;

+ (NSString*)nim_formatProgress:(CGFloat)fprogress;

+ (NSString*)nim_formatUrl:(NSString*)strUrl;

- (BOOL)nim_isNumberString;

+ (NSString *)nim_yyyy_MM_ddToMM_dd:(NSString *)yyyy_MM_dd;

+ (NSString *)nim_yyyy_MM_dd_HH_mm_ssToMM_dd:(NSString *)yyyy_MM_dd_HH_mm_ss;

+ (NSString *)nim_toMM_dd:(NSString *)time;
@end
