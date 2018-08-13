//
//  MBTip.m
//  QianbaoIM
//
//  Created by liyan on 14-4-9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "MBTip.h"
//#import "MBProgressHUD.h"

typedef enum _PopDir
{
    PopDirTop = 0,
    PopDirBottom,
}PopDir;

@interface TipsView : UIView{
    PopDir _toDir;
    NSString *_tips;
    UIView *_inview;
    
    BOOL _autoDismiss;
    NSInteger _dismisSec;
    CGSize _size;
    
    UILabel *_titleLabel;
}

@property (nonatomic, copy) NSString *tips;
@property (nonatomic, assign) BOOL  isNightStyle;
@property (nonatomic, retain) UIView *inview;


#pragma mark - functions
- (void)dismiss;

- (void)showTips;

#pragma mark init
- (id)initWithTips:(NSString *)tips
           andSize:(CGSize)size
             toDir:(PopDir)toDir
            inView:(UIView*)view
       autoDismiss:(BOOL)autoDismiss
             inSec:(NSInteger)sec
         textColor:(UIColor *)textColor
         backColor:(UIColor *)backColor;

@end

#define kTipsViewInterval 5.0f
#define kTipsBorderMargin 30.0f
#define kTipsFont [UIFont systemFontOfSize:15.0f]
#define kTipsLabelLeftMargin 10.0f
#define kTipsLabelTopMargin 5.0f

#define kBMTipsViewBackDayColor COLOR_RGBA(0, 0, 0, 0.8)
#define kBMTipsViewBackNightColor COLOR_RGBA(255, 255, 255, 0.8)

#define kBMTipsViewTextDayColor [UIColor whiteColor]
#define kBMTipsViewTextNightColor [UIColor blackColor]

@interface TipsView()
{
    UIColor     *_textColor;
    UIColor     *_backColor;
}

@property (nonatomic, retain) NSTimer *timer;

- (void)moveTipsview:(TipsView *)tipsview to:(PopDir)toDir;
- (void)startTimer;
- (void)stopTimer;
@end

@implementation TipsView
@synthesize tips = _tips;
@synthesize timer = _timer;
@synthesize isNightStyle = _isNightStyle;
@synthesize inview = _inview;

#pragma mark - lifecycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tips = nil;
    [_timer invalidate];
    self.timer = nil;
    _titleLabel = nil;
    _inview = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isNightStyle = NO;
        self.layer.cornerRadius = 2.0f;
        _titleLabel = [[UILabel alloc] initWithFrame:
                       CGRectMake(kTipsLabelLeftMargin,
                                  kTipsLabelTopMargin,
                                  self.bounds.size.width - 2 * kTipsLabelLeftMargin,
                                  self.bounds.size.height - 2 * kTipsLabelTopMargin)];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = _textColor;
        self.backgroundColor = _backColor;
        
        _titleLabel.font = kTipsFont;
        [self addSubview:_titleLabel];
        
    }
    return self;
}

