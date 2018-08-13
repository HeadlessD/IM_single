//
//  Util.m
//  QBIM
//
//  Created by liunian on 14-3-17.
//  Copyright (c) 2014年 liunian. All rights reserved.
//

#import "SSIMSpUtil.h"
//#import "GTMBase64.h"
//#import "QBOrderBaseCellModel.h"
//#import "Base64Data.h"
//#import "SecKeyWrapper.h"
#include <sys/socket.h>
// Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import  "CYApiDefines.h"
//#import "MBProgressHUD.h"
//#import "RegexKitLite.h"
//#import "NSString+NIMMD5.h"
#import "sys/utsname.h"
//#import "ZXingObjC.h"
//#import <AVFoundation/AVAudioSession.h>
#import <CommonCrypto/CommonHMAC.h>
#import "ALAssetsLibrary+NIMCustomPhotoAlbum.h"



#import "NIMManager.h"

@implementation SSIMSpUtil
//特殊字符正则
#define REGEX_SPECIALCHARACTER                  @"[`~!@#$^&*()=|{}':;'\\\\,\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；;”“'。，、？%]"

+ (void)setTabBarHidden:(BOOL)hidden
{
    
    
}

+ (BOOL)tabBarHidden
{
    
    return NO;
}
+ (void)setMsgNum:(int)num
{
    
    //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    IMTabBarController *tabBarController = delegate.imTabBarController;
    //    if (tabBarController) {
    //        [tabBarController setMsgNum:num];
    //    }
}
+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark - 正则

+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //目前钱宝交给服务端验证了，此处只要判断开头为1即可
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//+ (BOOL)isValidateMobile:(NSString *)mobile
//{
//
//    //手机号以13， 15，18开头,以及145，147两个新段，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[57]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    //    NSLog(@"phoneTest is %@",phoneTest);
//    return [phoneTest evaluateWithObject:mobile];
//}
//密码规则：
//密码规则：密码为6~14位单字符，支持数字，大小写字母和标点符号，不允许有空格。密码不允许有空格。
//标点符号：除空格以外的单字节字符。
//密码提示：不符合密码规则提示"密码长度或格式不正确"
+ (BOOL)isValidateUserPassword:(NSString *)password;
{
    //NSString *regexStr = @"^[0-9A-Za-z_]{6,32}$";
    
    // modify by huagnxiaojie 2014.5.22 密码为6~14位单字符，支持数字，大小写字母和标点符号，不允许有空格
    NSString* regexStr   = @"^[\\x00-\\xff&&[^\\x20]]{6,14}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:password];
    
    
}

+ (BOOL)isValidateChinaChar:(NSString *)realname
{
    NSString *regexStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:realname];
}

+ (BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    NSString *regexStr = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}[\\d|X]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:identityCard];
}

+ (BOOL)isEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailStr];
}

+ (BOOL)isPhoneNum:(NSString *)phoneNum
{
    NSString *regexStr = @"^1[34578]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:phoneNum];
}

+ (BOOL)isValidateCHNameChar:(NSString *)realname
{
    NSString *regexStr = @"^[\u4e00-\u9fa5]{1,}[·|.|•|•|•]?[\u4e00-\u9fa5]{1,}$";//@"^[\u4e00-\u9fa5]{2,24}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:realname];
}

+(BOOL)isTypeEnglish:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}


+ (BOOL)isTypeNumber:(NSString *)num
{
    NSString *regexStr = @"^\\d+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:num];
}

+ (BOOL)isTypeDecimalNumber:(NSString *)num
{
    NSString *regexStr = @"^[+-]?\\d+(\\.\\d+)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:num];
}

+ (BOOL)isTypeTowDecimalNumber:(NSString *)num
{
    NSString *regexStr = @"^[0-9]+(.[0-9]{0,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:num];
}
+ (BOOL)isContainSpecialCharacter:(NSString*)str
{
    if(!str || str.length <= 0)
        return YES;
    
    //    BOOL flag = [str isMatchedByRegex:REGEX_SPECIALCHARACTER];
    return NO;
}

+ (BOOL)isContainNonEnglishAndChineseCharacter:(NSString*)str
{
    NSString *regTags = @"^[0-9a-zA-Z\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regTags];
    return ![predicate evaluateWithObject:str];
}

+ (BOOL)isContainNonEnglishAndUnderscores:(NSString*)str
{
    NSString *regTags = @"^[0-9a-zA-Z_]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regTags];
    return ![predicate evaluateWithObject:str];
}

