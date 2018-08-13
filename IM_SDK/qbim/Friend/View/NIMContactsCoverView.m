//
//  NIMContactsCoverView.m
//  QianbaoIM
//
//  Created by Yun on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMContactsCoverView.h"

@interface NIMContactsCoverView ()
- (IBAction)addFriend:(id)sender;
- (IBAction)addGroupChat:(id)sender;

@end

@implementation NIMContactsCoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_delegate&&[_delegate respondsToSelector:@selector(hiddenContactsView)])
    {
        [_delegate hiddenContactsView];
    }
}

- (IBAction)addFriend:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(addFriend)])
    {
        [_delegate addFriend];
    }
}

- (IBAction)addGroupChat:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(addGroupChat)])
    {
        [_delegate addGroupChat];
    }
}


@end
