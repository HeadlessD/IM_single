//
//  NIMAddFriendAttributeCell.h
//  QBNIMClient
//
//  Created by 豆凯强 on 2017/8/16.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMRChatTableViewCell.h"

@interface NIMAddFriendAttributeCell : NIMRChatTableViewCell


@property (nonatomic, strong) UILabel * timelineLabel;
@property (nonatomic, strong) UIView * blackView;
@property (nonatomic, strong) NIMAttributedLabel *btnStrLabel;
@property (nonatomic, assign) NSRange lineboldRange;
@property (nonatomic, assign) NSRange lineboldRange1;


@end
