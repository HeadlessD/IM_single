//
//  NIMRRightCardCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightCardCell.h"
  
//#import "PublicEntity.h"

@implementation NIMRRightCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.containerView addGestureRecognizer:self.longPressRecognizer];
//    [self.containerView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    NSData *m_Data        = [recordEntity.msgContent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *m_Dict  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                            options:NSJSONReadingMutableLeaves
                                                              error:nil];
    int type = [[m_Dict objectForKey:@"type"] intValue];
    int64_t userid = [[m_Dict objectForKey:@"id"] longLongValue];
    NSString *name = nil;
    NSString *src = nil;
    if (type == 0) {
        self.typeLabel.text = @"个人名片";
        
        name = [NIMStringComponents finFristNameWithID:userid];
        
        if (IsStrEmpty(name)) {
            name = [m_Dict objectForKey:@"showName"];
        }

        src = USER_ICON_URL(userid);

    }else if (type == 1){
        self.typeLabel.text = @"公众号名片";
        NOffcialEntity *publicEntity = recordEntity.offcialEntity;
        if (!publicEntity) {
            name = [m_Dict objectForKey:@"showName"];
            src = [m_Dict objectForKey:@"avatar"];
        }else{
            name = publicEntity.name;
            src = publicEntity.avatar;
        }
    }
    self.nameLabel.text = name;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:[UIImage imageNamed:@"fclogo"]];
}

- (void)makeConstraints{
    [super makeConstraints];
    
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@200);
//            make.height.equalTo(@60);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@200);
//            make.height.equalTo(@60);
        }];
    }

    [self.avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
//    [self.accessory mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-14);
//        make.width.equalTo(@15);
//        make.height.equalTo(@15);
//        make.centerY.equalTo(self.avatarView.mas_centerY);
//    }];
    
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-29);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.avatarView.mas_centerY);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.paoButton.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-11);
        make.top.equalTo(self.avatarView.mas_bottom).with.offset(10);
        make.height.equalTo(@1);
    }];
    
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.avatarView.mas_leading);
        make.trailing.equalTo(self.lineView.mas_trailing);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.equalTo(@15);
    }];
    
}

#pragma mark actions
- (IBAction)tapRecognizerHandler:(UITapGestureRecognizer*)gesture
{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemForward];
    }
    return _menuItems;
}
- (UIImage *)image{
    if (!_image) {
        _image = [IMGGET(@"nim_chat_frame_right")
                  resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UIImage *)highlightedImage{
    if (!_highlightedImage) {
        _highlightedImage = [IMGGET(@"nim_chat_frame_right_hl")
                             resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _highlightedImage;
}
- (UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithImage:IMGGET(@"")];
        _avatarView.clipsToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = 2;
        [self.contentView addSubview:_avatarView];
    }
    return _avatarView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)accessory{
    if (!_accessory) {
        _accessory = [[UIImageView alloc] initWithImage:IMGGET(@"icon_activity_enter")];
        _accessory.clipsToBounds = YES;
        [self.contentView addSubview:_accessory];
    }
    return _accessory;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [SSIMSpUtil getColor:@"DCDCDC"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.font = [UIFont systemFontOfSize:10];
        _typeLabel.textColor = [UIColor grayColor];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_typeLabel];
    }
    return _typeLabel;
}

@end
