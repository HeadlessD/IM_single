#import "NIMBaseUtil.h"
#import "UIImage+NIMHBClass.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
@implementation NIMBaseUtil
static NSString * const CLASS_NAME = @"NIMBaseUtil";
//设置于服务器的时间差
static int64_t server_delta_time = 0;

+ (uint64_t) GetMsTime
{
    uint64_t ms_time = [[NSDate date] timeIntervalSince1970] * 1000000;
    return ms_time;
}

+ (void) SetServerTime:(uint64_t) time
{
    server_delta_time = [NIMBaseUtil GetMsTime] - time;
}

+ (int64_t) GetDeltaTime
{
    return server_delta_time;
}

+ (uint64_t) GetServerTime
{
    return ([NIMBaseUtil GetMsTime] - [NIMBaseUtil GetDeltaTime]);
}

+ (int)getPacketSessionID
{
    static int base_seq = 1;
    base_seq = (base_seq + 1) % 4294967296;
    return base_seq;
}

+(NSString *)getStringWithCString:(const char *)cString
{
    return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

+ (NSArray *)parseHTTPURLWithString:(NSString *)string
{
    NSError *error;
    //(\\[img])?http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)(\\[/img])?
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                                           options:0
                                                                             error:&error];
    NSMutableArray *arry = nil;
    if (regex != nil)
    {
        NSArray *array = [regex matchesInString: string
                                        options: 0
                                          range: NSMakeRange(0, [string length])];
        arry = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSTextCheckingResult *match in array)
        {
            NSRange firstHalfRange = [match rangeAtIndex:0];
            NSString *result=[string substringWithRange:firstHalfRange];
            [arry addObject:result];
        }
    }
    return arry;
}


+ (NSArray *)parseVoiceHTTPURLWithString:(NSString *)string
{
    NSError *error;
    //(\\[voice])?http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)(\\[/voice])?
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?"
                                                                           options:0
                                                                             error:&error];
    NSMutableArray *arry = nil;
    if (regex != nil)
    {
        NSArray *array = [regex matchesInString: string
                                        options: 0
                                          range: NSMakeRange(0, [string length])];
        arry = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSTextCheckingResult *match in array)
        {
            NSRange firstHalfRange = [match rangeAtIndex:0];
            NSString *result=[string substringWithRange:firstHalfRange];
            [arry addObject:result];
        }
    }
    return arry;
}


+ (NSString *)applicationNSCachesDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
}


