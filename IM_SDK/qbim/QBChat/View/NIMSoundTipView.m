//
//  NIMSoundTipView.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/19.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMSoundTipView.h"

@interface NIMSoundTipView ()

@property(nonatomic,strong)UILabel *tipL;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation NIMSoundTipView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_RGBA(0, 0, 0, 0.7);
        _tipL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, frame.size.width, frame.size.height-20)];
        _tipL.textColor = [UIColor whiteColor];
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.font = [UIFont systemFontOfSize:13 weight:2];
        _tipL.center = CGPointMake(frame.size.width*0.5, frame.size.height*0.5);
        [self addSubview:_tipL];
        _isShow = NO;
    }
    return self;
}


- (void)timerFireMethod:(NSTimer*)theTimer
{
    if (_isShow == NO) {
        return;
    }
    _isShow = NO;
    UIView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert removeFromSuperview];
    promptAlert =NULL;
}


- (void)hide:(UIView*)promptAlert
{
    if (_isShow == NO) {
        return;
    }
    _isShow = NO;
    [promptAlert removeFromSuperview];
    promptAlert =NULL;
}

- (void)showSoundAlert:(NSString *)message atView:(UIView *)view{
    
    if (_isShow == YES) {
        [self hide:self];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
    
    
    _isShow = YES;

    _tipL.text = message;
    
    [view addSubview:self];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:self
                                    repeats:NO];
}

@end