+ (BOOL)isContainEnglishAndDigister:(NSString*)str
{
    NSString *regTags = @"^[0-9a-zA-Z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regTags];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)isContainNonEnglishAndUnderscoresAndChinese:(NSString*)str
{
    NSString *regTags = @"^[0-9a-zA-Z\u4e00-\u9fa5_]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regTags];
    return ![predicate evaluateWithObject:str];
}

+ (BOOL)isValidateUserName:(NSString *)userName
{
    NSString *regexStr = @"^[0-9A-Za-z][_0-9A-Za-z]{5,19}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:userName];
}
+ (BOOL)isValidateUserName:(NSString *)userName withLength:(NSString *)length
{
    NSString *regexStr = [NSString stringWithFormat:@"[-\\w]{1,%@}",length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:userName];
}
+(BOOL)isValidateProductName:(NSString*)name
{
    NSString *regexStr = [NSString stringWithFormat:@"^[0-9a-zA-Z\u4e00-\u9fa5_]+$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    BOOL returnvalue=[predicate evaluateWithObject:name];
    return returnvalue;
}
+ (BOOL)isValidateTag:(NSString *)userName withLength:(NSString *)length
{
    NSString *regexStr = [NSString stringWithFormat:@"^[\\x5c0-9a-zA-Z\u4e00-\u9fa5_、 -]+${1,%@}",length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:userName];
}
+ (BOOL)isNickValidateTag:(NSString *)userName withLength:(NSString *)length
{
    NSString *regexStr = [NSString stringWithFormat:@"^[\\x5c0-9a-zA-Z\u4e00-\u9fa5_ -]+${1,%@}",length];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:userName];
}

//是否只包含空格和换行
+ (BOOL)isWhitespaceCharacterSet:(NSString *)str
{
    NSString *character  = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [character length] == 0 ;
}

+ (NSString *)getFormatPhoneNum:(NSString *)phoneNum
{
    NSMutableString *num = nil;
    if (phoneNum)
    {
        NSString *pNum = phoneNum;
        num = [NSMutableString stringWithString:pNum];
        if ([num length] == 4 + 4+ 3)
        {
            [num replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    return [num length]<=0?@"":num;
}

+ (NSString *)getMoneyFormatNumbers:(NSString *)numbers
{
    if (!numbers) {
        return nil;
    }
    
    NSMutableString *src = [NSMutableString stringWithString:numbers];
    
    NSInteger dotNums = floor(src.length / 3);
    
    for (NSInteger i = 1; i <= dotNums; i++)
    {   NSInteger pos = src.length - 3 * i - (i -1);
        if (pos != 0) {
            [src insertString:@"," atIndex:pos];
        }
    }
    
    return src;
}

+ (NSString *)deleteMoneyChar:(NSString *)money
{
    if (!money) {
        return nil;
    }
    return [money stringByReplacingOccurrencesOfString:@"," withString:@""];
}

+ (NSString *)starEncrypted:(NSString *)sensitiveString
{
    NSMutableString *str = [NSMutableString string];
    if (sensitiveString.length > 5)
    {
        [str appendString:[sensitiveString substringWithRange:NSMakeRange(0, 3)]];
        [str appendString:@"***"];
        [str appendString:[sensitiveString substringWithRange:NSMakeRange(sensitiveString.length - 2, 2)]];
    }
    else
        str = [NSMutableString stringWithString:sensitiveString];
    return str;
}

//rsa加密
+(NSString *)encryptWithString:(NSString *)content

{
    
    //    NSData *publicKey = [NSData dataFromBase64String:CYPUBLICKEY];
    //
    //    NSData *usernamm = [content dataUsingEncoding: NSUTF8StringEncoding];
    //
    //    NSData *newKey= [SecKeyWrapper encrypt:usernamm publicKey:publicKey];
    //
    //    NSString *result = [newKey base64EncodedString];
    
    return nil;
    
}

+ (NSString*)toThousand:(NSString*) strnormal
{
    if(!strnormal)
        return nil;
    
    strnormal = [strnormal stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    strnormal = [NSString stringWithFormat:@"%@",strnormal];
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString* strThousand = [[NSMutableString alloc]initWithString: trim] ;
    NSRange range = [strThousand rangeOfString:@"."];
    
    NSUInteger iLen;
    if(range.length == 0)
    {
        iLen = [strThousand length];
    }
    else
    {
        iLen = range.location;
    }
    NSUInteger iWhole = iLen / 3;
    NSUInteger iRemainder = iLen % 3;
    NSUInteger iPos;
    
    for(NSUInteger iIndex=iWhole; iIndex>0; iIndex--)
    {
        iPos = iRemainder + (iIndex-1)*3;
        if(iPos != 0)
        {
            if(iPos != 1 || (iPos == 1 && ![[strThousand substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]))
            {
                [strThousand insertString:@"," atIndex:iPos];
            }
        }
    }
    return strThousand;
}

+(NSString *)removePoint:(NSString *)strnormal
{
    if(!strnormal)
        return strnormal;
    
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString* strThousand = [[NSMutableString alloc]initWithString: trim];
    NSRange range = [strThousand rangeOfString:@"."];
    NSUInteger iLen;
    if(range.length == 0)
    {
        return strnormal;
    }
    iLen = range.location;
    if (strnormal.length -iLen == 3)
    {
        NSString *last = [strnormal substringFromIndex:range.location+1];
        if ([last isEqual:@"00"]) {
            strnormal = [strnormal substringToIndex:range.location];
            return strnormal;
        }
    }
    
    NSString *last = [strnormal substringFromIndex:strnormal.length-1];
    if ([last isEqual:@"0"]) {
        strnormal = [strnormal substringToIndex:strnormal.length-1];
        return strnormal;
    }
    
    return strnormal;
}

+(BOOL)isMorePoint:(NSString *)strnormal
{
    if(!strnormal)
        return NO;
    
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString* strThousand = [[NSMutableString alloc]initWithString: trim];
    NSRange range = [strThousand rangeOfString:@"."];
    NSUInteger iLen;
    if(range.length == 0)
    {
        return NO;
    }
    iLen = range.location;
    if (strnormal.length -iLen > 3)
    {
        return YES;
    }
    return NO;
}

+(BOOL)isNoPoint:(NSString *)strnormal
{
    if(!strnormal)
        return NO;
    
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString* strThousand = [[NSMutableString alloc]initWithString: trim];
    NSRange range = [strThousand rangeOfString:@"."];
    if(range.length == 0)
    {
        return YES;
    }
    return NO;
}
//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



//判断是否有emoji
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}




//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
+(BOOL)isMoreThanTwoPoint:(NSString *)strnormal
{
    if(!strnormal)
        return NO;
    
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger iLen = 0;
    
    while (trim.length > 0) {
        NSRange range = [trim rangeOfString:@"."];
        if(range.length > 0)
        {
            iLen ++;
            trim = [trim substringFromIndex:range.location+1];
        }
        else
        {
            break;
        }
        
    }
    
    if (iLen >1) {
        return YES;
    }
    
    return NO;
}


+ (NSString*)toThousandByW:(NSString*)strnormal
{
    return [[self class] toThousandByW:strnormal digit:6];
}
+ (NSString*)toThousandByW:(NSString*) strnormal digit:(int)digit
{
    NSString *trim = [strnormal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    double dTrim = [trim doubleValue];
    
    if(dTrim >  (pow(10, digit +1) - 1))
    {
        dTrim =  dTrim / 10000;
        dTrim = dTrim * 100;
        dTrim = floor(dTrim);
        dTrim = dTrim / 100;
        NSMutableString *strThousand = [NSMutableString string];
        [strThousand appendString:[SSIMSpUtil toThousand:_IM_FormatStr(@"%.02f",dTrim)]];
        [strThousand appendString:@"万"];
        
        return strThousand;
    }
    else
    {
        return [SSIMSpUtil toThousand:strnormal];
    }
}


+ (NSString*)removeThousand:(NSString*)strthousand
{
    if(!strthousand)
    {
        return nil;
    }
    else
    {
        return [strthousand stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
}

+ (BOOL)isNumberString:(NSString *)numString
{
    if(!self)
        return NO;
    
    NSCharacterSet *cs;
    
    //    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[numString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [numString isEqualToString:filtered];
    
    return basic;
}

+ (NSString *)convertDoubleToDoubleDigit:(double)doubleValue
{
    long long step1 = ((doubleValue+0.0055)*100);
    double step2 = step1/100.000;
    return [NSString stringWithFormat:@"%.2f",step2];
}

#pragma mark - JSON
+ (NSDictionary *)connvertJSONFileToDict:(NSString *)fileName
{
    NSString *Json_path = [[NSBundle mainBundle]  pathForResource:fileName ofType:@"json"];
    NSData *data= [NSData dataWithContentsOfFile:Json_path];
    NSError *error;
    NSDictionary *JsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    return JsonObject;
}

+ (NSDictionary *)convertJSONToDict:(NSString *)string
{
    NSError *error = nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!data || data == nil) {
        return nil;
    }
    NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (nil == error){
        return respDict;
    }else{
        return nil;
    }
}

+ (NSString *)convertObjectToJSON:(id)object;
{
    NSError *error = nil;
    NSData  *data = nil;
    if (object) {
        data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    if (data == nil) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
#pragma mark - Dictionary

+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict
{
    if(![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    id obj = [dict objectForKey:key];
    if ([obj isKindOfClass:[NSString class]] && [obj isEqual:@""]) {
        return nil; //空字符串
    } else if ([obj isKindOfClass:[NSNull class]]) {
        return nil; //空类
    }
    return obj;
}

+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict forClass:(Class)forClass
{
    if(![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    id obj = [dict objectForKey:key];
    
    if ([obj isKindOfClass:forClass])
    {
        if (([obj isKindOfClass:[NSString class]] && [obj isEqual:@""]) || [obj isKindOfClass:[NSNull class]])
        {
            return nil;
        }
        else
        {
            return obj;
        }
    }
    else
    {
        //目前只使用大钱旺专属服务机制
        
        if([obj isKindOfClass:[NSNumber class]])
        {
            if([NSStringFromClass(forClass) isEqualToString:NSStringFromClass([NSString class])])
            {
                return _IM_FormatStr(@"%@",obj);
            }
            else
            {
                
            }
        }
        else if([obj isKindOfClass:[NSString class]])
        {
            if([NSStringFromClass(forClass) isEqualToString:NSStringFromClass([NSNumber class])])
            {
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                NSNumber *number = [f numberFromString:obj];
                RELEASE_SAFELY(f);
                return number;
            }
            else
            {
                
            }
        }
        else
        {
            
        }
        
    }
    return nil;
}

+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict character:(NSCharacterSet*)character
{
    if(![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    id obj = [dict objectForKey:key];
    if ([obj isKindOfClass:[NSString class]])
    {
        if (!obj || [obj isEqual:@""])
        {
            return nil;
        }
        else
        {
            if(character)
            {
                return [obj stringByTrimmingCharactersInSet:character];
            }
            return obj;
        }
    }
    else if ([obj isKindOfClass:[NSNull class]])
    {
        return nil; //空类
    }
    return obj;
}
+ (NSDate*)zoneChange:(NSTimeInterval)timeInterval{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//[NSTimeZone timeZoneWithName:@"GMT"];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

+ (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode
{
    UIImage *resultImage = nil;
    double systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (systemVersion >= 6.0)
    {
        resultImage = [image resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
    }
    else if (systemVersion >= 5.0)
    {
        resultImage = [image resizableImageWithCapInsets:capInsets];
    }
    else
    {
        resultImage = [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
    return resultImage;
}

+ (NSTextAlignment)getAlign:(ALIGNTYPE)type
{
    CGFloat ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    switch (type)
    {
        case ALIGNTYPE_LEFT:
        {
            if(ver < 6.0)
            {
                return NSTextAlignmentLeft;
            }
            else
            {
                return NSTextAlignmentLeft;
            }
        }break;
        case ALIGNTYPE_CENTER:
        {
            if(ver < 6.0)
            {
                return NSTextAlignmentCenter;
            }
            else
            {
                return NSTextAlignmentCenter;
            }
        }break;
        case ALIGNTYPE_RIGHT:
        {
            if(ver < 6.0)
            {
                return NSTextAlignmentRight;
            }
            else
            {
                return NSTextAlignmentRight;
            }
        }break;
        default:
        {
            if(ver < 6.0)
            {
                return NSTextAlignmentLeft;
            }
            else
            {
                return NSTextAlignmentLeft;
            }
        }
            break;
    }
    
}
+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int redInt_, greenInt_, blueInt_;
    NSRange rangeNSRange_;
    rangeNSRange_.length = 2;  // 范围长度为2
    
    // 取红色的值
    rangeNSRange_.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&redInt_];
    
    // 取绿色的值
    rangeNSRange_.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&greenInt_];
    
    // 取蓝色的值
    rangeNSRange_.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:rangeNSRange_]] scanHexInt:&blueInt_];
    
    return [UIColor colorWithRed:(float)(redInt_/255.0f) green:(float)(greenInt_/255.0f) blue:(float)(blueInt_/255.0f) alpha:1.0f];
}

//颜色转换图片
+ (UIImage *)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)encryptPassword:(NSString *)password userName:(NSString *)userName{
    return [[NSString stringWithFormat:@"%@{%@}", password, userName] nim_MD5Hash];
    //    return nil;
}

+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}

+ (NSString *)generateVerifyCode:(NSArray *)params{
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for (id obj in params)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            [str appendString:obj];
        }
        else if([obj respondsToSelector:@selector(stringValue)])
        {
            [str appendFormat:@"%@",[obj stringValue]];
        }
    }
    
    [str appendFormat:@"{verifyCode}"];
    //    return [str nim_MD5Hash];
    return nil;
}

+ (UIImage *)getUploadImage:(UIImage *)image;
{
    CGFloat  size  = (image.size.width*image.size.height)/(512*512);
    CGFloat  scaleSize = size<=2.0?1.0:(2/size);
    
    if(scaleSize * image.size.width <200)
    {
        scaleSize = 200/ image.size.width;
    }
    if(scaleSize * image.size.height <200)
    {
        scaleSize = 200/ image.size.height;
    }
    
    return [[self class] scaleImage:image toScale:scaleSize];
    
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(NSString*)urlStringFromUrl:(NSString *)url compare:(NSString*)compareString changeString:(NSString*)changeString
{
    NSString *modifiedString=nil;
    NSString *tempString =[NSString stringWithFormat:@"%@=%@",compareString,changeString];
    if ([url rangeOfString:compareString].length==0) {
        modifiedString =[NSString stringWithFormat:@"%@&%@=%@",url,compareString,changeString];
    }
    else
    {
        NSString *regTags = [NSString stringWithFormat:@"(%@=[^&]*)",compareString];
        NSError *error;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionDotMatchesLineSeparators  error:&error];
        modifiedString = [regex stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, [url length]) withTemplate:tempString];
        
        
    }
    return modifiedString;
}

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 atPosition:(CGRect)frame
{
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    // Draw image2
    [image1 drawInRect:frame];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+(CGSize)getChatImageSize:(UIImage *)image
{
    CGFloat imgW = image.size.width;
    CGFloat imgH = image.size.height;
    
    if (imgW==0 || imgH == 0 || image == nil) {
        imgW = SCREEN_WIDTH*0.45;
        imgH = SCREEN_HEIGHT*0.3;
    }
    
    CGFloat bgW = SCREEN_WIDTH*0.4;
    CGFloat bgH = SCREEN_WIDTH*0.4;
    
    if (imgW == imgH) {
        return CGSizeMake(bgW, bgW);
    }
    
    CGFloat scale = 1;
    if (imgW > imgH) {//宽图
        
        if (imgW>=bgW) {
            scale = imgH/imgW;
            bgH = scale*bgW;
            if (bgH<=SCREEN_WIDTH*0.2) {
                bgH = SCREEN_WIDTH*0.2;
            }
        }else{
            scale = imgH/imgW;
            bgH = scale*bgW;
        }
        
    }else{//长图
        scale = imgW/imgH;
        if (imgH>=bgH) {
            bgW = bgH*scale;
            if (bgW<=SCREEN_WIDTH*0.25) {
                bgW = SCREEN_WIDTH*0.25;
            }
            
        }else{
            bgW = scale*bgH;
        }
    }
    
    return CGSizeMake(bgW, bgH);
}

+ (NSString *)holderImgURL:(NSString *)imgURL
{
    NSString *holderImgURL = nil;
    
    if(imgURL)
    {
        if ([imgURL containsString:@"http"]||[imgURL containsString:@"https"]) {
            return imgURL;
        }
        holderImgURL = [NSString stringWithFormat:@"%@/%@",SERVER_FIM_HTTP,imgURL];
    }
    
    return holderImgURL;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [SSIMSpUtil zoneChange:[[NSDate date]timeIntervalSince1970]];
    
    NSDate *yesterday;
    
    //    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSInteger dateDay      = [dateComponents day];
    
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:today];
    NSInteger todayDay      = [todayComponents day];
    
    //    NSDateComponents *tomorrowComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:tomorrow];
    //    NSInteger tomorrowDay      = [tomorrowComponents day];
    
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:yesterday];
    NSInteger yesterdayDay      = [yesterdayComponents day];
    
    if ( dateDay == todayDay)
    {
        return @" ";
    } else if ( dateDay == yesterdayDay)
    {
        return @"昨天";
    }
    return nil;
}

+ (NSString *)getMonthStr:(NSInteger)month
{
    switch (month) {
        case 1:
            return @"一月";
            break;
        case 2:
            return @"二月";
            break;
        case 3:
            return @"三月";
            break;
        case 4:
            return @"四月";
            break;
        case 5:
            return @"五月";
            break;
        case 6:
            return @"六月";
            break;
        case 7:
            return @"七月";
            break;
        case 8:
            return @"八月";
            break;
        case 9:
            return @"九月";
            break;
        case 10:
            return @"十月";
            break;
        case 11:
            return @"十一月";
            break;
        case 12:
            return @"十二月";
            break;
        default:
            break;
    }
    return @"";
}

+ (BOOL)sameDayWithDate:(NSDate *)date1 date2:(NSDate *)date2;
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    [components1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger day1 = [components1 day];
    
    NSInteger month1= [components1 month];
    
    NSInteger year1= [components1 year];
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    [components2 setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger day2 = [components2 day];
    
    NSInteger month2= [components2 month];
    
    NSInteger year2= [components2 year];
    
    if(day1 == day2 && month1 == month2 && year1 == year2)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)avatarURL60:(NSString *)url60
{
    
    //    return url60;
    
    if(url60 == nil)
    {
        return nil;
    }
    NSString *avatar = url60;
    NSError *error;
    NSString *muRegulaStr = [NSString stringWithFormat:@"updateTime=[1-9]\\d*"];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:muRegulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:url60 options:0 range:NSMakeRange(0, [url60 length])];
    if([arrayOfAllMatches count]> 0 )
    {
        NSTextCheckingResult *match = [arrayOfAllMatches objectAtIndex:0];
        NSRange range = match.range;
        
        NSString *updateTime   = [url60 substringWithRange:range];
        //        //NSLog(@"%@",updateTime);
        
        NSArray *arr = [updateTime componentsSeparatedByString:@"="];
        if([arr count] == 2)
        {
            NSString *str =  [arr objectAtIndex:1];
            
            if([str length]> 17)
            {
                NSString *temmp =  [url60 substringWithRange:NSMakeRange(0 , [url60 length] - range.length)];
                
                avatar = [NSString stringWithFormat:@"%@%@=%@",temmp, [arr objectAtIndex:0],[str substringToIndex:17]];
            }
            
        }
        
    }
    return avatar;
}


+ (NSString*)sampleTimeString:(NSTimeInterval)timestamp
{
    NSMutableString * titleStr = @"".mutableCopy;
    
    NSDate *date = [SSIMSpUtil zoneChange:timestamp];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSInteger day = [components day];
    NSInteger month= [components month];
    [titleStr appendFormat:@"%02ld-%02ld",(long)month,(long)day];
    
    return titleStr;
}

+ (NSString *)decimalString:(NSString *)str{
    NSString *decimalStr = @"";
    NSArray *arr = [str componentsSeparatedByString:@"."];
    if (arr.count >= 2) {
        decimalStr = [arr objectAtIndex:1];
        decimalStr = [NSString stringWithFormat:@".%@",decimalStr];
    }
    return decimalStr;
}





+ (NSString*)timeString:(NSTimeInterval)timestamp
{
    NSMutableString * titleStr = [NSMutableString string];
    
    
    NSDate *date = [SSIMSpUtil zoneChange:timestamp];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    NSString *result = [SSIMSpUtil compareDate:date];
    
    
    NSInteger hour      = [components hour];
#pragma mark 聊天时间显示不对,改为下5行
    if ([components hour]<8) {
        hour      = [components hour]+16;
    }else{
        hour      = [components hour]-8;
    }
    
    NSInteger minute    = [components minute];
    
    if(result)
    {
        [titleStr appendString:result];
        titleStr = [SSIMSpUtil trimString:titleStr].mutableCopy;
        [titleStr appendFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    }
    else
    {
        
        
        NSInteger day = [components day];
        NSInteger month= [components month];
        [titleStr appendFormat:@"%02ld-%02ld",(long)month,(long)day];
        //        [titleStr appendString: [NSString stringWithFormat:@"%d月",month]];
        //        [titleStr appendFormat:@"%d日",day];
        //        [titleStr appendString:@" "];
        //        [titleStr appendFormat:@"%02d:%02d",hour,minute];
    }
    
    return titleStr;
}

+ (NSString*)parseTime:(NSTimeInterval)timestamp{
    NSTimeInterval now = [NIMBaseUtil GetServerTime]/1000000;
    NSTimeInterval tmp = now - timestamp;
    NSDate *date = [SSIMSpUtil zoneChange:timestamp];
    NSDate *myDate = [NSDate dateWithTimeInterval:-8*3600 sinceDate:date];

    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitWeekday fromDate:myDate];
    
    NSInteger hour      = [components hour];
    NSInteger minute    = [components minute];
    NSInteger monty = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];

//    if (hour<8) {
//        hour      = hour+16;
//        day       = day-1;
//    }else{
//        hour      = hour-8;
//        day       = day;
//    }
    
    NSInteger week = [components weekday];
    NSString *weekStr = nil;
    if (week==1) {
        week = 7;
        weekStr = @"日";
    }else{
        week = week-1;
        weekStr = [SSIMSpUtil ChineseWithInteger:week];
    }
    
    NSDate *dateNow = [SSIMSpUtil zoneChange:now];
    NSDate *myDateNow = [NSDate dateWithTimeInterval:-8*3600 sinceDate:dateNow];

    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:myDateNow];
    NSInteger dayNow = componentsNow.day;
//    NSInteger hourNow = [componentsNow hour];
    
//    if (hourNow<8) {
//        hourNow      = hourNow+16;
//        dayNow       = dayNow-1;
//    }else{
//        hourNow      = hourNow-8;
//        dayNow       = dayNow;
//    }
//    
//    else if(tmp<2*24*60*60){
//        return [NSString stringWithFormat:@"昨天 %02ld:%02ld",(long)hour,(long)minute];
//    }
    if(tmp<24*60*60){
        if(day !=dayNow)
            return [NSString stringWithFormat:@"昨天 %02ld:%02ld",(long)hour,(long)minute];
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    }
    else if(tmp<7*24*60*60){
        return [NSString stringWithFormat:@"星期%@ %02ld:%02ld",weekStr,(long)hour,(long)minute];
    }
    else if(tmp<365*24*60*60){
        if (year != componentsNow.year)
            return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)year,(long)monty,(long)day,(long)hour,(long)minute];
        return [NSString stringWithFormat:@"%02ld-%02ld %02ld:%02ld",(long)monty,(long)day,(long)hour,(long)minute];
    }
    else{
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld",(long)year,(long)monty,(long)day,(long)hour,(long)minute];
    }
    return @"";
}


+ (NSString*)chatListParseTime:(NSTimeInterval)timestamp{
    NSTimeInterval now = [NIMBaseUtil GetServerTime]/1000000;
    NSTimeInterval tmp = now - timestamp;
    NSDate *date = [SSIMSpUtil zoneChange:timestamp];
    NSDate *myDate = [NSDate dateWithTimeInterval:-8*3600 sinceDate:date];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitWeekday fromDate:myDate];
    
    NSInteger hour      = [components hour];
    NSInteger minute    = [components minute];
    NSInteger monty = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
//    if (hour<8) {
//        hour      = hour+16;
//        day       = day-1;
//    }else{
//        hour      = hour-8;
//        day       = day;
//    }
//    
    NSInteger week = [components weekday];
    NSString *weekStr = nil;
    if (week==1) {
        week = 7;
        weekStr = @"日";
    }else{
        week = week-1;
        weekStr = [SSIMSpUtil ChineseWithInteger:week];
    }
    
    NSDate *dateNow = [SSIMSpUtil zoneChange:now];
    NSDate *myDateNow = [NSDate dateWithTimeInterval:-8*3600 sinceDate:dateNow];

    NSDateComponents *componentsNow = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:myDateNow];
    NSInteger dayNow = componentsNow.day;
//    NSInteger hourNow = [componentsNow hour];
    NSInteger yearNow = [componentsNow year];

//    if (hourNow<8) {
//        hourNow      = hourNow+16;
//        dayNow       = dayNow-1;
//    }else{
//        hourNow      = hourNow-8;
//        dayNow       = dayNow;
//    }
//    else if(tmp<2*24*60*60){
//        return @"昨天";
//    }
    if (year != yearNow){
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)monty,(long)day];
    }
    if(tmp<24*60*60){
        if(day !=dayNow)
            return @"昨天";
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)minute];
    }
    else if(tmp<7*24*60*60){
        return [NSString stringWithFormat:@"星期%@",weekStr];
    }
    else if(tmp<365*24*60*60){
        return [NSString stringWithFormat:@"%02ld-%02ld",(long)monty,(long)day];
    }
    else{
        return [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)year,(long)monty,(long)day];
    }
    return @"";
}




