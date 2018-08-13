//
//  NIMBlackListCell.h
//  QBNIMClient
//
//  Created by 豆凯强 on 17/7/31.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NIMDefaultTableViewCell.h"

@interface NIMBlackListCell : NIMDefaultTableViewCell
@property (nonatomic, strong) UIView* badgeView;
@property (nonatomic, strong) UILabel* badgeLabel;
@property (nonatomic, strong) UIView* vLine;


- (void)updateWithFDList:(FDListEntity *)fdlist;

@end
    
