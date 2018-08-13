//
//  NIMSubSeleteTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubSeleteTableViewCell.h"

@implementation NIMSubSeleteTableViewCell

- (void)setHave:(BOOL)have{
    if (_have != have) {
        _have = have;
    }
    [self updateWithHave:have];
}

- (void)updateWithHave:(BOOL)have{
    self.seleteBtn.selected = have;
    self.titleLable.textColor = [SSIMSpUtil getColor:@"262626"];
    self.titleLable.font = [ UIFont boldSystemFontOfSize:16];

}

-(void)click:(UIButton*)btn
{
    [_selDeleagte click:btn];
}
#pragma mark config
- (void)makeConstraints{
    [self.seleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
        make.width.equalTo(@22);
        make.height.equalTo(self.seleteBtn.mas_width);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.leading.equalTo(self.seleteBtn.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
        make.width.equalTo(self.iconView.mas_height);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(10);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
    }];
    if (_hasLineLeadingLeft) {
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.trailing.equalTo(self.mas_trailing).with.offset(0);
            make.height.equalTo(@1);
        }];
    }else{
        [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.trailing.equalTo(self.mas_trailing).with.offset(0);
            make.height.equalTo(@1);
        }];
    }
}
#pragma mark getter
- (UIButton *)seleteBtn{
    if (!_seleteBtn) {
        _seleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _seleteBtn.clipsToBounds = YES;
        [_seleteBtn setImage:IMGGET(@"select.png") forState:UIControlStateNormal];
        [_seleteBtn setImage:IMGGET(@"select_on.png") forState:UIControlStateSelected];
        [_seleteBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_seleteBtn];
    }
    return _seleteBtn;
}
@end
