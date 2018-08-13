//
//  NIMRRightTaskCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTaskCell.h"
#import "NSAttributedString+Attributes.h"
@implementation NIMRRightTaskCell
- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = PUGetObjFromDict(@"img_url", htmDic, [NSString class]);
    NSString *titleStr =PUGetObjFromDict(@"task_name", htmDic, [NSString class]);
    NSString *margins = PUGetObjFromDict(@"margins", htmDic, [NSString class]);
    NSString *reward = PUGetObjFromDict(@"reward", htmDic, [NSString class]);
    NSString *ad_count = PUGetObjFromDict(@"ad_count", htmDic, [NSString class]);
    NSString *baoquan = PUGetObjFromDict(@"baoquan", htmDic, [NSString class]);
    NSString *taskID = PUGetObjFromDict(@"task_id", htmDic, [NSString class]);
    
    if (IsStrEmpty(baoquan) || baoquan.doubleValue == 0) {
        [self baoquanConstraints];
    }
    else
    {
        self.baoQuanLabel.hidden = NO;
        self.baoQuanImageView.hidden = NO;
        self.baoQuanrewardLabel.hidden = NO;
    }
    
    if ([taskID doubleValue] > TASK_ID_FOR_ACTIVE) {//判断是分享任务
        self.adCountLabel.hidden = YES;
        [self.marginsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baoQuanLabel.mas_bottom);
            make.leading.equalTo(self.baoQuanLabel.mas_leading);
            make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
            make.height.greaterThanOrEqualTo(@16);
        }];
    }
    
    margins = [SSIMSpUtil toThousandByW:margins];
    reward = [SSIMSpUtil toThousandByW:reward];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.titleLabel.text = titleStr;

    {
//        NSString *str = _IM_FormatStr(@"钱宝收益: "__QB_UNIT__"%@" , reward);
//        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
//        [attrStr setTextColor:[UIColor lightGrayColor]];
//        [attrStr setFont:FONT_TITLE(12.0)];
//        [attrStr setFont:__QB_UNIT__FONT(11) range:[str rangeOfString:@__QB_UNIT__]];
//        self.rewardLabel.attributedText = attrStr;
        
        NSString *str = _IM_FormatStr(@"收益(元): %@" , reward);
        self.rewardLabel.text = str;
    }
    
    self.baoQuanrewardLabel.text =[SSIMSpUtil toThousand:baoquan];
    
    {
        NSString *str = _IM_FormatStr(@"保证金(元): %@" , margins);
        self.marginsLabel.text = str;
//        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
//        [attrStr setTextColor:[UIColor lightGrayColor]];
//        [attrStr setFont:FONT_TITLE(12.0)];
//        [attrStr setFont:__QB_UNIT__FONT(11) range:[str rangeOfString:@__QB_UNIT__]];
//        self.marginsLabel.attributedText = attrStr;
    }
    self.adCountLabel.text = [NSString stringWithFormat:@"广告数:%@条",ad_count];;
}

-(void)baoquanConstraints
{
    
    self.baoQuanLabel.hidden = YES;
    self.baoQuanImageView.hidden = YES;
    self.baoQuanrewardLabel.hidden = YES;
    
    [self.rewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    [self.adCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLabel.mas_bottom);
        make.leading.equalTo(self.rewardLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    [self.marginsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adCountLabel.mas_bottom);
        make.leading.equalTo(self.rewardLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
}

- (void)makeConstraints{
    [super makeConstraints];
    
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@(kMarginPaoPaoWidth));
//            make.height.equalTo(@100);
        }];
        
    }else{
        
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.trailing.equalTo(self.avatarBtn.mas_leading).with.offset(-10);
            make.width.equalTo(@(kMarginPaoPaoWidth));
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
    
    [self.rewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    [self.baoQuanLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLabel.mas_bottom);
        make.leading.equalTo(self.rewardLabel.mas_leading);
        make.width.equalTo(@55);
        make.height.equalTo(@16);
    }];
    
    [self.baoQuanImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLabel.mas_bottom).offset(2.5);
        make.leading.equalTo(self.baoQuanLabel.mas_trailing);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];
    
    [self.baoQuanrewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardLabel.mas_bottom);
        make.leading.equalTo(self.baoQuanImageView.mas_trailing).offset(1);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@16);
    }];
    
    [self.adCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baoQuanLabel.mas_bottom);
        make.leading.equalTo(self.baoQuanLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    [self.marginsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adCountLabel.mas_bottom);
        make.leading.equalTo(self.rewardLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.greaterThanOrEqualTo(@16);
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

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rewardLabel.font = [UIFont systemFontOfSize:12];
        _rewardLabel.textColor = [UIColor lightGrayColor];
        _rewardLabel.numberOfLines = 1;
        
        _rewardLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_rewardLabel];
    }
    return _rewardLabel;
}
- (UILabel *)adCountLabel{
    if (!_adCountLabel) {
        _adCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _adCountLabel.font = [UIFont systemFontOfSize:12];
        _adCountLabel.textColor = [UIColor lightGrayColor];
        _adCountLabel.textAlignment = NSTextAlignmentLeft;
        _adCountLabel.numberOfLines = 1;
        [self.contentView addSubview:_adCountLabel];
    }
    return _adCountLabel;
}
- (UILabel *)marginsLabel{
    if (!_marginsLabel) {
        _marginsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _marginsLabel.font = [UIFont systemFontOfSize:12];
        _marginsLabel.textColor = [UIColor lightGrayColor];
        _marginsLabel.textAlignment = NSTextAlignmentLeft;
        _marginsLabel.numberOfLines = 1;
        [self.contentView addSubview:_marginsLabel];
    }
    return _marginsLabel;
}

- (UILabel *)baoQuanLabel{
    if (!_baoQuanLabel) {
        _baoQuanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _baoQuanLabel.font = [UIFont systemFontOfSize:12];
        _baoQuanLabel.textColor = [UIColor lightGrayColor];
        _baoQuanLabel.numberOfLines = 1;
        _baoQuanLabel.text = @"宝券收益:";
        _baoQuanLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_baoQuanLabel];
    }
    return _baoQuanLabel;
}

-(UIImageView *)baoQuanImageView
{
    if (!_baoQuanImageView) {
        _baoQuanImageView = [UIImageView new];
        _baoQuanImageView.image = IMGGET(@"baoquan");
        [self.contentView addSubview:_baoQuanImageView];
    }
    return _baoQuanImageView;
}

- (UILabel *)baoQuanrewardLabel{
    if (!_baoQuanrewardLabel) {
        _baoQuanrewardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _baoQuanrewardLabel.font = [UIFont systemFontOfSize:12];
        _baoQuanrewardLabel.textColor = [UIColor lightGrayColor];
        _baoQuanrewardLabel.numberOfLines = 1;
        
        _baoQuanrewardLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_baoQuanrewardLabel];
    }
    return _baoQuanrewardLabel;
}

@end
