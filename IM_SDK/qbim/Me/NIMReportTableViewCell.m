//
//  NIMReportTableViewCell.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/3/20.
//  Copyright (c) 2015年 liu nian. All rights reserved.
//

#import "NIMReportTableViewCell.h"

@implementation NIMReportTableViewCell

- (void)awakeFromNib {
    // Initialization code

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setAutoLayout];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setAutoLayout
{
    [self.btnChooseBg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.top.equalTo(self.contentView.mas_top).with.offset(15);

        make.height.with.offset(22);
        make.width.width.offset(22);
    }];
    
    [self.labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.btnChooseBg.mas_trailing).with.offset(13);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-8);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-15);
        make.top.equalTo(self.contentView.mas_top).with.offset(18);
        
    }];
    
    [self.botomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.btnChooseBg.mas_trailing).with.offset(13);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-1);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
        make.height.with.offset(1);
        
    }];
}
- (UIButton*)btnChooseBg
{
    if(!_btnChooseBg)
    {
        _btnChooseBg = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnChooseBg setBackgroundImage:[[UIImage imageNamed:@"icon_square_unchecked"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_btnChooseBg setBackgroundImage:[[UIImage imageNamed:@"icon_square_selected"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateHighlighted];
        [_btnChooseBg setBackgroundImage:[[UIImage imageNamed:@"icon_square_selected"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]forState:UIControlStateSelected];
        [_btnChooseBg addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnChooseBg];
    }
    return _btnChooseBg;
}
- (UILabel*)labTitle
{
    if(!_labTitle)
    {
        _labTitle = [[UILabel alloc] init];
        _labTitle.font = BOLDFONT_TITLE(16);
        _labTitle.textColor = __COLOR_262626__;
        _labTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}
- (void)chooseClick:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(chooseBtnClick:)])
    {
        [_delegate chooseBtnClick:self];
    }
}
- (UIImageView*)botomLine
{
    if(!_botomLine)
    {
        _botomLine = [[UIImageView alloc]init];
        _botomLine.backgroundColor=[SSIMSpUtil getColor:@"e6e6e6"];
        
        _botomLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_botomLine];
    }
    return _botomLine;
}

@end