+ (NSString *)timeWithTimeInterval:(double)time
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getStatusTimerFromTimeInterval:(NSTimeInterval)timestamp
{
    if(timestamp<0)
        return @"";
    
    unsigned int time = timestamp / 1000;
    
    int day;
    int hour;
    int minute;
    int second;
    
    second = time % 60;
    minute = (time / 60) % 60;
    hour   = (time / 3600) % 24;
    day    = (time / 86400);
    return _IM_FormatStr(@"%d天%02d时%02d分%02d秒",day,hour,minute,second);
}

+ (UIImage*)getImageFromString:(NSString*)str{
    //    NSError* error = nil;
    //    ZXMultiFormatWriter* writer = [ZXMultiFormatWriter writer];
    //
    //    ZXEncodeHints* hints = [ZXEncodeHints hints];
    //    hints.errorCorrectionLevel = [ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH];//容错性设成最高，二维码里添加图片
    //    hints.encoding =  NSUTF8StringEncoding;// 加上这两句，可以用中文了
    //    ZXBitMatrix* result = [writer encode:str
    //                                  format:kBarcodeFormatQRCode width:800 height:800 hints:hints error:&error];
    //    if (result) {
    //        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
    //        UIImage *image1 =   [UIImage imageWithCGImage:image];//二维码原图
    //        return image1;
    //        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    //    } else {
    //        return nil;
    //    }
    return nil;
}



