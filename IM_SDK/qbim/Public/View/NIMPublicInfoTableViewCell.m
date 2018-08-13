//
//  NIMPublicInfoTableViewCell.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/23.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicInfoTableViewCell.h"

@implementation NIMPublicInfoTableViewCell

- (void)awakeFromNib {
  
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDataSource:(NIMPublicInfoModel *)model
{
    [self makeConstraints];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarPic] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    //link2隐藏代码
    //1是黄的  2是蓝的subjecttype默认1
    if (model.subjecttype.intValue ==2) {
        self.typeImageView.image =  IMGGET(@"icon_enterprise.png");
    }
    else if(model.subjecttype.intValue==1 &&model.authpass.intValue==1)
    {
        self.typeImageView.image =  IMGGET(@"icon_personal.png");
    }
    else
    {
        [self.typeImageView setImage:nil];
    }

    self.nameLabel.text = model.nickName;
    self.contentLabel.text =[NSString stringWithFormat:@"公众号账号：%@",IsStrEmpty(model.pubaccount)?@"":model.pubaccount];
}

- (void)makeConstraints{
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.leading.equalTo(self.mas_leading).offset(15);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    
    [self.typeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.trailing.equalTo(@0);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(10);
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.mas_trailing).offset(-15);
    }];
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(10);
        make.height.equalTo(@20);
        make.trailing.equalTo(self.mas_trailing).offset(-15);
    }];
}

#pragma mark getter

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;

}
-(UIImageView *)typeImageView
{
    if (!_typeImageView) {
        _typeImageView = [[UIImageView alloc] init];
        [self.iconImageView addSubview:_typeImageView];
    }
    return _typeImageView;
    
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [SSIMSpUtil getColor:@"262626"];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
