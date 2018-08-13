//
//  NIMSubAccessoryTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubAccessoryTableViewCell.h"


@interface NIMSubAccessoryTableViewCell ()
@property (nonatomic, strong) UIImage *redBoxImage;
@property (nonatomic, strong) UIImage *redBoxImageHighlighted;
@property (nonatomic, strong) UIImage *greenBoxImage;
@property (nonatomic, strong) UIImage *greenBoxImageHighlighted;
@property (nonatomic, strong, readwrite) VcardEntity *vcardEntity;
@property (nonatomic, strong, readwrite) FDListEntity *fdlistEntity;

@property (nonatomic, strong) NSDictionary *InterestDic;
@end
@implementation NIMSubAccessoryTableViewCell

#pragma mark config
- (void)updateWithVcardEntity:(VcardEntity *)vcardEntity{
    
    [super updateWithVcardEntity:vcardEntity];
    self.vcardEntity = vcardEntity;
    NSString *btnTitlt = @"";
    NSMutableString *introString = [NSMutableString stringWithString:@""];
    
    _fdlistEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,vcardEntity.userid]];
    
    if (vcardEntity.userid == OWNERID) {
        _fdlistEntity.fdFriendShip = FriendShip_IsMe;
    }
    
    switch (_fdlistEntity.fdFriendShip) {
            
        case FriendShip_MobileRecommend:{
            btnTitlt = @"添加";
            [introString appendString:@"手机联系人已加入钱宝"] ;
            [self.accessoryBtn setTitleColor:[SSIMSpUtil getColor:@"fd472b"] forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImage forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImageHighlighted forState:UIControlStateHighlighted];
            
            break;
        }
        case FriendShip_Ask_Me:{
            
            btnTitlt = @"同意";
            [introString appendFormat:@"%@",_fdlistEntity.fdAddInfo];
            [self.accessoryBtn setTitleColor:[SSIMSpUtil getColor:@"45A900"] forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.greenBoxImage forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.greenBoxImageHighlighted forState:UIControlStateHighlighted];
            
            break;
        }

        case FriendShip_Outlast :{
            
            btnTitlt = @"已过期";
            [introString appendString: @"好友添加申请已过期"];
            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
            [self.accessoryBtn setTitleColor:[SSIMSpUtil getColor:@"ff9600"] forState:UIControlStateNormal];
            break;
        }            
        case FriendShip_Friended:{
            
            if (_fdlistEntity.fdConsent == FriendShip_Consent_Peer){
                btnTitlt = @"已添加";
                [introString appendString: @"已同意对方的添加申请"];
                [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
                [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
                [self.accessoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else{
                NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                _fdlistEntity.isInNewFriend = NO;
                [privateContext MR_saveToPersistentStoreAndWait];
            }
            break;
        }
        default:{
            NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
            _fdlistEntity.isInNewFriend = NO;
            [privateContext MR_saveToPersistentStoreAndWait];
        }
            break;
    }
    
    //if ([vcardEntity.nFriend.extrInfo length]) {
    //    introString = [NSMutableString stringWithString:vcardEntity.nFriend.extrInfo];
    //}
    
    [self.accessoryBtn setTitle:btnTitlt forState:UIControlStateNormal];
    self.introLablel.text = introString;
}

- (void)updateWithInterest:(NSDictionary *)dic{
    [self makeConstraints];
    self.InterestDic = dic;
    
    NSString *name = dic[@"showName"];
    NSString *avatar = PUGetObjFromDict(@"avatar", dic, [NSString class]);
    [self.iconView setViewDataSourceFromUrlString:avatar];
    self.titleLable.text = name;
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    
    NSString *btnTitlt = @"";
    NSString *introString = @"";
    NSString *userid = PUGetObjFromDict(@"userId", dic, [NSString class]);
    
    NIMFriendshipType friendshipType = FriendShip_NotFriend;
    
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:userid.doubleValue];
    if (vcard) {
        _fdlistEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,vcard.userid]];
        friendshipType = _fdlistEntity.fdFriendShip;
    }
    
    
    switch (friendshipType) {
        case FriendShip_NotFriend:
        {
            btnTitlt = @"添加";
            [self.accessoryBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImage forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImageHighlighted forState:UIControlStateHighlighted];
            self.accessoryBtn.userInteractionEnabled = YES;

        }
            break;
     
        case FriendShip_Friended:
        {
            btnTitlt = @"已添加";
//            introString = @"现在可以聊天了";
            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
            [self.accessoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.accessoryBtn.userInteractionEnabled = NO;
        }
            break;

            
        default:{
            
            btnTitlt = @"添加";
            [self.accessoryBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImage forState:UIControlStateNormal];
            [self.accessoryBtn setBackgroundImage:self.redBoxImageHighlighted forState:UIControlStateHighlighted];
            self.accessoryBtn.userInteractionEnabled = YES;

//            NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//            _fdlistEntity.isInNewFriend = NO;
//            [privateContext MR_saveToPersistentStoreAndWait];
        }
            break;
    }
    introString = dic[@"desc"];
    [self.accessoryBtn setTitle:btnTitlt forState:UIControlStateNormal];
    self.introLablel.text = introString;
}

- (void)makeConstraints{
    [super makeConstraints];
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.equalTo(self.iconView.mas_height);
    }];
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
        make.height.equalTo(@20);
    }];
    
    [self.introLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(0);
        make.leading.equalTo(self.titleLable.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
        make.bottom.equalTo(self.iconView.mas_bottom);
    }];
    
    [self.accessoryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.iconView.mas_centerY);
    }];
}
#pragma mark actions
- (void)accessoryBtnClick:(id)sender{
    
    if (self.InterestDic) {
        NIMFriendshipType friendshipType = FriendShip_NotFriend;
        if ([self.InterestDic[@"isFriend"] isEqualToString:@"y"]) {
            friendshipType = FriendShip_Friended;
        }
        
        if (friendshipType == FriendShip_NotFriend) {
            [_delegate tableViewCell:self didSelectedWithType:FriendActionTypeTypeToAdd userid:[self.InterestDic[@"userId"] doubleValue]];
        }
    }else if (self.vcardEntity){
            if (_fdlistEntity.fdFriendShip == FriendShip_Ask_Me) {
                [_delegate tableViewCell:self didSelectedWithType:FriendActionTypeTypeToAgree userid:self.vcardEntity.userid];
                
            }else if (_fdlistEntity.fdFriendShip == FriendShip_MobileRecommend) {
                [_delegate tableViewCell:self didSelectedWithType:FriendActionTypeTypeToAdd userid:self.vcardEntity.userid];
            }
    }
}