+ (void )LeftBubbleImage:(UIImageView *)imageView
{
    /*
     if(imageView)
     {
     CALayer *mask = [CALayer layer];
     UIImage *img = [SSIMSpUtil stretchImage:IMGGET(@"bubble_mask_l.png") withLeftCapWidth:18 topCapHeight:18 capInsets:UIEdgeInsetsMake(18, 18, 17, 26) resizingMode:UIImageResizingModeStretch];
     UIImage *newImg = [SSIMSpUtil scaleFromImage:img toSize:CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height)];
     mask.contents = (id)[newImg CGImage];
     mask.frame = CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height);
     imageView.layer.mask = mask;
     imageView.layer.masksToBounds = YES;
     }
     */
}

+ (void )RightBubbleImage:(UIImageView *)imageView
{
    /*
     if(imageView)
     {
     CALayer *mask = [CALayer layer];
     UIImage *img = [SSIMSpUtil stretchImage:IMGGET(@"bubble_mask_r.png") withLeftCapWidth:18 topCapHeight:18 capInsets:UIEdgeInsetsMake(18, 18, 17, 26) resizingMode:UIImageResizingModeStretch];
     UIImage *newImg = [SSIMSpUtil scaleFromImage:img toSize:CGSizeMake(imageView.bounds.size.width, imageView.bounds.size.height)];
     mask.contents = (id)[newImg CGImage];
     mask.frame = CGRectMake(0, 0, imageView.bounds.size.width, imageView.bounds.size.height);
     imageView.layer.mask = mask;
     imageView.layer.masksToBounds = YES;
     }
     */
}

