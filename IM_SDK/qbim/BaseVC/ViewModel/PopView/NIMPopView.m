//
//  NIMPopView.m
//  QianbaoIM
//
//  Created by liyan on 9/23/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMPopView.h"
#import "NIMPopBaseContextView.h"
#import "UIImage+NIMEffects.h"
#import "UIImage+NIMEllipse.h"
#import "NIMPopBaseContextView.h"

@interface NIMPopView()

@property (nonatomic, weak)NIMPopBaseContextView *contextView;
@property (nonatomic, strong)UIControl          *hideControl;

@property (nonatomic, strong) NSMutableArray    *animatableConstraints;

@property (nonatomic, strong) UIImageView       *imgView;//模糊

@property (nonatomic, strong) UIView            *bottomView;

@property (nonatomic, strong) UIButton          *closeBtn;

@property (nonatomic, strong) UILabel           *titleLabel;

@property (nonatomic, strong) UIView            *titleView;

@property (nonatomic, assign)float               contextHeight;

@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, assign) int                bottomTopHeigth;
@end


@implementation NIMPopView



- (id)init
{
    self = [super init];
    if(self)
    {
         self.backgroundColor = _COLOR_BLACK;
        
        self.imgView = [[UIImageView alloc]initWithImage:nil];
        
        [self addSubview: self.imgView];

        
        UIView *bg = [[UIView alloc]init];
        bg.backgroundColor =_COLOR_BLACK;
        bg.alpha = 0.6;
        [self addSubview:bg];
        
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        self.hideControl = [[UIControl alloc]init];
        _CLEAR_BACKGROUND_COLOR_(self.hideControl);
        [self addSubview:self.hideControl];
        [self.hideControl addTarget:self action:@selector(closeACtion) forControlEvents:UIControlEventTouchUpInside];

        self.bottomView = [[UIView alloc]init];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bottomView];
        self.bottomView.layer.shadowColor = _COLOR_BLACK.CGColor;
        self.bottomView.layer.shadowOffset = CGSizeMake(0, -4);
        self.bottomView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
        
        
        
        self.lineView =  [[UIView alloc]init];
        self.lineView.backgroundColor = __COLOR_D5D5D5__;
        [self.bottomView addSubview:self.lineView];

        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:IMGGET(@"icon_discover_close.png") forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeACtion) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView addSubview:self.closeBtn];
        
        
        self.titleLabel = [[UILabel alloc]init];
        _CLEAR_BACKGROUND_COLOR_(self.titleLabel);
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textColor = __COLOR_262626__;
        
        [self.bottomView addSubview:self.titleLabel];

    }
    return self;
}

+ (instancetype)popView
{
    NIMPopView *view = [[NIMPopView alloc]init];
    return view;
    
}

#pragma mark - public
- (void)qb_show:(NIMPopBaseContextView *)contextView toUIViewController:(UIViewController *)viewController title:(NSString *)title
{
    //默认title样式
    
    self.titleLabel.hidden = NO;
    self.bottomTopHeigth = 70;
    [self.titleView removeFromSuperview];

    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@69);
        make.trailing.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@15);
        make.height.equalTo(@40);
        make.trailing.equalTo(self.closeBtn.mas_leading);
    }];
    
    [self.hideControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.top.equalTo(@11);
        make.trailing.equalTo(@(-2));
    }];
    
    [self qb_show:contextView toUIViewController:viewController];
    [self.titleLabel setText:title];

}


- (void)qb_showUIView:(UIView *)view toUIViewController:(UIViewController *)viewController title:(NSString *)title
{
    NIMPopBaseContextView *_contextV = nil;
    if(![view isKindOfClass:[NIMPopBaseContextView class]])
    {
        _contextV =  [[NIMPopBaseContextView alloc]initWithHeight:view.bounds.size.height];
        [_contextV addSubview:view];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(0));
            make.top.equalTo(@(0));
            make.trailing.equalTo(@(0));
            make.bottom.equalTo(@(0));
        }];
    }
    else
    {
        _contextV = (NIMPopBaseContextView *)view;
    }
    [self qb_show:_contextV toUIViewController:viewController title:title];
}

- (void)qb_showUIView:(UIView *)view toUIViewController:(UIViewController *)viewController titleView:(UIView *)titleView
{
    [self.titleView removeFromSuperview];
    self.titleView = titleView;
    self.titleLabel.hidden = YES;
    self.bottomTopHeigth = 92;
    [self.bottomView addSubview:self.titleView];
    
    
    
    self.titleLabel.hidden = YES;
    self.titleView.hidden = NO;
    //自定义样式
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@91);
        make.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];

    
    [self.hideControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@44);
        make.height.equalTo(@44);
        make.top.equalTo(@21);
        make.trailing.equalTo(@(-2));
    }];
    
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.closeBtn.mas_leading);
        make.height.equalTo(@70);
        make.top.equalTo(@11);
        make.leading.equalTo(@(15));
    }];
    
    if(![view isKindOfClass:[NIMPopBaseContextView class]])
    {
        NIMPopBaseContextView *_contextV =  [[NIMPopBaseContextView alloc]initWithFrame:view.bounds];
        [_contextV addSubview:view];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(0));
            make.top.equalTo(@(0));
            make.trailing.equalTo(@(0));
            make.bottom.equalTo(@(0));
        }];
        [self qb_show:_contextV toUIViewController:viewController];
    }
    else
    {
        [self qb_show:(NIMPopBaseContextView *)view  toUIViewController:viewController];
    }
}

