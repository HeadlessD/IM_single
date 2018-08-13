//
//  UIViewController+NIMPushVC.m
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "UIViewController+NIMPushVC.h"
#import "NIMViewController.h"
#import "UIActionSheet+nimphoto.h"
#import "NIMScanCodeViewController.h"
#import "NSString+NIMMD5.h"

@implementation UIViewController (NIMPushVC)

- (void)nim_pushToVC:(UIViewController*)vc animal:(BOOL)animal
{
    [self nim_pushToVC:vc inNav:self.navigationController animal:animal];
}

- (void)nim_pushToVC:(UIViewController*)vc inNav:(UINavigationController*)nav animal:(BOOL)animal
{
    [self nim_pushToVC:vc inNav:nav animal:animal hideTabbar:YES];
}

- (void)nim_pushToVC:(UIViewController*)vc inNav:(UINavigationController*)nav animal:(BOOL)animal hideTabbar:(BOOL)hidden
{
    [vc setHidesBottomBarWhenPushed:hidden];
    [nav pushViewController:vc animated:animal];
}


- (void)nim_showScanCodeView
{
    //先判断下设备是否支持扫一扫
    NIMScanCodeViewController* scan = [[NIMScanCodeViewController alloc] init];
    [self nim_pushToVC:scan animal:YES];
   
}


@end
