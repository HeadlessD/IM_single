#import <Foundation/Foundation.h>
@interface NIMBaseUtil: NSObject

typedef void (^Success)(void);
typedef void (^Failure)(void);


//获取当前毫秒级时间
+ (uint64_t) GetMsTime;
//设置服务器时间差=(服务器时间-本地时间)
+ (void) SetServerTime:(uint64_t) time;
+ (uint64_t) GetServerTime;
//本地时间+时间差=服务器时间
+ (int64_t) GetDeltaTime;
//获取PacketSessionID
+ (int)getPacketSessionID;
//C++字符串转OC字符串
+ (NSString *)getStringWithCString:(const char *)cString;

+ (NSString *)applicationNSCachesDirectory;
+ (NSString *)cacheImageMsgId:(int64_t)mid;
+ (NSString *)cacheThumbImageMsgId:(int64_t)mid;
+ (void)cacheImage:(UIImage *)image mid:(int64_t)mid;
+ (NSString *)bigImageDocMsgId:(int64_t)msgId;
+ (NSString *)thumbImageDocMsgId:(int64_t)msgId;
+ (void)cacheVideoThumb:(UIImage *)thumb msgId:(int64_t)mid;
+ (NSString *)videoThumbImageDocMsgId:(int64_t)msgid;
+ (NSArray *)parseHTTPURLWithString:(NSString *)string;
+ (NSArray *)parseVoiceHTTPURLWithString:(NSString *)string;

+ (BOOL)coverAAC:(NSString *)aacFile toMP3:(NSString *)toPath;

+ (NSString*)deviceVersion;

//是否为URL
+ (NSURL *)smartURLForString:(NSString *)str;

//是否插入耳机
+ (BOOL)usingHeadset;

//播放提示音
+ (void)playBeep;

//图片链接是否可用
+ (void)isAvailableURL:(NSString *)url success:(Success)success failure:(Failure)failure;

+ (NSArray *)splitArray:(NSArray *)array withSubSize:(int)subSize;

+ (NSInteger)getMessageCount;

//切换播放语音模式提示框
+ (void)showSoundAlert:(NSString *)message atView:(UIView *)view;

//获取指定宽度字符串
+ (NSString *)splitString:(NSString *)string goalWidth:(CGFloat)goalWidth;

//获取URL的指定参数对应值
+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param;

//网络状态提示
+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title;
+ (UIAlertController *)createAlertControllerWithOnlyTitle:(NSString *)title;

//创建随机端口
+(int)creatPort;

@end
