//
//  NIMRRightLBCell.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/7/30.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMRRightLBCell.h"

@implementation NIMRRightLBCell

- (void)awakeFromNib {
     
    [super awakeFromNib];
    [self.paoButton addGestureRecognizer:self.longPressRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = [htmDic objectForKey:@"icon"];
    NSString *titleStr = [htmDic objectForKey:@"title"];
    NSString *introStr = [htmDic objectForKey:@"description"];
    NSString *urlStr = [htmDic objectForKey:@"url"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"icon_dialouge_link.png")];
    self.titleLabel.text = titleStr;
    if (introStr == nil || introStr.length == 0) {
        introStr = urlStr;
    }
    self.introLabel.text = introStr;
}
- (void)makeConstraints{
    [super makeConstraints];
    
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo([NSNumber numberWithFloat:kMaxWidthContent]);
            //            make.height.equalTo(@100);
        }];
        
    }else{
        
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo([NSNumber numberWithFloat:kMaxWidthContent]);
            //            make.height.equalTo(@100);
        }];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(5);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(5);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-16);
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        //        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(-5);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(5);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.introLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
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
- (UIImage *)image{
    if (!_image) {
        _image = [IMGGET(@"bg_dialog_-forward_right.png")
                  resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UIImage *)highlightedImage{
    if (!_highlightedImage) {
        _highlightedImage = [IMGGET(@"bg_dialog_-forward_right_highlight")
                             resizableImageWithCapInsets:UIEdgeInsetsMake(30, 15, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _highlightedImage;
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
        _titleLabel.numberOfLines =2;
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
        _introLabel.numberOfLines = 0;
        _introLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}
- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.font = [UIFont systemFontOfSize:14];
        _sourceLabel.textColor = [UIColor darkGrayColor];
        _sourceLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_sourceLabel];
    }
    return _sourceLabel;
}

@end
