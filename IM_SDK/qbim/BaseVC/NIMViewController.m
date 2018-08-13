//
//  BaseViewController.m
//  QianbaoIM
//
//  Created by Yun on 14-8-8.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  基础VC

#import "NIMViewController.h"
#import "UIViewController+NIMQBaoUI.h"
#import "NIMWTErrorView.h"
#import "NIMMenuView.h"
#import "NIMTNoDataView.h"
#import "NIMRightTipView.h"

#define KEYPAHT_LOADINGANIMAL   @"transform.rotation"
#define KEY_LOADINGANIMAL       @"rotationAnimation"

@interface NIMViewController ()<NIMWTErrorViewDelegate,NIMTNoDataViewDelegate>

@property (nonatomic, strong) MBProgressHUD         *progressHUD;
@property (nonatomic, strong) UIImageView           *loadingImageView;
@property (nonatomic, strong) NIMMenuView              *NIMMenuView;
@property (nonatomic, strong) UIImageView           *NIMMenuViewArrow;
@property (nonatomic, strong) NSLayoutConstraint    *menuArrowConstrain;
@property (nonatomic, strong) UIView                *menuBackView;
@property (nonatomic, strong) NSArray               *constraint;
@property (nonatomic, strong) NSArray               *constraint2;
@property (nonatomic, strong) NIMWTErrorView          *qbm_viewError;
@property (nonatomic, strong) NIMTNoDataView         *qbm_viewNoData;
@property (nonatomic, strong) NIMRightTipView        *rigthTipView;
@end

@implementation NIMViewController

- (void)dealloc
{
    
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:IMGGET(@"red") forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:NSStringFromClass([self class])];
//    _GET_APP_DELEGATE_(app);
//    [app.applicationActionSheet dismissWithClickedButtonIndex:app.applicationActionSheet.cancelButtonIndex animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.qb_expectionUserIcon = YES;
}

- (void)qb_addNotificationUpdateModel
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qb_notification_updateNewModel) name:NOTIFICATION_UPDATE_MYINFO object:nil];
}

- (void)qb_removeNotificationUpdateModel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATE_MYINFO object:nil];
}

- (void)qb_postNotificationUpdateModel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_MYINFO object:nil];\
}


- (void)qb_addNotificationDeviceOrientationDidChange
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qb_notification_updateNewDeviceOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)qb_removeNotificationDeviceOrientationDidChange
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void)qb_notification_updateNewModel
{
    if([self respondsToSelector:@selector(updateUIbyModel)])
    {
        [self updateUIbyModel];
    }
}

- (void)qb_notification_updateNewDeviceOrientation
{
    if([self respondsToSelector:@selector(updateUIByDeviceOrientation)])
    {
        [self updateUIByDeviceOrientation];
    }
}

- (void)qb_setNavLeftButtonSpace
{
    // Do any additional setup after loading the view.
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -6;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:self.qb_leftBarButton];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, self.qb_leftBarButton, nil]];
}

- (void)qb_setNavRigthButtonSpace
{
    // Do any additional setup after loading the view.
    [self.rightButton sizeToFit];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -2;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setRightBarButtonItem:self.qb_rightBarButton];
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, self.qb_rightBarButton,nil]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:NSStringFromClass([self class])];
    
//    [self qb_showBackButton:YES];

    [self qb_setNavLeftButtonSpace];
    [self qb_setNavRigthButtonSpace];
    //设置默认颜色
    
    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
}

