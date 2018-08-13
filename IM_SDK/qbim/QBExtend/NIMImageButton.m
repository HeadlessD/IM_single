//
//  NIMImageButton.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/22.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMImageButton.h"

@implementation NIMImageButton

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self setImage:IMGGET(@"icon_add_good") forState:UIWindowLevelNormal];
    
    CGFloat swidth = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.width;

    
    CGFloat offset = SCREEN_WIDTH - swidth;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
}

@end
