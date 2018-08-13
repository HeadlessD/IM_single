//
//  NIMRRightOrderCell.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightOrderCell.h"
#import "NSAttributedString+Attributes.h"
@implementation NIMRRightOrderCell

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = PUGetObjFromDict(@"order_img", htmDic, [NSString class]);
//    NSString *titleStr = [htmDic objectForKey:@"title"];

    NSString *refund_amount = PUGetObjFromDict(@"refund_amount", htmDic, [NSString class]);
    NSString *unitPrice = PUGetObjFromDict(@"order_price", htmDic, [NSString class]);

    NSString *total = PUGetObjFromDict(@"order_pay", htmDic, [NSString class]);
    NSString *number = PUGetObjFromDict(@"order_num", htmDic, [NSString class]);
    NSString *state = PUGetObjFromDict(@"order_status", htmDic, [NSString class]);

    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.titleLabel.text = [NSString stringWithFormat:@"订单号:%@",[htmDic objectForKey:@"order_id"]];
    if(total.doubleValue == 0)
    {
        self.moneyLabel.text = @"实付: 0.00";
    }
    else
    {
        total = _IM_FormatStr(@"%.0f",total.doubleValue);
        total = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(total.doubleValue)/100]];
        NSString *str = _IM_FormatStr(@"实付: "__QB_UNIT__"%@" , total);
        if (!IsStrEmpty(refund_amount) && refund_amount.doubleValue >0) {
            str = _IM_FormatStr(@"交易金额: "__QB_UNIT__"%@" , total);
        }
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
        [attrStr setTextColor:[UIColor lightGrayColor]];
        [attrStr setFont:FONT_TITLE(12.0)];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:@__QB_UNIT__]];
        
        self.moneyLabel.attributedText = attrStr;
    }
    
    self.refundMoneyLabel.hidden = YES;
    if (!IsStrEmpty(unitPrice) && unitPrice.doubleValue >0) {
        unitPrice = _IM_FormatStr(@"%.0f",unitPrice.doubleValue);
//        refund_amount = [SSIMSpUtil toThousand:refund_amount];
//        refund_amount = [SSIMSpUtil removePoint:refund_amount];
        unitPrice = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(unitPrice.doubleValue)/100]];
        NSString *str = _IM_FormatStr(@"商品金额: "__QB_UNIT__"%@" , unitPrice);
        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
        [attrStr setTextColor:[UIColor lightGrayColor]];
        [attrStr setFont:FONT_TITLE(12.0)];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:@__QB_UNIT__]];
        self.refundMoneyLabel.hidden = NO;
        self.refundMoneyLabel.attributedText = attrStr;
        [self updatemakeConstraints];
    }

    if (number.intValue <=0 ) {
        self.numLabel.hidden = YES;
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"数量: %@ 件",number];
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@",state];;
}

-(void)updatemakeConstraints
{
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@15);
    }];
    
    [self.refundMoneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@15);
    }];
    
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundMoneyLabel.mas_bottom);
        make.leading.equalTo(self.moneyLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@15);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom);
        make.leading.equalTo(self.numLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@15);
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
    
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@20);
    }];
    
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.leading.equalTo(self.moneyLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
        make.height.equalTo(@20);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom);
        make.leading.equalTo(self.numLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
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
- (UIImage *)image{
    if (!_image) {
        _image = [IMGGET(@"nim_chat_frame_right")
                  resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _image;
}

- (UIImage *)highlightedImage{
    if (!_highlightedImage) {
        _highlightedImage = [IMGGET(@"nim_chat_frame_right_hl")
                             resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 10, 30) resizingMode:UIImageResizingModeStretch];
    }
    return _highlightedImage;
}
- (NSArray *)menuItems{
    return @[];
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

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyLabel.font = [UIFont systemFontOfSize:12];
        _moneyLabel.textColor = [UIColor lightGrayColor];
        _moneyLabel.numberOfLines = 4;
        _moneyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UILabel *)refundMoneyLabel{
    if (!_refundMoneyLabel) {
        _refundMoneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundMoneyLabel.font = [UIFont systemFontOfSize:12];
        _refundMoneyLabel.textColor = [UIColor lightGrayColor];
        _refundMoneyLabel.numberOfLines = 1;
        _refundMoneyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_refundMoneyLabel];
    }
    return _refundMoneyLabel;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = [UIColor lightGrayColor];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.numberOfLines = 1;
        [self.contentView addSubview:_numLabel];
    }
    return _numLabel;
}
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor lightGrayColor];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.numberOfLines = 1;
        [self.contentView addSubview:_statusLabel];
    }
    return _statusLabel;
}
@end
