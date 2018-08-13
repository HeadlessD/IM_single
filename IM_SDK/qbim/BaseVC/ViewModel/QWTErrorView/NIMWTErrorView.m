//
//  NIMWTErrorView.m
//  TicketsProject
//
//  Created by zhangtie on 14-7-1.
//  Copyright (c) 2014年 zhangtie. All rights reserved.
//

#import "NIMWTErrorView.h"

@interface NIMWTErrorView ()

_PROPERTY_NONATOMIC_RETAIN(UIImageView,    iconError);

_PROPERTY_NONATOMIC_RETAIN(UILabel,        labError);

@end

@implementation NIMWTErrorView

- (void)dealloc
{
    RELEASE_SAFELY(_iconError);
    RELEASE_SAFELY(_labError);
    RELEASE_SAFELY(_btnDoErr);
    RELEASE_SUPER_DEALLOC;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         
        
        [self addSubview:self.iconError];
        
        [self.iconError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@(0));
            make.width.equalTo(@(self.iconError.image.size.width));
            make.height.equalTo(@(self.iconError.image.size.height));
        }];
        
        [self addSubview:self.labError];
        
        [self.labError mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.iconError.mas_bottom).offset(20);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(19));
        }];
        
        [self addSubview:self.btnDoErr];
        
        [self.btnDoErr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.labError.mas_bottom).offset(10);
            make.width.equalTo(@(120));
            make.height.equalTo(@(32));
        }];
        
    }
    return self;
}

- (void)setUserIMG:(BOOL)userIMG
{
    _userIMG = userIMG;
    if(userIMG)
    {
        
    }
    else
    {
        self.iconError.hidden = YES;
        [self.labError mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(@20);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(19));
        }];

    }
}

- (void)doErrAction
{
    SEL callBack = @selector(doErrHandle:);
    if([self.delegate respondsToSelector:callBack])
    {
        [self.delegate doErrHandle:self];
    }
}

#pragma mark -- getter
_GETTER_BEGIN(UIImageView, iconError)
{
    _iconError = [[UIImageView alloc]initWithImage:IMGGET(@"icon_point_wifi.png")];
    [_iconError setUserInteractionEnabled:YES];
}
_GETTER_END(iconError)

_GETTER_BEGIN(UILabel, labError)
{
    _CREATE_LABEL(_labError, CGRectZero, 13);
    [_labError setTextAlignment:ALIGN_CENTER];
    [_labError setTextColor:[SSIMSpUtil getColor:@"b2b2b2"]];
    [_labError setText:@"网络不给力，数据获取失败"];
}
_GETTER_END(labError)

_GETTER_BEGIN(UIButton, btnDoErr)
{
    NSString *strTitle = @"重新加载";
    _CREATE_BUTTON(_btnDoErr, CGRectZero, strTitle, 15, @selector(doErrAction));
    [_btnDoErr setTitleColor:__COLOR_888888__ forState:UIControlStateNormal];
    [_btnDoErr setTitleColor:__COLOR_888888__ forState:UIControlStateHighlighted];
//    _btnDoErr.layer.cornerRadius = 2;
//    _btnDoErr.layer.borderWidth  = 1;
    
    [_btnDoErr setBackgroundImage:[SSIMSpUtil stretchImage:IMGGET(@"btn_point_again.png") capInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_btnDoErr setBackgroundImage:[SSIMSpUtil stretchImage:IMGGET(@"btn_point_again_highlight.png") capInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
}
_GETTER_END(btnDoErr)

@end
