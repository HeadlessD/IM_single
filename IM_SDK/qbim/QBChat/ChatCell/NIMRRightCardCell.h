//
//  NIMRRightCardCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRRightTableViewCell.h"

@interface NIMRRightCardCell : NIMRRightTableViewCell
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *accessory;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *typeLabel;

@end