- (void)qb_showRigthtTip:(NSString *)tipMessage
{
    if(self.rigthTipView == nil)
    {
        self.rigthTipView = [[NIMRightTipView alloc]init];
        [self.view addSubview:self.rigthTipView];
    }
    else
    {
        return;
    }
    
    [self.rigthTipView setMessage:tipMessage];
    
    [self.rigthTipView setCenter:_CGP(GetWidth(self.view)+GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
    [UIView animateWithDuration:.4 animations:^{
        [self.rigthTipView setCenter:_CGP(GetWidth(self.view)-GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.4 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.rigthTipView setCenter:_CGP(GetWidth(self.view)+GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
        } completion:^(BOOL finished) {
            [self.rigthTipView removeFromSuperview];
            self.rigthTipView = nil;
        }];
    }];
}

- (void)qb_showRigthtTip:(NSString *)tipMessage icon:(BOOL)need
{
    if(need)
    {
        [self qb_showRigthtTip:tipMessage];
    }
    else
    {
        if(self.rigthTipView == nil)
        {
            self.rigthTipView = [[NIMRightTipView alloc]init];
            [self.view addSubview:self.rigthTipView];
        }
        else
        {
            return;
        }
        
        [self.rigthTipView setNoIconMessage:tipMessage];
        
        [self.rigthTipView setCenter:_CGP(GetWidth(self.view)+GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
        [UIView animateWithDuration:.4 animations:^{
            [self.rigthTipView setCenter:_CGP(GetWidth(self.view)-GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.4 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
                [self.rigthTipView setCenter:_CGP(GetWidth(self.view)+GetWidth(self.rigthTipView)/2, GetHeight(self.view)/2)];
            } completion:^(BOOL finished) {
                [self.rigthTipView removeFromSuperview];
                self.rigthTipView = nil;
            }];
        }];
    }
    
}


#pragma mark - style
- (void)qb_setHideNavBar:(BOOL)hideNavBar
{
    self.navigationController.navigationBarHidden = hideNavBar;
}

- (BOOL)qb_hideNavBar
{
    return self.navigationController.navigationBarHidden;
}

- (void)qb_setNavBarBackGroundImage:(NSString *)imageName
{
    [self.navigationController.navigationBar setBackgroundImage:[[self class] getNavImage:imageName] forBarMetrics:UIBarMetricsDefault];
}

- (void)qb_setNavBarTintColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTintColor:color];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
}

-(void)qb_setStatusBar_Default
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)qb_setStatusBar_Light
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)qb_setNavStyleTheme:(THEME_COLOR)theme
{
    UIImage  *t_leftImg     = nil;
    UIColor  *t_leftColor   = nil;
    NSString *t_bgNavImage  = nil;
    UIColor  *t_titleColor  = nil;
    if(theme == THEME_COLOR_RED)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg       = IMGGET(@"bg_nav_back");
        t_bgNavImage    = @"bg_qb_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
        [self.navigationController.navigationBar setTranslucent:YES];
        
    }
    else if(theme == THEME_COLOR_RED_NO_BACKICON)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg       = nil;
        t_bgNavImage    = @"bg_qb_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
        [self.navigationController.navigationBar setTranslucent:YES];
        
    }
    else if(theme == THEME_COLOR_WHITHE_NO_BACKICON)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"66666e"];
        t_leftImg       = nil;
        t_bgNavImage    = @"bg_rich_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"35353f"];

        [self qb_setStatusBar_Light];
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    else if(theme == THEME_COLOR_GRID)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg       = IMGGET(@"bg_nav_back");
        t_bgNavImage    = @"bg_profit02";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
        self.navigationController.navigationBar.alpha = 1;
        [self.navigationController.navigationBar setTranslucent:NO];
        
    }
    else if (theme == THEME_COLOR_WHITHE)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"66666e"];
        t_leftImg       = IMGGET(@"icon_titlebar_back");
        t_bgNavImage    = @"bg_rich_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"35353f"];
        [self qb_setStatusBar_Default];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        
    }
    
    else if (theme == THEME_COLOR_WHITHE_D)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"FFFFFF"];
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"bg_rich_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"FFFFFF"];
        [self qb_setStatusBar_Default];
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        
    }

    else if (theme == THEME_COLOR_TRANSPARENT_PINK)
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        
        t_leftColor     = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg       = IMGGET(@"bg_nav_back");
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
    }
    
    else if (theme == THEME_COLOR_TRANSPARENT_LIGHTGRAY)
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        
        t_leftColor     = [SSIMSpUtil getColor:@"ffffff"];
        t_leftImg       = IMGGET(@"bg_task_back_t_lg");
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
    }
    
    else if (theme == THEME_COLOR_TRANSPARENT_WHITE)
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        t_leftColor     = [SSIMSpUtil getColor:@"ffffff"];
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self qb_setStatusBar_Light];
    }
    
    else if (theme == THEME_COLOR_BLACK)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"ffffff"];
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"bg_qb_topbar01";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
    }
    
    else if(theme == THEME_COLOR_BUSINESS)
    {
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"icon_activity_business_back");
        t_bgNavImage    = @"bg_qb_topbar_business";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
    }
    else if(theme == THEME_COLOR_BUSINESS_GRID)
    {
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"bg_profit_business";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        
    }
    else if (theme == THEME_COLOR_BUSINESS_TRANSPARENT)
    {
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"icon_activity_business_back");
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
    }
    else if (theme == THEME_COLOR_RED_PACKET)//红包的顶部栏
    {
        t_leftColor     = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg       = IMGGET(@"bg_nav_back");
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self.navigationController.navigationBar setBackgroundImage:[SSIMSpUtil createImageWithColor:[SSIMSpUtil getColor:@"f83619"]] forBarMetrics:UIBarMetricsDefault];//f94930
        [self.navigationController.navigationBar setTranslucent:YES];
        
        UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        navBarHairlineImageView.hidden = YES;
    }
    else if(theme == THEME_COLOR_BAOYUE){//宝约的顶部栏
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"baoyue_titlerbar";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    else if(theme == THEME_COLOR_ZHUSHOU){//钱宝助手
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"zhushou_titlerbar";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    else
    {
        return;
    }
    if(t_bgNavImage)
    {
        [self qb_setNavBarBackGroundImage:t_bgNavImage];
    }
    
    [self.labTitle   setTextColor:t_titleColor];
    [self.leftButton setTitleColor:t_leftColor  forState:UIControlStateNormal];
    [self.leftButton setImage:t_leftImg         forState:UIControlStateNormal];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 27)];
    [_leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
}

