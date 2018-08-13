//
//  NIMRSinglePicTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRSinglePicTextCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) UIButton    *containerView;
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *introLabel;
@property (nonatomic, strong) UIImageView    *iconView;
@property (nonatomic, strong) UILabel    *descLabel;
@property (nonatomic, strong) UIImageView    *lineView;
@property (nonatomic, strong) UILabel    *tipLabel;
@property (nonatomic, strong) UIImageView    *accessory;
@end
