//
//  NIMSubDetailTableViewCell.h
//  QianbaoIM
//
//  Created by liunian on 14/9/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMDefaultTableViewCell.h"
@class GroupList;

#define kSubDetailReuseIdentifier @"kSubDetailReuseIdentifier"
@protocol NIMSubDetailTableViewCellDelegate <NSObject>



@end
@interface NIMSubDetailTableViewCell : NIMDefaultTableViewCell
@property (nonatomic, strong) UILabel   *deLablel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
//让控制器成为Cell的代理
@property (nonatomic, weak) id<NIMSubDetailTableViewCellDelegate>datasource;

- (void)updateWithGroupList:(GroupList *)groupEntity;

@end

