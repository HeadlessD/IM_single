//
//  NIMVcardTableViewCell.m
//  QianbaoIM
//
//  Created by liunian on 14/8/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMVcardTableViewCell.h"

@implementation NIMVcardTableViewCell

- (void)awakeFromNib {
     
    [super awakeFromNib];
    self.avatarBtn.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
