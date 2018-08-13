//
//  NIMOldTableViewCell.m
//  QianbaoIM
//
//  Created by xuqing on 15/11/18.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMOldTableViewCell.h"

@implementation NIMOldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
 
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.accessImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-25));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}
-(UIImageView *)accessImage
{
    if (!_accessImage) {
        _accessImage =[[UIImageView alloc]init];
        _accessImage.image =IMGGET(@"icon_activity_enter");
        [self.contentView addSubview:_accessImage];
    }
    return _accessImage;
}
@end