+ (void)LeftBubbleImageButton:(UIButton *)btn
{
    //    if(btn)
    //    {
    //        CALayer *mask = [CALayer layer];
    //        UIImage *img = [SSIMSpUtil stretchImage:IMAGE(@"bubble_mask_l@2x.png") withLeftCapWidth:0 topCapHeight:0 capInsets:UIEdgeInsetsMake(40, 44, 39, 46) resizingMode:UIImageResizingModeStretch];
    //        UIImage *newImg = [SSIMSpUtil scaleFromImage:img toSize:CGSizeMake(btn.bounds.size.width*2, btn.bounds.size.height*2)];
    //        mask.contents = (id)[newImg CGImage];
    //        mask.frame = CGRectMake(0, 0, btn.bounds.size.width, btn.bounds.size.height);
    //        btn.layer.mask = mask;
    //        btn.layer.masksToBounds = YES;
    //    }
    [self setBubbleImageButton:btn isLeft:YES];
}

+ (void)RightBubbleImageButton:(UIButton *)btn
{
    //    if(btn)
    //    {
    //        CALayer *mask = [CALayer layer];
    //        UIImage *img = [SSIMSpUtil stretchImage:IMAGE(@"bubble_mask_r@2x.png") withLeftCapWidth:0 topCapHeight:0 capInsets:UIEdgeInsetsMake(40, 46, 39, 45) resizingMode:UIImageResizingModeStretch];
    //        UIImage *newImg = [SSIMSpUtil scaleFromImage:img toSize:CGSizeMake(btn.bounds.size.width*2, btn.bounds.size.height*2)];
    //        mask.contents = (id)[newImg CGImage];
    //        mask.frame = CGRectMake(0, 0, btn.bounds.size.width, btn.bounds.size.height);
    //        btn.layer.mask = mask;
    //        btn.layer.masksToBounds = YES;
    //    }
    [self setBubbleImageButton:btn isLeft:NO];
}
+(void)setBubbleImageButton:(UIButton*)btn isLeft:(BOOL)left
{
    UIImage *img;
    if (left) {
        img=IMGGET(@"image_mask.png");
    }else{
        img=IMGGET(@"image_mask_sender.png");
    }
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[img CGImage];
    mask.frame = CGRectMake(0, 0, btn.bounds.size.width, btn.bounds.size.height);
    btn.layer.mask = mask;
    btn.layer.masksToBounds = YES;
}
+ (NSString *)navigationBarTitleView:(NSString *)title
{
    return title;
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100,20)];
    //    label.text = title;
    //    label.font = [UIFont boldSystemFontOfSize:19];
    //
    //    label.textColor = __COLOR_262626__;
    //    label.textAlignment = ALIGN_CENTER;
    //    _CLEAR_BACKGROUND_COLOR_(label);
    //
    //    return [label autorelease];
}


