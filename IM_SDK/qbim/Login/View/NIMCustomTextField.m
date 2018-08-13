//
//  NIMCustomTextField.m
//  alumni
//
//  Created by 徐庆 on 13-9-27.
//  Copyright (c) 2013年 徐 庆. All rights reserved.
//

#import "NIMCustomTextField.h"

@implementation NIMCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x +35,
                      bounds.origin.y, bounds.size.width-70, bounds.size.height);
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x +35,
                      bounds.origin.y, bounds.size.width-70, bounds.size.height);
}

- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [SSIMSpUtil getColor:@"e6e6e6"].CGColor);
//    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame)+10, 0.5));
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
