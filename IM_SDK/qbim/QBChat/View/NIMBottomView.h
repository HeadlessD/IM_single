//
//  NIMBottomView.h
//  QianbaoIM
//
//  Created by liyan on 9/20/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIMBottomView : UIView
_PROPERTY_NONATOMIC_RETAIN(UIButton, leftBtn);
_PROPERTY_NONATOMIC_RETAIN(UIButton, rightBtn);
_PROPERTY_NONATOMIC_RETAIN(UIButton, centerBtn);
@property (nonatomic,assign)UIColor *titleColor; //默认 343434
@property (nonatomic,assign)UIFont  *titleFont;  //默认 15

- (void)setTopLineColor:(UIColor *)color;
- (void)setCenterLineColor:(UIColor *)color;

- (void)setCenterLineHeight:(CGFloat)lineHeight;//当为0表示最大高度



- (void)setLeftTitle:(NSString *)title action:(SEL)sel target:(id)target;
- (void)setRightTitle:(NSString *)title action:(SEL)sel target:(id)target;

- (void)setLeftTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target;
- (void)setRightTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target;

- (void)setCenterTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target;

//设置左边按钮颜色
-(void)setLeftBtnTitleColor:(UIColor *)color;
- (id)initView;
//设置右边按钮文字和背景颜色
-(void)setRightBtnTitleFont:(NSInteger)textfont withTitleColor:(UIColor *)textcolor withBtnBackgroundColor:(UIColor *)bgcolor;
@end
