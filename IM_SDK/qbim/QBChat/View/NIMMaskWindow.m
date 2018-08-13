//
//  NIMMaskWindow.m
//  QianbaoIM
//
//  Created by fengsh on 16/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMMaskWindow.h"

@interface NIMMaskWindow()
{
    UIWindow        * _maskWindow;
}
@end

@implementation NIMMaskWindow

- (id)init
{
    self = [super init];
    if (self) {
        [self initDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefault];
    }
    
    return self;
}

- (void)initDefault
{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65f]];
    self.touchDismiss = NO;
    [self addNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIWindow *)maskKeyWindow
{
    if (!_maskWindow) {
        _maskWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _maskWindow.backgroundColor = [UIColor clearColor];
        self.frame = _maskWindow.bounds;
        [_maskWindow addSubview:self];
    }
    return _maskWindow;
}

- (void)dealloc
{
    [self removeNotification];
}

- (void)show
{
    [[self maskKeyWindow]makeKeyAndVisible];
    [self maskKeyWindow].alpha = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self maskKeyWindow].alpha = 1;
    [UIView commitAnimations];
}

- (void)showAfterDelayDismiss:(NSTimeInterval)timeinterval
{
    [self show];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:timeinterval];
}

- (void)dismiss
{
    //to call self dealloc
    [self removeFromSuperview];
    
    [self performSelector:@selector(dismissWindow) withObject:nil afterDelay:0.1];
}

- (void)dismissWindow
{
    if (_maskWindow)
    {
        [_maskWindow setNeedsDisplay];
        if (_maskWindow.isKeyWindow)
        {
            [_maskWindow resignKeyWindow];
        }
        _maskWindow = nil;
    }
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchDismiss) {
        // 点击消失
        [self dismiss];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - 键盘事件
- (void)keyBoardWillShow:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat kh = keyboardRect.size.height;
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rt = self.bounds;
                         rt.size.height = CGRectGetHeight([UIScreen mainScreen].bounds) - kh;
                         self.frame = rt;
                         [self maskKeyWindow].frame = rt;
                     }completion:nil];
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                            self.frame = [UIScreen mainScreen].bounds;
                            [self maskKeyWindow].frame = [UIScreen mainScreen].bounds;
                        }completion:nil];
}

@end
