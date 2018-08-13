//
//  NIMRLeftTransactionCell.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTransactionCell.h"
#import "NSAttributedString+Attributes.h"

@implementation NIMRLeftTransactionCell

- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    NSString* sbody = recordEntity.msgContent;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *unit = PUGetObjFromDict(@"unit", htmDic, [NSString class]);
    NSInteger tType = [[htmDic objectForKey:@"type"] integerValue];
    NSDictionary *dataDic = [htmDic objectForKey:@"data"];
//    NSString *errorMsg = [dataDic objectForKey:@"errorMsg"];

//    if (IsStrEmpty(errorMsg)) {
//        self.isCheck = NO;
//    }
//    else
//    {
//        self.isCheck = YES;
//
//    }

    [self makeConstraints];
    if (self.showTimeline) {
        [self.timelineLabel setTitle:[SSIMSpUtil parseTime:recordEntity.ct/1000] forState:UIControlStateNormal ];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    /*
     {"data":{"orderId":171,"picUrl":"http://qbsns.qiniudn.com/FvAkh9EKOu6AOxwv7BrLWWE1LF9z","title":"买家待付款","productName":"大跌牌眼镜","buyerUserNickName":"Tianshan","orderAmount":"0.00","orderStatus":1,"buyUserId":2007300,"productId":190},"type":1000}
     */
//    if (IsStrEmpty(errorMsg)) {
//        self.isCheck = NO;
//    }
//    else
//    {
//        self.isCheck = YES;
//        NSString *msg = nil;
//        if (errorMsg.length >8 ) {
//            msg = [errorMsg substringToIndex:8];
//            self.resonLabel.text = [NSString stringWithFormat:@"(%@...)",msg];
//
//        }
//        else {
//            msg = errorMsg;
//            self.resonLabel.text = [NSString stringWithFormat:@"(%@)",msg];
//        }
//    }
    NSString *picUrl = [dataDic objectForKey:@"picUrl"];
    NSString *tip = [dataDic objectForKey:@"title"];
    NSString *productName = [dataDic objectForKey:@"productName"];
    NSString *refundAmount = dataDic[@"refundAmount"];

    NSString *price =PUGetObjFromDict(@"price", dataDic, [NSString class]);
    
    self.tipLabel.text = tip;
    self.timeLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.nameLabel.text = productName;
    if (tType == 1000)
    {
        NSString *buyerUserNickName = [dataDic objectForKey:@"buyerUserNickName"];
        NSString *orderAmount = [dataDic objectForKey:@"orderAmount"];
//        NSInteger orderStatus = [[dataDic objectForKey:@"orderStatus"] integerValue];
        
        self.buyerLable.text = [NSString stringWithFormat:@"买家:%@",buyerUserNickName];
        if (orderAmount.floatValue == 0 && refundAmount.floatValue == 0)
        {
            self.totalPriceLabel.text =[NSString stringWithFormat:@"实付:面议"];
        }
        else
        {
            if (refundAmount.floatValue!=0) {
                if (unit.intValue == 0) {
                    refundAmount = _IM_FormatStr(@"%.0f",refundAmount.doubleValue*100);
                }
                else if (unit.intValue == 1)
                {
                    refundAmount = _IM_FormatStr(@"%.0f",refundAmount.doubleValue);
                }
                refundAmount = _IM_FormatStr(@"%.0f",refundAmount.doubleValue);
//                refundAmount = [SSIMSpUtil toThousand:refundAmount];
//                refundAmount = [SSIMSpUtil removePoint:refundAmount];
                refundAmount = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(refundAmount.doubleValue)/100]];;

                
                NSString *str = _IM_FormatStr(@"退款: "__QB_UNIT__"%@" , refundAmount);
                NSString * decimal = [SSIMSpUtil decimalString:str];

                NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
                [attrStr setTextColor:[UIColor lightGrayColor]];
                [attrStr setFont:FONT_TITLE(13.0)];
                [attrStr setFont:FONT_TITLE(12) range:[str rangeOfString:@__QB_UNIT__]];
                [attrStr setFont:FONT_TITLE(12) range:[str rangeOfString:decimal]];

                self.totalPriceLabel.attributedText = attrStr;
            }else{
                if (unit.intValue == 0) {
                    orderAmount = _IM_FormatStr(@"%.0f",orderAmount.doubleValue*100);
                }
                else if (unit.intValue == 1)
                {
                    orderAmount = _IM_FormatStr(@"%.0f",orderAmount.doubleValue);
                }
                orderAmount = _IM_FormatStr(@"%.0f",orderAmount.doubleValue);
//                orderAmount = [SSIMSpUtil toThousand:orderAmount];
//                orderAmount = [SSIMSpUtil removePoint:orderAmount];
                orderAmount = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(orderAmount.doubleValue)/100]];;

                NSString *str = _IM_FormatStr(@"实付: "__QB_UNIT__"%@" , orderAmount);
                NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
                [attrStr setTextColor:[UIColor lightGrayColor]];
                [attrStr setFont:FONT_TITLE(13.0)];
                [attrStr setFont:FONT_TITLE(12) range:[str rangeOfString:@__QB_UNIT__]];
                
                self.totalPriceLabel.attributedText = attrStr;
            }
        }
    }
    else if (tType == 1001)
    {
        NSInteger stock = [[dataDic objectForKey:@"stock"] integerValue];
        self.buyerLable.text = [NSString stringWithFormat:@"库存:%ld",(long)stock];
        if (price.floatValue == 0)
        {
            self.totalPriceLabel.text =[NSString stringWithFormat:@"总价:面议"];
        }
        else
        {
            price = _IM_FormatStr(@"%.0f",price.doubleValue * 100);
//            price = [SSIMSpUtil toThousand:price];
//            price = [SSIMSpUtil removePoint:price];
            price = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(price.doubleValue)/100]];;

            NSString *str = _IM_FormatStr(@"总价: "__QB_UNIT__"%@" , price);
            NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
            [attrStr setTextColor:[UIColor lightGrayColor]];
            [attrStr setFont:FONT_TITLE(13.0)];
            [attrStr setFont:FONT_TITLE(12) range:[str rangeOfString:@__QB_UNIT__]];
            
            self.totalPriceLabel.attributedText = attrStr;
            
        }
    }
    
}
- (void)makeConstraints{
    
    if (self.showTimeline) {
        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.leading.equalTo(self.contentView.mas_centerX).with.offset(-40);
            make.trailing.equalTo(self.contentView.mas_centerX).with.offset(40);
            make.height.equalTo(@20);
        }];
        
        [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timelineLabel.mas_bottom).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }else{
        [self.containerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            
        }];
    }
