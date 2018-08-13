//
//  SSIMSpUtil.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/4.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _ALIGNTYPE
{
    ALIGNTYPE_LEFT,
    ALIGNTYPE_CENTER,
    ALIGNTYPE_RIGHT,
}ALIGNTYPE;

@interface SSIMSpUtil : NSObject

+ (void)setTabBarHidden:(BOOL)hidden;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;
+ (BOOL)tabBarHidden;
+ (void)setMsgNum:(int)num;
+(UIImage *)fixOrientation:(UIImage *)aImage;
+(NSString *)md5:(NSString *)str;
#pragma mark - 正则
//手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile;
//6-32个字符,请使用字母、数字或下划线，区分大小写
+ (BOOL)isValidateUserPassword:(NSString *)password;
//判断商品名的合法性（不含有特殊符号）
+(BOOL)isValidateProductName:(NSString*)name;
//只能输入汉字
+ (BOOL)isValidateChinaChar:(NSString *)realname;
//身份证号码
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard;
//邮箱
+ (BOOL)isEmail:(NSString *)emailStr;
//中国大陆手机号码
+ (BOOL)isPhoneNum:(NSString *)phoneNum;
//身份证上的姓名
+ (BOOL)isValidateCHNameChar:(NSString *)realname;
//纯数字
+ (BOOL)isTypeNumber:(NSString *)num;


//纯字母
+(BOOL)isTypeEnglish:(NSString *)inputString;

//数字或者小数
+ (BOOL)isTypeDecimalNumber:(NSString *)num;
//两位小数
+ (BOOL)isTypeTowDecimalNumber:(NSString *)num;
//是否包含特殊字符
+ (BOOL)isContainSpecialCharacter:(NSString*)str;
//是否是否仅包含英文、中文、数字
+ (BOOL)isContainNonEnglishAndChineseCharacter:(NSString*)str;
//字母、数字或下划线
+ (BOOL)isContainNonEnglishAndUnderscores:(NSString*)str;
//字母数字组合
+ (BOOL)isContainEnglishAndDigister:(NSString*)str;
//字母、数字或下划线中文
+ (BOOL)isContainNonEnglishAndUnderscoresAndChinese:(NSString*)str;

+ (BOOL)isValidateUserName:(NSString *)userName;
+ (BOOL)isValidateUserName:(NSString *)userName withLength:(NSString *)length;
+ (BOOL)isValidateTag:(NSString *)userName withLength:(NSString *)length;
+ (BOOL)isNickValidateTag:(NSString *)userName withLength:(NSString *)length;
//是否只包含空格和换行
+ (BOOL)isWhitespaceCharacterSet:(NSString *)str;

//判断是否有emoji
+(BOOL)stringContainsEmoji:(NSString *)string;

//格式化手机号
+ (NSString *)getFormatPhoneNum:(NSString *)phoneNum;
//格式化数字为钱币显示格式如10000 为 10,000
+ (NSString *)getMoneyFormatNumbers:(NSString *)numbers;
//格式化钱币显示正常数据形式式如10,000 为 10000
+ (NSString *)deleteMoneyChar:(NSString *)money;

//  XXX***XX
+ (NSString *)starEncrypted:(NSString *)sensitiveString;

//转千分位
+ (NSString*)toThousand:(NSString*) strnormal;
+ (NSString*)toThousandByW:(NSString*)strnormal;
+ (NSString*)toThousandByW:(NSString*) strnormal digit:(int)digit;
+ (NSString*)removePoint:(NSString *)strnormal;
+(BOOL)isMorePoint:(NSString *)strnormal;
+(BOOL)isNoPoint:(NSString *)strnormal;
+(BOOL)isMoreThanTwoPoint:(NSString *)strnormal;
+ (NSString*)removeThousand:(NSString*)strthousand;
+ (BOOL)isNumberString:(NSString *)numString;

+ (NSString *)convertDoubleToDoubleDigit:(double)doubleValue;
+ (NSString *)decimalString:(NSString *)str;
#pragma mark - JSON
+ (NSDictionary *)connvertJSONFileToDict:(NSString *)fileName;
//JSON转换成Dict
+ (NSDictionary *)convertJSONToDict:(NSString *)string;
//Dictionary or Array转换成JSON
+ (NSString *)convertObjectToJSON:(id)object;
#pragma mark - Dictionary
//获取Dictionary中的元素,主要防止服务器发送@""或者obje-c转化成NSNull
+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict;
//按照数据类型获取Dictionary中的元素,主要防止服务器发送@""或者obje-c转化成NSNull
+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict forClass:(Class)forClass;
//获取Dictionary中的元素,当是字符串时候处理过滤空白字符,否则返回取出的值 add by zt 2013.5.28
+ (id)getElementForKey:(id)key fromDict:(NSDictionary *)dict character:(NSCharacterSet*)character;
+(NSString *)encryptWithString:(NSString *)content;
+ (UIImage *)stretchImage:(UIImage *)image
                capInsets:(UIEdgeInsets)capInsets
             resizingMode:(UIImageResizingMode)resizingMode;

