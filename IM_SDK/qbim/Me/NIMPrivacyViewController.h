//
//  NIMPrivacyViewController.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/26.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMTableViewController.h"
#import "DFSettingItem.h"

typedef void(^settingBlock)(DFSettingItem *item);

@interface NIMPrivacyViewController : NIMTableViewController
@property (weak, nonatomic) IBOutlet UISwitch *listPicSwitch;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (weak, nonatomic) IBOutlet UISwitch *tipSwitch;

@property (copy,nonatomic)settingBlock settingBlock;

@end
