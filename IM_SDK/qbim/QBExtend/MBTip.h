//
//  MBTip.h
//  QianbaoIM
//
//  Created by liyan on 14-4-9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

@interface MBTip : NSObject

+ (void)showTipsView:(NSString *)tips;

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view;

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view afterDelay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset;

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay;

//+ (void)showTipsView:(NSString *)tips atView:(UIView *)view withTextColor:(UIColor *)textColor backColor:(UIColor *)backColor;

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view withImage:(UIImage *)image afterDelay:(NSTimeInterval)delay tipsTag:(NSInteger)tag target:(id)target;

+ (void)showError:(NSString *)error toView:(UIView *)view;

@end