- (void)setTitleColor:(UIColor *)color
{
    _labTitle.textColor = color;
}

- (void)qb_labTitleSizeToFit
{
    [self.labTitle sizeToFit];
}

+ (UIImage*)getNavImage:(NSString*)navImage
{
    UIImage *t_navImage = IMGGET(navImage);
    if (IOS_VERSION >= 7)
    {
        t_navImage = [SSIMSpUtil scaleFromImage:t_navImage toSize:_CGS(GetWidth([UIApplication sharedApplication].keyWindow), 64)];
    }
    else
    {
        t_navImage = [SSIMSpUtil scaleFromImage:t_navImage toSize:_CGS(GetWidth([UIApplication sharedApplication].keyWindow), 44)];
    }
    
    return t_navImage;
}

#pragma mark - loading


- (void)qb_bringSubviewToFrontLoading
{
    [self.view bringSubviewToFront:self.progressHUD];
}

- (void)qb_showLoading
{
    [self qb_bringSubviewToFrontLoading];
    [self qb_showLoadingWithCustomView:self.loadingImageView animal:YES];
}



- (void)qb_showLoadingWithCustomView:(UIView*)customView animal:(BOOL)animal
{
    [self qb_showLoadingWithCustomView:customView title:nil animal:animal];
}




- (void)qb_showLoadingWithCustomView:(UIView*)customView title:(NSString*)loadingTitle animal:(BOOL)animal
{
    if(customView == nil)
    {
        customView = self.loadingImageView;
    }
    self.progressHUD.customView = customView;
    
    if(animal)
    {
        [self qb_addAnimation];
    }
    
    if(loadingTitle)
    {
        self.progressHUD.detailsLabelText = loadingTitle;
        self.progressHUD.detailsLabelFont = FONT_TITLE(10);
    }
    [self.progressHUD show:YES];
}

- (void)qb_addAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation           = [CABasicAnimation animationWithKeyPath:KEYPAHT_LOADINGANIMAL];
    rotationAnimation.toValue   = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration  = 3;
    rotationAnimation.cumulative    = YES;
    rotationAnimation.repeatCount   = CGFLOAT_MAX;
    rotationAnimation.fillMode  = kCAFillModeBoth;
    
    [self.progressHUD.customView.layer addAnimation:rotationAnimation forKey:KEY_LOADINGANIMAL];
}


//- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock
//{
//    self.progressHUD.completionBlock = completeBlock;
//    
//    [self.progressHUD hide:YES];
//    
//    [self.progressHUD.customView.layer removeAnimationForKey:KEY_LOADINGANIMAL];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qb_back
{
    // modify by shiji
    if (self.popLevel == ROOT_LEVEL) {
//        NSInteger ctrlCount = self.navigationController.viewControllers.count;
//        [self.navigationController popToViewController:self.navigationController.viewControllers[3] animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)qb_backWithoutAnimated
{
    if (self.popLevel == ROOT_LEVEL) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)qb_back_toSuper:(id)viewContrller
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (vc == viewContrller)
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (void)qb_showBackButton:(BOOL)show
{
    self.navigationItem.hidesBackButton = YES;
    if(show)
    {
        [self qb_setNavLeftButtonSpace];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItems:nil];
    }
}

- (void)qb_setRightButtonHidden:(BOOL)hidden
{
    if(!hidden)
    {
        [self qb_setNavRigthButtonSpace];
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:nil];
    }
}

- (void)qb_showRightButton:(NSString *)buttonTitle
{
    [self qb_showRightButton:buttonTitle andBtnImg:nil tyleTheme:THEME_COLOR_WHITHE];
}

- (void)qb_showRightButton:(NSString *)buttonTitle andBtnImg:(UIImage *)image
{
    [self qb_showRightButton:buttonTitle andBtnImg:image tyleTheme:THEME_COLOR_WHITHE];
}

- (void)qb_showRightButton:(NSString *)buttonTitle andBtnImg:(UIImage *)image tyleTheme:(THEME_COLOR)theme
{
    [self.rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.rightButton setTitle:buttonTitle forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    if (image)
    {
        self.rightButton.frame = _CGR(0, 0, image.size.width, image.size.height);
    }
    
    if(theme == THEME_COLOR_RED)
    {
        [self.rightButton setTitleColor:_COLOR_WHITE forState:UIControlStateNormal];
        
    }
    else if (theme == THEME_COLOR_WHITHE)
    {
      [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"66666e"] forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_TRANSPARENT_PINK)
    {
        [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"FFFFFF"] forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_BUSINESS)
    {
        [self.rightButton setTitleColor:__COLOR_C7CCE6__ forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_BUSINESS_GRID)
    {
        [self.rightButton setTitleColor:__COLOR_C7CCE6__ forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_UNENABLED)
    {
        [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"ff8d79"] forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_BUSINESS_UNENABLED)
    {
        [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"8a90b3v"] forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_BAOYUE){
        [self.rightButton sizeToFit];
        [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"FFFFFF"] forState:UIControlStateNormal];
        return;
    }
    
    
    [self qb_setNavRigthButtonSpace];
}

- (void)qb_showLeftButtonWithImg:(UIImage *)image
{
    self.qb_leftBarButton = nil;
    [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setTitle:nil forState:UIControlStateNormal];
    [self qb_setNavLeftButtonSpace];
}

- (void)qb_showRightButtonWithImg:(UIImage *)image
{
    self.qb_rightBarButton = nil;
    [self.rightButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [self.rightButton setTitle:nil forState:UIControlStateNormal];
    [self qb_setNavRigthButtonSpace];
}


- (void)qb_setEnabledLeft:(BOOL)enabled
{
    if(enabled)
    {
        NSArray *t_items = self.navigationItem.leftBarButtonItems;
        for (UIBarButtonItem *t_subItem in t_items)
        {
            t_subItem.enabled = YES;
        }
    }
    else
    {
        [self.navigationItem.leftBarButtonItems makeObjectsPerformSelector:@selector(setEnabled:) withObject:@NO];
    }
}

- (void)qb_setEnabledRight:(BOOL)enabled
{
    if(enabled)
    {
        NSArray *t_items = self.navigationItem.rightBarButtonItems;
        for (UIBarButtonItem *t_subItem in t_items)
        {
            t_subItem.enabled = YES;
        }
    }
    else
    {
        [self.navigationItem.rightBarButtonItems makeObjectsPerformSelector:@selector(setEnabled:) withObject:@NO];
    }
}


- (void)qb_rightButtonAction
{
    
}

- (void)qb_setTitleText:(NSString*)titleText
{
    
    titleText = [NIMBaseUtil splitString:titleText goalWidth:SCREEN_WIDTH-220];
    self.labTitle.text = titleText;
}

- (void)qb_setTitleButtonText:(NSString*)titleText
{
    if ([self.navigationItem.titleView isKindOfClass:[UIButton class]])
    {
        UIButton *titBtn = (UIButton *)self.navigationItem.titleView;
        [titBtn setTitle:titleText forState:UIControlStateNormal];
        [titBtn removeConstraint:_menuArrowConstrain];
        CGSize si = [titleText sizeWithAttributes:@{NSFontAttributeName:FONT_NUM_LIGHT(16)}];
        self.menuArrowConstrain = [NSLayoutConstraint constraintWithItem:_NIMMenuViewArrow
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:titBtn
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:si.width/2+10];
        [titBtn addConstraint:_menuArrowConstrain];
    }
}

- (void)qb_setTitleButton:(NSString*)titleText
{
    if (! _labTitle)
        [self qb_setTitleText:@""];//防止该属性在viewViewAppear重新对titleView赋值
    
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:_CGR(0, 0, 150, 35)];
    [titleBtn setTitle:titleText forState:UIControlStateNormal];
    titleBtn.titleLabel.font = FONT_NUM_LIGHT(16);
    titleBtn.backgroundColor = _COLOR_CLEAR;
    [titleBtn addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    CGSize si = [titleText sizeWithAttributes:@{NSFontAttributeName:FONT_NUM_LIGHT(16)}];
//    [titleBtn setImage:IMGGET(@"icon_discover_shearhead2.png") forState:UIControlStateNormal];
//    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (si.width+GetWidth(titleBtn))/2+5, 0, 0)];
//    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -si.width/2, 0, 0)];
    self.navigationItem.titleView = titleBtn;
    
    [titleBtn addSubview:self.NIMMenuViewArrow];
    self.menuArrowConstrain = [NSLayoutConstraint constraintWithItem:_NIMMenuViewArrow
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:titleBtn
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:si.width/2];
    [titleBtn addConstraint:_menuArrowConstrain];
    [titleBtn addConstraint:[NSLayoutConstraint constraintWithItem:_NIMMenuViewArrow
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:titleBtn
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
}


- (void)initialNIMMenuView:(NSArray *)menuDataSource andCell:(Class)cellClassType andResponseder:(id)responseder
{
    [self menuBackView];
    
    NIMMenuView *mView = [[NIMMenuView alloc] initWithSourse:menuDataSource andCell:cellClassType];
    mView.translatesAutoresizingMaskIntoConstraints = NO;
    mView.backgroundColor = _COLOR_WHITE;
    mView.delegate = responseder;
    self.NIMMenuView = mView;
    [self.view addSubview:_NIMMenuView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_NIMMenuView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_NIMMenuView)]];
    NSString *str = [NSString stringWithFormat:@"V:|[_NIMMenuView(%.0f)]",menuDataSource.count*58.0];
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:str
                                                           options:0
                                                           metrics:nil
                                                             views:NSDictionaryOfVariableBindings(_NIMMenuView)];
    self.constraint = arr;
    
    NSArray *arr2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_NIMMenuView(0)]"
                                                            options:0
                                                            metrics:nil
                                                              views:NSDictionaryOfVariableBindings(_NIMMenuView)];
    self.constraint2 = arr2;
    [self.view addConstraints:_constraint2];
    _menuBackView.hidden = YES;
    
}

