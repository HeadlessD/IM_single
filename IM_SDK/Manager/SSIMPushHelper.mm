//
//  SSIMPushHelper.mm
//  Empire
//
//  Created by shiyunjie on 15/9/11.
//
//

#import "SSIMPushHelper.h"
#import <UserNotifications/UserNotifications.h>
#import "NetCenter.h"
//#include "platform/ios/CCLuaObjcBridge.h"

static SSIMPushHelper *instance = nil;

@implementation SSIMPushHelper

+(SSIMPushHelper *)getInstance
{
    if(instance == nil)
    {
        instance = [[SSIMPushHelper alloc] init];
    }
    
    return instance;
}

//限制方法，类只能初始化一次
//alloc的时候调用
+ (id) allocWithZone:(struct _NSZone *)zone{
    if(instance == nil){
        instance = [super allocWithZone:zone];
    }
    return instance;
}

//拷贝方法
- (id)copyWithZone:(NSZone *)zone{
    return instance;
}

//需要重写release方法，不能让其引用+1
//- (id)retain{
//    return self;
//}
//
//- (id)autorelease{
//    return self;
//}

- (id)init
{
    return self;
}

#pragma mark - 推送相关
static int register_lua_call_back_id = -1;

+(void)registerRemoteNotification:(NSDictionary *)dict
{
    /*
    // 模拟器不支持
    #if !TARGET_IPHONE_SIMULATOR
        register_lua_call_back_id = [[dict objectForKey:@"listener"] intValue];
        //如果注册成功，但关闭了推送通知，上传全0的token以禁用推送通知
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        }
    
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    #endif
     */
    // 模拟器不支持

    #if !TARGET_IPHONE_SIMULATOR
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // 必须写代理，不然无法监听通知的接收与点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 点击允许
                NSLog(@"同意推送");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@", settings);
                }];
            } else {
                // 点击不允许
                NSLog(@"拒绝推送");
            }
        }];
    }else{
        //iOS 10 before
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // 注册获得device Token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif

}

uint const kDefaultRemoteNotificationType =  UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;

+(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //如果注册成功，但关闭了推送通知，上传全0的token以禁用推送通知
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        BOOL is_open_remote_notification = [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        if(!is_open_remote_notification)
        {
            Byte zeroToken[32] = {0};
            deviceToken = [NSData dataWithBytes:&zeroToken[0] length:sizeof(zeroToken)];
        }
    }else{
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
        UIRemoteNotificationType rnt = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if((rnt & kDefaultRemoteNotificationType) == 0)
        {
            Byte zeroToken[32] = {0};
            deviceToken = [NSData dataWithBytes:&zeroToken[0] length:sizeof(zeroToken)];
        }
    }
    [SSIMPushHelper processRemoteDeviceToken:deviceToken saveImmediate:false];
}

//推送注册成功
+(void)processRemoteDeviceToken:(NSData *)deviceToken saveImmediate:(BOOL)saveImmediate{
    [[NIMUserOperationBox sharedInstance]sendRegisterApnsRQ:deviceToken];
}

//推送注册失败
+(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    Byte zeroToken[32] = {0};
    NSData * deviceToken = [NSData dataWithBytes:&zeroToken[0] length:sizeof(zeroToken)];
    [[NIMUserOperationBox sharedInstance]sendRegisterApnsRQ:deviceToken];
}

+(void)didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    /*
    NSString *bufString = [userInfo objectForKey:@"Buffer"];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:bufString options:0];
    NSLog(@"%@",data);
    
    QBTransParam *trans_param = [[QBTransParam alloc] init];
    trans_param.packet_id = [[userInfo objectForKey:@"PackId"] integerValue];
    trans_param.buf_len = data.length;
    trans_param.buffer = data;
    
    [[NetCenter sharedInstance] ProcessNetMsg:trans_param];
     */
}

+(void)didReceiveLocalNotification:(UILocalNotification *)notification{
    
    
}



+(void)createLocalNotification:(NSDictionary *)dict
{
    // 模拟器不支持推送
#if !TARGET_IPHONE_SIMULATOR
    if(!isBackgroundMode)
    {
        return;
    }
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if(notification == nil)
    {
        return;
    }
    
    NSString* alert_body = [dict objectForKey: @"alert_body"];
    int delay_time = [[dict objectForKey: @"delay_time"] intValue];
    NSString* notification_key = [dict objectForKey: @"notification_key"];
    //设置推送时间
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:delay_time];
    notification.fireDate = pushDate;
    //设置时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    //设置重复间隔
    notification.repeatInterval = kCFCalendarUnitDay;
    //推送声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    //推送内容
    notification.alertBody = alert_body;
    //显示在icon上的红色圈中的数字
    notification.applicationIconBadgeNumber = 1;
    //设置userinfo 方便在之后需要撤销的时候使用
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"notification" forKey:notification_key];
    notification.userInfo = info;
    
    //添加推送到UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
#endif
}

+(void)clearLocalNotification:(NSDictionary *)dict
{
    // 模拟器不支持推送
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *p_local_array = [app scheduledLocalNotifications];
    if(p_local_array)
    {
        for(UILocalNotification *local_notification in p_local_array)
        {
            if(local_notification)
            {
                [app cancelLocalNotification:local_notification];
                //                local_notification = nil;
            }
        }
        
        p_local_array = nil;
    }
#endif
}

+ (void)scheduleLocalNotificationBody:(NSString *)alertBody
{
    UIApplication* app = [UIApplication sharedApplication];
    
    if([app applicationState] == UIApplicationStateBackground)
    {
        NSArray * oldNotifications = [app scheduledLocalNotifications];
        if ([oldNotifications count] > 0)
            [app cancelAllLocalNotifications];
        UILocalNotification* alarm = [[UILocalNotification alloc] init];
        if (alarm)
        {
            alarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            alarm.timeZone = [NSTimeZone defaultTimeZone];
            alarm.repeatInterval = 0;
            alarm.soundName = UILocalNotificationDefaultSoundName;
            alarm.alertBody = alertBody;
            [app scheduleLocalNotification:alarm];
        }
    }
}

BOOL isBackgroundMode;
+(void)setBackGroundMode:(BOOL)flag
{
    isBackgroundMode = flag;
}

@end

