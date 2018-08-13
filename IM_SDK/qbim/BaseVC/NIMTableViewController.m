//
//  NIMTableViewController.m
//  QianbaoIM
//
//  Created by Yun on 14-8-11.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "UIViewController+NIMQBaoUI.h"
#import "NIMTNoDataView.h"
#import "NIMWTErrorView.h"
#import "NIMViewController.h"
//#import "UIBarButtonItem+NavaBadge.h"
#define KEYPAHT_LOADINGANIMAL   @"transform.rotation"
#define KEY_LOADINGANIMAL       @"rotationAnimation"

@interface NIMTableViewController ()<NIMViewControllerDelegate,NIMWTErrorViewDelegate,NIMTNoDataViewDelegate>

//@property (nonatomic, strong) MBProgressHUD     *progressHUD;
@property (nonatomic, strong) UIImageView       *loadingImageView;
@property (nonatomic, strong) NIMWTErrorView          *qbm_viewError;
@property (nonatomic, strong) NIMTNoDataView         *qbm_viewNoData;

@end


@implementation NIMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receImageView.hidden = YES;
    [self.labTitle addSubview:self.receImageView];
    [self qb_setTitleText:self.navigationItem.title];
    
    [self qb_setStatusBar_Light];
    self.view.backgroundColor = [UIColor whiteColor];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBackgroundImage:[[self class] getNavImage:@"bg_qb_topbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.separatorColor = __COLOR_E6E6E6__;
    self.tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self.tableView setFrame:CGRectMake(0, IPX_NAVI_H, SCREEN_WIDTH, SCREEN_HEIGHT-IPX_NAVI_H-IPX_BOTTOM_SAFE_H)];

}


#pragma mark - Private
-(void)buttonPress:(id)sender
{
    //方法调用直接清楚角标
//    self.navigationItem.leftBarButtonItem.badgeValue = @"";
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [TalkingData trackPageEnd:NSStringFromClass([self class])];
    //    _GET_APP_DELEGATE_(app);
    //    [app.applicationActionSheet dismissWithClickedButtonIndex:app.applicationActionSheet.cancelButtonIndex animated:NO];
}


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
    [self.navigationController.navigationBar setBackgroundImage:IMGGET(imageName) forBarMetrics:UIBarMetricsDefault];
}

