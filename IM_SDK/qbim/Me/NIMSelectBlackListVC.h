//
//  NIMSelectBlackListVC.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/27.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMViewController.h"

@class NIMSelectBlackListVC;
@protocol NIMSelectBlackListVCDelegate <NSObject>

@optional
- (void)selectListViewController:(NIMSelectBlackListVC *)viewController didSelectUsers:(NSArray *)users userNames:(NSArray *)userNames;
@end


@interface NIMSelectBlackListVC : NIMViewController
@property (nonatomic, weak) id<NIMSelectBlackListVCDelegate>delegate;
@property (nonatomic, assign) BOOL  showSelected;
@property (nonatomic, assign) BOOL  isBlack;
@property (nonatomic, strong) NSArray  *selectedUsers;

@end
