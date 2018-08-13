//
//  cateViewController.m
//  QianbaoIM
//
//  Created by liyan on 9/16/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "UIViewController+NIMQBaoUI.h"

@implementation UIViewController(NIMQBaoUI_Background)

- (void)nim_setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
}

@end


@implementation UIViewController(NIMQBaoUI_statusBar)

- (void)nim_setStatusBar_Default
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)nim_setStatusBar_Light
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (void)nim_setStatusBar_Default
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

+ (void)nim_setStatusBar_Light
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}


@end

@implementation UIViewController(NIMQBaoUI_Util)

- (void)nim_setBoundsRadius:(UIView *)view
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:2];
//    [downButtonLayer setBorderWidth:0];
}


@end