+ (void)setBorder:(UIView *)view
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:0];
    [downButtonLayer setBorderWidth:1.0];
    [downButtonLayer setBorderColor:[[SSIMSpUtil getColor:@"e6e6e6"] CGColor]];
}


+ (void)popVC:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController.navigationController.topViewController == viewController)
    {
        [viewController.navigationController popViewControllerAnimated:animated];
    }
    else
    {
        [[viewController class]cancelPreviousPerformRequestsWithTarget:viewController];
    }
    
}

+ (BOOL)isEqual:(double)userId1 userId2:(double)userId2
{
    if(userId2 - userId1 == 0)
    {
        return YES;
    }
    return NO;
}

+ (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title Traget:(id)traget sel:(SEL)sel ;
{
    
    return [[self class] backBarButtonItemWithTitle:title Traget:traget sel:sel arrow:YES];
}

+ (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title Traget:(id)traget sel:(SEL)sel arrow:(BOOL)arrow;
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.backgroundColor = [UIColor yellowColor];
    btn.frame = CGRectMake(0, 0, 85, 28);
    btn.exclusiveTouch = YES;
    
    [btn addTarget:traget action:sel forControlEvents:UIControlEventTouchUpInside];
    if(arrow)
    {
        [btn setImage:IMGGET(@"back.png") forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[SSIMSpUtil getColor:@"ff3020"] forState:UIControlStateNormal];
    [btn sizeToFit];
    UIBarButtonItem *barButtton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return barButtton;
}

+ (CAAnimation *)animationShrink:(double)toValue
{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnim.toValue = [NSNumber numberWithFloat:toValue];
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.removedOnCompletion = NO;
    
    return scaleAnim;
}





#pragma mark - audio

+ (void)beginAudioSession
{
    //    NSError *error;
    //    AVAudioSession * session = [AVAudioSession sharedInstance];
    //    if(![session setCategory:AVAudioSessionCategoryPlayback error:&error]){
    //        DLog(@"%@",[error debugDescription]);
    //    }
    //    if(![session setActive:YES error:&error]){
    //        DLog(@"%@",[error debugDescription]);
    //    }
}

+ (void)endAudioSession
{
    //    NSError * error = nil;
    //    if (![[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]){
    //        DLog(@"------->setActive %@", [error debugDescription]);
    //    }
    
}

+ (BOOL)isEmptyOrNull:(NSString*) string
{
    return ! [self notEmptyOrNull:string];
    
}

+ (BOOL)notEmptyOrNull:(NSString*) string
{
    if([string isKindOfClass:[NSNull class]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]])
    {
        if (string != nil)
        {
            return  YES;
        }
        return NO;
    } else
    {
        string=[[self class] trimString:string];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@" "])
        {
            return  YES;
        }
        return NO;
    }
}