- (void)setIsNightStyle:(BOOL)isNightStyle
{
    if (_isNightStyle != isNightStyle)
    {
        _isNightStyle = isNightStyle;
        if (_isNightStyle)
        {
            self.backgroundColor = kBMTipsViewBackNightColor;
            _titleLabel.textColor = kBMTipsViewTextNightColor;
        }
        else
        {
            self.backgroundColor = kBMTipsViewBackDayColor;
            _titleLabel.textColor = kBMTipsViewTextDayColor;
        }
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    if (PopDirBottom == _toDir)
    {
        self.frame = CGRectMake(floor((self.superview.bounds.size.width - _size.width)/2),
                                kTipsBorderMargin,
                                _size.width,
                                _size.height);
    }
    
    if (PopDirTop == _toDir)
    {
        self.frame = CGRectMake(floor((self.superview.bounds.size.width - _size.width)/2),
                                self.superview.bounds.size.height - _size.height - kTipsBorderMargin,
                                _size.width,
                                _size.height);
    }
}

- (id)initWithTips:(NSString *)tips
           andSize:(CGSize)size
             toDir:(PopDir)toDir
            inView:(UIView*)view
       autoDismiss:(BOOL)autoDismiss
             inSec:(NSInteger)sec
         textColor:(UIColor *)textColor
         backColor:(UIColor *)backColor
{
    if (textColor != nil)
    {
        _textColor = textColor;
    }
    else
    {
        _textColor = kBMTipsViewTextDayColor;
    }
    if (backColor != nil)
    {
        _backColor = backColor;
    }
    else
    {
        _backColor = kBMTipsViewBackDayColor;
    }
//    CGSize wordSize = [tips sizeWithFont:kTipsFont
//                       constrainedToSize:CGSizeMake(size.width - 2 * kTipsLabelLeftMargin, 1500)];
    
    
    CGSize wordSize = CGSizeZero;
    
    // use new sizeWithAttributes: if possible
    SEL selector = NSSelectorFromString(@"sizeWithAttributes:");
    if ([tips respondsToSelector:selector]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        NSDictionary *attributes = @{NSFontAttributeName:kTipsFont};
        wordSize = [tips sizeWithAttributes:attributes];
#endif
    }
    
    // otherwise use old sizeWithFont:
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
        wordSize = [tips sizeWithFont:kTipsFont];
#endif
    }
    
    CGRect rect = CGRectMake(floor((view.bounds.size.width - size.width)/2),
                             0,
                             size.width,
                             (size.height>(wordSize.height + 2 * kTipsLabelTopMargin))?size.height:(wordSize.height + 2 * kTipsLabelTopMargin));
    self = [self initWithFrame:rect];
    if (self)
    {
        self.tips = tips;
        _toDir = toDir;
        self.inview = view;
        _autoDismiss = autoDismiss;
        _dismisSec = sec;
        _size = self.frame.size;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    return self;
}


#pragma mark - public function
- (void)dismiss
{
    [self.timer invalidate];
    self.timer = nil;
    CGRect toRect = CGRectZero;
    CGRect tmpRect = self.frame;
    NSInteger tipsNum = 0;
    for (UIView *view in self.inview.subviews)
    {
        if ([view isKindOfClass:[TipsView class]])
        {
            tipsNum++;
            if (tipsNum > 1)
            {
                break;
            }
        }
    }
    
    if (PopDirBottom == _toDir)
    {
        toRect = CGRectMake(tmpRect.origin.x,
                            -_size.height,
                            tmpRect.size.width,
                            _size.height);
    }
    
    if (PopDirTop == _toDir)
    {
        toRect = CGRectMake(tmpRect.origin.x,
                            self.inview.bounds.size.height,
                            tmpRect.size.width,
                            _size.height);
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (tipsNum > 1)
                         {
                             self.alpha = 0;
                         }
                         else
                         {
                             self.frame = toRect;
                         }
                     }
                     completion:^(BOOL finished)
     {
         if (self.superview!=nil)
         {
             [self removeFromSuperview];
         }
     }];
}

- (void)showTips:(NSString *)tips
           toDir:(PopDir)toDir
            size:(CGSize)size
          inView:(UIView*)view
     autoDismiss:(BOOL)autoDismiss
           inSec:(NSInteger)sec
{
    if (view == nil || tips== nil || [tips length] == 0)
    {
        return;
    }
    
    //reset member data
    self.tips = tips;
    _toDir = toDir;
    self.inview = view;
    _autoDismiss = autoDismiss;
    _dismisSec = sec;
    _size = size;
    
    
    CGRect originRect = CGRectZero;
    CGRect toRect = CGRectZero;
    
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[self class] ]) {
             TipsView *tipsview = obj;
             [self moveTipsview:tipsview to:toDir];
         }
     }];
    
    if (PopDirBottom == toDir)
    {
        originRect = CGRectMake(floor((view.bounds.size.width - size.width)/2),
                                -size.height,
                                size.width,
                                size.height);
        toRect = CGRectMake(floor((view.bounds.size.width - size.width)/2),
                            kTipsBorderMargin,
                            size.width,
                            size.height);
    }
    
    if (PopDirTop == toDir)
    {
        originRect = CGRectMake(floor((view.bounds.size.width - size.width)/2),
                                view.bounds.size.height,
                                size.width,
                                size.height);
        toRect = CGRectMake(floor((view.bounds.size.width - size.width)/2),
                            view.bounds.size.height - size.height - kTipsBorderMargin,
                            size.width,
                            size.height);
    }
    
    self.frame = originRect;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = toRect;
                     }
                     completion:^(BOOL finished) {
                         //do nothing
                     }];
    
    _titleLabel.text = tips;
    [view addSubview:self];
    
    if (autoDismiss)
    {
        [self startTimer];
        
    }
}

- (void)showTips{
    [self showTips:self.tips
             toDir:_toDir
              size:self.bounds.size
            inView:self.inview
       autoDismiss:_autoDismiss
             inSec:_dismisSec];
}

#pragma mark - private function
- (void)moveTipsview:(TipsView *)tipsview to:(PopDir)toDir
{
    CGRect toRect = CGRectZero;
    CGRect tmpRect = tipsview.frame;
    if (PopDirBottom == toDir)
    {
        toRect = CGRectMake(tmpRect.origin.x,
                            tmpRect.origin.y+_size.height + kTipsViewInterval,
                            tmpRect.size.width,
                            tmpRect.size.height);
    }
    
    if (PopDirTop == toDir)
    {
        toRect = CGRectMake(tmpRect.origin.x,
                            tmpRect.origin.y - _size.height - kTipsLabelTopMargin,
                            tmpRect.size.width,
                            tmpRect.size.height);
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         tipsview.frame = toRect;
                     }
                     completion:^(BOOL finished) {
                         //do nothing
                     }];
}

