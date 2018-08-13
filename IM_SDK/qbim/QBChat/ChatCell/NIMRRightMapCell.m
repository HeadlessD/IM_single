//
//  NIMRRightMapCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightMapCell.h"
#import "Location+CoreDataClass.h"

@implementation NIMRRightMapCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    Location *locationEntity = recordEntity.location;
    self.iconView.image = IMGGET(@"pic_dialog_map");
    UIImage *img = IMGGET(@"nim_map_right");
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[img CGImage];
    mask.frame = CGRectMake(0, 0, 220, 120);
    self.containerView.layer.mask = mask;
    self.containerView.layer.masksToBounds = YES;
    self.nameLabel.text = locationEntity.address;
    self.paoButton.hidden = YES;
}

- (void)makeConstraints{
    [super makeConstraints];
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@220);
//            make.height.equalTo(@120);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@220);
//            make.height.equalTo(@120);
        }];
    }

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
        make.width.equalTo(@220);
//        make.height.equalTo(@120);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top);
        make.leading.equalTo(self.containerView.mas_leading);
        make.width.equalTo(self.containerView.mas_width);
        make.height.equalTo(self.containerView.mas_height);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.containerView.mas_leading);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.height.equalTo(@20);
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

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_containerView addGestureRecognizer:self.tapGestureRecognizer];
        [_containerView addGestureRecognizer:self.longPressRecognizer];
        _containerView.userInteractionEnabled = YES;
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}
//215X105
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:IMGGET(@"pic_dialog_map")];
        _iconView.userInteractionEnabled = YES;
        [self.containerView addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.containerView addSubview:_nameLabel];
    }
    return _nameLabel;
}

@end
