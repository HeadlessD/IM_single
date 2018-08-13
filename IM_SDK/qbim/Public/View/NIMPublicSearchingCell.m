//
//  NIMPublicSearchingCell.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/7/10.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicSearchingCell.h"

@implementation NIMPublicSearchingCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataSource:(NSString*)searching type:(NSInteger)type
{
    self.type =type;
    [self.m_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.m_imageView.mas_trailing).with.offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.height.greaterThanOrEqualTo(@20);
    }];
    NSString *resultString=nil;

    if (type==0) {
        resultString =[NSString stringWithFormat:@"搜索：%@",searching];
    }
    else if (type==1)
    {
        resultString =[NSString stringWithFormat:@"没有搜索到结果"];
        
    }
    
    NSMutableAttributedString *attrituteString1 = [[NSMutableAttributedString alloc] initWithString:resultString];
    NSRange range1 =NSMakeRange(0, 0);
    if (type==0) {
        range1 =[resultString rangeOfString:searching];
;
    }
    else if (type==1)
    {
        range1 =[resultString rangeOfString:@"没有搜索到结果"];
;
    }
    if (type==0) {
        self.titleLable.textColor =[UIColor blackColor];
        self.m_imageView.hidden=NO;
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.m_imageView.mas_trailing).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
            make.height.greaterThanOrEqualTo(@20);
        }];

        [attrituteString1 setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:16]} range:range1];
    }
    else if(type==1)
    {
        [attrituteString1 setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor],   NSFontAttributeName : [UIFont systemFontOfSize:18]} range:range1];
        self.titleLable.textColor =[UIColor lightGrayColor];
        self.m_imageView.hidden=YES;
        [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.height.greaterThanOrEqualTo(@20);
        }];

    }
    self.titleLable.attributedText = attrituteString1;

}
-(UIImageView*)m_imageView
{
    if(!_m_imageView)
    {
        _m_imageView = [[UIImageView alloc] init];
        _m_imageView.image =IMGGET(@"icon_search_public.png");
        [self.contentView addSubview:_m_imageView];
        _m_imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _m_imageView;
}
-(UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont systemFontOfSize:16];
        _titleLable.textColor = [SSIMSpUtil getColor:@"262626"];
        [self.contentView addSubview:_titleLable];
        _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    if (self.type==1) {
        _titleLable.lineBreakMode =NSLineBreakByCharWrapping;
        _titleLable.numberOfLines=3;
    }
    else
    {
        _titleLable.lineBreakMode =NSLineBreakByTruncatingTail;
        _titleLable.numberOfLines=1;

    }

    return _titleLable;
}

@end
