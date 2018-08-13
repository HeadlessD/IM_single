//
//  NIMBadgeTableViewCell.m
//  QianbaoIM
//
//  Created by Yun on 14/11/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMBadgeTableViewCell.h"

@implementation NIMBadgeTableViewCell

- (void)updateWithVcardEntity:(VcardEntity *)vcardEntty{
    [super updateWithVcardEntity:vcardEntty];
    [self setBottomFrame];
}

//- (void)updateWithPublicEntity:(PublicEntity *)publicEntty{
////    [super updateWithPublicEntity:publicEntty];
//    [self setBottomFrame];
//}

- (void)updateWithImage:(UIImage *)image name:(NSString *)name{
    [super updateWithImage:image name:name];
    [self setBottomFrame];
}

- (void)setBottomFrame{
//    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.contentView.mas_leading).with.offset(60);
//        make.bottom.equalTo(self.mas_bottom).with.offset(0);
//        make.trailing.equalTo(self.mas_trailing).with.offset(0);
//        make.height.equalTo(_LINE_HEIGHT_1_PPI);
//    }];
}

- (UIView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] init];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.userInteractionEnabled = NO;
        _badgeView.layer.cornerRadius = 10;
        _badgeView.layer.masksToBounds = YES;
        UIImageView* img = [[UIImageView alloc] init];
        img.image = IMGGET(@"05");
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

@end
