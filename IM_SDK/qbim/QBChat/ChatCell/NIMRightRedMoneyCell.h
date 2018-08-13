//
//  NIMRightRedMoneyCell.h
//  QianbaoIM
//
//  Created by fengsh on 15/12/2.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMRRightTableViewCell.h"

@interface NIMRightRedMoneyCell : NIMRRightTableViewCell

@property (nonatomic, strong) UIImageView            *redmoneylogo;
//红包口令/简介
@property (nonatomic, strong) UILabel                *redBagdesc;
//类型
@property (nonatomic, strong) UILabel                *redBagType;
//红包来源
@property (nonatomic, strong) UILabel                *redBagSource;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *bubble;

@end
