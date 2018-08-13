//
//  NIMRLeftTransactionCell.h
//  QianbaoIM
//
//  Created by qianwang on 14/11/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMRLeftTableViewCell.h"

@interface NIMRLeftTransactionCell : NIMRChatTableViewCell
@property (nonatomic, strong) UIButton    *timelineLabel;
@property (nonatomic, strong) UIButton    *containerBtn;
@property (nonatomic, strong) UILabel   *tipLabel;
@property (nonatomic, strong) UILabel   *timeLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UILabel *resonLabel;
@property (nonatomic, strong) UILabel *buyerLable;
@property (nonatomic, strong) UILabel *totalPriceLabel;

//@property (nonatomic)BOOL isCheck;
@end
