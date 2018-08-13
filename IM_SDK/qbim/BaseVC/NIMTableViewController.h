//
//  NIMTableViewController.h
//  QianbaoIM
//
//  Created by Yun on 14-8-11.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSIMNetConstDefines.h"
@interface NIMTableViewController : UITableViewController
{
    UIButton *_leftButton;
    UIButton *_rightButton;
}

@property(nonatomic, strong)  UIButton              *leftButton;
@property(nonatomic, strong)  UIButton              *rightButton;
@property(nonatomic, strong)  UIBarButtonItem       *qb_leftBarButton;
@property(nonatomic, strong) UIBarButtonItem        *qb_rightBarButton;
@property(nonatomic, assign) uint64_t               officialid;
@property(nonatomic, strong) UILabel               *labTitle;
@property (nonatomic, strong) UIImageView *receImageView;


@property(nonatomic, assign)BOOL                noNeedPopAnimation;//供多步骤操作时，其中的一步不需要pop动画使用
- (void)qb_setTitleText:(NSString*)titleText;
- (void)qb_showLeftButtonWithImg:(UIImage *)image;
- (void)qb_showBackButton:(BOOL)show;
- (void)qb_back;
- (void)qb_rightButtonAction;
- (void)qb_showLoading;
//- (void)hideLoading;
//- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock;

- (void)qb_showRightButton:(NSString *)buttonTitle;
- (void)qb_showRightButton:(NSString *)buttonTitle andBtnImg:(UIImage *)image tyleTheme:(THEME_COLOR)theme;

- (void)qb_setHideNavBar:(BOOL)hideNavBar;

- (BOOL)qb_hideNavBar;

- (void)qb_setNavBarBackGroundImage:(NSString *)imageName;

- (void)qb_setNavLeftButtonStyle:(UIButton*)leftButton theme:(THEME_COLOR)theme;

- (void)qb_setNavBarTintColor:(UIColor *)color;

- (void)qb_setNavStyleTheme:(THEME_COLOR)theme;
#pragma mark -- 异常展示行为
- (void)qb_showNoDataView:(NSString*)noteTitle;

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView withImage:(UIImage*)image;

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView;

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView offset:(CGPoint)offset;

- (void)qb_hideNoDataView;

- (void)qb_showErrorView;

- (void)qb_showErrorViewAtView:(UIView*)superView;

- (void)qb_showErrorViewAtView:(UIView*)superView offset:(CGPoint)offset;

- (void)qb_hideErrorView;

- (void)qb_setStatusBar_Default;

- (void)qb_setStatusBar_Light;

@end
