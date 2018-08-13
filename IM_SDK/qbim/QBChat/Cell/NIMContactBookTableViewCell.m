//
//  NIMContactBookTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/10/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMContactBookTableViewCell.h"

#import "PhoneBookEntity+CoreDataProperties.h"

@interface NIMContactBookTableViewCell ()
@property (nonatomic, strong) UIImage *redBoxImage;
@property (nonatomic, strong) UIImage *redBoxImageHighlighted;
@property (nonatomic, strong) UIImage *greenBoxImage;
@property (nonatomic, strong) UIImage *greenBoxImageHighlighted;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) PhoneBookEntity *phoneBookEntity;

@end
@implementation NIMContactBookTableViewCell

- (void)updateWithVcardEntity:(PhoneBookEntity *)pbEntity{
    
}

- (void)updateWithphoneBookEntity:(PhoneBookEntity *)phoneBookEntity{
    
    [self makeConstraints];
    self.phoneBookEntity = phoneBookEntity;
    self.titleLabel.text = phoneBookEntity.name;
    self.introLablel.text = phoneBookEntity.phoneNum;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:USER_ICON_URL(phoneBookEntity.userid)] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    
    
    FDListEntity * fdlist =  [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and  (fdFriendShip = %d  OR fdFriendShip = %d)",OWNERID,phoneBookEntity.userid,FriendShip_Friended,FriendShip_UnilateralFriended]];
    if (!fdlist) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",phoneBookEntity.name];
    }else{
//        phoneBookEntity.fdList = fdlist;
        if ([phoneBookEntity.fdList defaultName]) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",phoneBookEntity.name,[phoneBookEntity.fdList defaultName]];
        }else if ([phoneBookEntity.vcard defaultName]) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",phoneBookEntity.name,[phoneBookEntity.vcard defaultName]];
        }
    }
 
    
    if (phoneBookEntity.fdList.fdFriendShip == FriendShip_Friended ||
        phoneBookEntity.fdList.fdFriendShip == FriendShip_UnilateralFriended) {
        
        [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.accessoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.accessoryBtn setTitle:@"已添加" forState:UIControlStateNormal];
        self.accessoryBtn.userInteractionEnabled = NO;
    }else{
        [self.accessoryBtn setTitleColor:[SSIMSpUtil getColor:@"49ad01"] forState:UIControlStateNormal];
        [self.accessoryBtn setBackgroundImage:self.greenBoxImage forState:UIControlStateNormal];
        [self.accessoryBtn setBackgroundImage:self.greenBoxImageHighlighted forState:UIControlStateHighlighted];
        [self.accessoryBtn setTitle:@"添加" forState:UIControlStateNormal];
        self.accessoryBtn.userInteractionEnabled = YES;
    }
    
//    if (phoneBookEntity.vcard != nil && phoneBookEntity.fdList != nil) {
//        if (phoneBookEntity.fdList.fdFriendShip == FriendShip_Friended ||
//            phoneBookEntity.fdList.fdFriendShip == FriendShip_UnilateralFriended) {
//            
//            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateNormal];
//            [self.accessoryBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
//            [self.accessoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [self.accessoryBtn setTitle:@"已添加" forState:UIControlStateNormal];
//            self.accessoryBtn.userInteractionEnabled = NO;
//        }
//    }else{
//        [self.accessoryBtn setTitleColor:[SSIMSpUtil getColor:@"49ad01"] forState:UIControlStateNormal];
//        [self.accessoryBtn setBackgroundImage:self.greenBoxImage forState:UIControlStateNormal];
//        [self.accessoryBtn setBackgroundImage:self.greenBoxImageHighlighted forState:UIControlStateHighlighted];
//        [self.accessoryBtn setTitle:@"添加" forState:UIControlStateNormal];
//        self.accessoryBtn.userInteractionEnabled = YES;
//    }
}

- (void)makeConstraints{
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.width.height.equalTo(@36);
    }];

    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
        make.height.equalTo(@20);
    }];
    
    [self.introLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-80);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
    }];
    
    [self.accessoryBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
 }

#pragma mark actions
- (void)accessoryBtnClick:(id)sender{
    [_delegate contactBookTableViewCell:self didSelectedWithphoneBookEntity:self.phoneBookEntity];
}
#pragma mark
- (UIButton *)accessoryBtn{
    if (!_accessoryBtn) {
        _accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _accessoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_accessoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_accessoryBtn addTarget:self action:@selector(accessoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_accessoryBtn];
    }
    return _accessoryBtn;
}
- (UILabel *)introLablel{
    if (!_introLablel) {
        _introLablel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLablel.numberOfLines = 1;
        _introLablel.font = [UIFont systemFontOfSize:14];
        _introLablel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_introLablel];
    }
    return _introLablel;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark getter
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.cornerRadius = 2;
        _iconView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _iconView.clipsToBounds = YES;
//        _iconView.delegate = self;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
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
        _greenBoxImageHighlighted = [IMGGET(@"btn_taskhelper_dotask_select") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                                     resizingMode:UIImageResizingModeStretch];
    }
    return _greenBoxImageHighlighted;
}
@end
