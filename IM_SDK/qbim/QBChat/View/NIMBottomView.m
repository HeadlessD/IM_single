//
//  NIMBottomView.m
//  QianbaoIM
//
//  Created by liyan on 9/20/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMBottomView.h"

@interface NIMBottomView()

_PROPERTY_NONATOMIC_RETAIN(UIView, lineTop);
_PROPERTY_NONATOMIC_RETAIN(UIView, lineCenter);



@end

@implementation NIMBottomView


#pragma mark - private

- (void)dealloc
{
    RELEASE_SAFELY(_leftBtn);
    RELEASE_SAFELY(_rightBtn);
    RELEASE_SAFELY(_lineTop);
    RELEASE_SAFELY(_lineCenter);
}
-(void)awakeFromNib
{
    [self addSubview:self.lineTop];
    [self addSubview:self.lineCenter];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.centerBtn];
    _leftBtn.exclusiveTouch = YES;
    _rightBtn.exclusiveTouch = YES;
    [self _loadConstraint];
 
}
- (id)initView
{
    self=[super init];
    if (self) {
        
    
    [self addSubview:self.lineTop];
    [self addSubview:self.lineCenter];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.centerBtn];
    _leftBtn.exclusiveTouch = YES;
    _rightBtn.exclusiveTouch = YES;
    [self _loadConstraint];
    }
    return self;
}

- (void)_loadConstraint
{
    [self.lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.width.equalTo(self);
        make.height.equalTo(@(.5));
    }];
    
    [self.lineCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.centerX.equalTo(self);
        make.width.equalTo(@(_LINE_HEIGHT_1_PPI));
        make.height.equalTo(self);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.rightBtn);
        make.top.equalTo(@0);
        make.height.equalTo(self);
        make.leading.equalTo(@0);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.rightBtn);
        make.top.equalTo(@0);
        make.height.equalTo(self);
        make.leading.equalTo(self.leftBtn.mas_trailing);
        make.trailing.equalTo(@0);
    }];
    
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
}


- (void)setTopLineColor:(UIColor *)color
{
    self.lineTop.backgroundColor = color;
}

- (void)setCenterLineColor:(UIColor *)color
{
    self.lineCenter.backgroundColor = color;
}

- (void)setCenterLineHeight:(CGFloat)lineHeight
{
    if(lineHeight == 0)
    {
        [self.lineCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.centerX.equalTo(self);
            make.width.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.height.equalTo(self);
        }];
    }
    else
    {
        [self.lineCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.height.equalTo(@(lineHeight));
            
        }];
    }
}

#pragma mark - get

_GETTER_BEGIN(UIView, lineTop)
{
    _lineTop =[[UIView alloc]init];
    _lineTop.backgroundColor = __COLOR_D5D5D5__;
   
}
_GETTER_END(lineTop)


_GETTER_BEGIN(UIView, lineCenter)
{
    _lineCenter =[[UIView alloc]init];
    _lineCenter.backgroundColor = __COLOR_E6E6E6__;
   
}
_GETTER_END(lineCenter)

_GETTER_BEGIN(UIButton, leftBtn)
{
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setTitle:@"按钮" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[SSIMSpUtil getColor:@"343434"] forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = FONT_TITLE(15);
}
_GETTER_END(leftBtn)


_GETTER_BEGIN(UIButton, rightBtn)
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"按钮" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[SSIMSpUtil getColor:@"343434"] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = FONT_TITLE(15);
}
_GETTER_END(rightBtn)

_GETTER_BEGIN(UIButton, centerBtn)
{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn setTitle:@"按钮" forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[SSIMSpUtil getColor:@"343434"] forState:UIControlStateNormal];
    _centerBtn.titleLabel.font = FONT_TITLE(15);
}
_GETTER_END(centerBtn)

#pragma mark - public

- (void)setLeftTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target
{
    [self.leftBtn setTitle:title forState:UIControlStateNormal];
    [self.leftBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [self.leftBtn setImage:img forState:UIControlStateNormal];
    if(img)
    {
        self.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    }
    
    self.centerBtn.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    self.lineCenter.hidden = NO;
    self.lineTop.hidden = NO;
}

- (void)setLeftTitle:(NSString *)title action:(SEL)sel target:(id)target
{
    [self setLeftTitle:title img:nil action:sel target:target ];
}

- (void)setRightTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target
{
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    [self.rightBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn setImage:img forState:UIControlStateNormal];
    
    if(img)
    {
        self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    }
    
    self.centerBtn.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    self.lineCenter.hidden = NO;
    self.lineTop.hidden = NO;
}

- (void)setRightTitle:(NSString *)title action:(SEL)sel target:(id)target
{
    [self setRightTitle:title img:nil action:sel target:target];
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    
    [self.leftBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    
    self.centerBtn.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    self.lineCenter.hidden = NO;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.leftBtn.titleLabel.font  = titleFont;
    self.rightBtn.titleLabel.font = titleFont;
    
    self.centerBtn.hidden = YES;
    self.leftBtn.hidden = NO;
    self.rightBtn.hidden = NO;
    self.lineCenter.hidden = NO;
}


- (void)setCenterTitle:(NSString *)title img:(UIImage *)img action:(SEL)sel target:(id)target
{
    self.centerBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.lineCenter.hidden = YES;
    
    [self.centerBtn setTitle:title forState:UIControlStateNormal];
    [self.centerBtn setImage:img forState:UIControlStateNormal];
    
    
    NSArray *array = [self.centerBtn actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    
    for (NSString *selStr in array)
    {
        SEL sel = NSSelectorFromString(selStr);
        [self.centerBtn removeTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.centerBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    if(img)
    {
        self.centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    }
    
    if(title.length ==0 && img == nil && sel == nil)
    {
        self.lineTop.hidden = YES;
    }
    else
    {
        self.lineTop.hidden = NO;
    }

}

/*********************************************************************
 函数名称 : setLeftBtnTitleColor
 函数描述 : 设置左边按钮颜色
 参数  :color
 返回值 :N/A
 作者 : yan_hao
 *********************************************************************/
-(void)setLeftBtnTitleColor:(UIColor *)color
{
    [self.leftBtn setTitleColor:color forState:UIControlStateNormal];
}

/*********************************************************************
 函数名称 : setRightBtnTitleFront
 函数描述 : 设置右边按钮文字和背景颜色,字体大小
 参数  :textcolor,bgcolor,textfont
 返回值 :N/A
 作者 : yan_hao
 *********************************************************************/
-(void)setRightBtnTitleFont:(NSInteger)textfont withTitleColor:(UIColor *)textcolor withBtnBackgroundColor:(UIColor *)bgcolor
{
    self.rightBtn.titleLabel.font = FONT_TITLE(textfont);
    [self.rightBtn setTitleColor:textcolor forState:UIControlStateNormal];
    self.rightBtn.backgroundColor = bgcolor;
}

@end