+ (void)storeGroupIcon:(UIImage *)image groupid:(int64_t)groupid
{
    NSString *docPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
    NSString *imageDirectory = [docPath stringByAppendingPathComponent:@"record/image/group"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageStoreFilePath = [imageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",groupid]];
    
    [UIImageJPEGRepresentation(image,1) writeToFile:imageStoreFilePath
                                         atomically:YES];

}


+ (NSString *)bigImageDocMsgId:(int64_t)msgId
{
    NSString *imageDirectory = @"/record/image/CHAT_IMAGE";
    NSString *imageStoreFilePath = [imageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",msgId]];
    return imageStoreFilePath;
}


+ (NSString *)thumbImageDocMsgId:(int64_t)msgId
{
    NSString *imageDirectory = @"/record/image/CHAT_IMAGE_THUMB";
    NSString *imageStoreFilePath = [imageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",msgId]];
    return imageStoreFilePath;
}


+ (NSString *)cacheImageMsgId:(int64_t)mid{
    
    NSString *docPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
    NSString *imageDirectory = [docPath stringByAppendingPathComponent:@"record/image/CHAT_IMAGE"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:imageDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageStoreFilePath = [imageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",mid]];
    return imageStoreFilePath;
}


+ (NSString *)cacheThumbImageMsgId:(int64_t)mid{
    
    NSString *docPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
    NSString *thumbImageDirectory = [docPath stringByAppendingPathComponent:@"record/image/CHAT_IMAGE_THUMB"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:thumbImageDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbImageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageStoreFilePath = [thumbImageDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",mid]];
    return imageStoreFilePath;
}

+ (void)cacheImage:(UIImage *)image mid:(int64_t)mid{
    if (image == nil)
    {
        return;
    }
    
    CGSize chatSize = [SSIMSpUtil getChatImageSize:image];
    
//    CGFloat ratio_width = 200;
//    CGFloat ratio_height = 200;
    UIImage *thumbNail = [SSIMSpUtil imageCompressForSize:image targetSize:chatSize];
    [UIImageJPEGRepresentation(thumbNail,1) writeToFile:[NIMBaseUtil cacheThumbImageMsgId:mid]
                                             atomically:YES];
    
    [UIImageJPEGRepresentation(image,1) writeToFile:[NIMBaseUtil cacheImageMsgId:mid]
                                         atomically:YES];
    
}


+ (void)cacheVideoThumb:(UIImage *)thumb msgId:(int64_t)mid{
    
    NSString *docPath = [[NIMCoreDataManager currentCoreDataManager] recordPathMov];
    NSString *filePath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",mid]];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData  *data = UIImageJPEGRepresentation(thumb,1);
            if (data) {
                NSLog(@"文件名称:%@",filePath);
                [data writeToFile:filePath atomically:YES];
            } else {
                
            }
        });
    }
}


+ (NSString *)videoThumbImageDocMsgId:(int64_t)msgid
{
    NSString *thumbPath = [[[NIMCoreDataManager currentCoreDataManager] recordPathMov] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg",msgid]];
    return thumbPath;
}


+ (BOOL)coverAAC:(NSString *)aacFile toMP3:(NSString *)toPath{
    // coverToMP3
    NSString *aacFilePath = aacFile;
    NSString *mp3FilePath = toPath;
    
    NSException *coverException = nil;
    @try {
        int read, write;
        
        FILE *pcm = fopen([aacFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, RATE_SAMPLE);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        coverException = exception;
    }
    
    return coverException == nil;
}


+(NSString *)deviceVersion
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}



+ (NSURL *)smartURLForString:(NSString *)str {
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    result = nil;
    
    
    NSString* regexStr   = @"^[(http|https)://]*([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    
    NSString* regexIp = @"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    BOOL  isUrl = [predicate evaluateWithObject:str];
    
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexIp];
    BOOL  isIP = [predicate1 evaluateWithObject:str];
    
    if (!isUrl && !isIP) {
        return result;
    }
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // 格式不符合
            }
        }
    }
    
    return result;
}



+ (BOOL)usingHeadset
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
    CFStringRef route;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    
    BOOL hasHeadset = NO;
    if((route == NULL) || (CFStringGetLength(route) == 0))
    {
        // Silent Mode
    }
    else
    {
        /* Known values of route:
         * "Headset"
         * "Headphone"
         * "Speaker"
         * "SpeakerAndMicrophone"
         * "HeadphonesAndMicrophone"
         * "HeadsetInOut"
         * "ReceiverAndMicrophone"
         * "Lineout"
         */
        NSString* routeStr = (__bridge NSString*)route;
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
        
        if (headphoneRange.location != NSNotFound)
        {
            hasHeadset = YES;
        }
        else if(headsetRange.location != NSNotFound)
        {
            hasHeadset = YES;
        }
    }
    
    if (route)
    {
        CFRelease(route);
    }
    
    return hasHeadset;
}

//TODO:播放语音
+ (void)playBeep{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(1004);
    }
    else {
        DBLog(@"Error: audio file not found at path: %@", path);
    }
}

+ (void)isAvailableURL:(NSString *)url success:(Success)success failure:(Failure)failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode == 200) {
            success();
        }else{
            failure();
        }
    }];
    [task resume];
}

+ (NSArray *)splitArray:(NSArray *)array withSubSize:(int)subSize{
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];

    for (int i = 0; i < subSize; i ++) {
        
        //将子数组添加到保存子数组的数组中
        [arr addObject:[array objectAtIndex:i]];
    }
    
    
    
    /*
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];  
    }  
    */
    return [arr copy];  
}


+(NSInteger)getMessageCount
{
    NSInteger uCount = 0;

    return uCount;
}

+ (void)timerFireMethod:(NSTimer*)theTimer
{
    UIView *promptAlert = (UIAlertView*)[theTimer userInfo];
    
    promptAlert =NULL;
}


+ (void)showSoundAlert:(NSString *)message atView:(UIView *)view{
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(view.frame)+60, SCREEN_WIDTH, 50)];
    alertView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
    
    [view addSubview:alertView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:alertView
                                    repeats:NO];
}


+ (NSString *)splitString:(NSString *)string goalWidth:(CGFloat)goalWidth{
    
    NSString *goalStr = nil;
    
    for (int i=0; i<string.length; i++) {
        goalStr = [string substringToIndex:i];
        
        CGFloat swidth = [goalStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.width;
        
        if (swidth>=goalWidth) {
            goalStr = [string substringToIndex:i-2];
            goalStr = [goalStr stringByAppendingString:@"..."];
            break;
        }else{
            if (i==string.length-1) {
                goalStr = string;
            }
        }
    }
    
    return goalStr;
}

+ (NSString *) paramValueOfUrl:(NSString *) url withParam:(NSString *) param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}


+ (UIAlertController *)createAlertControllerWithTitle:(NSString *)title

{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"连接失败，请检查你的网络设置。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}


+ (UIAlertController *)createAlertControllerWithOnlyTitle:(NSString *)title

{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    return alertController;
}

+(int)creatPort{
    NSArray * portArr = [NSArray arrayWithObjects:@7700,@7701,nil];
    NSNumber * numm =  portArr[arc4random()%portArr.count];
    return [numm intValue];
}


@end
