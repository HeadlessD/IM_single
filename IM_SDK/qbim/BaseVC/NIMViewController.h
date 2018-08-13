//
//  BaseViewController.h
//  QianbaoIM
//
//  Created by Yun on 14-8-8.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSIMNetConstDefines.h"
#import "NIMQBLabel.h"
@class NIMResultMeta;
@protocol NIMViewControllerDelegate <NSObject>

- (void)requestNewModel;
- (void)updateUIbyModel;
- (void)updateUIByDeviceOrientation;

@end
typedef NS_ENUM(NSInteger, VcardSelectedActionType){
    VcardSelectedActionTypeNone         = 0,
    VcardSelectedActionTypeForward      = 1,
    VcardSelectedActionTypeChat         = 2,
};

typedef void (^VcardCompleteBlock)(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result);


// add by shiji
// back to Two ViewController
typedef NS_ENUM(NSInteger, POPVIEWCTRL_LEVEL) {
    ONE_LEVEL,    // 返回一级
    TWO_LEVEL,    // 返回两级
    THREE_LEVEL,  // 返回三级
    
    ROOT_LEVEL,   // 返回最底部
};

//@class NIMResultMeta;
@interface NIMViewController : UIViewController<NIMViewControllerDelegate>
{
    UIButton *_leftButton;
    UIButton *_rightButton;
}
@property(nonatomic, strong)NIMQBLabel           *labTitle;
@property(nonatomic, strong)UIButton            *leftButton;
@property(nonatomic, strong)UILabel             *uCountL;
@property(nonatomic, strong)UIBarButtonItem     *qb_leftBarButton;
@property(nonatomic, strong)UIBarButtonItem     *qb_rightBarButton;
@property(nonatomic, strong)UIButton            *rightButton;
@property(nonatomic, assign)BOOL                noNeedPopAnimation;//供多步骤操作时，其中的一步不需要pop动画使用
@property(nonatomic, assign)BOOL                qb_expectionUserIcon;//异常界面是否使用icon
@property(nonatomic, assign)POPVIEWCTRL_LEVEL   popLevel;         // 返回控制器的级数
- (void)qb_addNotificationUpdateModel;
- (void)qb_removeNotificationUpdateModel;
- (void)qb_postNotificationUpdateModel;

- (void)qb_addNotificationDeviceOrientationDidChange;
- (void)qb_removeNotificationDeviceOrientationDidChange;

- (void)qb_setTitleText:(NSString*)titleText;
- (void)qb_setTitleButton:(NSString*)titleText;
- (void)titleBtnAction;
- (void)qb_setTitleButtonText:(NSString*)titleText;
- (void)initialNIMMenuView:(NSArray *)menuDataSource andCell:(Class)cellClassType andResponseder:(id)responseder;
- (void)qb_showBackButton:(BOOL)show;
- (void)qb_setLeftButtonTitle:(NSString*)leftTitle;
- (void)qb_showRigthtTip:(NSString *)tipMessage;
- (void)qb_showRigthtTip:(NSString *)tipMessage icon:(BOOL)need;
- (void)qb_back;
- (void)qb_backWithoutAnimated;
- (void)qb_back_toSuper:(id)viewContrller;
- (void)qb_setRightButtonHidden:(BOOL)hidden;
- (void)qb_showRightButton:(NSString *)buttonTitle;
- (void)qb_showRightButton:(NSString *)buttonTitle andBtnImg:(UIImage *)image;
- (void)qb_showRightButton:(NSString *)buttonTitle andBtnImg:(UIImage *)image tyleTheme:(THEME_COLOR)theme;
- (void)qb_showLeftButtonWithImg:(UIImage *)image;
- (void)qb_showRightButtonWithImg:(UIImage *)image;

- (void)qb_rightButtonAction;

- (void)qb_setEnabledLeft:(BOOL)enabled;
- (void)qb_setEnabledRight:(BOOL)enabled;

- (void)qb_showLoading;

//- (void)hideLoading;
//- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock;
- (void)qb_bringSubviewToFrontLoading;

#pragma mark -- style
- (void)qb_setHideNavBar:(BOOL)hideNavBar;

- (BOOL)qb_hideNavBar;

- (void)qb_setNavBarBackGroundImage:(NSString *)imageName;

- (void)qb_setNavBarTintColor:(UIColor *)color;

- (void)qb_setNavStyleTheme:(THEME_COLOR)theme;

- (void)setTitleColor:(UIColor *)color;

- (void)qb_labTitleSizeToFit;

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

- (void)qb_reflashErrorView;

-(void)qb_setStatusBar_Default;

-(void)qb_setStatusBar_Light;


- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock;
#pragma mark -- 统一提示处理
- (void)qb_doNoteByResult:(NIMResultMeta*)result superView:(UIView*)superView;
+ (UIImage*)getNavImage:(NSString*)navImage;
@end
