//
//  NIMSContactTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/9/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSContactTableViewCell.h"

@interface NIMSContactTableViewCell ()
@property (nonatomic, strong, readwrite) FDListEntity *contactEntity;
@property (nonatomic, strong, readwrite) GroupList *groupEntity;
@end

@implementation NIMSContactTableViewCell
@synthesize contactEntity = _contactEntity;
@synthesize groupEntity = _groupEntity;

#pragma mark config
- (void)makeConstraints{
    [super makeConstraints];
    if (_hasTip)
    {
        [self.tipLablel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(10);
            make.height.equalTo(@20);
        }];
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipLablel.mas_bottom).with.offset(5);
            make.leading.equalTo(self.contentView.mas_leading).with.offset(0);
            make.trailing.equalTo(self.contentView.mas_trailing).with.offset(0);
            make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
        }];
        
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom).with.offset(5);
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
//            make.width.equalTo(40);
            make.leading.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@45);
        }];

    }
    else
    {
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).with.offset(10);
//            make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
//            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
            make.leading.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@45);
        }];
    }
    
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_top).with.offset(10);
        make.leading.equalTo(self.iconView.mas_trailing).with.offset(10);
        make.bottom.equalTo(self.iconView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-10);
    }];
    
}
#pragma mark getter
- (UILabel *)tipLablel{
    if (!_tipLablel) {
        _tipLablel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLablel.numberOfLines = 1;
        _tipLablel.font = [UIFont systemFontOfSize:14];
        _tipLablel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_tipLablel];
    }
    return _tipLablel;
}
- (UIImageView *)lineView{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:nil];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _lineView.backgroundColor = [SSIMSpUtil getColor:@"e6e6e6"];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
@end
