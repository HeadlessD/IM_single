//
//  NIMPublicForApnsTableViewCell.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicForApnsTableViewCell.h"

@implementation NIMPublicForApnsTableViewCell

- (void)awakeFromNib {
     
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataSource:(NIMPublicInfoModel *)model
{
    [self makeConstraints];
    self.apnsTitleLAbel.text = @"接收消息";
    self.apnsSwitch.on = !model.pubSwitch.boolValue;
}

- (void)makeConstraints{
    [self.apnsTitleLAbel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.leading.equalTo(@15);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    [self.apnsSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.trailing.equalTo(self.mas_trailing);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
}
- (UILabel *)apnsTitleLAbel{
    if (!_apnsTitleLAbel) {
        _apnsTitleLAbel = [[UILabel alloc] init];
        _apnsTitleLAbel.font = [UIFont systemFontOfSize:15];
        _apnsTitleLAbel.textColor = [SSIMSpUtil getColor:@"262626"];
        [self.contentView addSubview:_apnsTitleLAbel];
    }
    return _apnsTitleLAbel;
}
- (UISwitch*)apnsSwitch{
    if(!_apnsSwitch){
        _apnsSwitch = [[UISwitch alloc] init];
        _apnsSwitch.on = YES;
//        [_apnsSwitch addTarget:self action:@selector(chooseApns:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_apnsSwitch];
    }
    return _apnsSwitch;
}
//- (void)chooseApns:(id)sender {
//    if ([_delegate performSelector:@selector(chooseAPNSAction:) withObject:self]) {
//        [_delegate chooseAPNSAction:self.apnsSwitch.on];
//    }
//}



@end
