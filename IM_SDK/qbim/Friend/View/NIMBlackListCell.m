//
//  NIMBlackListCell.m
//  QBNIMClient
//
//  Created by 豆凯强 on 17/7/31.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBlackListCell.h"

@implementation NIMBlackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAutoLayout];
    }
    return self;
}

- (void)setAutoLayout
{

}

- (void)updateWithFDList:(FDListEntity *)fdlist{

    self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);
//    [self makeConstraints];
    
    NSString *firstName = [NIMStringComponents finFristNameWithID:fdlist.fdPeerId];

    [self.iconView setViewDataSourceFromUrlString:USER_ICON_URL(fdlist.fdPeerId)];
    self.titleLable.text = firstName;
}

- (UIView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] init];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.userInteractionEnabled = NO;
        _badgeView.layer.cornerRadius = 10;
        _badgeView.layer.masksToBounds = YES;
        UIImageView* img = [[UIImageView alloc] init];
        img.image = IMGGET(@"red");
        img.frame = CGRectMake(0, 0, 100, 100);
        [_badgeView addSubview:img];
        [self.contentView addSubview:_badgeView];
        [_badgeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_top).with.offset(-5);
            make.leading.equalTo(self.iconView.mas_trailing).with.offset(-10);
            make.width.greaterThanOrEqualTo(@20);
            make.height.equalTo(@20);
        }];
        [self.contentView bringSubviewToFront:_badgeView];
        
    }
    return _badgeView;
}
- (UILabel*)badgeLabel
{
    if(!_badgeLabel)
    {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [self.badgeView addSubview:_badgeLabel];
        [_badgeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.badgeView.mas_top);
            make.leading.equalTo(self.badgeView.mas_leading);
            make.trailing.equalTo(self.badgeView.mas_trailing);
            make.bottom.equalTo(self.badgeView.mas_bottom);
        }];
    }
    return _badgeLabel;
}

- (UIView*)vLine{
    if(!_vLine){
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = __COLOR_D5D5D5__;
        [self.contentView addSubview:_vLine];
        [_vLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.leading.equalTo(self.contentView.mas_leading);
            make.trailing.equalTo(self.contentView.mas_trailing);
            make.height.with.offset(_LINE_HEIGHT_1_PPI);
        }];
    }
    return _vLine;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
