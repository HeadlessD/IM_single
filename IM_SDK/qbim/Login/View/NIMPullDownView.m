//
//  NIMPullDownView.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/15.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMPullDownView.h"
@interface NIMPullDownView ()
{
    UIImageView *_backgroundView;
}
@end

@implementation NIMPullDownView

- (id)initWithContents:(NSArray *)contentsArr andRect:(CGRect)rect{
    if (self = [super init]) {
        self.frame = [[UIApplication sharedApplication].delegate window].bounds;
        //背景图片
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.frame = CGRectMake(rect.origin.x-40, rect.origin.y+5, rect.size.width+50, contentsArr.count*30);
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.backgroundColor = _COLOR_LIGHT_GRAY;
        [self addSubview:_backgroundView];
        //循环按钮
        for (NSInteger i = 0; i < contentsArr.count; i++) {
            //            [UIView animateWithDuration:0.05 animations:^{
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag                        = 100 + i;
            btn.titleLabel.font            = [UIFont systemFontOfSize:15];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [btn setTitle:[NSString stringWithFormat:@"%@",contentsArr[i]] forState:UIControlStateNormal];
            btn.hidden = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"backImg"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(2, 30*i, _backgroundView.frame.size.width-34, 30);
            [_backgroundView addSubview:btn];
            if (i != 0) {
                //循环创建线条
                UILabel *line = [[UILabel alloc] init];
                line.frame = CGRectMake(btn.frame.origin.x+5, btn.frame.origin.y, btn.frame.size.width-10, 1);
                line.backgroundColor = [UIColor whiteColor];
                [_backgroundView addSubview:line];
            }
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.tag                        = 200 + i;
            closeBtn.titleLabel.font            = [UIFont systemFontOfSize:15];
            [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [closeBtn setImage:[UIImage imageNamed:@"close_p"] forState:UIControlStateHighlighted];
            [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
            closeBtn.hidden = YES;
            closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            closeBtn.frame = CGRectMake(_backgroundView.frame.size.width-32, 30*i, 30, 30);
            [_backgroundView addSubview:closeBtn];
            //            }];
            
        }
        
        //添加手势
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden:)]];
    }
    return self;
}

//显示
- (void)showInView:(UIView *)view {
    CGRect fram = _backgroundView.frame;
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            [subview removeFromSuperview];
        }
    }
    [view addSubview:self];
    for (UIView *subView in _backgroundView.subviews) {
        subView.hidden = YES;
    }
    _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, 40);
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.frame = fram;
        
    } completion:^(BOOL finished) {
        for (UIView *subView in _backgroundView.subviews) {
            subView.hidden = NO;
        }
    }];
}

#pragma mark - UIbuttonEvent
- (void)clickBtn:(UIButton *)btn {
    if (_eventTouchSelf) {
        _eventTouchSelf(btn);
    }
}

- (void)clickCloseBtn:(UIButton *)btn {
    if (self.eventTouchCloseBtn) {
        self.eventTouchCloseBtn(btn);
    }
}

- (void)hidden:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    
    if (CGRectContainsPoint(_backgroundView.frame, point)) {
        return;
    }
    
    [self cancle];
}

//消失
- (void)cancle {
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
        _backgroundView.frame = CGRectMake(_backgroundView.frame.origin.x, _backgroundView.frame.origin.y, _backgroundView.frame.size.width, 40);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
