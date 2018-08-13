//
//  NIMMessageHeaderView.m
//  QianbaoIM
//
//  Created by Yun on 14/8/13.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMMessageHeaderView.h"
//#import "QBWebLoginViewController.h"

@interface NIMMessageHeaderView ()
@property (nonatomic, strong) UIView        *buttonView;
@property (nonatomic, strong) UIButton      *signBtn; //
@property (nonatomic, strong) UIButton      *adBtn;
@property (nonatomic, strong) UIButton      *rechargeBtn;

@property (nonatomic, strong) UIView        *webButtonView;
@property (nonatomic, strong) UIButton      *webButton;

@property (nonatomic, strong) UIImageView   *markimageView;


@property (nonatomic, strong) UIView        *line1View;
@property (nonatomic, strong) UIView        *line2View;
@end

@implementation NIMMessageHeaderView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutView];
    }
    return self;
}

- (id) traverseResponderChainForUIViewController:(UIView*)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

- (IBAction)webLoginOut:(id)sender
{
//    UIViewController* vc = [self traverseResponderChainForUIViewController:self];
//    QBWebLoginViewController* webLogin = (QBWebLoginViewController*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMWebLoginIdentity"];
//    [vc.navigationController pushViewController:webLogin animated:YES];
}

- (IBAction)headerButtonClick:(UIButton*)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(MHheaderClick:)])
    {
        [self.delegate MHheaderClick:sender];
    }
}

- (void)layoutView{
    CGSize size = self.bounds.size;
    CGFloat sWidth = ceilf(size.width/3);
    CGFloat sHeight = size.height;
    if (_webLogin) {
        sHeight = size.height - 60;
        [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.bottom.equalTo(self).with.offset(-60);
            make.trailing.equalTo(@0);
        }];
        
        [self.signBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonView.mas_top);
            make.leading.equalTo(@0);
            make.bottom.equalTo(self.buttonView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.adBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signBtn.mas_top);
            make.leading.equalTo(self.signBtn.mas_trailing);
            make.bottom.equalTo(self.signBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.rechargeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.adBtn.mas_top);
            make.leading.equalTo(self.adBtn.mas_trailing);
            make.bottom.equalTo(self.adBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.webButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.buttonView.mas_bottom).with.offset(16);
            make.leading.equalTo(self.buttonView.mas_leading);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.trailing.equalTo(@0);
        }];
        
        [self.line1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.top.equalTo(self.buttonView.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        [self.line2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.top.equalTo(self.buttonView.mas_bottom).offset(16);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        self.webButton.hidden = NO;
//        self.webButtonView.hidden = YES;
        
    }else{
        sHeight = size.height - 16;
        [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.bottom.equalTo(self).with.offset(-16);;
            make.trailing.equalTo(@0);
        }];
        
        [self.signBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.bottom.equalTo(self.buttonView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.adBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signBtn.mas_top);
            make.leading.equalTo(self.signBtn.mas_trailing);
            make.bottom.equalTo(self.signBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.rechargeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.adBtn.mas_top);
            make.leading.equalTo(self.adBtn.mas_trailing);
            make.bottom.equalTo(self.adBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(sWidth, sHeight));
        }];
        
        [self.webButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.buttonView.mas_bottom).with.offset(16);
            make.height.equalTo(@0);
            make.leading.equalTo(self.buttonView.mas_leading);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.trailing.equalTo(@0);
        }];
        
        [self.line1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.top.equalTo(self.buttonView.mas_bottom);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        [self.line2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
            make.top.equalTo(self.buttonView.mas_bottom).offset(16);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        self.webButton.hidden = YES;
        self.webButtonView.hidden = YES;
    }
}

- (void)addSignMark:(BOOL)mark
{
    if (! _markimageView)
    {
        self.markimageView = [[UIImageView alloc] init];
        _markimageView.image = IMGGET(@"icon_dialog_new-_small.png");
        [self addSubview:_markimageView];
        [_markimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.leading.equalTo(_signBtn.mas_trailing).offset(-35);
            make.width.height.equalTo(@8);
        }];
    }
    [_markimageView setHidden:! mark];
}

#pragma mark getter

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_buttonView];
    }
    return _buttonView;
}

//39x39签到按钮
- (UIButton *)signBtn{
    if (!_signBtn) {
        UIImage *image = IMGGET(@"icon_qb_signIn");
        
        CGSize size = self.bounds.size;
        CGFloat sWidth = ceilf(size.width/3);
//        CGFloat sHeight = size.height;
        CGSize imageSize = image.size;
        
        
        UIEdgeInsets imageEdge = UIEdgeInsetsZero;
        UIEdgeInsets titleEdge = UIEdgeInsetsZero;
        
        imageEdge = UIEdgeInsetsMake(0, 0, 30, 0);
        titleEdge = UIEdgeInsetsMake(0, -imageSize.width, -30, 0);
        _signBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _signBtn.exclusiveTouch = YES;
        [_signBtn setTag:TAG_EVENT_QIANBAO_BUTTON_SIGN];
        [_signBtn setImage:image forState:UIControlStateNormal];
#warning libc++abi.dylib: terminate_handler unexpectedly threw an exception 
        // QianbaoIM[735:208471] -[UICTFont setFont:]: unrecognized selector sent to instance 0x16e209d0
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        
        [_signBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_signBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_signBtn setTitleColor:__COLOR_262626__ forState:UIControlStateNormal];
        [_signBtn setContentEdgeInsets:UIEdgeInsetsMake(0, ceilf((sWidth - imageSize.width)/2), 0, ceilf((sWidth - imageSize.width)/2))];
        [_signBtn setTitleEdgeInsets:titleEdge];
        [_signBtn setImageEdgeInsets:imageEdge];
        [_signBtn setBackgroundColor:[UIColor clearColor]];
        [_signBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_signBtn];
    }
    return _signBtn;
}

