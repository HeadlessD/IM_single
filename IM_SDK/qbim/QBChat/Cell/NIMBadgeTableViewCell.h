//
//  NIMBadgeTableViewCell.h
//  QianbaoIM
//
//  Created by Yun on 14/11/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"

#define kNIMBadgeTableViewCell       @"NIMBadgeTableViewCell"
#define kQBHeadBadgeTableViewCell   @"kQBHeadBadgeTableViewCell"

@interface NIMBadgeTableViewCell : NIMDefaultTableViewCell
@property (nonatomic, strong) UIView* badgeView;
@property (nonatomic, strong) UILabel* badgeLabel;
@property (nonatomic, strong) UIView* vLine;
@end
