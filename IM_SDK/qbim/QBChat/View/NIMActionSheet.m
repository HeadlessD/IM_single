//
//  NIMActionSheet.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/19.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMActionSheet.h"
#import "NIMImageButton.h"
#import "UIImage+NIMEllipse.h"
#define kCollectionViewHeight 178.0f
#define ItemHeight 50.0f
#define H [UIScreen mainScreen].bounds.size.height
#define W [UIScreen mainScreen].bounds.size.width
#define Color [UIColor colorWithRed:26/255.0f green:178.0/255.0f blue:10.0f/255.0f alpha:1]
#define Spacing 7.0f
#define KMaxSize CGSizeMake(W-20, 100)

@class NIMActionSheet;

@interface NIMActionSheet ()<UIGestureRecognizerDelegate>
{
    UIWindow *window;
}

@property (nonatomic,copy)      NSString *CancelStr;

@property (nonatomic,strong)    NSArray *Titles;

@property (nonatomic,weak)      UIView *ButtomView;

@property (nonatomic,copy)      NSString *AttachTitle;

@end

@implementation NIMActionSheet

-(instancetype) initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray *)Titles AttachTitle:(NSString *)AttachTitle{
    
    self = [super init];
    
    if (self) {
        
        _AttachTitle = AttachTitle;
        _CancelStr = str;
        _Titles = Titles;
        [self loadUI];
        [self addSubview];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissForThird) name:NC_SHEET_MISS object:nil];
    }
    
    return self;
}

-(void)addSubview
{
    UIViewController *toVC = [self appRootViewController];
    if (toVC.tabBarController != nil) {
        [toVC.tabBarController.view addSubview:self];
    }else if (toVC.navigationController != nil){
        [toVC.navigationController.view addSubview:self];
    }else{
        [toVC.view addSubview:self];
    }
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    [self adaptUIBaseOnOriention];
}

