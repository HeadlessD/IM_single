//
//  SSIMPushHelper.h
//  Empire
//
//  Created by shiyunjie on 15/9/11.
//
//
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SSIMPushHelper : NSObject

+(SSIMPushHelper *)getInstance;

//注册远程推送成功得到token
+(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

//注册远程推送失败
+(void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

//接收到远程通知消息
+(void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

//接收到本地通知消息
+(void)didReceiveLocalNotification:(UILocalNotification *)notification;

//是否处于后台状态
+(void)setBackGroundMode:(BOOL)flag;

/**************以下在SDK内部调用************/
//TCP登陆成功后注册ios推送
+(void)registerRemoteNotification:(NSDictionary *)dict;
+(void)scheduleLocalNotificationBody:(NSString *)alertBody;
+(void)clearLocalNotification:(NSDictionary *)dict;
@end
