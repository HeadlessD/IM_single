//
//  PinYinManager.h
//  QianbaoIM
//
//  Created by liyan on 14-3-28.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

@interface PinYinManager : NSObject

//+ (void)InitPinyin;
//+ (void)cancelPinyin;
// 获取名字全拼
+ (NSString *)getFullPinyinString:(NSString *)str;
// 获取首字母
+ (NSString *)getFirstLetter:(NSString *)str;

// 获取名字全拼
+ (NSString *)getAllFullPinyinString:(NSString *)str;

@end
