//
//  NIMChatCountView.m
//  qbnimclient
//
//  Created by 秦雨 on 17/12/6.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMChatCountView.h"

@implementation NIMChatCountView
{
    UIButton *groundBtn;
}


-(instancetype)initBottomViewWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        groundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [groundBtn setBackgroundImage:IMGGET(@"nim_newMessage") forState:UIControlStateNormal];
        [groundBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        groundBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        groundBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0);
        [groundBtn addTarget:self action:@selector(clickAtBottom) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:groundBtn];
        
    }
    return self;
}

-(void)setUCount:(NSInteger)UCount
{
    _UCount = UCount;
    if (UCount<=0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    [groundBtn setTitle:_IM_FormatStr(@"%ld",UCount) forState:UIControlStateNormal];
}

-(void)clickAtBottom
{
    if ([_delegate respondsToSelector:@selector(clickAtChatCountView)]) {
        [_delegate clickAtChatCountView];
    }
}



@end
