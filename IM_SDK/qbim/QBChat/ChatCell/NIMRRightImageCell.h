//
//  NIMRRightImageCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"
#import "NIMInstallView.h"


@interface NIMRRightImageCell : NIMRRightTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) NIMInstallView *bgView;

@end
