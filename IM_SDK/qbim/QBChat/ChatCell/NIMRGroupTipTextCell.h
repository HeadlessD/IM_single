//
//  NIMRGroupTipTextCell.h
//  qbim
//
//  Created by 秦雨 on 17/3/14.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMRGroupTipTextCell : NIMRChatTableViewCell
@property (nonatomic, strong) UILabel *timelineLabel;
@property (nonatomic, strong) NIMAttributedLabel *nameLabel;
@property (nonatomic, assign) NSRange lineboldRange;
@property (nonatomic, assign) NSRange lineboldRange1;
@end
