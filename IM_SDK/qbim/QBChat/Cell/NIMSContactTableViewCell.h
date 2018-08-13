//
//  NIMSContactTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"

#define kSContactReuseIdentifier @"kSContactReuseIdentifier"

@interface NIMSContactTableViewCell : NIMDefaultTableViewCell
@property (nonatomic, strong) UILabel   *tipLablel;
@property (nonatomic, strong) UIImageView   *lineView;
@property (nonatomic, assign) BOOL      hasTip;
@end
