//
//  bottomView.m
//  qbim
//
//  Created by 秦雨 on 17/5/4.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMRemarkBottomView.h"

@implementation NIMRemarkBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    
    return self;
}

-(void)setupViews
{
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.0, self.frame.size.width/5.0, 1)];
    left.backgroundColor = [UIColor grayColor];
    
    UIView *rigth = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width*4/5.0, self.frame.size.height/2.0, self.frame.size.width/5.0, 1)];
    rigth.backgroundColor = [UIColor grayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/5.0, 0, self.frame.size.width*3/5.0, self.frame.size.height)];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"仅群主可编辑";
    
    [self addSubview:left];
    [self addSubview:rigth];
    [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
