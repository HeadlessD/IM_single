//
//  PinYinManager.m
//  QianbaoIM
//
//  Created by liyan on 14-3-28.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "PinYinManager.h"
//#import "Allpinyin.h"
//#import "RegexKitLite.h"
#import "pinyin.h"
@implementation PinYinManager

//+ (void)InitPinyin
//{
//    NSString *indexFilePath = [[NSBundle mainBundle] pathForResource:@"pinyin_index" ofType:@"txt"];
//    NSString *pinyinFilePath = [[NSBundle mainBundle] pathForResource:@"pinyin" ofType:@"txt"];
//    init_pinyin([indexFilePath UTF8String],[pinyinFilePath UTF8String]);
//}
//
//+ (void)cancelPinyin
//{
//    destroy_pinyin();
//}

// 获取名字全拼
//+ (NSString *)getFullPinyinString:(NSString *)str
//{
//    if([str isKindOfClass:[NSNull class]])
//    {
//        return @"";
//    }
//    [PinYinManager InitPinyin];
//    //    NSAssert([QBFriendManager sharedFriendManager], @"需要先初始化QBFriendManager");
//	NSString *sTmp = @"";
//	for (int i = 0; i < [str length]; i++)
//    {
//		unichar c = [str characterAtIndex:i];
//		NSString *s = [NSString stringWithFormat:@"%C",c];
//        if(!s)
//            continue;
//		if ([s isMatchedByRegex:@"[\u4e00-\u9fa5]"])
//        {
//			const char *str1 = hanzi2pinyin(c);
//            if (str1 != NULL)
//            {
//                s = [NSString stringWithUTF8String:str1];
//            }
//			else
//            {
//                DBLog(@"const char *str = hanzi2pinyin(c) is NULL!");
//                return sTmp;
//            }
//		}
//		sTmp = [sTmp stringByAppendingString:s];
//	}
//	return [sTmp uppercaseString];
//}

// 获取首字母
+ (NSString *)getFirstLetter:(NSString *)str{
    
//    NSString *sTmp = @"";
//    for (int i = 0; i < 1; i++)  {
//
//        NSString *sz = [NSString stringWithFormat:@"%c",pinyinFirstLetter([str characterAtIndex:i])];
//
//        NSString *upper = [sz uppercaseString];
//
//        if ([upper isEqualToString:@"#"]) {
//            upper = @"Z#";
//        }
//
//        sTmp = [sTmp stringByAppendingString:upper];
//    }
    if (str.length != 0) {
        NSString * fullAll = [self getAllFullPinyinString:str];
        NSString * firForFull = [fullAll substringToIndex:1];

        if (![SSIMSpUtil isTypeEnglish:firForFull]) {
            return @"Z#";
        }else{
            return firForFull;
        }
//        if ([fullAll isEqualToString:sTmp]) {
//        NSLog(@"%@_%@",bcmp,firForFull);
//        }
    }else{
        return @"Z#";
    }
//
//    return sTmp;
}

//获取全拼
+ (NSString *)getFullPinyinString:(NSString *)str{
    
    NSString *sTmp = @"";
    for (int i = 0; i < [str length]; i++)  {
        
//        unichar c = [str characterAtIndex:i];
        //        NSString *s = [NSString stringWithFormat:@"%C",c];
        
        //        printf("pinyin__%c", pinyinFirstLetter([str characterAtIndex:i]));
        
        NSString *sz = [NSString stringWithFormat:@"%c",pinyinFirstLetter([str characterAtIndex:i])];
        
        if ([sz isEqualToString:@"#"]) {
            sz = @"Z#";
        }
        
        sTmp = [sTmp stringByAppendingString:sz];
    }
    return sTmp;
}


//获取全拼
+ (NSString *)getAllFullPinyinString:(NSString *)str{
    NSMutableString *pinyin = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    DBLog(@"%@", pinyin);
    
    
    NSString * quanpin = [pinyin uppercaseString];
    
    quanpin = [quanpin stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    return quanpin;
    
    //    用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，如果需要去掉音标，
    //    则继续使用kCFStringTransformStripCombiningMarks方法即可。
}

//    [PinYinManager InitPinyin];
//	if (!str || [str isEqualToString:@""]) {
//		return @"Z#";
//	}
//
//	NSString *theFirstLetter = [str substringToIndex:1];
//	if (![theFirstLetter isMatchedByRegex:@"[a-zA-Z]"]) {
//		return @"Z#";
//	}
//	return [theFirstLetter uppercaseString];

@end
