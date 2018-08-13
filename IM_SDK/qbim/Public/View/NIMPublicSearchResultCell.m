//
//  NIMPublicSearchResultCell.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicSearchResultCell.h"

@implementation NIMPublicSearchResultCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}
- (void)setCellDataSource:(publicMode*)publicmode searchString:(NSString*)searchString
{
    [self setAutoLayOut];
    self.m_publicMode =publicmode;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:publicmode.avatarPic] placeholderImage:[UIImage imageNamed:@"fclogo"]];
   if([publicmode.subjecttype isEqualToString:@"1"]&&[publicmode.authpass isEqualToString:@"1"])
   {
       [self.flagImage setImage:IMGGET(@"icon_personal.png")];
   }
    else if([publicmode.subjecttype isEqualToString:@"2"])
    {
       [self.flagImage setImage:IMGGET(@"icon_enterprise.png")];
    }
    else
    {
       [self.flagImage setImage:nil];
    }
    
        if (IsStrEmpty(publicmode.nickName)) {
            self.nameLable.text=@"";
        }
        else{
            NSString *nameString =[NSString stringWithFormat:@"%@",publicmode.nickName];
    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:nameString];
    NSRange range = [nameString rangeOfString:searchString];
    [attrituteString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} range:range];
    self.nameLable.attributedText = attrituteString;
        }
        if (IsStrEmpty(publicmode.userAccount)) {
            self.numbLable.text = @"";
        }
        else
        {
            NSString *numString =[NSString stringWithFormat:@"公众号账号：%@",publicmode.userAccount];
            NSMutableAttributedString *attrituteString1 = [[NSMutableAttributedString alloc] initWithString:numString];
            NSRange range1 = [numString rangeOfString:searchString];
            [attrituteString1 setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:14]} range:range1];
            self.numbLable.attributedText = attrituteString1;
        }

    if(publicmode.recommend.integerValue>0)
    {
        self.JXflagImage.image =IMGGET(@"icon_list_select");
    }
    else
    {
        self.JXflagImage.image =nil;
    }
    if ([publicmode.subscribed isEqualToString:@"0"]) {
        [_followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_followBtn setBackgroundImage:self.redBoxImage forState:UIControlStateNormal];
        [_followBtn setBackgroundImage:self.redBoxImageHighlighted forState:UIControlStateHighlighted];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.followBtn setEnabled:YES];
    }
    else
    {
        [self.followBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.followBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.followBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
        [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followBtn setEnabled:NO];
    }


}
-(void)updateButnState
{
    [self.followBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.followBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [self.followBtn setEnabled:NO];
}
-(void)changeButnState
{
    [_followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_followBtn setBackgroundImage:self.redBoxImage forState:UIControlStateNormal];
    [_followBtn setBackgroundImage:self.redBoxImageHighlighted forState:UIControlStateHighlighted];
    [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.followBtn setEnabled:YES];
}

-(void)followBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JXPublicfollowBtnPressed:publicMode:)]) {
        [self.delegate JXPublicfollowBtnPressed:self publicMode:self.m_publicMode];
    }
}
-(void)setAutoLayOut
{
    [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    [self.flagImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImage.mas_right);
        make.bottom.equalTo(self.iconImage.mas_bottom);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];

    
    
    [self.nameLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.leading.equalTo(self.iconImage.mas_trailing).with.offset(10);
        make.width.greaterThanOrEqualTo(@10);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [self.JXflagImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLable.mas_right).with.offset(5);
        make.centerY.equalTo(self.nameLable.mas_centerY);
        make.trailing.lessThanOrEqualTo(self.followBtn.mas_leading).with.offset(-10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];

    [self.numbLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLable.mas_leading);
        make.top.equalTo(self.nameLable.mas_bottom).with.offset(5);
        make.trailing.equalTo(self.followBtn.mas_leading).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
//    [self.detailLable mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
//        make.top.equalTo(self.numbLable.mas_bottom).with.offset(5);
//        make.leading.equalTo(self.iconImage.mas_trailing).with.offset(10);
//        make.height.greaterThanOrEqualTo(20);
//    }];
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLable.mas_leading);
        make.bottom.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
    }];
    [self.followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@25);
    }];

    
}
-(UIImageView*)line
{
    if (!_line) {
        _line = [[UIImageView alloc]init];
        _line.backgroundColor=[SSIMSpUtil getColor:@"e6e6e6"];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_line];
    }
    return _line;
}

-(UILabel *)nameLable
{
    if (!_nameLable) {
        _nameLable = [UILabel new];
        _nameLable.font = [UIFont boldSystemFontOfSize:16];
        _nameLable.textColor = [SSIMSpUtil getColor:@"262626"];
        _nameLable.numberOfLines = 1;

        _nameLable.lineBreakMode = NSLineBreakByTruncatingTail;

        [self.contentView addSubview:_nameLable];
        _nameLable.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _nameLable;
}
-(UIImageView*)iconImage
{
    if(!_iconImage)
    {
        _iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImage];
        _iconImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconImage;
}

-(UILabel *)numbLable
{
    if (!_numbLable) {
        _numbLable = [UILabel new];
        _numbLable.font = [UIFont systemFontOfSize:14];
        _numbLable.textColor = [SSIMSpUtil getColor:@"888888"];
        [self.contentView addSubview:_numbLable];
        _numbLable.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _numbLable;
}
//-(UILabel *)detailLable
//{
//    if (!_detailLable) {
//        _detailLable = [UILabel new];
//        _detailLable.font = [UIFont systemFontOfSize:14];
//        _detailLable.textColor = [SSIMSpUtil getColor:@"888888"];
//        _detailLable.lineBreakMode = NSLineBreakByCharWrapping;
//        _detailLable.numberOfLines = 2;
//        [self.contentView addSubview:_detailLable];
//        _detailLable.translatesAutoresizingMaskIntoConstraints = NO;
//        
//    }
//    return _detailLable;
//}
-(UIImageView*)flagImage
{
    if (!_flagImage) {
        _flagImage = [[UIImageView alloc] init];
        [self.iconImage addSubview:_flagImage];
        _flagImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _flagImage;
}
-(UIImageView*)JXflagImage
{
    if (!_JXflagImage) {
        _JXflagImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_JXflagImage];
        _JXflagImage.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _JXflagImage;
}
- (UIImage *)redBoxImage{
    if (!_redBoxImage) {
        _redBoxImage = [IMGGET(@"btn_taskhelper_dotask_select") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                 resizingMode:UIImageResizingModeStretch];
    }
    return _redBoxImage;
}

- (UIImage *)redBoxImageHighlighted{
    if (!_redBoxImageHighlighted) {
        _redBoxImageHighlighted = [IMGGET(@"btn_taskhelper_dotask_select") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                                            resizingMode:UIImageResizingModeStretch];
    }
    return _redBoxImageHighlighted;
}

#pragma mark
- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followBtn];
    }
    return _followBtn;
}

@end
