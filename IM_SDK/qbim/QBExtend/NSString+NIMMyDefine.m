//
//  NSString+NIMMyDefine.m
//  M_Comm
//
//  Created by Yun on 13-12-8.
//  Copyright (c) 2013年 Yun. All rights reserved.
//

#import "NSString+NIMMyDefine.h"

@implementation NSString (NSString_MyDefine)

#pragma 根据字符串的字体获取size长款
+(CGSize)nim_getSizeFromString:(NSString*)str withFont:(UIFont*)font andLabelSize:(CGSize)size
{
    if([str isKindOfClass:[NSNull class]]){
        str = @"";
    }
    CGRect textFrame = CGRectZero;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    textFrame = [str boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
    return textFrame.size;
}


#pragma 去除字符串前后空格
+(NSString*)nim_trim:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}

#pragma 用户icon后面要添加
+(NSString*)nim_forIMIcon:(NSString*)url
{
    NSRange foundObj=[url rangeOfString:@"&fromIM=1" options:NSCaseInsensitiveSearch];
    NSRange qiniu = [url rangeOfString:@"qbsns.qiniudn" options:NSCaseInsensitiveSearch];//加入七牛地址认证
    if(foundObj.length>0 || qiniu.length>0) {
        return url;
    }
    else
    {
        return [NSString stringWithFormat:@"%@&fromIM=1",url];
    }
    return url;
}

- (CGSize)nim_calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        expectedLabelSize = [self boundingRectWithSize:size options:options attributes:attributes context:nil].size;
    }
    else {
        expectedLabelSize = [self sizeWithFont:font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}
@end