-(void)adaptUIBaseOnOriention
{
    CGFloat height;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    if ([self isBlankString:_AttachTitle]) {
        height = ((ItemHeight)+Spacing) + (_Titles.count * (ItemHeight));
    }else{
        CGSize size = [self markGetAuthenticSize:_AttachTitle Font:font MaxSize:KMaxSize];
        height  = ((ItemHeight)+Spacing) + (_Titles.count * (ItemHeight)) + (size.height+50);
    }
    UIView *views = [self viewWithTag:9090];
    UIView *TopView = [self viewWithTag:999];
    [TopView setFrame:CGRectMake(0, 0, W, H - height)];
    if (height > H) {
        [_ButtomView setFrame:CGRectMake(0, 0, W, H)];
        CGFloat He = H - (CGRectGetHeight(views.bounds) + Spacing);
        CGFloat BtnH = He / ((_Titles.count)+1);
        UIButton *Cancebtn = (UIButton *)[self viewWithTag:100];
        [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - BtnH, W, BtnH)];
        for (NSString *Title in _Titles) {
            NSInteger index = [_Titles indexOfObject:Title];
            
            UIButton *btn = (UIButton *)[_ButtomView viewWithTag:(index + 100)+1];
            //CGFloat hei = (BtnH * _ButtonTitles.count)+Spacing;
            //CGFloat y = (CGRectGetMinY(Cancebtn.frame) + (index * (BtnH))) - hei;
            CGFloat Y = (BtnH *index) + (CGRectGetHeight(views.bounds));
            [btn setFrame:CGRectMake(0, Y, W, BtnH)];
            UIView *lin = [btn viewWithTag:(index + 1010)+1];
            [lin setFrame:CGRectMake(0, 0.5f, W, 0.5f)];
        }
        return;
    }
    [_ButtomView setFrame:CGRectMake(0, H - height, W, height)];
    UIButton *Cancebtn = (UIButton *)[self viewWithTag:100];
    [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(_ButtomView.bounds) - ItemHeight, W, ItemHeight)];
    for (NSString *Title in _Titles) {
        NSInteger index = [_Titles indexOfObject:Title];
        
        UIButton *btn = (UIButton *)[_ButtomView viewWithTag:(index + 100)+1];
        CGFloat Y = (ItemHeight *index) + (CGRectGetHeight(views.bounds));
        [btn setFrame:CGRectMake(0, Y, W, ItemHeight)];
        UIView *lin = [btn viewWithTag:(index + 1010)+1];
        [lin setFrame:CGRectMake(0, 0, W, 0.5f)];
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


-(void)loadUI{
    
    /*self*/
    [self setFrame:CGRectMake(0, 0, W, H)];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    [self setBackgroundColor:[UIColor clearColor]];
    /*end*/
    
    /*buttomView*/
    UIView *ButtomView;
    UIView *TopView;
    NSInteger Ids = 0;
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统
//    if (version >= 8.0f) {
//
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//        ButtomView = [[UIVisualEffectView alloc] initWithEffect:blur];
//
//    }else if(version >= 7.0f){
//
//        ButtomView = [[UIToolbar alloc] init];
//
//    }else{
    
        ButtomView = [[UIView alloc] init];
        Ids = true;
        
//    }
    if (Ids == 1) {
        ButtomView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:226.0f/255.f blue:236.0f/255.0f alpha:1];
    }
    CGFloat height;
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGSize size = [self markGetAuthenticSize:_AttachTitle Font:font MaxSize:KMaxSize];
    
    if ([self isBlankString:_AttachTitle]) {
        height = ((ItemHeight)+Spacing) + (_Titles.count * (ItemHeight));
    }else{
        height  = ((ItemHeight)+Spacing) + (_Titles.count * (ItemHeight)) + (size.height+50);
    }
    
    [ButtomView setFrame:CGRectMake(0, H, W, height)];
    _ButtomView = ButtomView;
    ButtomView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:ButtomView];
    
    TopView = [[UIView alloc] init];
    TopView.backgroundColor = [UIColor clearColor];
    [TopView setTag:999];
    [TopView setFrame:CGRectMake(0, 0, W, H)];
    TopView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    [self addSubview:TopView];
    /*end*/
    
    /*CanceBtn*/
    UIButton *Cancebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [Cancebtn setFrame:CGRectMake(0, CGRectGetHeight(ButtomView.bounds) - ItemHeight, W, ItemHeight)];
    [Cancebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Cancebtn setTitle:_CancelStr forState:UIControlStateNormal];
    [Cancebtn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
    [Cancebtn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f]];
    [Cancebtn addTarget:self action:@selector(scaleToSmall:)
       forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [Cancebtn addTarget:self action:@selector(scaleAnimation:)
       forControlEvents:UIControlEventTouchUpInside];
    [Cancebtn addTarget:self action:@selector(scaleToDefault:)
       forControlEvents:UIControlEventTouchDragExit];
    [Cancebtn titleLabel].font = [UIFont systemFontOfSize:18.0f];
    [Cancebtn setTag:100];
    [_ButtomView addSubview:Cancebtn];
    /*end*/
    
    /*Items*/
    for (NSString *Title in _Titles) {
        
        NSInteger index = [_Titles indexOfObject:Title];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat hei = (50 * _Titles.count)+Spacing;
        CGFloat y = (CGRectGetMinY(Cancebtn.frame) + (index * (ItemHeight))) - hei;
        
        [btn setFrame:CGRectMake(0, y, W, ItemHeight)];
        [btn setTag:(index + 100)+1];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:Title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [btn titleLabel].font = [UIFont systemFontOfSize:18.0f];
        [btn addTarget:self action:@selector(SelectedButtons:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(scaleToSmall:)
      forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(scaleAnimation:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(scaleToDefault:)
      forControlEvents:UIControlEventTouchDragExit];
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        [btn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f]];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-ItemHeight+10, y+15, ItemHeight-30, ItemHeight-30)];
        imgView.image = [IMGGET(@"icon_discover_check") nim_imageWithColor:[UIColor grayColor]];
        imgView.tag = (index + 10000)+1;
        imgView.hidden = YES;
        
        UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, 0, W, 0.5f)];
        lin.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1];
        [_ButtomView addSubview:btn];
        [_ButtomView addSubview:imgView];
        [lin setTag:(index + 1010)+1];
        lin.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        [btn addSubview:lin];
    }
    /*END*/
    
    if ([self isBlankString:_AttachTitle]) {
        
    }else{
        
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, size.height+50)];
        views.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        
        views.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f];
        UILabel *AttachTitleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, W-20, size.height+50)];
        AttachTitleView.font = font;
        AttachTitleView.textColor = [UIColor grayColor];
        AttachTitleView.text = _AttachTitle;
        AttachTitleView.numberOfLines = 0;
        AttachTitleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        AttachTitleView.textAlignment = 1;
        AttachTitleView.font = [UIFont systemFontOfSize:15.0f];
        [_ButtomView addSubview:views];
        [views addSubview:AttachTitleView];
        [views setTag:9090];
        //[self layoutIfNeeded];
    }
    
    typeof(self) __weak weak = self;
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        //[weak setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]];
        [TopView setFrame:CGRectMake(0, 0, W, H - height)];
        [TopView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]];
        [ButtomView setFrame:CGRectMake(0, H - height, W, height+10)];
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weak action:@selector(dismiss:)];
        tap.delegate = self;
        [TopView addGestureRecognizer:tap];
        [ButtomView setFrame:CGRectMake(0, H - height, W, height)];
        [UIView animateWithDuration:0.2 animations:^{
            if (height > H) {
                [weak adaptUIBaseOnOriention];
            }
        }];
    }];
}