+ (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}



// 计算缓存大小
+(float) caculateCacheSize:(NSArray*)folders
{
    //    float imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    //
    //    unsigned long  filesSize = 0;
    //
    //    //计算其他文件的大小
    //
    //    float  filseSizeMB = (filesSize + imageCacheSize) / 1024.0 /1024.0;
    //change by wangli 2014-08-05 09:34 缩小11倍
    return 11;
}

// 清除缓存大小
+(BOOL)cleanCache:(NSArray*)folders
{
    //    [[SDImageCache sharedImageCache] clearDisk];
    
    //其他缓冲清空
    
    return YES;
}

+ (void)setGroupVcardWithURL:(NSString *)url withImag:(UIImage *)img{
    //    [[SDImageCache sharedImageCache] storeImage:img forKey:url toDisk:YES];
}
+ (UIImage *)groupVcardWithURL:(NSString *)url{
    //    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    return nil;
}


+ (void)saveImageToAlbum:(UIImage*)image withAlert:(BOOL)alert{
    
    if(image)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ALAssetsLibrary* lib = [[ALAssetsLibrary alloc] init];
            [lib nim_saveImage:image
                   toAlbum:@"钱宝" withCompletionBlock:^(NSError *error) {
                       NSString* message = @"";
                       if (error) {
                           if(error.code == -3310)
                           {
                               message = @"请允许“钱宝”访问图片库";
                           }
                           else
                           {
                               message = @"保存失败";
                           }
                           
                       } else {
                           message = @"成功保存到相册";
                       }
                       if(alert){
                           void(^callback)();
                           callback= ^(){
                               //[MBProgressHUD showSuccess:message toView:[UIApplication sharedApplication].keyWindow];
                           };
                           if([NSThread isMainThread]){
                               callback();
                           }
                           else{
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   callback();
                               });
                           }
                       }
                   }];
        });
    }
    else
    {
        if(alert){
            [MBTip showError:@"图片无效" toView:nil];
        }
    }
    
}



+ (NSString*)getOrderSubStatusString:(NSString*)status{
    /*
     switch (status.intValue) {
     case ORDER_STATE_WAIT_REFUND_MONEY_210:
     case ORDER_STATE_WILL_SEND_GOOD_202:
     {
     return @"待退款";
     }
     break;
     case ORDER_STATE_SUCCESS_REFUND_GOOD_9202:
     case ORDER_STATE_CLOSE_ORDER_2201:
     {
     return @"退款成功";
     }
     break;
     case ORDER_STATE_WILL_REFUND_GOOD_901:
     case ORDER_STATE_WILL_REFUND_GOOD_902:
     case ORDER_STATE_WILL_REFUND_GOOD_903:
     return @"待退货";
     break;
     case ORDER_STATE_WILL_REFUND_MONEY_920:
     case ORDER_STATE_WILL_REFUND_MONEY_921:
     case ORDER_STATE_WILL_REFUND_MONEY_922:
     return @"待退货";
     break;
     case ORDER_STATE_ING_REFUND_GOOD_910:
     case ORDER_STATE_ING_REFUND_GOOD_911:
     case ORDER_STATE_ING_REFUND_GOOD_912:
     return @"退货中";
     break;
     case ORDER_STATE_SUCCESS_REFUND_GOOD_9300:
     case ORDER_STATE_SUCCESS_REFUND_GOOD_9402:
     case ORDER_STATE_CLOSE_REFUND_GOOD_9404:
     {
     return @"退货退款成功";
     }
     break;
     case ORDER_STATE_WILL_RECEIVE_GOOD_300:
     case ORDER_STATE_WILL_RECEIVE_GOOD_301:
     case ORDER_STATE_WILL_RECEIVE_GOOD_303:
     case ORDER_STATE_WILL_RECEIVE_GOOD_305:
     {
     return @"待收货";
     }
     break;
     case ORDER_STATE_WILL_RECEIVE_GOOD_302:
     case ORDER_STATE_WILL_RECEIVE_GOOD_304:
     case ORDER_STATE_WILL_RECEIVE_GOOD_306:
     {
     return @"仲裁中";
     }
     break;
     case ORDER_STATE_SUCCESS_ORDER_1000:
     case ORDER_STATE_SUCCESS_ORDER_3401:
     {
     return @"交易成功";
     }
     break;
     case ORDER_STATE_CLOSE_REFUND_GOOD_9201:
     case ORDER_STATE_CLOSE_REFUND_GOOD_9001:
     case ORDER_STATE_CLOSE_REFUND_GOOD_9401:
     case ORDER_STATE_CLOSE_REFUND_GOOD_9403:
     return @"退货关闭";
     break;
     default:
     {
     }
     break;
     }
     return @"";
     }
     
     + (NSString*)getOrderMainStatusString:(NSString*)status{
     switch (status.intValue) {
     case ORDER_STATE_WILL_PAY_100:
     {
     return @"待付款";
     }
     break;
     case ORDER_STATE_WILL_EXAMINE_110:
     {
     return @"待审核";
     }
     break;
     case ORDER_STATE_WILL_SEND_GOOD_200:
     case ORDER_STATE_WILL_SEND_GOOD_201:
     case ORDER_STATE_WILL_SEND_GOOD_202:
     case ORDER_STATE_WAIT_REFUND_MONEY_210:
     {
     return @"待发货";
     }
     break;
     case ORDER_STATE_WILL_RECEIVE_GOOD_300:
     case ORDER_STATE_WILL_RECEIVE_GOOD_301:
     case ORDER_STATE_WILL_RECEIVE_GOOD_303:
     case ORDER_STATE_WILL_RECEIVE_GOOD_305:
     case ORDER_STATE_WILL_RECEIVE_GOOD_302:
     case ORDER_STATE_WILL_RECEIVE_GOOD_304:
     case ORDER_STATE_WILL_RECEIVE_GOOD_306:
     {
     return @"待收货";
     }
     break;
     case ORDER_STATE_CLOSE_ORDER_2101:
     case ORDER_STATE_CLOSE_ORDER_2102:
     case ORDER_STATE_CLOSE_ORDER_2201:
     case ORDER_STATE_CLOSE_ORDER_3001:
     case ORDER_STATE_CLOSE_ORDER_3002:
     case ORDER_STATE_CLOSE_ORDER_3402:
     case ORDER_STATE_CLOSE_ORDER_3403:
     case ORDER_STATE_CLOSE_ORDER_3404:
     {
     return @"交易关闭";
     }
     break;
     case ORDER_STATE_SUCCESS_ORDER_1000:
     case ORDER_STATE_SUCCESS_ORDER_3401:
     {
     return @"交易成功";
     }
     break;
     default:
     {
     }
     break;
     }
     */
    return @"";
}
+(UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



+ (NSString *)getAllUrl:(NSString *)url
{
    if (url == nil)
    {
        return nil;
    }
    NSString *lower =  [url lowercaseString];//url.toLowerCase();
    
    if(![lower hasPrefix:@"http"])
    {
        return _IM_FormatStr(@"http://%@",url);
    }
    
    return url;
}

+ (BOOL)stringA:(NSString *)stringA containString:(NSString *)stringB
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        return [stringA containsString:stringB];
    }
    else
    {
        if(stringB)
        {
            NSRange rage = [stringA rangeOfString:stringB];
            return rage.length>0;
        }
        else
            return NO;
    }
}
+ (NSString *)sha1:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

