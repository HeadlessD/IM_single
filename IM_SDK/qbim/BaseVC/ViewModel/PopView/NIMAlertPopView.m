//
//  NIMAlertPopView.m
//  QianbaoIM
//
//  Created by liyan on 11/5/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMAlertPopView.h"
#import "UIImage+NIMEffects.h"
#import "UIImage+NIMEllipse.h"

#define POP_CONTENT_HEIGHT_NO_MESSAGE 165
#define POP_CONTENT_HEIGHT_MESSAGE    180

@interface NIMAlertPopView()


_PROPERTY_NONATOMIC_RETAIN(UIView ,     popBG);
_PROPERTY_NONATOMIC_RETAIN(UIView,      blackBG);
_PROPERTY_NONATOMIC_RETAIN(UIImageView, iconIMG);
_PROPERTY_NONATOMIC_RETAIN(UILabel,     tipLabel);
_PROPERTY_NONATOMIC_RETAIN(UILabel, messageLabel);
_PROPERTY_NONATOMIC_RETAIN(UIButton,    okBtn);
_PROPERTY_NONATOMIC_RETAIN(UIButton,    backBtn);

@end

@implementation NIMAlertPopView

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.isNeedBack = YES;
        
        [self addSubview:self.viewBG];
        [self addSubview:self.blackBG];
        [self addSubview:self.popBG];
        [self.popBG addSubview:self.iconIMG];
        [self.popBG addSubview:self.tipLabel];
        [self.popBG addSubview:self.messageLabel];
        [self.popBG addSubview:self.okBtn];
        [self.popBG addSubview:self.backBtn];
        
        [self.viewBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        [self.blackBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        
        [self.popBG mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@25);
            make.trailing.equalTo(@(-25));
            make.height.equalTo(@(POP_CONTENT_HEIGHT_NO_MESSAGE));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.iconIMG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@80);
            make.width.equalTo(@80);
            make.centerX.equalTo(self.popBG);
            make.top.equalTo(@(-36));
        }];
        
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(self.iconIMG.mas_bottom).offset(10);
            make.height.equalTo(@30);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(self.tipLabel.mas_bottom).offset(10);
            make.height.equalTo(@15);
        }];

        [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@18);
            make.trailing.equalTo(@(-18));
            make.bottom.equalTo(@(-35));
            make.height.equalTo(@35);
        }];
        
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@18);
            make.trailing.equalTo(@(-18));
            make.bottom.equalTo(@(-8));
            make.height.equalTo(@19);
        }];
        
    }
    
    return self;
}

- (void)qb_ShowTitle:(NSString *)title okTitle:(NSString *)okTitle  toUIViewController:(UIViewController *)viewController
{
    [self qb_ShowTitle:title message:nil okTitle:okTitle toUIViewController:viewController];
}

- (void)qb_ShowTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle  toUIViewController:(UIViewController *)viewController
{
    if(message.length > 0 )
    {
        [self.popBG mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(POP_CONTENT_HEIGHT_MESSAGE));
            make.leading.equalTo(@25);
            make.trailing.equalTo(@(-25));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(self.iconIMG.mas_bottom).offset(10);
        }];
        self.messageLabel.hidden = NO;
    }
    else
    {
        [self.popBG mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(POP_CONTENT_HEIGHT_NO_MESSAGE));
            make.leading.equalTo(@25);
            make.trailing.equalTo(@(-25));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(self.iconIMG.mas_bottom).offset(10);
        }];
        self.messageLabel.hidden = YES;
    }
    [viewController.navigationController.view addSubview:self];

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    
    NSData *imageData   = UIImageJPEGRepresentation([UIImage nim_imgWithVC:viewController], 1);
    UIImage *img        = [UIImage imageWithData:imageData];
    UIImage *vcImg      = [img nim_blurredImage:.2];
    self.viewBG.image   = vcImg;
    self.tipLabel.text  = title;
    self.messageLabel.text = message;
    [self.okBtn setTitle:okTitle  forState:UIControlStateNormal];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn setImage:IMGGET(@"icon_activity_back") forState:UIControlStateNormal];

    self.backBtn.hidden = ! self.isNeedBack;
    if(self.backBtn.hidden)
    {
        self.messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.text = message;
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(@0);
            make.trailing.mas_equalTo(@0);
            make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(2);
            make.height.mas_equalTo(50);
        }];
        
        [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(18);
            make.trailing.mas_equalTo(-18);
            make.bottom.mas_equalTo(-15);
            make.height.mas_equalTo(35);
        }];
    }
    
}

- (void)qb_hide
{
    [self removeFromSuperview];
}

- (void)okAction
{
    if([_delegate respondsToSelector:@selector(alertPopViewFinish:)])
    {
        [_delegate alertPopViewFinish:self];
    }
}

- (void)cancelAction
{
    if([_delegate respondsToSelector:@selector(alertPopViewBack:)])
    {
        [_delegate alertPopViewBack:self];
    }
}


_GETTER_BEGIN(UIImageView, viewBG);
{
    _viewBG = [[UIImageView alloc]init];
}
_GETTER_END(viewBG);

_GETTER_BEGIN(UIView, blackBG);
{
    _blackBG = [[UIView alloc]init];
    _blackBG.alpha = .2;
    _blackBG.backgroundColor = _COLOR_BLACK;
}
_GETTER_END(blackBG);

_GETTER_BEGIN(UIView, popBG);
{
    _popBG = [[UIView alloc]init];
    _popBG.backgroundColor = _COLOR_WHITE;
//    _popBG.layer.masksToBounds = YES;
    _popBG.layer.cornerRadius = 6;
}
_GETTER_END(popBG);

_GETTER_BEGIN(UIImageView, iconIMG);
{
    _iconIMG = [[UIImageView alloc]init];
    _iconIMG.image = IMGGET(@"icon_bomb_check.png");
}
_GETTER_END(iconIMG);

_GETTER_BEGIN(UILabel, tipLabel);
{
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.font = [UIFont boldSystemFontOfSize:19];
    _tipLabel.textColor = __COLOR_262626__;
    _tipLabel.textAlignment = NSTextAlignmentCenter;
}
_GETTER_END(tipLabel);
_GETTER_BEGIN(UILabel, messageLabel);
{
    _messageLabel = [[UILabel alloc]init];
    _messageLabel.font = [UIFont boldSystemFontOfSize:15];
    _messageLabel.textColor = __COLOR_888888__;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    
}
_GETTER_END(messageLabel);

_GETTER_BEGIN(UIButton, okBtn);
{
    _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _okBtn.backgroundColor = __COLOR_7BCF54__;
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 2;
    _okBtn.titleLabel.font = FONT_TITLE(16);
    [_okBtn setTitleColor:_COLOR_WHITE forState:UIControlStateNormal];
    _okBtn.exclusiveTouch = YES;
    [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(okBtn);

_GETTER_BEGIN(UIButton, backBtn);
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitleColor:__COLOR_BBBBBB__ forState:UIControlStateNormal];
    _backBtn.titleLabel.font = FONT_TITLE(13);
    _backBtn.exclusiveTouch = YES;
    [_backBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(backBtn);


@end
