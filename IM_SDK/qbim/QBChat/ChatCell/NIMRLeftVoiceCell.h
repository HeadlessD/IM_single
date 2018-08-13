//
//  NIMRLeftVoiceCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTableViewCell.h"

@interface NIMRLeftVoiceCell : NIMRLeftTableViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *signView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end