+ (void)cacheAddressAvatar:(UIImage *)image phoneNum:(NSString *)phoneNum
{
    [UIImageJPEGRepresentation(image,1) writeToFile:[SSIMSpUtil cacheAddressPhoneNum:phoneNum]
                                         atomically:YES];
}
+ (NSString *)cacheAddressPhoneNum:(NSString *)phoneNum{
    NSString *imageDirectory = [[NIMBaseUtil applicationNSCachesDirectory] stringByAppendingPathComponent:@"ADDRESS"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageStoreFilePath = [imageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",phoneNum]];
    return imageStoreFilePath;
}

//数字转汉字
+ (NSString *)ChineseWithInteger:(NSInteger)integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)integer]];
    if ([string isEqualToString:@"one"]) {
        string = @"一";
    }else if ([string isEqualToString:@"two"]){
        string = @"二";
    }else if ([string isEqualToString:@"three"]){
        string = @"三";
    }else if ([string isEqualToString:@"four"]){
        string = @"四";
    }else if ([string isEqualToString:@"five"]){
        string = @"五";
    }else if ([string isEqualToString:@"six"]){
        string = @"六";
    }else if ([string isEqualToString:@"seven"]){
        string = @"七";
    }
    return string;
}

+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }
        
        else{
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
        
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+(CGFloat)pxSizeConvert:(CGFloat)pxSize{
    NSNumber *iosFontSize = [NSNumber numberWithFloat:pxSize/96*72];
    CGFloat size = [iosFontSize floatValue];
    return size;
}


+(NSString *)creatBirthdayWithtime:(NSString *)birthdayTime{
    if (IsStrEmpty(birthdayTime)) {
        return @"";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间
    NSDate *date = [NSDate date]; // 获得时间对象
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    NSTimeInterval time2 = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate * dateNow = [date dateByAddingTimeInterval:time2];// 然后把差的时间加上,就是当前系统准确的时间
    
    //现在时间戳
    long timenow;
    timenow = (long)[dateNow timeIntervalSince1970]*1000;
    NSString * nowTimeStr = [NSString stringWithFormat:@"%ld",timenow];
 
    //生日时间
    long birtime;
    birtime = [birthdayTime integerValue];
    NSString * birStr = [NSString stringWithFormat:@"%ld",birtime];
    
    
    long ageTime;
    ageTime = timenow - birtime;
    NSString * ageStr = [NSString stringWithFormat:@"%ld",ageTime/365/24/3600/1000];

    return ageStr;
}


+(NSString *)creatTimeWithBirthday:(NSString *)birthday{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * dateStr = birthdayForDic;
    NSDate *lastDate = [formatter dateFromString:birthday];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    NSString * dateBir = [NSString stringWithFormat:@"%ld000",firstStamp];
    return  dateBir;
}

+(CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:URL.absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:URL.absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(image)
        {
            return image.size;
        }
    }
#endif
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    if ([pathExtendsion rangeOfString:@"png"].location != NSNotFound) {
        size = [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion rangeOfString:@"gif"].location != NSNotFound)
    {
        size = [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSData dataWithContentsOfURL:URL];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            //如果未使用SDWebImage，则忽略；缓存该图片
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    //过滤掉不符合大小的图片，大图太大浪费流量，用户体验不好
    if (size.height > 2048 || size.height <= 0 || size.width > 2048 || size.width <= 0 ) {
        return CGSizeZero;
    }
    else
    {
        return size;
    }
}
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

+(UIImage *)blurImageWithImage:(UIImage *)image{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *imagef = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:imagef forKey:kCIInputImageKey];
    [filter setValue:@1.0f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

+(NSString *)handlePhonenum:(NSString *)phonenum{
    if (!phonenum) {
        return nil;
    }
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@")" withString:@""];
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@"·" withString:@""];
    
    NSRange range = [phonenum rangeOfString:@"+86"];
    if (range.location == NSNotFound) {
        phonenum = [NSString stringWithFormat:@"+86%@",phonenum];
    }
    
    NSString * hone = [phonenum substringFromIndex:3];
    
    NSString *cleaned = [[hone componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    //         personPhone = [personPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return cleaned;
}

+ (UIViewController *)topViewController {
    
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}


@end
