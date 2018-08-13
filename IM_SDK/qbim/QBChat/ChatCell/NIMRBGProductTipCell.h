//
//  NIMRBGProductTipCell.h
//  QianbaoIM
//
//  Created by xuqing on 15/10/19.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRBGProductTipCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel    *timelineLabel;
@property (nonatomic, strong) UIButton *containerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *sendBtn;
@end
