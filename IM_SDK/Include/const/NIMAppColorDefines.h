//
//  NIMAppColorDefines.h
//  QianbaoIM
//
//  Created by fengsh on 7/4/15.
//  Copyright (c) 2015年 fengsh. All rights reserved.
//
/**
 *  app 应用中使用到的颜色值进行统一声明处
 */

#ifndef QianbaoIM_QBAppColorDefines_h
#define QianbaoIM_QBAppColorDefines_h

/**************************************颜色***************************************/

#define COLOR_RGB(r,g,b)                        [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define COLOR_RGBA(r,g,b,a)                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kPushRefreshBodyColor                   [UIColor colorWithRed:212.0/255.0 green:177.0/255.0 blue:138.0/255.0 alpha:1.0f]
#define kPushRefreshSkinColor                   [UIColor clearColor]
///十六进制转RGB
#define UIColorOfHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kNavBGColor                       [UIColor colorWithPatternImage:IMGNAMED(@"color_nav.png")]

#define _COLOR_GRAY_LINE                  [SSIMSpUtil getColor:@"D5D5D5"]
#define _COLOR_RED                        [UIColor redColor]
#define _COLOR_BLUE                       [UIColor blueColor]
#define _COLOR_YELLOW                     [UIColor yellowColor]
#define _COLOR_GREEN                      [UIColor greenColor]
#define _COLOR_BLACK                      [UIColor blackColor]
#define _COLOR_WHITE                      [UIColor whiteColor]
#define _COLOR_CLEAR                      [UIColor clearColor]
#define _COLOR_DARK_GRAY                  [UIColor darkGrayColor]
#define _COLOR_GRAY                       [UIColor grayColor]
#define _COLOR_LIGHT_GRAY                 [UIColor lightGrayColor]

#define __COLOR_F7F7F7__                  [SSIMSpUtil getColor:@"f7f7f7"]
#define __COLOR_262626__                  [SSIMSpUtil getColor:@"262626"]
#define __COLOR_FE6410__                  [SSIMSpUtil getColor:@"FE6410"]
#define __COLOR_545454__                  [SSIMSpUtil getColor:@"545454"]
#define __COLOR_555555__                  [SSIMSpUtil getColor:@"555555"]
#define __COLOR_FF362C__                  [SSIMSpUtil getColor:@"FF362C"]
#define __COLOR_FF432F__                  [SSIMSpUtil getColor:@"FF432F"]
#define __COLOR_FF6600__                  [SSIMSpUtil getColor:@"FF6600"]
#define __COLOR_FF503D__                  [SSIMSpUtil getColor:@"FF503D"]
#define __COLOR_FAC6BD__                  [SSIMSpUtil getColor:@"FAC6BD"]
#define __COLOR_FF5A00__                  [SSIMSpUtil getColor:@"FF5A00"]
#define __COLOR_FF9C00__                  [SSIMSpUtil getColor:@"FF9C00"]
#define __COLOR_FF9600__                  [SSIMSpUtil getColor:@"FF9600"]
#define __COLOR_E6E6E6__                  [SSIMSpUtil getColor:@"E6E6E6"]
#define __COLOR_000000__                  [SSIMSpUtil getColor:@"000000"]
#define __COLOR_454545__                  [SSIMSpUtil getColor:@"454545"]
#define __COLOR_888888__                  [SSIMSpUtil getColor:@"888888"]
#define __COLOR_979797__                  [SSIMSpUtil getColor:@"979797"]
#define __COLOR_C0C0C0__                  [SSIMSpUtil getColor:@"C0C0C0"]
#define __COLOR_146FDF__                  [SSIMSpUtil getColor:@"146FDF"]
#define __COLOR_D5D5D5__                  [SSIMSpUtil getColor:@"D5D5D5"]
#define __COLOR_757575__                  [SSIMSpUtil getColor:@"757575"]
#define __COLOR_FD472B__                  [SSIMSpUtil getColor:@"FD472B"]
#define __COLOR_F17918__                  [SSIMSpUtil getColor:@"F17918"]
#define __COLOR_AFAFAF__                  [SSIMSpUtil getColor:@"AFAFAF"]
#define __COLOR_FD472B__                  [SSIMSpUtil getColor:@"FD472B"]
#define __COLOR_7BCF54__                  [SSIMSpUtil getColor:@"7BCF54"]
#define __COLOR_7ECEF4__                  [SSIMSpUtil getColor:@"7ECEF4"]
#define __COLOR_BBBBBB__                  [SSIMSpUtil getColor:@"BBBBBB"]
#define __COLOR_E62F17__                  [SSIMSpUtil getColor:@"E62F17"]
#define __COLOR_FF8400__                  [SSIMSpUtil getColor:@"FF8400"]
#define __COLOR_252A46__                  [SSIMSpUtil getColor:@"252A46"]
#define __COLOR_C7CCE6__                  [SSIMSpUtil getColor:@"C7CCE6"]
#define __COLOR_8393BA__                  [SSIMSpUtil getColor:@"8393BA"]
#define __COLOR_00137D__                  [SSIMSpUtil getColor:@"00137D"]
#define __COLOR_23338E__                  [SSIMSpUtil getColor:@"23338E"]
#define __COLOR_2B93FD__                  [SSIMSpUtil getColor:@"2B93FD"]
#define __COLOR_6F81AC__                  [SSIMSpUtil getColor:@"6F81AC"]
#define __COLOR_AAAAAA__                  [SSIMSpUtil getColor:@"AAAAAA"]
#define __COLOR_C4C4C4__                  [SSIMSpUtil getColor:@"C4C4C4"]
#define __COLOR_25327B__                  [SSIMSpUtil getColor:@"25327B"]
#define __COLOR_A2A9CD__                  [SSIMSpUtil getColor:@"A2A9CD"]
#define __COLOR_6774B6__                  [SSIMSpUtil getColor:@"6774B6"]
#define __COLOR_B67822__                  [SSIMSpUtil getColor:@"B67822"]
#define __COLOR_D1A76C__                  [SSIMSpUtil getColor:@"D1A76C"]
#define __COLOR_D6A054__                  [SSIMSpUtil getColor:@"D6A054"]

#endif
