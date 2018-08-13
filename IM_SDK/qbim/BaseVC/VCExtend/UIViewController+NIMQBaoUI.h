//
//  cateViewController.h
//  QianbaoIM
//
//  Created by liyan on 9/16/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(NIMQBaoUI_Background)

- (void)nim_setBackgroundColor:(UIColor *)color;

@end


@interface UIViewController(NIMQBaoUI_statusBar)


- (void)nim_setStatusBar_Default;

- (void)nim_setStatusBar_Light;

+ (void)nim_setStatusBar_Default;

+ (void)nim_setStatusBar_Light;

@end

@interface UIViewController(NIMQBaoUI_Util)

- (void)nim_setBoundsRadius:(UIView *)view;

@end