- (void)qb_setNavBarTintColor:(UIColor *)color
{
    [self.navigationController.navigationBar setTintColor:color];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
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
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    else if (theme == THEME_COLOR_WHITHE_K)
    {
        t_leftColor     = [SSIMSpUtil getColor:@"222222"];
        t_leftImg       = IMGGET(@"icon_titlebar_back");
        t_bgNavImage    = @"bg_rich_topbar";
        t_titleColor    = [SSIMSpUtil getColor:@"222222"];
        
        [self qb_setStatusBar_Default];
        [self.navigationController.navigationBar setTranslucent:YES];
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
        //        self.navigationController.navigationBar.alpha = 1;
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
        //        self.navigationController.navigationBar.alpha = 1;
    }
    
    else if (theme == THEME_COLOR_TRANSPARENT_WHITE)
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        [self.navigationController.navigationBar setTranslucent:YES];
        //        self.navigationController.navigationBar.alpha = 1;
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
        //        self.navigationController.navigationBar.alpha = 0.7;
        
    }
    else if(theme == THEME_COLOR_BUSINESS)
    {
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"icon_activity_business_back.png");
        t_bgNavImage    = @"bg_qb_topbar_business";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
    }
    else if(theme == THEME_COLOR_BUSINESS_GRID)
    {
        t_leftColor     = __COLOR_C7CCE6__;
        t_leftImg       = IMGGET(@"bg_nav_back_black");
        t_bgNavImage    = @"bg_profit_business";
        t_titleColor    = [SSIMSpUtil getColor:@"ffffff"];
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
    [_leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
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


- (void)qb_setNavLeftButtonStyle:(UIButton*)leftButton theme:(THEME_COLOR)theme
{
    UIImage  *t_leftImg   = nil;
    UIColor  *t_leftColor = nil;
    if(theme == THEME_COLOR_RED)
    {
        t_leftColor = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg   = IMGGET(@"bg_nav_back");
        [self.navigationController.navigationBar setBackgroundImage:[[self class] getNavImage:@"bg_qb_topbar"] forBarMetrics:UIBarMetricsDefault];
    }
    else if (theme == THEME_COLOR_WHITHE)
    {
        t_leftColor = [SSIMSpUtil getColor:@"fac6bd"];
        t_leftImg   = IMGGET(@"bg_nav_back");
    }
    else
    {
        return;
    }
    
    [leftButton setTitleColor:t_leftColor forState:UIControlStateNormal];
    [leftButton setImage:t_leftImg forState:UIControlStateNormal|UIControlStateSelected|UIControlStateHighlighted];
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [TalkingData trackPageBegin:NSStringFromClass([self class])];
    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
    [self qb_showBackButton:YES];
}


#pragma mark -- loading

- (void)qb_showLoading
{
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
    //    self.progressHUD.customView = customView;
    
    if(animal)
    {
        [self qb_addAnimation];
    }
    
    if(loadingTitle)
    {
        //        self.progressHUD.labelText = loadingTitle;
        //        self.progressHUD.labelFont = FONT_TITLE(10);
    }
    //    [self.progressHUD show:YES];
}
- (void)qb_showLeftButtonWithImg:(UIImage *)image
{
    self.qb_leftBarButton = nil;
    [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setTitle:nil forState:UIControlStateNormal];
    [self qb_setNavLeftButtonSpace];
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
    
    //    [self.progressHUD.customView.layer addAnimation:rotationAnimation forKey:KEY_LOADINGANIMAL];
}


//- (void)qb_hideLoadingWithCompleteBlock:(MBProgressHUDCompletionBlock)completeBlock
//{
//    self.progressHUD.completionBlock = completeBlock;
//
//    [self.progressHUD hide:YES];
//
//    [self.progressHUD.customView.layer removeAnimationForKey:KEY_LOADINGANIMAL];
//}


- (void)qb_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qb_showBackButton:(BOOL)show
{
    if(show)
    {
        [self qb_setNavLeftButtonSpace];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)qb_rightButtonAction
{
    
}
- (void)qb_showRightButton:(NSString *)buttonTitle
{
    [self qb_showRightButton:buttonTitle andBtnImg:nil tyleTheme:THEME_COLOR_RED];
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
        [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    else if (theme == THEME_COLOR_WHITHE)
    {
        [self.rightButton setTitleColor:__COLOR_FF432F__ forState:UIControlStateNormal];
    }
    else if (theme == THEME_COLOR_TRANSPARENT_PINK)
    {
        [self.rightButton setTitleColor:[SSIMSpUtil getColor:@"FFFFFF"] forState:UIControlStateNormal];
    }
    
    else if(theme == THEME_COLOR_BUSINESS)
    {
        [self.rightButton setTitleColor:__COLOR_C7CCE6__ forState:UIControlStateNormal];
    }
    else if(theme == THEME_COLOR_BUSINESS_GRID)
    {
        [self.rightButton setTitleColor:__COLOR_C7CCE6__ forState:UIControlStateNormal];
    }
    
    [self qb_setNavRigthButtonSpace];
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


- (void)qb_setTitleText:(NSString*)titleText
{
    self.labTitle.text = titleText;
    
    CGFloat width = [titleText boundingRectWithSize:CGSizeMake(100, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.width;

    CGFloat offset = 80+width/2.0;

    [self.receImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle.mas_centerY);
        make.width.equalTo(@(19));
        make.height.equalTo(@(19));
        make.leading.equalTo(self.labTitle.mas_leading).with.offset(offset);
    }];
    
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
        height = 100;
    }
    else
    {
        height = 50;
    }
    float systemName = [[[UIDevice currentDevice]systemVersion]floatValue];
    if(systemName >= 8.0){
        [self.qbm_viewNoData mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(superView.mas_centerX);
            make.centerY.equalTo(superView.mas_centerY).offset(-64);
            make.width.equalTo(@(200));
            make.height.equalTo(@(height));
        }];
    }else{
        CGPoint p=self.qbm_viewNoData.center;
        p.x = superView.center.x;
        p.y = superView.center.y-64;
        self.qbm_viewNoData.center = p;
    }
    
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
    
}

- (void)qb_hideErrorView
{
    [self.qbm_viewError removeFromSuperview];
}


-(void)qb_setStatusBar_Default
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)qb_setStatusBar_Light
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark -- getter
_GETTER_BEGIN(NIMWTErrorView, qbm_viewError)
{
    _qbm_viewError = _ALLOC_OBJ_(NIMWTErrorView);
    _qbm_viewError.delegate = self;
}
_GETTER_END(qbm_viewError)


_GETTER_BEGIN(UIBarButtonItem, qb_rightBarButton)
{
    _qb_rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}
_GETTER_END(qb_rightBarButton)


_GETTER_BEGIN(UIBarButtonItem, qb_leftBarButton)
{
    UIView *t_leftView = _ALLOC_OBJ_WITHFRAME_(UIView, _CGR(0, 0, 60, 30));
    [t_leftView addSubview:self.leftButton];
    _qb_leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:t_leftView];
}
_GETTER_END(qb_leftBarButton)

_GETTER_BEGIN(UILabel, labTitle)
{
    _CREATE_LABEL_ALIGN_BOLDFONT(_labTitle, _CGR(0, 0, 100, 35), ALIGN_CENTER, 19);
    self.navigationItem.titleView = _labTitle;
}
_GETTER_END(labTitle)

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

//_GETTER_BEGIN(MBProgressHUD, progressHUD)
//{
//    _progressHUD        = [[MBProgressHUD alloc] initWithView:self.view];
//    //        _progressHUD.delegate = self;
//    _progressHUD.mode   = MBProgressHUDModeCustomView;
//    [self.view addSubview:_progressHUD];
//}
//_GETTER_END(progressHUD)

_GETTER_BEGIN(UIImageView, loadingImageView)
{
    _loadingImageView = [[UIImageView alloc]initWithImage:IMGGET(@"icon_point_load.png")];
}
_GETTER_END(loadingImageView)


_GETTER_BEGIN(UIButton, rightButton)
{
    //    UIImage *btnImage   = IMGGET(@"icon_topbar_info_02.png");
    _rightButton    = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame  = _CGR(0, 0, 60, 25);
    _rightButton.titleLabel.font = FONT_TITLE(16);
    _CLEAR_BACKGROUND_COLOR_(_rightButton);
    _rightButton.exclusiveTouch  = YES;
    [_rightButton sizeToFit];
    [_rightButton addTarget:self action:@selector(qb_rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //    [_rightButton setImage:btnImage forState:UIControlStateNormal];
}
_GETTER_END(rightButton)
_GETTER_BEGIN(NIMTNoDataView, qbm_viewNoData)
{
    _qbm_viewNoData = _ALLOC_OBJ_(NIMTNoDataView);
    _qbm_viewNoData.delegate = self;
}
_GETTER_END(qbm_viewNoData)

_GETTER_BEGIN(UIImageView, receImageView)
{
    UIImage *image =  IMGGET(@"听");
    _receImageView = [[UIImageView alloc]initWithImage:image];
    
}
_GETTER_END(receImageView)
@end
