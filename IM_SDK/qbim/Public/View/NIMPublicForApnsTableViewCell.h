//
//  NIMPublicForApnsTableViewCell.h
//  QianbaoIM
//
//  Created by qianwang on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMPublicInfoModel.h"

@class NIMPublicForApnsTableViewCell;
//@protocol NIMPublicForApnsTableViewCellDelegate <NSObject>
//
//-(void)chooseAPNSAction:(BOOL)open;
//
//@end
@interface NIMPublicForApnsTableViewCell : UITableViewCell
@property (strong, nonatomic) UISwitch *apnsSwitch;
@property (strong, nonatomic) UILabel  *apnsTitleLAbel;

//@property(nonatomic ,weak)id<NIMPublicForApnsTableViewCellDelegate>delegate;
-(void)setDataSource:(NIMPublicInfoModel *)model;
@end
