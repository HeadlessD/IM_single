//
//  NIMRLeftHtmlCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftHtmlCell.h"

@implementation NIMRLeftHtmlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.paoButton addGestureRecognizer:self.longPressRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];

    NSString* sbody = recordEntity.msgContent;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = [htmDic objectForKey:@"img_url"];
    NSString *titleStr = [htmDic objectForKey:@"title"];
    NSString *introStr = [htmDic objectForKey:@"description"];
    NSString *urlStr = [htmDic objectForKey:@"url"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"icon_dialouge_link.png")];
    self.titleLabel.text = titleStr;
    if (introStr == nil || introStr.length == 0) {
        introStr = urlStr;
    }
    self.introLabel.text = introStr;
//    self.sourceLabel.text = sourceStr;
}

- (void)makeConstraints{
    [super makeConstraints];
    
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-60);
            make.width.equalTo([NSNumber numberWithFloat:kMaxWidthContent]);
//            make.height.equalTo(@80);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-60);
            make.width.equalTo([NSNumber numberWithFloat:kMaxWidthContent]);
//            make.height.equalTo(@80);
        }];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(5);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(18);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-5);
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
//        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(-10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(18);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.introLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-5);
    }];
}

#pragma mark actions
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
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:IMGGET(@"")];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.cornerRadius = 2;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLabel.font = [UIFont systemFontOfSize:12];
        _introLabel.textColor = [UIColor darkGrayColor];
        _introLabel.numberOfLines = 4;
        
        _introLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}
- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.font = [UIFont systemFontOfSize:12];
//        _sourceLabel.backgroundColor = [UIColor lightGrayColor];
        _sourceLabel.textColor = [UIColor lightGrayColor];
        _sourceLabel.textAlignment = NSTextAlignmentLeft;
        _sourceLabel.numberOfLines = 1;
        [self.contentView addSubview:_sourceLabel];
    }
    return _sourceLabel;
}

@end