- (UIButton *)adBtn{
    if (!_adBtn) {
         UIImage *image = IMGGET(@"icon_qb_promotion");
        CGSize size = self.bounds.size;
        CGFloat sWidth = ceilf(size.width/3);
//        CGFloat sHeight = size.height;
        CGSize imageSize = image.size;
        
        
        UIEdgeInsets imageEdge = UIEdgeInsetsZero;
        UIEdgeInsets titleEdge = UIEdgeInsetsZero;
        imageEdge = UIEdgeInsetsMake(0, 0, 30, 0);
        titleEdge = UIEdgeInsetsMake(0, -imageSize.width, -30, 0);
        _adBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _adBtn.exclusiveTouch = YES;
        [_adBtn setTag:TAG_EVENT_QIANBAO_BUTTON_RECOMMOD];
        _adBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_adBtn setImage:image forState:UIControlStateNormal];
        [_adBtn setTitle:@"推广" forState:UIControlStateNormal];
        [_adBtn setImage:image forState:UIControlStateNormal];
        [_adBtn setContentEdgeInsets:UIEdgeInsetsMake(0, ceilf((sWidth - imageSize.width)/2), 0, ceilf((sWidth - imageSize.width)/2))];
        [_adBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_adBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_adBtn setTitleColor:__COLOR_262626__ forState:UIControlStateNormal];
        [_adBtn setTitleEdgeInsets:titleEdge];
        [_adBtn setBackgroundColor:[UIColor clearColor]];
        [_adBtn.titleLabel setBackgroundColor:[UIColor clearColor]];
        [_adBtn setImageEdgeInsets:imageEdge];
        [_adBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_adBtn];
    }
    return _adBtn;
}

- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        UIImage *image = IMGGET(@"icon_qb_deposit");
        CGSize size = self.bounds.size;
        CGFloat sWidth = ceilf(size.width/3);
//        CGFloat sHeight = size.height;
        CGSize imageSize = image.size;
        
        UIEdgeInsets imageEdge = UIEdgeInsetsZero;
        UIEdgeInsets titleEdge = UIEdgeInsetsZero;
        imageEdge = UIEdgeInsetsMake(0, 0, 30, 0);
        titleEdge = UIEdgeInsetsMake(0, -imageSize.width, -30, 0);
        _rechargeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _rechargeBtn.exclusiveTouch = YES;
        [_rechargeBtn setTag:TAG_EVENT_QIANBAO_BUTTON_RECHARGE];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rechargeBtn setImage:image forState:UIControlStateNormal];
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setContentEdgeInsets:UIEdgeInsetsMake(0, ceilf((sWidth - imageSize.width)/2), 0, ceilf((sWidth - imageSize.width)/2))];
        [_rechargeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_rechargeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_rechargeBtn setImageEdgeInsets:imageEdge];
        [_rechargeBtn setTitleEdgeInsets:titleEdge];
        [_rechargeBtn setTitleColor:__COLOR_262626__ forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rechargeBtn];
    }
    return _rechargeBtn;
}

- (UIView *)webButtonView{
    if (!_webButtonView) {
        _webButtonView = [[UIView alloc] initWithFrame:CGRectZero];
        _webButtonView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_webButtonView];
    }
    return _webButtonView;
}

- (UIButton *)webButton{
    if (!_webButton) {
        _webButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        UIImage *image = nil;//IMGGET(@"Connectkeyboad_banner__icon");
        CGSize size = self.bounds.size;
        CGFloat sWidth = ceilf(size.width/3);
//        CGFloat sHeight = size.height;
        CGSize imageSize = image.size;
        
        UIEdgeInsets imageEdge = UIEdgeInsetsMake(10, ceilf((sWidth - imageSize.width)/2), 30, ceilf((sWidth - imageSize.width)/2));
        UIEdgeInsets titleEdge = UIEdgeInsetsMake(imageSize.height + imageEdge.top + 5, imageEdge.left, -35, imageEdge.right);
        imageEdge = UIEdgeInsetsMake(0, 20, 0, 0);
        titleEdge = UIEdgeInsetsMake(0,image.size.width + 10, 0, 0);
        
        _webButton.clipsToBounds = YES;
        _webButton.exclusiveTouch = YES;
        _webButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_webButton setImage:image forState:UIControlStateNormal];
        [_webButton setTitle:@"聊天消息备份失败" forState:UIControlStateNormal];
        [_webButton setBackgroundColor:[UIColor whiteColor]];
        [_webButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_webButton setImageEdgeInsets:imageEdge];
        [_webButton setTitleEdgeInsets:titleEdge];
        [_webButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        [_webButton setBackgroundImage:IMGGET(@"bg_tabbar") forState:UIControlStateNormal];
        [_webButton setBackgroundImage:IMGGET(@"bg_navigation_white") forState:UIControlStateHighlighted];
        [_webButton addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_webButton];
    }
    return _webButton;
}

_GETTER_BEGIN(UIView, line1View)
{
    _line1View = [[UIView alloc]initWithFrame:CGRectZero];
    _line1View.backgroundColor = __COLOR_D5D5D5__;
    [self addSubview:_line1View];
}
_GETTER_END(line1View)

_GETTER_BEGIN(UIView, line2View)
{
    _line2View = [[UIView alloc]initWithFrame:CGRectZero];
    _line2View.backgroundColor = __COLOR_D5D5D5__;
    [self addSubview:_line2View];
}
_GETTER_END(line2View)

@end
