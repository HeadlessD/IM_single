//
//  NIMAppConstDefines.h
//  QianbaoIM
//
//  Created by fengsh on 7/4/15.
//  Copyright (c) 2015年 fengsh. All rights reserved.
//
/**
 *  APP项目使用的宏声明,一般情况下是保持不变，与项目无关的放在这里
 */

#ifndef QianbaoIM_NIMAppConstDefines_h
#define QianbaoIM_NIMAppConstDefines_h
#import "NIMResultMeta.h"
typedef void (^CompleteBlock)(id object ,NIMResultMeta *result);
/*********************************日志打印*********************************/
#ifdef DEBUG
#define DBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DBLog(xx, ...)  ((void)0)
#endif

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define __QB_UNIT__   "￥"
#define __QB_UNIT__FONT(X) [UIFont fontWithName:@"fontello" size:X]
#define RATE_SAMPLE 8000.0
#define kTipsDelay 1.5f

/*********************************APP应用名和版本号***********************************/
#define APPLICATION_NAME                    @"qbaonew-ios"
#define APP_DEV                             @"iphone"
#define kAgient                             [NSString stringWithFormat:@"%@/%@",APPLICATION_NAME,APP_VERSION]
#define APP_NAME                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define APP_VERSION                         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


/************************************设备判断***************************************/
#define _IM_IS_PAD_                        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define _IM_IS_3_5_                        ([[UIScreen mainScreen] bounds].size.height <= 480.0)
#define IOS_VERSION                        [[[UIDevice currentDevice] systemVersion] doubleValue]

#define SCREEN_HEIGHT                       [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH                        [[UIScreen mainScreen] bounds].size.width

//屏幕尺寸判断
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//屏幕尺寸判断
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6P_MIN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


/************************************UI调整***************************************/

//状态栏高度
#define  IPX_STATUS_H        (KIsiPhoneX ? 44 : 20)
//导航栏高度
#define  IPX_NAVI_H          (KIsiPhoneX ? 88 : 64)
//头部安全高度
#define  IPX_TOP_SAFE_H       (KIsiPhoneX ? 24 : 0)
//底部安全高度
#define  IPX_BOTTOM_SAFE_H    (KIsiPhoneX ? 34 : 0)
//Tarbar高度
#define  IPX_TABBAR_H         (KIsiPhoneX ? 83 : 49)



//6屏幕宽度
#define ScreenScale [UIScreen mainScreen].bounds.size.width / 375


/************************************编译处理***************************************/
///lineBreakMode 适配ios6以前的换行模式
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
    #define NSUITextAlignment                     UITextAlignment
    #define NSUILineBreakMode                     UILineBreakMode
    #define NSUILineBreakModeWordWrap             UILineBreakModeWordWrap
    #define NSUILineBreakModeCharacterWrap        UILineBreakModeCharacterWrap
    #define NSUILineBreakModeClip                 UILineBreakModeClip
    #define NSUILineBreakModeHeadTruncation       UILineBreakModeHeadTruncation
    #define NSUILineBreakModeTailTruncation       UILineBreakModeTailTruncation
    #define NSUILineBreakModeMiddleTruncation     UILineBreakModeMiddleTruncation
#else
    #define NSUITextAlignment                     NSTextAlignment
    #define NSUILineBreakMode                     NSLineBreakMode
    #define NSUILineBreakModeWordWrap             NSLineBreakByWordWrapping
    #define NSUILineBreakModeCharacterWrap        NSLineBreakByCharWrapping
    #define NSUILineBreakModeClip                 NSLineBreakByClipping
    #define NSUILineBreakModeHeadTruncation       NSLineBreakByTruncatingHead
    #define NSUILineBreakModeTailTruncation       NSLineBreakByTruncatingTail
    #define NSUILineBreakModeMiddleTruncation     NSLineBreakByTruncatingMiddle
#endif

#define TASK_ID_FOR_ACTIVE                  30000000

//presentModal
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#define _PRESENT_VC(VC,toVC,BL) [VC presentModalViewController:toVC animated:BL]
#define _DISSMIS_VC(VC,BL)      [VC dismissModalViewControllerAnimated:BL]
#else
#define _PRESENT_VC(VC,toVC,BL) [VC presentViewController:toVC animated:BL completion:nil]
#define _DISSMIS_VC(VC,BL)      [VC dismissViewControllerAnimated:BL completion:nil]
#endif

//对齐方式
#define ALIGN_LEFT      [SSIMSpUtil getAlign:ALIGNTYPE_LEFT]
#define ALIGN_CENTER    [SSIMSpUtil getAlign:ALIGNTYPE_CENTER]
#define ALIGN_RIGHT     [SSIMSpUtil getAlign:ALIGNTYPE_RIGHT]

//后台进入前台的通知
#define AppEnterActive                  @"kAppEnterActive"

#define BUGLY_APP_ID @"f51d7b909c"

#endif
