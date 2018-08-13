//
//  NIMSystemInfoCell.m
//  QianbaoIM
//
//  Created by Yun on 14/9/19.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSystemInfoCell.h"

@interface NIMSystemInfoCell()
@property (nonatomic, strong) UIButton* btnBg;
@property (nonatomic, strong) UILabel* labTitle;
@property (nonatomic, strong) UILabel* labDateTime;
@property (nonatomic, strong) UILabel* labContent;
@property (nonatomic, strong) UIView* vLine;
@property (nonatomic, strong) UILabel* labDetail;
@property (nonatomic, strong) UIImageView* imageDetail;
@end

@implementation NIMSystemInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight:(NSDictionary*)dic//有数据需要修改为收益实体
{
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width-54;
    NSString* stitle = dic[@"title"];
    NSString* con = dic[@"content"];
    CGSize tsize = [NSString nim_getSizeFromString:stitle
                                      withFont:[UIFont boldSystemFontOfSize:18] andLabelSize:CGSizeMake(width, MAXFLOAT)];
    CGSize csize = [NSString nim_getSizeFromString:con
                                      withFont:[UIFont systemFontOfSize:14] andLabelSize:CGSizeMake(width, MAXFLOAT)];
    
    return 12+15+tsize.height+10+14+csize.height+17+45;
}
- (void)setCellDataSource:(NSDictionary*)dic
{
    [self setAutoLayout];
    NSString* stitle = dic[@"title"];
    NSString* con = dic[@"content"];
    NSString* datetime = dic[@"datetime"];
    _labTitle.text = stitle;
    _labDateTime.text = datetime;
    _labContent.text = con;
}

#pragma mark setAutoLayout
- (void)setAutoLayout
{
    [self.btnBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(13);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnBg.mas_top).with.offset(15);
        make.leading.equalTo(self.btnBg.mas_leading).with.offset(12);
        make.trailing.equalTo(self.btnBg.mas_trailing).with.offset(-12);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.labDateTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labTitle.mas_bottom).with.offset(6);
        make.leading.equalTo(self.btnBg.mas_leading).with.offset(12);
        make.trailing.equalTo(self.btnBg.mas_trailing).with.offset(-12);
        make.height.with.offset(15);
    }];
    
    [self.labContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btnBg.mas_bottom).with.offset(-55);
        make.leading.equalTo(self.btnBg.mas_leading).with.offset(12);
        make.trailing.equalTo(self.btnBg.mas_trailing).with.offset(-12);
        make.height.with.greaterThanOrEqualTo(@20);
    }];
    
    [self.vLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.btnBg.mas_leading).with.offset(20);
        make.trailing.equalTo(self.btnBg.mas_trailing).with.offset(-20);
        make.bottom.equalTo(self.btnBg.mas_bottom).with.offset(-45);
        make.height.with.offset(1);
    }];

    [self.labDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.btnBg.mas_leading).with.offset(12);
        make.bottom.equalTo(self.btnBg.mas_bottom);
        make.height.with.offset(45);
        make.width.with.offset(200);
    }];
    
    [self.imageDetail mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.btnBg.mas_trailing).with.offset(-12);
        make.bottom.equalTo(self.btnBg.mas_bottom).with.offset(-15);
        make.width.with.offset(15);
        make.height.with.offset(15);
    }];
}

#pragma mark geter
- (UIButton*)btnBg
{
    if(!_btnBg)
    {
        _btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnBg setBackgroundImage:[IMGGET(@"bg_task_cell") stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
        [_btnBg setBackgroundImage:[IMGGET(@"bg_task_cell_hightlight") stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateHighlighted];
        [_btnBg setBackgroundImage:[IMGGET(@"bg_task_cell_hightlight") stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateSelected];
        [self.contentView addSubview:_btnBg];
    }
    return _btnBg;
}

- (UILabel*)labTitle
{
    if(!_labTitle)
    {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = [UIFont boldSystemFontOfSize:18];
        _labTitle.textColor = [SSIMSpUtil getColor:@"262626"];
        _labTitle.numberOfLines = 0;
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}
- (UILabel*)labDateTime
{
    if(!_labDateTime)
    {
        _labDateTime = [[UILabel alloc] init];
        _labDateTime.font = [UIFont systemFontOfSize:12];
        _labDateTime.textColor = __COLOR_888888__;
        [self.contentView addSubview:_labDateTime];
    }
    return _labDateTime;
}
- (UILabel*)labContent
{
    if(!_labContent)
    {
        _labContent = [[UILabel alloc] init];
        _labContent.font = [UIFont systemFontOfSize:14];
        _labContent.textColor = __COLOR_888888__;
        _labContent.numberOfLines = 0;
        [self.contentView addSubview:_labContent];
    }
    return _labContent;
}

- (UIView*)vLine
{
    if(!_vLine)
    {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = [SSIMSpUtil getColor:@"D5D5D5"];
        [self.contentView addSubview:_vLine];
    }
    return _vLine;
}

- (UILabel*)labDetail
{
    if(!_labDetail)
    {
        _labDetail = [[UILabel alloc]init];
        _labDetail.text = @"详情";
        _labDetail.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_labDetail];
    }
    return _labDetail;
}

- (UIImageView*)imageDetail
{
    if(!_imageDetail)
    {
        _imageDetail = [[UIImageView alloc] init];
        _imageDetail.image = IMGGET(@"icon_activity_enter");
        [self.contentView addSubview:_imageDetail];
    }
    return _imageDetail;
}
@end
