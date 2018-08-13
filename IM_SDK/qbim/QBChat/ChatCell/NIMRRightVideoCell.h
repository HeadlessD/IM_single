//
//  NIMRRightVideoCell.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/27.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMRRightTableViewCell.h"
#import "NIMInstallView.h"
@interface NIMRRightVideoCell : NIMRRightTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NIMInstallView *bgView;
@property (nonatomic, strong) UIImageView *playView;

@end
