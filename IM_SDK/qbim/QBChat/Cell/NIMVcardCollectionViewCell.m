//
//  NIMVcardCollectionViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMVcardCollectionViewCell.h"


@implementation NIMVcardCollectionViewCell

- (UIEdgeInsets)layoutMargins {
    [super layoutMargins];
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.avatarBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(0);
    }];
    
    [self.lbIsGroupMaster mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarBtn);
        make.height.equalTo(@14);
        make.leading.equalTo(self.avatarBtn);
        make.trailing.equalTo(self.avatarBtn);
    }];
    
    [self.delImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarBtn.mas_top).with.offset(0);
        make.trailing.equalTo(self.avatarBtn.mas_trailing).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
#pragma mark actions
- (void)avatarClick:(id)sender{
    [_vcardDelegate vcardCollectionViewCell:self didSelectedWithAvatar:self.avatarBtn];
}

#pragma mark
- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _avatarBtn.contentMode = UIViewContentModeScaleAspectFill;
        _avatarBtn.clipsToBounds = YES;
        _avatarBtn.layer.cornerRadius = 2;
        [_avatarBtn addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_avatarBtn];
    }
    return _avatarBtn;
}

- (UILabel *)lbIsGroupMaster
{
    if (!_lbIsGroupMaster) {
        _lbIsGroupMaster = [[UILabel alloc]init];
        _lbIsGroupMaster.backgroundColor = [UIColor grayColor];
        _lbIsGroupMaster.alpha = 0.7;
        _lbIsGroupMaster.textAlignment = NSTextAlignmentCenter;
        _lbIsGroupMaster.textColor = [UIColor whiteColor];
        _lbIsGroupMaster.text = @"群主";
        _lbIsGroupMaster.font = [UIFont systemFontOfSize:10];
        _lbIsGroupMaster.hidden = YES;
        [self.contentView addSubview:_lbIsGroupMaster];
    }
    
    return _lbIsGroupMaster;
}

- (UIImageView *)delImgView{
    if (!_delImgView) {
        _delImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _delImgView.image = [UIImage imageNamed:@"icon_delete_btn"];
        _delImgView.hidden = YES;
        [self.contentView addSubview:_delImgView];
    }
    return _delImgView;
}
@end
