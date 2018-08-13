//
//  NIMSubtitleTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubtitleTableViewCell.h"

@implementation NIMSubtitleTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self makeConstraints];
    }
    
    return self;
}


#pragma mark config
- (void)updateWithName:(NSString *)name icon:(NSString *)icon intro:(NSString *)intro{
    self.titleLable.text = name;
    [self.iconView setViewDataSourceFromUrlString:icon];
    self.introLablel.text = intro;
}
#pragma mark config
- (void)makeConstraints{
    [super makeConstraints];
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(-5);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
        make.height.equalTo(@20);
    }];
    
    
    [self.introLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLable.mas_bottom).with.offset(0);
        make.leading.equalTo(self.titleLable.mas_leading);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
        make.bottom.equalTo(self.iconView.mas_bottom).offset(10);
//        make.height.equalTo(@20);
        
    }];
    
}
#pragma mark getter
- (MLEmojiLabel *)introLablel{
    if (!_introLablel) {
        _introLablel = [[MLEmojiLabel alloc] initWithFrame:CGRectZero];
        _introLablel.numberOfLines = 1;
        _introLablel.lineBreakMode =NSLineBreakByTruncatingTail;
        _introLablel.font = [UIFont systemFontOfSize:14];
        _introLablel.textColor = __COLOR_888888__;
        [self.contentView addSubview:_introLablel];
    }
    _introLablel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    _introLablel.customEmojiPlistName = @"faceMapQQNew.plist";
    _introLablel.isNeedAtAndPoundSign = YES;
    _introLablel.userInteractionEnabled = NO;
    return _introLablel;
}
- (UIImageView *)infoImg{
    if (!_infoImg) {
        _infoImg = [[UIImageView alloc] initWithImage:IMGGET(@"icon_dialog_marvel")];
        [self.contentView addSubview:_infoImg];
    }
    return _infoImg;
}
@end
