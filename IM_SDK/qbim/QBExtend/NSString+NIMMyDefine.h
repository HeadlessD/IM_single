//
//  NSString+NIMMyDefine.h
//  M_Comm
//
//  Created by Yun on 13-12-8.
//  Copyright (c) 2013年 Yun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(NSString_MyDefine)

+(CGSize)nim_getSizeFromString:(NSString*)str withFont:(UIFont*)font andLabelSize:(CGSize)size;
+(NSString*)nim_forIMIcon:(NSString*)url;
+(NSString*)nim_trim:(NSString *)str;
- (CGSize)nim_calculateSize:(CGSize)size font:(UIFont *)font;
@end