- (void)qb_show:(NIMPopBaseContextView *)contextView toUIViewController:(UIViewController *)viewController
{
    
    contextView.popView = self;
    [self.contextView removeFromSuperview];
    self.contextView = contextView;
    self.contextHeight = contextView.bounds.size.height;
    NSData *imageData = UIImageJPEGRepresentation([UIImage nim_imgWithVC:viewController], 1);
    UIImage *img= [UIImage imageWithData:imageData];
    UIImage *vcImg = [img nim_blurredImage:.1];
    
    
    self.imgView.image = vcImg;
    
    
//    _GET_APP_DELEGATE_(appDelegate);
//    UIWindow *window = appDelegate.window;
     UIWindow *window = self.window;
//    [window addSubview:self];
    [viewController.navigationController.view addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    float k = 1;
    self.animatableConstraints = @[].mutableCopy;
    
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        [self.animatableConstraints addObjectsFromArray:@[
                                                          make.width.equalTo(@(window.bounds.size.width *k)),
                                                          make.height.equalTo(@(window.bounds.size.height *k)),
                                                          make.centerY.equalTo(self.mas_centerY)
                                                          ]];
        make.centerX.equalTo(self.mas_centerX);
    }];
    
   
   
    CGSize size = contextView.bounds.size;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        [self.animatableConstraints addObjectsFromArray:@[
                                                          make.bottom.equalTo(@((size.height +self.bottomTopHeigth)))
                                                          ]];
        make.leading.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(size.height +self.bottomTopHeigth));
    }];
    
    [self.bottomView addSubview:contextView];
    
    [contextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@(size.height));
    }];
   
    [self performSelector:@selector(initContextView) withObject:nil afterDelay:.01];
}

- (void)qb_hide
{
    //动画
    [self animateWithEnd];
}

- (void)moveUpInset:(float)upInset
{
    MASConstraint *constraint = [self.animatableConstraints objectAtIndex:3];
    constraint.equalTo(@(-upInset));

    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished)
     {
     }];
}

#pragma mark - btn action

- (void)closeACtion
{
    [self animateWithEnd];
}

#pragma mark - animate

- (void)initContextView
{
    [self.contextView show];
    [self performSelector:@selector(animateWithBegin) withObject:nil afterDelay:.01];
}

- (void)animateWithBegin
{
//    _GET_APP_DELEGATE_(appDelegate);
//    UIWindow *window = appDelegate.window;
     UIWindow *window = self.window;
    float k =0.8;
    
    MASConstraint *constraint = [self.animatableConstraints objectAtIndex:0];
    constraint.equalTo(@(window.bounds.size.width *k)),
    
    constraint = [self.animatableConstraints objectAtIndex:1];
    constraint.equalTo(@(window.bounds.size.height *k)),
    constraint = [self.animatableConstraints objectAtIndex:2];
    constraint.offset(-20);
    
    constraint = [self.animatableConstraints objectAtIndex:3];
    constraint.equalTo(@0);
    
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished)
     {
         
         if([self.delegate respondsToSelector:@selector(popViewDidShowEnd)])
         {
             [self.delegate popViewDidShowEnd];
         }
     }];
    
    //注册通知
    [self initHiddenPopViewNotification];
}

- (void)animateWithEnd
{
//    _GET_APP_DELEGATE_(appDelegate);
//    UIWindow *window = appDelegate.window;
     UIWindow *window = self.window;
    float k =1;
    
    if([self.animatableConstraints count] == 4)
    {
        MASConstraint *constraint = [self.animatableConstraints objectAtIndex:0];
        constraint.equalTo(@(window.bounds.size.width *k)),
        
        constraint = [self.animatableConstraints objectAtIndex:1];
        constraint.equalTo(@(window.bounds.size.height *k)),
        constraint = [self.animatableConstraints objectAtIndex:2];
        constraint.offset(0);
        
        constraint = [self.animatableConstraints objectAtIndex:3];
        constraint.equalTo(@((self.contextHeight +self.bottomTopHeigth)));
        
        
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            //repeat!
            if([self.delegate respondsToSelector:@selector(popViewDidCloseEnd)])
            {
                [self.delegate popViewDidCloseEnd];
            }
            
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
    
    //移除通知
    [self removeHiddenPopViewNotification];
}

/*********************************************************************
 函数名称 : initHiddenPopViewNotification
 函数描述 :初始化隐藏PopView的通知，用于检测粘贴板上有商品链接，进入本本程序时跳转商品详情时,
        PopView在当前页面而无法进入商品详情，先隐藏
 参数  :N/A
 返回值 :N/A
 作者 : yan_hao
 *********************************************************************/
-(void)initHiddenPopViewNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeACtion)
                                                 name:NOTIFICATION_DISSMISS_POPVIEW
                                               object:nil];
    
}

/*********************************************************************
 函数名称 : removeHiddenPopViewNotification
 函数描述 :移除隐藏PopView的通知
 参数  :gN/A
 返回值 :N/A
 作者 : yan_hao
 *********************************************************************/
-(void)removeHiddenPopViewNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_DISSMISS_POPVIEW object:nil];
}

#pragma mark - private api


@end