//-(void)recvNC_CLIENT_FRIEND_CONFIRM_RQ:(NSNotification *)noti
//{
//    {
//        id object = noti.object;
//        if (object) {
//            if ([object isKindOfClass:[QBNCParam class]]) {
//                QBNCParam *param = object;
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"friendald" object:param.p_string];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSString * btnTitlt = @"已添加";
//                    NSString * introString = @"添加好友成功";
//                    [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
//                    [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
//                    [self.accessoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                    [self.accessoryBtn setTitle:btnTitlt forState:UIControlStateNormal];
//                    self.introLablel.text = introString;
//                });
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                QBNCParam *param = [[QBNCParam alloc]init];
//                param.p_string = @"请求超时";
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"friendald" object:param.p_string];
//            });
//        }
//    }
//}


#pragma mark
- (UIButton *)accessoryBtn{
    if (!_accessoryBtn) {
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accessoryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_accessoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_accessoryBtn addTarget:self action:@selector(accessoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_accessoryBtn];
    }
    return _accessoryBtn;
}

- (UIImage *)redBoxImage{
    if (!_redBoxImage) {
        _redBoxImage = [IMGGET(@"btn_taskhelper_dotask_select") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                        resizingMode:UIImageResizingModeStretch];
    }
    return _redBoxImage;
}

- (UIImage *)_redBoxImageHighlighted{
    if (!_redBoxImageHighlighted) {
        _redBoxImageHighlighted = [IMGGET(@"btn_taskhelper_dotask_select") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                   resizingMode:UIImageResizingModeStretch];
    }
    return _redBoxImageHighlighted;
}
- (UIImage *)greenBoxImage{
    if (!_greenBoxImage) {
        _greenBoxImage = [IMGGET(@"btn_contacts_addfriend_add") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                        resizingMode:UIImageResizingModeStretch];
    }
    return _greenBoxImage;
}

- (UIImage *)greenBoxImageHighlighted{
    if (!_greenBoxImageHighlighted) {
        _greenBoxImageHighlighted = [IMGGET(@"btn_contacts_addfriend_add") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                   resizingMode:UIImageResizingModeStretch];
    }
    return _greenBoxImageHighlighted;
}
@end
