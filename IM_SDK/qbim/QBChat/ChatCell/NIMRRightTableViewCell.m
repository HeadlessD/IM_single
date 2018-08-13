//
//  NIMRRightTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"
  

@implementation NIMRRightTableViewCell
@synthesize paoButton = _paoButton;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

#pragma mark actions
- (IBAction)avatarClick:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeAvatar];
}
- (void)actionCopy:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.recordEntity.msgContent;
    
}
- (void)paoClick:(id)sender{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    BOOL isMenuVisible = menu.isMenuVisible;
    if (isMenuVisible) {
        return;
    }
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}
- (void)infoButtonClick:(id)sender{
    [_delegate chatTableViewCell:self infoButtonDidSelectedWithRecordEntity:self.recordEntity];
}
#pragma mark Menu Notification
- (void)menuControllerDidHideMenuNotification:(NSNotification *)notification{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    BOOL isMenuVisible = menu.isMenuVisible;
    self.paoButton.selected = isMenuVisible;
}
#pragma mark UIGestureRecognizer
- (IBAction)recognizerHandler:(UIGestureRecognizer*)gesture
{
    NSArray *menuItems = self.menuItems;
    if (!self.isNoLongPress)
    {
        if(gesture.state == UIGestureRecognizerStateBegan)
        {
            self.paoButton.selected = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_LINCK_BEGINLONGPRESS" object:nil];
            if (menuItems)
            {
                [self becomeFirstResponder];
                
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuItems = menuItems;
                [menu setTargetRect:self.paoButton.frame inView:self.contentView];
                [menu setMenuVisible:YES animated:YES];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(menuControllerDidHideMenuNotification:)
                                                             name:UIMenuControllerDidHideMenuNotification
                                                           object:nil];
            }
        }else if (gesture.state == UIGestureRecognizerStateEnded){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_LINCK_ENDLONGPRESS" object:nil];

        }
    }

}
- (void)prepareForReuse{
    [super prepareForReuse];
//    _timeLine.text = nil;
}

- (void)updateWithTimeline:(double)time{
    self.timeLine.text = [SSIMSpUtil parseTime:time];
    self.timeLine.hidden = NO;
}
- (void)updateWithRecordStatus:(QIMMessageStatu)status{
    [self.activityIndicatorView stopAnimating];
    switch (status) {
        case QIMMessageStatuNormal:
        {
            [self.activityIndicatorView stopAnimating];
            self.infoButton.hidden = YES;
        }
            break;
        
        case QIMMessageStatuIsUpLoading:
        {
            self.infoButton.hidden = YES;
            [self.activityIndicatorView startAnimating];
        }
            break;
        case QIMMessageStatuUpLoadFailed:
        {
            self.infoButton.hidden = NO;
            [self.activityIndicatorView stopAnimating];
        }
            break;
        default:
            break;
    }
}

- (void)updateWithVcardEntity:( VcardEntity *)vcardEntity{
    //[self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:vcardEntity.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];

    [self.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:vcardEntity.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    self.avatarBtn.layer.cornerRadius = 2;
    if (self.showName) {
//        self.vNameLabel.text = [vcardEntity defaultName];
        self.vNameLabel.hidden = NO;
    }else{
        self.vNameLabel.hidden = YES;
    }
}



- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    if (self.showTimeline) {
        [self updateWithTimeline:recordEntity.ct/1000.0];///////更改
    }else{
        self.timeLine.hidden = YES;
    }
    [self makeConstraints];
     VcardEntity *vcardEntity = recordEntity.vcard;
    if (vcardEntity==nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:recordEntity.userId];
    }
    [self updateWithVcardEntity:vcardEntity];
    [self updateWithRecordStatus:recordEntity.status];
    
}

- (void)makeConstraints{
    UIView *markView = self.contentView;
    if (self.showTimeline) {
        CGSize tsize =[NSString nim_getSizeFromString:self.timeLine.text withFont:[UIFont systemFontOfSize:13] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];

        [self.timeLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markView.mas_top).with.offset(0);
//            make.leading.equalTo(markView.mas_leading).with.offset(10);
//            make.trailing.equalTo(markView.mas_trailing).with.offset(-10);
            make.height.with.offset(20);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(tsize.width+10));
        }];
         markView = self.timeLine;
        [self.avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markView.mas_bottom).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-kWidthMarginAvatar);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }else{
        [self.avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markView.mas_top).with.offset(0);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-kWidthMarginAvatar);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    
    if (self.showName) {
        [self.vNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.leading.greaterThanOrEqualTo(@48);
            make.height.equalTo(@20);
        }];
        
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(0);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.leading.greaterThanOrEqualTo(@60);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.leading.greaterThanOrEqualTo(@60);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
    }

    [self.infoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.paoButton.mas_leading).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.paoButton.mas_centerY);
    }];
    [self.activityIndicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerX.equalTo(self.infoButton.mas_centerX);
        make.centerY.equalTo(self.infoButton.mas_centerY);
    }];
}

#pragma mark getter
- (UIImage *)image{
    if (!_image) {
        _image = [IMGGET(@"nim_chat_bg_right")
                  resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UIImage *)highlightedImage{
    if (!_highlightedImage) {
        _highlightedImage = [IMGGET(@"nim_chat_bg_right_hl")
                             resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _highlightedImage;
}
- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.exclusiveTouch = YES;
        _avatarBtn.clipsToBounds = YES;
        _avatarBtn.layer.cornerRadius = 2;
        [_avatarBtn addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_avatarBtn];
    }
    return _avatarBtn;
}

- (UIButton *)paoButton{
    if (!_paoButton) {
        _paoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paoButton setBackgroundImage:self.image forState:UIControlStateNormal];
        [_paoButton setBackgroundImage:self.highlightedImage forState:UIControlStateHighlighted];
//        [_paoButton setBackgroundImage:self.highlightedImage forState:UIControlStateSelected];
        [_paoButton addTarget:self action:@selector(paoClick:) forControlEvents:UIControlEventTouchUpInside];
        [_paoButton addGestureRecognizer:self.longPressRecognizer];
        [self.contentView addSubview:_paoButton];
    }
    return _paoButton;
}

- (UILabel *)timeLine{
    if (!_timeLine) {
        _timeLine = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLine.font = [UIFont systemFontOfSize:13];
        _timeLine.lineBreakMode = NSLineBreakByWordWrapping;
        _timeLine.textAlignment = NSTextAlignmentCenter;
        _timeLine.textColor = [UIColor whiteColor];
        _timeLine.backgroundColor = kTipColor;
        _timeLine.numberOfLines = 1;
        _timeLine.layer.cornerRadius = 4;
        _timeLine.layer.masksToBounds = YES;

        [self.contentView addSubview:_timeLine];
    }
    return _timeLine;
}
- (UILabel *)vNameLabel{
    if (!_vNameLabel) {
        _vNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _vNameLabel.font = [UIFont systemFontOfSize:12];
        _vNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _vNameLabel.textColor = [UIColor lightGrayColor];
        _vNameLabel.numberOfLines = 1;
        [self.contentView addSubview:_vNameLabel];
    }
    return _vNameLabel;
}
- (UIButton *)infoButton{
    if (!_infoButton) {
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setImage:IMGGET(@"icon_dialog_marvel") forState:UIControlStateNormal];
        [_infoButton setImage:IMGGET(@"icon_dialog_marvel_highlight") forState:UIControlStateHighlighted];
        [_infoButton setExclusiveTouch:YES];
        [_infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_infoButton];
    }
    return _infoButton;
}
- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self.contentView addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}
@end
