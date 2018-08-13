//
//  NIMRProductTipCell.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRProductTipCell.h"
#import "NSAttributedString+Attributes.h"
@implementation NIMRProductTipCell

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    [self makeConstraints];
    
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = PUGetObjFromDict(@"order_img", htmDic, [NSString class]);
    NSString *titleStr = PUGetObjFromDict(@"order_title", htmDic, [NSString class]);
    NSString *price =PUGetObjFromDict(@"order_price", htmDic, [NSString class]);
    NSString *state =PUGetObjFromDict(@"order_status", htmDic, [NSString class]);
    NSString *refundState =PUGetObjFromDict(@"order_list_desc", htmDic, [NSString class]);
    NSString *orderid =PUGetObjFromDict(@"order_id", htmDic, [NSString class]);
    int number =[PUGetObjFromDict(@"order_num", htmDic, [NSString class]) intValue];
    int unit =[PUGetObjFromDict(@"unit", htmDic, [NSString class]) intValue];
    NSString *total =PUGetObjFromDict(@"order_pay", htmDic, [NSString class]);

    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.nameLabel.text = titleStr;
    self.stateLabel.text = state;
    self.idLabel.text = _IM_FormatStr(@"订单号：%@",orderid);
    self.payLabel.text = _IM_FormatStr(@"实付：￥%@",[SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(total.doubleValue)/100]]);
    self.refundLabel.text = refundState;
    if (IsStrEmpty(price) || price.doubleValue ==0)
    {
        self.priceLabel.text = @"面议";
    }
    else
    {
        price = _IM_FormatStr(@"%.0f",price.doubleValue);
//        price = [SSIMSpUtil toThousand:price];
//        price = [SSIMSpUtil removePoint:price];
        price = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(price.doubleValue)/100]];

        NSString *str = _IM_FormatStr(@""__QB_UNIT__"%@" , price);
        NSString * decimal = [SSIMSpUtil decimalString:str];

        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
        [attrStr setTextColor:[UIColor lightGrayColor]];
        [attrStr setFont:FONT_TITLE(12.0)];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:@__QB_UNIT__]];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:decimal]];

        self.priceLabel.attributedText = attrStr;
    }
    if (number <= 0) {
        self.nameLabel.hidden = YES;
    }else{
        self.numberlabel.text = _IM_FormatStr(@"x %d",number);
    }
}

- (void)makeConstraints{
    
    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
        
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }else{
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }
    
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).with.offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self.idLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_top).with.offset(0);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(10);
        make.trailing.equalTo(self.stateLabel.mas_leading).with.offset(5);
        make.height.mas_equalTo(@20);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.height.equalTo(@(20));
        make.width.greaterThanOrEqualTo(@(70));
    }];
    [self.numberlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.height.equalTo(@(20));
        make.width.greaterThanOrEqualTo(@(70));
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.priceLabel.mas_leading).with.offset(-10);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.payLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_leading).with.offset(0);
        make.trailing.equalTo(self.priceLabel.mas_trailing).with.offset(0);
        make.height.greaterThanOrEqualTo(@20);
        make.bottom.equalTo(self.iconView.mas_bottom);
    }];
    
    [self.refundLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.payLabel.mas_top);
        make.height.equalTo(@15);
    }];

    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom).with.offset(10);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(10);
        make.trailing.equalTo(self.containerView.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-10);
    }];
}

#pragma mark actions
- (void)sendClick:(id)sender{
    [_delegate chatTableViewCell:self didSendProductWithRecordEntity:self.recordEntity];
}
- (void)paoClick:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}
#pragma mark getter
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

-(UILabel *)idLabel
{
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _idLabel.font = [UIFont boldSystemFontOfSize:14];
        _idLabel.textColor = [UIColor lightGrayColor];
        _idLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_idLabel];
    }
    return _idLabel;
}

-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
        _stateLabel.textColor = [UIColor redColor];
        _stateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_stateLabel];
    }
    return _stateLabel;
}

-(UILabel *)numberlabel
{
    if (!_numberlabel) {
        _numberlabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberlabel.font = [UIFont boldSystemFontOfSize:12];
        _numberlabel.textColor = [UIColor lightGrayColor];
        _numberlabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_numberlabel];
    }
    return _numberlabel;
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
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(UILabel *)refundLabel
{
    if (!_refundLabel) {
        _refundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refundLabel.font = [UIFont systemFontOfSize:12];
        _refundLabel.textColor = [SSIMSpUtil getColor:@"3399CC"];
        _refundLabel.numberOfLines = 1;
        _refundLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_refundLabel];
    }
    return _refundLabel;
}

-(UILabel *)payLabel
{
    if (!_payLabel) {
        _payLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _payLabel.font = [UIFont systemFontOfSize:14];
        _payLabel.textColor = [UIColor blackColor];
        _payLabel.numberOfLines = 0;
        _payLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_payLabel];
    }
    return _payLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor lightGrayColor];
        _priceLabel.numberOfLines = 0;
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}


- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发给商家" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[SSIMSpUtil getColor:@"2b93fd"] forState:UIControlStateNormal];
        _sendBtn.clipsToBounds = YES;
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _sendBtn.contentMode = UIViewContentModeScaleAspectFill;
        _sendBtn.layer.cornerRadius = 2;
        _sendBtn.layer.borderColor = [SSIMSpUtil getColor:@"2b93fd"].CGColor;
        _sendBtn.layer.borderWidth = 1.0;
        [_sendBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
    }
    return _sendBtn;
}
@end
