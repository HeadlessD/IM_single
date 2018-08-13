//
//  NIMRGainCell.h
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRGainCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) UIButton    *containerBtn;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView    *lineView;
@property (nonatomic, strong) UILabel    *tipLabel;
@property (nonatomic, strong) UIImageView    *accessory;
@end