-(void)scaleToSmall:(UIButton *)btn{
    
    [UIView animateWithDuration:0.2 animations:^{
        [btn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0f]];
    }];
    
}

- (void)scaleAnimation:(UIButton *)btn{
    
    [UIView animateWithDuration:0.2 animations:^{
        [btn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.0f]];
    }];
    
}

- (void)scaleToDefault:(UIButton *)btn{
    
    [UIView animateWithDuration:0.2 animations:^{
        [btn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6f]];
    }];
    
}

-(void)SelectedButtons:(UIButton *)btns{
    
    typeof(self) __weak weak = self;
    [self DismissBlock:^(BOOL Complete) {
        
        if (!weak.ButtonIndex) {
            return ;
        }
        weak.ButtonIndex(btns.tag-100);
        
    }];
    
    
}

-(void) ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index{
    
    UIButton *btn = (UIButton *)[_ButtomView viewWithTag:index + 100];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
}

-(void) SelectImageAndIndex:(NSInteger )index{
    
    UIImageView *imgView = (UIImageView *)[_ButtomView viewWithTag:index + 10000];
    imgView.hidden = NO;
}

-(void)ButtonIndex:(SeletedButtonIndex)ButtonIndex{
    
    _ButtonIndex = ButtonIndex;
    
}

-(void)dismissForThird
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NC_SHEET_MISS object:nil];
    [self DismissBlock:^(BOOL Complete) {
        
    }];
}

-(void)dismiss:(UITapGestureRecognizer *)tap{
    if( CGRectContainsPoint(self.frame, [tap locationInView:_ButtomView])) {
        NSLog(@"tap");
    } else{
        
        [self DismissBlock:^(BOOL Complete) {
            
        }];
    }
}

-(void)DismissBlock:(CompleteAnimationBlock)block{
    
    
    typeof(self) __weak weak = self;
    CGFloat height = ((ItemHeight+0.5f)+Spacing) + (_Titles.count * (ItemHeight+0.5f)) + kCollectionViewHeight;
    UIView *TopView = [self viewWithTag:999];
    
    [UIView animateWithDuration:0.2 animations:^{
        [TopView setFrame:CGRectMake(0, 0, W, H)];
        [TopView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
        
        [_ButtomView setFrame:CGRectMake(0, H, W, height)];
        
    } completion:^(BOOL finished) {
        block(finished);
        [weak removeFromSuperview];
        
    }];
    
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)show{
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.alpha = 1;
    window.hidden = false;
    [window addSubview:self];
}

-(void)dealloc{
    NSLog(@"正常释放");
}

-(void)removeFromSuperview{
    NSArray *SubViews = [self subviews];
    for (id obj in SubViews) {
        [obj removeFromSuperview];
    }
    [window resignKeyWindow];
    [window removeFromSuperview];
    window = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
    NSLog(@"不能正常结束?");
}

-(CGSize)markGetAuthenticSize:(NSString *)text Font:(UIFont *)font MaxSize:(CGSize)size{
    
    //获取当前那本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    //实际尺寸
    CGSize actualSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualSize;
    
}

@end

