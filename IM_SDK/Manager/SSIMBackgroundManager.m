//
//  SSIMBackgroundManager.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMBackgroundManager.h"
@implementation SSIMBackgroundManager

+(void)setupBackgroundHandler
{
    UIApplication *application = [UIApplication sharedApplication];
    
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
    BOOL backgroundAccepted = [application setKeepAliveTimeout:600 handler: ^
                               {
                                   //[self scheduleLocalNotificationBody:@"测试本地通知"];
                               }
                               ];
    if(backgroundAccepted)
    {
        NSLog(@"Set Background handler successed!");
    }
    else
    {//failed
        NSLog(@"Set Background handler failed!");
    }
}

+(UIApplicationState)getApplicationState
{
    UIApplication* app = [UIApplication sharedApplication];
    return app.applicationState;
}


+(void)getServerTime
{
    [[NIMSysManager sharedInstance] getServerTime];
}
@end
