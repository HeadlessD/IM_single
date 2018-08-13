//
//  NIMFansCell.m
//  QianbaoIM
//
//  Created by xuqing on 16/4/26.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMFansCell.h"

@implementation NIMFansCell
- (void)makeConstraints{
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.width.height.equalTo(@36);
    }];
    
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(6);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(-6);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.mas_trailing).with.offset(0);
        make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
    }];
}
- (void)updateWithVcardEntity:(NIMFansModle *)vcardEntty{
    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
    [self makeConstraints];

    [self.iconView setViewDataSourceFromUrlString:vcardEntty.avatarPic];
     if ([SSIMSpUtil isEmptyOrNull:vcardEntty.nickName]) {
        self.titleLable.text = vcardEntty.userName;

    }
    else
    {
    self.titleLable.text = vcardEntty.nickName;
    }
}
#pragma mark getter
- (NIMGroupUserIcon *)iconView{
    if (!_iconView) {
        _iconView = [[NIMGroupUserIcon alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.cornerRadius = 2;
        _iconView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _iconView.clipsToBounds = YES;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.numberOfLines = 1;
        _titleLable.font = [UIFont systemFontOfSize:16];//[UIFont boldSystemFontOfSize:16];
        _titleLable.textColor = __COLOR_262626__;
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [SSIMSpUtil getColor:@"EBEBEB"];
        [self.contentView addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

@end
