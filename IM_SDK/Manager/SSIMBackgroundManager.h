//
//  SSIMBackgroundManager.h
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSIMBackgroundManager : NSObject

//进入后台继续运行程序
+(void)setupBackgroundHandler;

//进入前台获取服务器时间用于同步
+ (void)getServerTime;

//当前当前设备状态
+(UIApplicationState)getApplicationState;

@end
