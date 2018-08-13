//
//  NIMSPublicTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSubtitleTableViewCell.h"
#define kSPublicReuseIdentifier @"kSPublicReuseIdentifier"
@interface NIMSPublicTableViewCell : NIMSubtitleTableViewCell
@property (nonatomic, strong) UILabel   *tipLablel;
@property (nonatomic, strong) UIImageView   *lineView;
@property (nonatomic, assign) BOOL  hasTip;
//- (void)updateWithPublicEntity:(PublicEntity *)publicEntity hasTip:(BOOL)hasTip;
@end
