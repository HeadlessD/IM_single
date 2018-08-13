//
//  NIMSquareTitleView.m
//  QianbaoIM
//
//  Created by Yun on 14/9/9.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSquareTitleView.h"

@interface NIMSquareTitleView()

@property (nonatomic, assign) BOOL isShowDetail;

@end

@implementation NIMSquareTitleView

- (void)setCurrentShowStatus:(BOOL)isShow
{
    _isShowDetail = isShow;
    CGFloat angle = 0;
    if(isShow)
    {
        angle = M_PI;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
                         [self.barImage setTransform:rotation];
                     }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self transImage];
}

- (void)transImage
{
    CGFloat angle = 0;
    if(!_isShowDetail)
    {
        angle = M_PI;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
                         [self.barImage setTransform:rotation];
                     }];
    
    _isShowDetail = !_isShowDetail;
    if(_delegate && [_delegate respondsToSelector:@selector(headerTitleClick:)])
    {
        [_delegate headerTitleClick:_isShowDetail];
    }
}

- (void)setBarTitle:(NSString *)barTitle
{
    UIFont* font = [UIFont boldSystemFontOfSize:19];
    [self setBarTitle:barTitle font:font];
}

- (void)setBarTitle:(NSString *)barTitle font:(UIFont *)font
{
    CGSize size = [NSString nim_getSizeFromString:barTitle
                                     withFont:font
                                 andLabelSize:CGSizeMake(100, 40)];
    self.labTitle.font = font;
    self.labTitle.text = barTitle;
    self.labTitle.frame = CGRectMake(0, 0, size.width, 44);
    
    self.barImage.frame = CGRectMake(size.width+4, 19, 13, 7);
    
    self.contentView.frame = CGRectMake((self.frame.size.width-(size.width+24))/2, 0, size.width+24, 44);
}

- (UIView*)contentView
{
    if(!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_contentView];
        
    }
    return _contentView;
}

- (UILabel*)labTitle
{
    if(!_labTitle)
    {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _labTitle.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}

- (UIImageView*)barImage
{
    if(!_barImage)
    {
        _barImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _barImage.image = IMGGET(@"bg_square_shearhead");
        [self.contentView addSubview:_barImage];
    }
    return _barImage;
}

@end