- (void)titleBtnAction
{
    [self.view bringSubviewToFront:_NIMMenuView];
    if (GetHeight(_NIMMenuView)>0)
    {

        [UIView animateWithDuration:0.3 animations:^{
             _NIMMenuViewArrow.transform = CGAffineTransformMakeRotation(0);
            [self.view removeConstraints:_constraint];
            [self.view addConstraints:_constraint2];
            _menuBackView.hidden = YES;
//            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {

        [UIView animateWithDuration:0.3 animations:^{
            _NIMMenuViewArrow.transform = CGAffineTransformMakeRotation(M_PI);
            [self.view removeConstraints:_constraint2];
            [self.view addConstraints:_constraint];
            _menuBackView.hidden = NO;
//            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)qb_setLeftButtonTitle:(NSString*)leftTitle
{
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
}

#pragma mark - 异常展示行为
- (void)qb_showNoDataView:(NSString*)noteTitle
{
    return [self qb_showNoDataView:noteTitle atView:self.view];
}

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView withImage:(UIImage*)image{
    [self qb_showNoDataView:noteTitle atView:superView];
    if(image){
        self.qbm_viewNoData.iconError.image = image;
    }
}

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView
{
    return [self qb_showNoDataView:noteTitle atView:superView offset:CGPointZero];
}

- (void)qb_showNoDataView:(NSString*)noteTitle atView:(UIView*)superView offset:(CGPoint)offset
{
    [superView addSubview:self.qbm_viewNoData];
    self.qbm_viewNoData.labError.text = noteTitle;

    CGFloat height = 0;
    if(self.qbm_viewNoData.userIMG)
    {
        height = 150;
    }
    else
    {
        height = 50;
    }

    
    [self.qbm_viewNoData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX).offset(offset.x);
        make.centerY.equalTo(superView.mas_centerY).offset(offset.y);
        make.width.equalTo(@(200));
        make.height.equalTo(@(height));
    }];
}

- (void)qb_hideNoDataView
{
    [self.qbm_viewNoData removeFromSuperview];
}

- (void)qb_showErrorView
{
    return [self qb_showErrorViewAtView:self.view];
}

- (void)qb_showErrorViewAtView:(UIView*)superView
{
    return [self qb_showErrorViewAtView:superView offset:CGPointZero];
}

- (void)qb_showErrorViewAtView:(UIView*)superView offset:(CGPoint)offset
{
    [superView addSubview:self.qbm_viewError];
    CGFloat height = 0;
    if(self.qbm_viewError.userIMG)
    {
        height = 190;
    }
    else
    {
        height = 100;
    }
    [self.qbm_viewError mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX).offset(offset.x);
        make.centerY.equalTo(superView.mas_centerY).offset(offset.y);
        make.width.equalTo(@(200));
        make.height.equalTo(@(height));
    }];
}

- (void)doErrHandle:(NIMWTErrorView *)sender
{
    [self qb_reflashErrorView];
}

- (void)qb_hideErrorView
{
    [self.qbm_viewError removeFromSuperview];
}


- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock
{
    self.progressHUD.completionBlock = completeBlock;
    
    [self.progressHUD hide:YES];
    
    [self.progressHUD.customView.layer removeAnimationForKey:KEY_LOADINGANIMAL];
}

#pragma mark - 统一提示处理
- (void)qb_doNoteByResult:(NIMResultMeta*)result superView:(UIView*)superView
{
    //[self qb_hideLoadingWithCompleteBlock:^{
//        if(result.code == QBIMErrorAbnormal ||
//           result.code == QBIMErrorConnect)
//        {
//            [self qb_showErrorViewAtView:superView];
//        }
//        else
//        {
//            [superView showTipsView:result.message afterDelay:1.0 completeBlock:nil];
//        }
//    }];
}

#pragma mark - setter

- (void)setQb_expectionUserIcon:(BOOL)qb_expectionUserIcon
{
    _qb_expectionUserIcon = qb_expectionUserIcon;
    self.qbm_viewError.userIMG = qb_expectionUserIcon;
    self.qbm_viewNoData.userIMG = qb_expectionUserIcon;
}


#pragma mark - getter
_GETTER_BEGIN(UIButton, leftButton)
{
    _leftButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _CLEAR_BACKGROUND_COLOR_(_leftButton);
    _leftButton.exclusiveTouch  = YES;
    _leftButton.frame           = _CGR(0, 0, 60, 28);
    [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:FONT_TITLE(16)];
    [_leftButton addTarget:self action:@selector(qb_back) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(leftButton)

_GETTER_BEGIN(UILabel, uCountL)
{
    _uCountL     = [[UILabel alloc] initWithFrame:CGRectZero];
    _CLEAR_BACKGROUND_COLOR_(_uCountL);
    _uCountL.exclusiveTouch  = YES;
    _uCountL.frame           = _CGR(CGRectGetMaxX(self.leftButton.frame)-10, 0, 50, 28);
    _uCountL.font = FONT_TITLE(14);
    _uCountL.textAlignment = NSTextAlignmentLeft;
    _uCountL.textColor = [SSIMSpUtil getColor:@"66666e"];
    _uCountL.hidden = YES;
}
_GETTER_END(uCountL)

_GETTER_BEGIN(UIButton, rightButton)
{
    _rightButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = _CGR(0, 0, 60, 25);
    _CLEAR_BACKGROUND_COLOR_(_rightButton);
    _rightButton.exclusiveTouch  = YES;
    [_rightButton sizeToFit];
    [_rightButton addTarget:self action:@selector(qb_rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.titleLabel.font = FONT_TITLE(16);
}
_GETTER_END(rightButton)

_GETTER_BEGIN(UIBarButtonItem, qb_leftBarButton)
{
    UIView *t_leftView = _ALLOC_OBJ_WITHFRAME_(UIView, _CGR(0, 0, 45, 30));
    [t_leftView addSubview:self.leftButton];
    [t_leftView addSubview:self.uCountL];
    _qb_leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:t_leftView];
}
_GETTER_END(qb_leftBarButton)

_GETTER_BEGIN(UIBarButtonItem, qb_rightBarButton)
{
    _qb_rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}
_GETTER_END(qb_rightBarButton)

//_GETTER_BEGIN(UILabel, labTitle)
//{
//    _CREATE_LABEL_ALIGN_BOLDFONT(_labTitle, _CGR(0, 0, 120, 35), ALIGN_CENTER, 19);
//    self.navigationItem.titleView = _labTitle;
//}
//_GETTER_END(labTitle)

-(NIMQBLabel *)labTitle
{
    if (!_labTitle) {
        _labTitle = [[NIMQBLabel alloc] initWithFrame:_CGR(0, 0, 100, 35)];
//        _labTitle.edgeInsets = UIEdgeInsetsMake(0, -10, 0, -10);
        _labTitle.backgroundColor = [UIColor clearColor];
        _labTitle.textAlignment = [SSIMSpUtil getAlign:ALIGNTYPE_CENTER];
        _labTitle.font = BOLDFONT_TITLE(19);
        self.navigationItem.titleView = _labTitle;
    }
    return _labTitle;
}

_GETTER_BEGIN(MBProgressHUD, progressHUD)
{
    if(self.isViewLoaded)
    {
        _progressHUD        = [[MBProgressHUD alloc] initWithView:self.view];
        //        _progressHUD.delegate = self;
        _progressHUD.mode   = MBProgressHUDModeCustomView;
//        _progressHUD.bezelView.color = [UIColor blackColor];
        [self.view addSubview:_progressHUD];
        
    }
}
_GETTER_END(progressHUD)

_GETTER_BEGIN(UIImageView, loadingImageView)
{
    _loadingImageView = [[UIImageView alloc]initWithImage:IMGGET(@"icon_point_load.png")];
}
_GETTER_END(loadingImageView)

_GETTER_BEGIN(NIMWTErrorView, qbm_viewError)
{
    _qbm_viewError = _ALLOC_OBJ_(NIMWTErrorView);
    _qbm_viewError.delegate = self;
}
_GETTER_END(qbm_viewError)

_GETTER_BEGIN(NIMTNoDataView, qbm_viewNoData)
{
    _qbm_viewNoData = _ALLOC_OBJ_(NIMTNoDataView);
    _qbm_viewNoData.delegate = self;
}
_GETTER_END(qbm_viewNoData)

_GETTER_BEGIN(UIImageView, NIMMenuViewArrow)
{
    _NIMMenuViewArrow = [[UIImageView alloc] initWithImage:IMGGET(@"icon_discover_shearhead2.png")];
    _NIMMenuViewArrow.translatesAutoresizingMaskIntoConstraints = NO;
}
_GETTER_END(NIMMenuViewArrow)

_GETTER_BEGIN(UIView, menuBackView)
{
    _menuBackView = [[UIView alloc] init];
    _menuBackView.translatesAutoresizingMaskIntoConstraints = NO;
    _menuBackView.backgroundColor = _COLOR_BLACK;
    _menuBackView.alpha = 0.4;
    [self.view addSubview:_menuBackView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_menuBackView]|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:NSDictionaryOfVariableBindings(_menuBackView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuBackView]|"
                                                                      options:0
                                                                      metrics:0
                                                                        views:NSDictionaryOfVariableBindings(_menuBackView)]];
    
}
_GETTER_END(menuBackView)

//隐藏navbar的地步分割线
- (UIImageView*)findHairlineImageViewUnder:(UIView*)view {
    
    if([view isKindOfClass:UIImageView.class] && view.bounds.size.height<=1.0) {
        return(UIImageView*)view;
    }
    for(UIView *subview in view.subviews) {
        UIImageView*imageView = [self findHairlineImageViewUnder:subview];
        if(imageView) {
            return imageView;
        }
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
