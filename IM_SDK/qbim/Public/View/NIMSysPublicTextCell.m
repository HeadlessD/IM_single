//
//  NIMSysPublicTextCell.m
//  QianbaoIM
//
//  Created by liunian on 14/10/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSysPublicTextCell.h"
#import "NSString+NIMMyDefine.h"

@implementation NIMSysPublicTextCell


- (void)updateWithPublicText:(NSString *)text{
    [self makeConstraints];
    self.introLabel.text = text;
}
#pragma mark config
- (void)makeConstraints{
    [self.introLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.leading.equalTo(self.mas_leading).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.mas_trailing).with.offset(-15);
    }];
}

#pragma mark getter
- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _introLabel.font = [UIFont systemFontOfSize:14];
        _introLabel.textColor = [UIColor darkGrayColor];
        _introLabel.numberOfLines = 0;
        [self.contentView addSubview:_introLabel];
    }
    return _introLabel;
}


+ (CGFloat)heightSysPublicTextCellWithText:(NSString *)text{
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGSize size = [text nim_calculateSize:CGSizeMake(CGRectGetWidth(bounds) - 30, 1000) font:[UIFont systemFontOfSize:14]];
    return size.height + 20;
}
@end