//    if (self.isCheck) {
//        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.containerBtn.mas_top).with.offset(10);
//            make.leading.equalTo(self.containerBtn.mas_leading).with.offset(10);
//            make.width.equalTo(@125);
//            make.height.equalTo(@20);
//        }];
//        [self.resonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.containerBtn.mas_top).with.offset(10);
//            make.leading.equalTo(self.tipLabel.mas_trailing).with.offset(0);
//            make.trailing.equalTo(self.containerBtn.mas_trailing).with.offset(-5);
//            make.height.equalTo(@20);
//        }];
//    }
//    else
//    {
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerBtn.mas_top).with.offset(10);
            make.leading.equalTo(self.containerBtn.mas_leading).with.offset(10);
            make.trailing.equalTo(self.containerBtn.mas_trailing).with.offset(-10);
            make.height.equalTo(@20);
        }];
//    }
    
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(5);
        make.leading.equalTo(self.tipLabel.mas_leading).with.offset(0);
        make.trailing.equalTo(self.tipLabel.mas_trailing).with.offset(0);
        make.height.equalTo(@20);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(5);
        make.leading.equalTo(self.timeLabel.mas_leading).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(3);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.containerBtn.mas_trailing).with.offset(-10);
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.buyerLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(9);
        make.leading.equalTo(self.nameLabel.mas_leading);
        make.trailing.equalTo(self.nameLabel.mas_trailing);
        make.height.equalTo(@15);
    }];
    
    [self.totalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyerLable.mas_bottom).with.offset(5);
        make.leading.equalTo(self.buyerLable.mas_leading);
        make.trailing.equalTo(self.buyerLable.mas_trailing);
        make.height.equalTo(@15);
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
- (UIButton *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UIButton alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:12];
        [_timelineLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _timelineLabel.titleLabel.numberOfLines = 1;
        _timelineLabel.backgroundColor = [SSIMSpUtil getColor:@"D5D5D5"];
        _timelineLabel.layer.cornerRadius =10;
        _timelineLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timelineLabel];
    }
    return _timelineLabel;
}

- (UIButton *)containerBtn{
    if (!_containerBtn) {
        UIImage *image = IMGGET(@"bg_task_cell");
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        
        
        UIImage *imageHightlight = IMGGET(@"bg_task_cell_hightlight");
        imageHightlight = [imageHightlight resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                          resizingMode:UIImageResizingModeStretch];
        
        _containerBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_containerBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateHighlighted];
        [_containerBtn setBackgroundImage:imageHightlight forState:UIControlStateSelected];
        _containerBtn.clipsToBounds = YES;
        [_containerBtn addTarget:self action:@selector(paoClick:) forControlEvents:UIControlEventTouchUpInside];
        _containerBtn.contentMode = UIViewContentModeScaleAspectFill;
        _containerBtn.layer.cornerRadius = 2;
        [self.contentView addSubview:_containerBtn];
    }
    return _containerBtn;
}
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont boldSystemFontOfSize:17];
        _tipLabel.textColor = [SSIMSpUtil getColor:@"262626"];
        _tipLabel.text = @"买家下订单";
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.text = @"";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.clipsToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameLabel.textColor = [SSIMSpUtil getColor:@"262626"];
        _nameLabel.text = @"";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

//- (UILabel *)resonLabel{
//    if (!_resonLabel) {
//        _resonLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _resonLabel.font = [UIFont systemFontOfSize:15];
//        _resonLabel.textColor = [SSIMSpUtil getColor:@"2b93fd"];
//        _resonLabel.text = @"";
//        _resonLabel.textAlignment = NSTextAlignmentLeft;
//        [self.contentView addSubview:_resonLabel];
//    }
//    return _resonLabel;
//}

- (UILabel *)buyerLable{
    if (!_buyerLable) {
        _buyerLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _buyerLable.font = [UIFont systemFontOfSize:13];
        _buyerLable.textColor = [SSIMSpUtil getColor:@"888888"];
        _buyerLable.text = @"";
        _buyerLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_buyerLable];
    }
    return _buyerLable;
}
- (UILabel *)totalPriceLabel{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalPriceLabel.font = [UIFont systemFontOfSize:13];
        _totalPriceLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        _totalPriceLabel.text = @"";
        _totalPriceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_totalPriceLabel];
    }
    return _totalPriceLabel;
}
@end
