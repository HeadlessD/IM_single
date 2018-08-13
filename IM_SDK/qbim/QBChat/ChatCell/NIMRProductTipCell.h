//
//  NIMRProductTipCell.h
//  QianbaoIM
//
//  Created by qianwang on 14/11/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRProductTipCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) UIButton *containerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numberlabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *refundLabel;
@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@end
