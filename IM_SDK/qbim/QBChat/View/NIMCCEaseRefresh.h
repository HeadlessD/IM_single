//
//  NIMCCEaseRefresh.h
//  NIMCCEaseRefresh
//
//  Created by v－ling on 15/9/18.
//  Copyright (c) 2015年 LiuZeChen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 刷新状态枚举
typedef NS_ENUM(NSInteger, NIMCCEaseRefreshState) {
    NIMCCEaseRefreshStateDefault = 0,
    NIMCCEaseRefreshStateVisible = 1, // 下拉消除全部未读提醒
    NIMCCEaseRefreshStateTrigger = 2, // 松开消除全部未读提醒
    NIMCCEaseRefreshStateLoading = 3  // 正在刷新
};

#define CCEaseDefaultTitle  @"下拉消除全部未读提醒"
#define CCEaseTriggertTitle @"松开消除全部未读提醒"
#define CCEaseLoadingTitle  @"松开消除全部未读提醒"  // 正在刷新
#define CCEaseTitleLength @"下拉消除全部未读提醒"  // 下拉刷新的字数
#define CCEaseFirstTextPull  @"下拉"
#define CCEaseFirstTextUp  @"松开"
#define CCEaseSecondText  @"消除全部未读提醒"
#define CCUpdateTimeKey     @"CCUpdateTimeKey"

@interface NIMCCEaseRefresh : UIControl

// 刷新状态
@property (nonatomic, assign) NIMCCEaseRefreshState refreshState;

// 初始化
- (instancetype)initInScrollView:(UIScrollView *)scrollView;

// 刷新方法
- (void)beginRefreshing;
- (void)endRefreshing;

@end
