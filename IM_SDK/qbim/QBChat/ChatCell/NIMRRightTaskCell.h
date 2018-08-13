//
//  NIMRRightTaskCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"

@interface NIMRRightTaskCell : NIMRRightTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *marginsLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UILabel *adCountLabel;

@property (nonatomic, strong) UILabel *baoQuanLabel;
@property (nonatomic, strong) UIImageView *baoQuanImageView;
@property (nonatomic, strong) UILabel *baoQuanrewardLabel;
@end
