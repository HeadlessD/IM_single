//
//  NIMRLeftMerchandiseCell.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftMerchandiseCell.h"
#import "NSAttributedString+Attributes.h"

@implementation NIMRLeftMerchandiseCell


- (void)updateWithRecordEntity:(ChatEntity *)recordEntity{
    [super updateWithRecordEntity:recordEntity];
    
    NSString* sbody = recordEntity.msgContent;
    NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
    NSString *imageStr = PUGetObjFromDict(@"main_img", htmDic, [NSString class]);
    NSString *titleStr = PUGetObjFromDict(@"product_title", htmDic, [NSString class]);
    NSString *price = PUGetObjFromDict(@"product_desc", htmDic, [NSString class]);
    NSString *source_img = PUGetObjFromDict(@"source_img", htmDic, [NSString class]);
    NSString *source_txt = PUGetObjFromDict(@"source_txt", htmDic, [NSString class]);

    int inventory = [[htmDic objectForKey:@"stock_num"] intValue];
    if (IsStrEmpty(source_txt)) {
        source_txt = @"钱宝";
    }
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:IMGGET(@"bg_dialog_pictures")];
    self.titleLabel.text = titleStr?:[htmDic objectForKey:@"product_name"];
    self.sourceTxt.text = source_txt;
    [self.sourceImg sd_setImageWithURL:[NSURL URLWithString:source_img] placeholderImage:[UIImage imageNamed:@"fclogo"]];

    if (IsStrEmpty(price) /*|| price.doubleValue ==0*/)
    {
//        self.priceLabel.text=@"面议";
        self.priceLabel.hidden = NO;
        price = [htmDic objectForKey:@"product_price"];
        self.priceLabel.text = price?_IM_FormatStr(@"价格：%@",price):titleStr;
    }
    else
    {
//        price = _IM_FormatStr(@"%.0f",price.doubleValue * 100);
////        price = [SSIMSpUtil toThousand:price];
////        price = [SSIMSpUtil removePoint:price];
//        price = [SSIMSpUtil toThousand:[SSIMSpUtil convertDoubleToDoubleDigit:fabs(price.doubleValue)/100]];;
//
//        
//        NSString *str = _IM_FormatStr(@"价格: "__QB_UNIT__"%@" , price);
//        NSString * decimal = [SSIMSpUtil decimalString:str];
//
//        NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:str];
//        [attrStr setTextColor:[UIColor lightGrayColor]];
//        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:@__QB_UNIT__]];
//        [attrStr setFont:FONT_TITLE(12.0)];
//        [attrStr setFont:FONT_TITLE(11) range:[str rangeOfString:decimal]];
//
//        self.priceLabel.attributedText = attrStr;
        self.priceLabel.hidden = NO;
        
        self.priceLabel.text = price;
    }
    if (inventory == 0) {
    }else{
        self.inStockLabel.hidden = NO;
        self.inStockLabel.text = [NSString stringWithFormat:@"库存: %d 件",inventory];
    }
}

- (void)makeConstraints{
    [super makeConstraints];
    
    if (self.showName) {
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vNameLabel.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            //            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-60);
            make.width.equalTo(@(kMarginPaoPaoWidth));
            //            make.height.equalTo(@100);
        }];
    }else{
        [self.paoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarBtn.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.avatarBtn.mas_trailing).with.offset(10);
            //            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-60);
            make.width.equalTo(@(kMarginPaoPaoWidth));
            //            make.height.equalTo(@100);
        }];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paoButton.mas_top).with.offset(5);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(20);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-5);
        make.height.lessThanOrEqualTo(@40);
    }];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(5);
        //        make.bottom.equalTo(self.paoButton.mas_bottom).with.offset(-10);
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.paoButton.mas_leading).with.offset(11);
        make.trailing.equalTo(self.paoButton.mas_trailing);
        make.top.equalTo(self.iconView.mas_bottom).with.offset(10);
        make.height.equalTo(@1);
    }];
    
    [self.sourceImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconView.mas_leading);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [self.sourceTxt mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sourceImg.mas_trailing).with.offset(5);
        make.trailing.equalTo(self.lineView.mas_trailing);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.sourceImg.mas_centerY);
    }];

//    [self.inStockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconView.mas_top);
//        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
//        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-18);
//        make.height.greaterThanOrEqualTo(@16);
//        make.bottom.equalTo(self.iconView.mas_bottom);
//    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(5);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-5);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    [self.inStockLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.priceLabel.mas_bottom);
        make.leading.equalTo(self.priceLabel.mas_leading);
        make.trailing.equalTo(self.paoButton.mas_trailing).with.offset(-5);
        make.height.greaterThanOrEqualTo(@16);
        make.bottom.equalTo(self.iconView.mas_bottom);
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [SSIMSpUtil getColor:@"262626"];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        _priceLabel.numberOfLines = 4;
        _priceLabel.hidden = YES;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}
- (UILabel *)inStockLabel{
    if (!_inStockLabel) {
        _inStockLabel = [[NIMMyLable alloc] initWithFrame:CGRectZero];
        _inStockLabel.font = [UIFont systemFontOfSize:13];
        _inStockLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        _inStockLabel.numberOfLines = 0;
        _inStockLabel.verticalAlignment = VerticalAlignmentTop;
        _inStockLabel.textAlignment = NSTextAlignmentLeft;
        _inStockLabel.hidden = YES;
        [self.contentView addSubview:_inStockLabel];
    }
    return _inStockLabel;
}

-(UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [SSIMSpUtil getColor:@"DCDCDC"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)sourceTxt{
    if (!_sourceTxt) {
        _sourceTxt = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceTxt.font = [UIFont systemFontOfSize:10];
        _sourceTxt.textColor = [UIColor grayColor];
        _sourceTxt.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_sourceTxt];
    }
    return _sourceTxt;
}

-(UIImageView *)sourceImg
{
    if (!_sourceImg) {
        _sourceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fclogo"]];
        _sourceImg.clipsToBounds = YES;
        _sourceImg.contentMode = UIViewContentModeScaleAspectFill;
        _sourceImg.layer.cornerRadius = 2;
        [self.contentView addSubview:_sourceImg];
    }
    return _sourceImg;
}
@end