+ (NSDate*)zoneChange:(NSTimeInterval)timeInterval;
+ (UIColor *)getColor:(NSString *)hexColor;
+ (NSTextAlignment)getAlign:(ALIGNTYPE)type;

// 密码加密
+ (NSString *)encryptPassword:(NSString *)password userName:(NSString *)userName;
+ (NSString *)hmacSha1:(NSString*)key text:(NSString*)text;
// 生产verifyCode
+ (NSString *)generateVerifyCode:(NSArray *)params;

+ (UIImage *)getUploadImage:(UIImage *)image;

//压缩图片
+ (UIImage *)scaleFromImage: (UIImage *) image toSize: (CGSize) size;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(CGFloat)scaleSize;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 atPosition:(CGRect)frame;
+ (CGSize)getChatImageSize:(UIImage *)image;
+ (NSString *)holderImgURL:(NSString*)imgURL;

+ (NSString *)compareDate:(NSDate *)date;

+ (NSString *)getMonthStr:(NSInteger)month;

+ (BOOL)sameDayWithDate:(NSDate *)date1 date2:(NSDate *)date2;

+ (NSString *)avatarURL60:(NSString *)url60;

+ (NSString*)timeString:(NSTimeInterval)timestamp;

+ (void )LeftBubbleImage:(UIImageView *)imageView;
+ (void )RightBubbleImage:(UIImageView *)imageView;

+ (void)LeftBubbleImageButton:(UIButton *)btn;
+ (void)RightBubbleImageButton:(UIButton *)btn;

+ (NSString *)navigationBarTitleView:(NSString *)title;

+ (void)setBorder:(UIView *)view;

+ (void)popVC:(UIViewController *)viewController animated:(BOOL)animated;

+ (BOOL)isEqual:(double)userId1 userId2:(double)userId2;


+ (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title Traget:(id)traget sel:(SEL)sel;
+ (UIBarButtonItem *)backBarButtonItemWithTitle:(NSString *)title Traget:(id)traget sel:(SEL)sel arrow:(BOOL)arrow;


+ (void)beginAudioSession;
+ (void)endAudioSession;


+ (BOOL)isEmptyOrNull:(NSString*) string;
+ (NSString*)sampleTimeString:(NSTimeInterval)timestamp;
+ (NSString *)trimString:(NSString *) str;

// 计算缓存大小
+(float) caculateCacheSize:(NSArray*)folders;

// 清除缓存大小
+(BOOL)cleanCache:(NSArray*)folders;

+ (void)setGroupVcardWithURL:(NSString *)url withImag:(UIImage *)img;
+ (UIImage *)groupVcardWithURL:(NSString *)url;
+ (NSString*)parseTime:(NSTimeInterval)timestamp;
+ (NSString*)chatListParseTime:(NSTimeInterval)timestamp;
+ (NSString *)timeWithTimeInterval:(double)time;
//根据字符串生成二维码图片
+ (UIImage*)getImageFromString:(NSString*)str;

//获取当前用户所在的路径

+ (void)saveImageToAlbum:(UIImage*)image withAlert:(BOOL)alert;

//获取订单状态（供聊天使用）
+ (NSString*)getOrderMainStatusString:(NSString*)status;
+ (NSString*)getOrderSubStatusString:(NSString*)status;


+ (NSString *)getAllUrl:(NSString *)url;

+ (NSString *)getStatusTimerFromTimeInterval:(NSTimeInterval)timestamp;
+(NSString*)urlStringFromUrl:(NSString *)url compare:(NSString*)compareString changeString:(NSString*)changeString;
//颜色转换图片
+ (UIImage *)createImageWithColor:(UIColor*)color;
/*
    向上取整 1000米以下的显示为xx米内 ，以上的显示xx公里内
 */
+ (BOOL)stringA:(NSString *)stringA containString:(NSString *)stringB;\
+ (NSString *)sha1:(NSString *)string;


+ (NSString *)cacheAddressPhoneNum:(NSString *)phoneNum;
+ (void)cacheAddressAvatar:(UIImage *)image phoneNum:(NSString *)phoneNum;


//数字转汉字
+ (NSString *)ChineseWithInteger:(NSInteger)integer;

+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+(CGFloat)pxSizeConvert:(CGFloat)pxSize;

//生日时间戳计算年龄
+(NSString *)creatBirthdayWithtime:(NSString *)birthdayTime;

//生日字符串转时间戳
+(NSString *)creatTimeWithBirthday:(NSString *)birthday;

//毛玻璃效果
+(UIImage *)blurImageWithImage:(UIImage *)image;

//通讯录号码处理
+(NSString *)handlePhonenum:(NSString *)phonenum;

//获取最上层控制器
+ (UIViewController *)topViewController;

//手机号脱敏处理
+ (NSString *)sensitiveWithPhoto:(NSString *)number;

//邮箱脱敏处理
+ (NSString *)sensitiveWithEmail:(NSString *)email;

@end
