//
//  NIMPublicInfoTableViewCell.h
//  QianbaoIM
//
//  Created by qianwang on 15/6/23.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicInfoModel.h"

@interface NIMPublicInfoTableViewCell : UITableViewCell
@property (nonatomic ,strong)UIImageView *iconImageView;
@property (nonatomic ,strong)UIImageView *typeImageView;
@property (nonatomic ,strong)UILabel *nameLabel;
@property (nonatomic ,strong)UILabel *contentLabel;
-(void)setDataSource:(NIMPublicInfoModel *)model;
@end
