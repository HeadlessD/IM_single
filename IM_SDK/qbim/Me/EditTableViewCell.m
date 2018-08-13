//
//  EditTableViewCell.m
//  qbnimclient
//
//  Created by shiyunjie on 2018/1/4.
//  Copyright © 2018年 秦雨. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)getViewModelWithIndex:(NSIndexPath *)indexPath withVcard:(VcardEntity *)vcard{
    NSArray * sourceArr = @[@"头像",@"昵称",@"手机号",@"性别",@"邮箱",@"城市"];
    self.titleLabel.text = sourceArr[indexPath.section];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.icon];

    [self creatMas];
    if (indexPath.section == 0) {
        self.icon.hidden = NO;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:USER_ICON_URL(OWNERID)] placeholderImage:USER_ICON_DEFAULT];
    }
}

-(void)creatMas{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(@80);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16 * ScreenScale];
        
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:16 * ScreenScale];
    }
    return _contentLabel;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        [_icon sd_setImageWithURL:[NSURL URLWithString:USER_ICON_URL(OWNERID)] placeholderImage:USER_ICON_DEFAULT];
        _icon.hidden = YES;
    }
    return _icon;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
