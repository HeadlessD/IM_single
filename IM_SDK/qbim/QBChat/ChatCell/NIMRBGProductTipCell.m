//
//  NIMRBGProductTipCell.m
//  QianbaoIM
//
//  Created by xuqing on 15/10/19.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMRBGProductTipCell.h"
#import "NSAttributedString+Attributes.h"
@implementation NIMRBGProductTipCell


- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    NSString* sbody = recordEntity.msgContent;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = PUGetObjFromDict(@"main_img", htmDic, [NSString class]);
    NSString *titleStr = PUGetObjFromDict(@"product_title", htmDic, [NSString class]);
    NSString *price =PUGetObjFromDict(@"product_price", htmDic, [NSString class]);
    //    NSString *inventory = [htmDic objectForKey:@"inventory"];
    if (self.showTimeline) {
        self.timelineLabel.text = [SSIMSpUtil parseTime:recordEntity.ct/1000];
        self.timelineLabel.hidden = NO;
    }else{
        self.timelineLabel.hidden = YES;
    }
    [self makeConstraints];

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.nameLabel.text = titleStr;
    if (IsStrEmpty(price) || price.doubleValue ==0)
    {
        self.priceLabel.text = @"面议";
    }
    else
    {
        price = _IM_FormatStr(@"%.0f",price.doubleValue);
//        price = [SSIMSpUtil toThousand:price];
//        price = [SSIMSpUtil removePoint:price];
        price = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(price.doubleValue)]];;
        NSString *str = _IM_FormatStr(@""__QB_UNIT__"%@" , price);
        NSString * decimal = [SSIMSpUtil decimalString:str];

        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
        [attrStr setTextColor:[UIColor lightGrayColor]];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:@__QB_UNIT__]];
        [attrStr setFont:FONT_TITLE(12.0)];
        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:decimal]];

        self.priceLabel.attributedText = attrStr;
    }

}

- (void)makeConstraints{
    
    if (self.showTimeline) {
        CGSize tsize =[NSString nim_getSizeFromString:self.timelineLabel.text withFont:[UIFont systemFontOfSize:13] andLabelSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-kMarginTipText, CGFLOAT_MAX)];

        [self.timelineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
//            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(tsize.width+13));
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
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).with.offset(5);
        make.leading.equalTo(self.containerView.mas_leading).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(0);
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
    
    
    
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
}

#pragma mark actions
- (void)BGsendClick:(id)sender{
    [_delegate chatTableViewCell:self didSendBGProductWithRecordEntity:self.recordEntity];
}
- (void)paoClick:(id)sender{
    [_delegate chatTableViewCell:self didSelectedWithRecordEntity:self.recordEntity];
}
#pragma mark getter
- (UILabel *)timelineLabel{
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timelineLabel.font = [UIFont systemFontOfSize:13];
        _timelineLabel.numberOfLines = 1;
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        _timelineLabel.backgroundColor = kTipColor;
        _timelineLabel.textColor = [UIColor whiteColor];
        _timelineLabel.layer.cornerRadius = 4;
        _timelineLabel.layer.masksToBounds = YES;
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
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
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
        [_sendBtn addTarget:self action:@selector(BGsendClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_sendBtn];
    }
    return _sendBtn;
}
@end
