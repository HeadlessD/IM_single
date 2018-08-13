//
//  NIMVcardTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/8/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kResuIdentifier @"NIMVcardTableViewCell"
@interface NIMVcardTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *avatarBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end
