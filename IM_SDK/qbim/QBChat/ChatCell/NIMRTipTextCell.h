//
//  NIMRTipTextCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/26.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"
#import "NIMQBLabel.h"
@interface NIMRTipTextCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) NIMQBLabel *nameLabel;
@end
