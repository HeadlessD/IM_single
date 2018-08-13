//
//  NIMRSinglePicTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRSinglePicTextCell.h"

@implementation NIMRSinglePicTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.containerView addGestureRecognizer:self.longPressRecognizer];
}

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    [self makeConstraints];

    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = [htmDic objectForKey:@"img_url"];
    NSString *titleStr = [htmDic objectForKey:@"title"];
    NSString *introStr = [htmDic objectForKey:@"digest"];
    NSString *ctStr = [htmDic objectForKey:@"ct"];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    self.nameLabel.text = titleStr;
    self.introLabel.text = ctStr;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.descLabel.text = introStr;
    
}
- (void)makeConstraints{

    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }else{
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).with.offset(5);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.introLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(0);
        make.leading.equalTo(self.nameLabel.mas_leading);
        make.trailing.equalTo(self.nameLabel.mas_trailing);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introLabel.mas_bottom).with.offset(5);
        make.leading.equalTo(self.introLabel.mas_leading);
        make.trailing.equalTo(self.introLabel.mas_trailing);
        make.height.equalTo(@140);
    }];
    
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(10);
        make.leading.equalTo(self.iconView.mas_leading);
//        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-50);
        make.trailing.equalTo(self.iconView.mas_trailing);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.descLabel.mas_leading);
        make.trailing.equalTo(self.descLabel.mas_trailing);
        make.height.equalTo(@1);
    }];
    
    [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(7);
        make.leading.equalTo(self.lineView.mas_leading).with.offset(0);
        make.trailing.equalTo(self.lineView.mas_trailing).with.offset(-30);
//        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-15);
        make.height.equalTo(@20);
    }];
    
    [self.accessory mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_top).with.offset(0);
        make.trailing.equalTo(self.lineView.mas_trailing).with.offset(0);
//        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-15);
        make.width.equalTo(@20);
       make.height.equalTo(@20);
    }];

}


#pragma mark actions
- (void)actionForward:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity action:ChatMenuActionTypeForward];
}
- (void)paoClick:(UIButton *)button{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}

#pragma mark getter
- (NSArray *)menuItems{
    if (!_menuItems) {
        _menuItems = @[kMenuItemForward];
    }
    return _menuItems;
}
- (UILabel *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:12];
        _timelineLabel.textColor = [UIColor lightGrayColor];
        _timelineLabel.numberOfLines = 1;
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timelineLabel];
    }
    return _timelineLabel;
}
- (UIButton *)containerView{
    if (!_containerView) {
        UIImage *image = IMGGET(@"bg_task_cell");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        
        
        UIImage *imageHightlight = IMGGET(@"bg_task_cell_hightlight");
        imageHightlight = [imageHightlight resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                          resizingMode:UIImageResizingModeStretch];
        
        _containerView = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_containerView setBackgroundImage:image forState:UIControlStateNormal];
        [_containerView setBackgroundImage:imageHightlight forState:UIControlStateHighlighted];
        [_containerView setBackgroundImage:imageHightlight forState:UIControlStateSelected];
        _containerView.clipsToBounds = YES;
        _containerView.contentMode = UIViewContentModeScaleAspectFill;
        _containerView.layer.cornerRadius = 2;
        [_containerView addTarget:self action:@selector(paoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_containerView];
    }
    return _containerView;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:IMGGET(@"")];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
//        _iconView.layer.cornerRadius = 2;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.textColor = [UIColor darkTextColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode =NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
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
- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.font = [UIFont systemFontOfSize:12];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.numberOfLines = 0;
        [self.contentView addSubview:_descLabel];
    }
    return _descLabel;
}
- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView.clipsToBounds = YES;
        _lineView.backgroundColor = [SSIMSpUtil getColor:@"d5d5d5"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor darkTextColor];
        _tipLabel.text = @"立即查看";
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}
- (UIImageView *)accessory{
    if (!_accessory) {
        _accessory = [[UIImageView alloc] initWithImage:IMGGET(@"icon_activity_enter")];
        _accessory.clipsToBounds = YES;
        [self.contentView addSubview:_accessory];
    }
    return _accessory;
}

@end
