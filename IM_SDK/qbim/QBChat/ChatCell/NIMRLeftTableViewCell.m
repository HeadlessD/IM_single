//
//  NIMRLeftTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTableViewCell.h"
  
#import "TextEntity+CoreDataClass.h"
//#import "PublicEntity.h"
#import "GMember+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
@implementation NIMRLeftTableViewCell
@synthesize paoButton = _paoButton;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
#pragma mark actions
- (IBAction)avatarClick:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeAvatar];
}

- (void)actionCopy:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.recordEntity.msgContent;

}

- (void)actionForward:(id)sender{

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
            if (menuItems)
            {
                [self becomeFirstResponder];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IS_LINCK_BEGINLONGPRESS" object:nil];

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
- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    DBLog(@"state:%ld",(long)gesture.state);
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.paoButton.highlighted = YES;
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        self.paoButton.highlighted = NO;
    }
}

#pragma mark config

- (void)updateWithVcardEntity:(VcardEntity *)vcardEntity{
    [self.avatarBtn setViewDataSourceFromUrlString:USER_ICON_URL(vcardEntity.userid)];
//    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:vcardEntity.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    self.avatarBtn.layer.cornerRadius = 2;
    
    if (self.showName) {
        self.vNameLabel.text = [NSString stringWithFormat:@"%@",[vcardEntity defaultName]];
    }
    self.vNameLabel.hidden = !self.showName;
}

- (void)updateWithPublicEntity:(NOffcialEntity *)publicEntity{
    
    if (publicEntity.offcialid == kSystemID) {
        [self.avatarBtn setViewIconFromImage:IMGGET(@"icon_qb_circular")];
    }else{
        [self.avatarBtn setViewDataSourceFromUrlString:publicEntity.avatar];
    }
    
//    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:publicEntity.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    self.avatarBtn.layer.cornerRadius = 2;
    
    if (self.showName) {
        self.vNameLabel.text = [publicEntity name];
    }
    self.vNameLabel.hidden = !self.showName;
}

- (void)updateWithBusinessEntity:(NBusinessEntity *)businessEntity{
    
    [self.avatarBtn setViewDataSourceFromUrlString:businessEntity.avatar];

    self.avatarBtn.layer.cornerRadius = 2;
    
    if (self.showName) {
        self.vNameLabel.text = IsStrEmpty([businessEntity name])?@"钱宝商家":[businessEntity name];
    }
    self.vNameLabel.hidden = !self.showName;
}

- (void)updateWithGroupEntity:(GMember *)gMember andUserId:(int64_t)userId sendName:(NSString *)sendName{

    FDListEntity *fdList = [[GroupManager sharedInstance] GetFDList:userId];
    
    VcardEntity *card = gMember.vcard;
    if (nil == card){
        card = [VcardEntity instancetypeFindUserid:userId];
    }
    
    self.avatarBtn.layer.cornerRadius = 2;
#pragma mark 优先备注
    if (self.showName) {
        NSString *name = IsStrEmpty(fdList.fdRemarkName)? [gMember groupmembernickname]:fdList.fdRemarkName;
        if (IsStrEmpty(name)) {
                name = card.defaultNickName;
            if(IsStrEmpty(name)){
                name = sendName;
            }
        }

        self.vNameLabel.text = name;
    }
    self.vNameLabel.hidden = !self.showName;
    [self.avatarBtn setViewDataSourceFromUrlString:USER_ICON_URL(userId)];

}
- (void)updateWithTimeline:(double)time{
    self.timeLine.text = [SSIMSpUtil parseTime:time];
    self.timeLine.hidden = NO;
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    if (recordEntity.chatType == PUBLIC)
    {
        NOffcialEntity *offcialEntity = [NOffcialEntity findFirstWithMsgBodyId:recordEntity.messageBodyId];
        [self updateWithPublicEntity:offcialEntity];
    }else if (recordEntity.chatType == GROUP)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(messageBodyId = %@) AND (userid = %@)",recordEntity.messageBodyId,@(recordEntity.opUserId)];
        GMember *member = [GMember NIM_findFirstWithPredicate:predicate];
        [self updateWithGroupEntity:member andUserId:recordEntity.opUserId sendName:recordEntity.sendUserName];
    }
    else if (recordEntity.chatType == PRIVATE)
    {
        int64_t secondID = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:secondID];
        if (vcardEntity==nil) {
            vcardEntity = [VcardEntity NIM_createEntity];
            vcardEntity.userid = secondID;
            vcardEntity.nickName = recordEntity.sendUserName;
        }
        [self updateWithVcardEntity:vcardEntity];
    }else if (recordEntity.chatType == SHOP_BUSINESS ||
              recordEntity.chatType == CERTIFY_BUSINESS)
    {
        int64_t bid = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
        NBusinessEntity *businessEntity = [NBusinessEntity instancetypeFindBid:bid];
        [self updateWithBusinessEntity:businessEntity];
    }
    
    if (self.showTimeline) {
        [self updateWithTimeline:recordEntity.ct/1000];
    }else{
        self.timeLine.hidden = YES;
    }
    self.infoButton.hidden = YES;
    self.activityIndicatorView.hidden = YES;
    [self makeConstraints];
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
            make.leading.equalTo(self.contentView.mas_leading).with.offset(kWidthMarginAvatar);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
    }else{
        
        [self.avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(kWidthMarginAvatar);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }

    if (self.showName) {
        [self.vNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
            make.height.equalTo(@15);
        }];
        
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(0);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.trailing.greaterThanOrEqualTo(@48);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            make.trailing.greaterThanOrEqualTo(@48);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
    }
    [self.infoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.paoButton.mas_trailing).with.offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
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
        _image = [IMGGET(@"nim_chat_bg_left") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 10)
                                                                                     resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UIImage *)highlightedImage{
    if (!_highlightedImage) {
        _highlightedImage = [IMGGET(@"nim_chat_bg_left_hl") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 10)
                             resizingMode:UIImageResizingModeStretch];
    }
    return _highlightedImage;
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
//        _vNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _vNameLabel.numberOfLines = 1;
        _vNameLabel.textColor = [UIColor lightGrayColor];
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

#pragma mark NIMGroupUserIconDelegate
- (void)NIMGroupUserIconClick{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeAvatar];
}

-(void)iconClick
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeAvatar];
}
#pragma mark getter
-(NIMGroupUserIcon *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [[NIMGroupUserIcon alloc] init];
        _avatarBtn.contentMode = UIViewContentModeScaleAspectFill;
        _avatarBtn.layer.cornerRadius = 2;
        _avatarBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _avatarBtn.clipsToBounds = YES;
        _avatarBtn.exclusiveTouch = YES;
//        _avatarBtn.delegate = self;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconClick)];
        [_avatarBtn addGestureRecognizer:tap];
        [self.contentView addSubview:_avatarBtn];
    }
    return _avatarBtn;
}

@end
