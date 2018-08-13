//
//  NIMSubAccessoryTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubtitleTableViewCell.h"
#define kSubAccessoryReuseIdentifier @"kSubAccessoryReuseIdentifier"

@interface NIMSubAccessoryTableViewCell : NIMSubtitleTableViewCell
@property(nonatomic, strong) UIButton *accessoryBtn;

//趣味相同的人使用
- (void)updateWithInterest:(NSDictionary *)dic;
@end