#pragma mark timer
- (void)timerFire:(id)sender{
    if (self.superview!=nil) {
        [self dismiss];
    }
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:_dismisSec
                                                  target:self
                                                selector:@selector(timerFire:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


@end


@implementation MBTip
+ (void)showTipsView:(NSString *)tips
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [self showTipsView:tips atView:window];
}

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view
{
    [self showTipsView:tips atView:view afterDelay:kTipsDelay yOffset:0.0];
}

+ (void)showTipsView:(NSString *)tips atView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    [self showTipsView:tips atView:view afterDelay:delay yOffset:0.0f];
}
#pragma mark - 新改
+ (void)showTipsView:(NSString *)tips atView:(UIView *)view afterDelay:(NSTimeInterval)delay  yOffset:(CGFloat)yOffset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tips;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:12];
    hud.detailsLabelColor = [UIColor whiteColor];
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
    
    //    hud.detailsLabelText = tips;
	//    CGPoint offset = hud.offset;
//    offset.y = yOffset;
//    hud.offset = offset;
//    //hud.bezelView.color = kBMTipsViewBackDayColor;
//    hud.detailsLabelColor = kBMTipsViewTextDayColor;

//    [hud hide:YES afterDelay:delay];
}

+ (void)showTipsView:(NSString *)tips
              atView:(UIView *)view
           withImage:(UIImage *)image
          afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:HUD];
    
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    //hud.bezelView.color = kBMTipsViewBackDayColor;
    HUD.detailsLabelColor = kBMTipsViewTextDayColor;
    HUD.detailsLabelText = tips;
	
    [HUD show:YES];
	[HUD hide:YES afterDelay:delay];
}

//+(void)showError:(NSString *)error toView:(UIView *)view
//{
//    [self showTipsView:error atView:view];
//}

//+ (void)showTipsView:(NSString *)tips atView:(UIView *)view
//{
//    [self showTipsView:tips atView:view afterDelay:1.0];
//}

+ (void)showTipsView:(NSString *)tips
              atView:(UIView *)view
       withTextColor:(UIColor *)textColor
           backColor:(UIColor *)backColor
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    CGSize size = CGSizeMake((view.bounds.size.width>320?320:view.bounds.size.width) - 60, 35);
    TipsView *tipsview = [[TipsView alloc] initWithTips:tips
                                                 andSize:size
                                                   toDir:PopDirTop
                                                  inView:view
                                             autoDismiss:YES
                                                   inSec:kTipsDelay
                                               textColor:textColor
                                               backColor:backColor];
    [tipsview showTips];
}

+ (void)showTipsView:(NSString *)tips
              atView:(UIView *)view
           withImage:(UIImage *)image
          afterDelay:(NSTimeInterval)delay
             tipsTag:(NSInteger)tag
              target:(id)target
{
    MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.tag = tag;
	[view addSubview:HUD];
    HUD.delegate = target;
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    //hud.bezelView.color = kBMTipsViewBackDayColor;
    HUD.detailsLabelColor = kBMTipsViewTextDayColor;
    HUD.detailsLabelText = tips;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    
}

+(void)showError:(NSString *)error toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    
    if([error isKindOfClass:[NSString class]])
    {
        if(error.length == 0)
        {
            error = @"网络异常";
        }
    }
    
    hud.detailsLabelText = error;

    // 设置图片
    //    hud.customView = [[UIImageView alloc] initWithImage:IMGGET([NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon])];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    //hud.bezelView.color = kBMTipsViewBackDayColor;
    hud.detailsLabelColor = kBMTipsViewTextDayColor;

    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 秒之后再消失
    [hud hide:YES afterDelay:kTipsDelay];
}


+ (void)showTipsView:(NSString *)tips atView:(UIView *)view afterDelay:(NSTimeInterval)delay completeBlock:(MBProgressHUDCompletionBlock)completeBlock{
    
    if(tips.length == 0)
    {
        tips = @"网络异常";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.completionBlock = completeBlock;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = tips;
    hud.detailsLabelFont = FONT_TITLE(14);
    //hud.bezelView.color = kBMTipsViewBackDayColor;
    hud.detailsLabelColor = kBMTipsViewTextDayColor;
    hud.margin = 10.f;
//    CGPoint offset = hud.offset;
//    offset.y = 0.0;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

@end
