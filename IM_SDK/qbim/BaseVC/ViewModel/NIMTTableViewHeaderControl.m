//
//  NIMTTableViewHeaderControl.m
//  Zhyq
//
//  Created by zhangtie on 14-5-9.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import "NIMTTableViewHeaderControl.h"

@interface NIMTTableViewHeaderControl ()

_PROPERTY_NONATOMIC_RETAIN(UILabel, labTitle);

@end

@implementation NIMTTableViewHeaderControl

- (void)dealloc
{
    RELEASE_SAFELY(_labTitle);
//    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.labTitle];
        
        CGFloat view_span_height = 0;
        UIView* view_span = [[UIView alloc]initWithFrame:CGRectMake(2,
                                                                    GetHeight(self) - view_span_height, 316, view_span_height)];
        [view_span setBackgroundColor:COLOR_RGBA(145, 71, 62, 1.0)];
        [self addSubview:view_span];
        RELEASE_SAFELY(view_span);
    }
    return self;
}

- (void)setTitle:(NSString*)title
{
    [self.labTitle setText:title];
}

_GETTER_BEGIN(UILabel, labTitle)
{
    CGFloat orginX      = 5.0f;
    CGFloat lab_orginY  = 5.0f;
    CGFloat lab_height  = GetHeight(self) - lab_orginY*2;
    CGFloat lab_width   = self.bounds.size.width - orginX - 5.0f;
    CGRect lab_rect = CGRectMake(orginX,
                                 lab_orginY,
                                 lab_width, lab_height);
    
    _CREATE_LABEL(_labTitle, lab_rect, 18);
    _labTitle.contentMode = UIViewContentModeCenter;
    _labTitle.textColor = COLOR_RGBA(145, 71, 62, 1.0);//[UIColor whiteColor];
    _labTitle.font = [UIFont boldSystemFontOfSize:18];
}
_GETTER_END(labTitle)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
