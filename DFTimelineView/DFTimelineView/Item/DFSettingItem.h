//
//  DFSettingItem.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/25.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFSettingItem : NSObject

@property (nonatomic, assign) int64_t userId;               //用户id
@property (nonatomic, assign) BOOL listPicFree;             //是否允许陌生人查看10张照片，0：否 1：是
@property (nonatomic, assign) Moments_Scope momentsScope;   //朋友圈查看范围  0:全部 1：最近三天 2：最近半年
@property (nonatomic, assign) BOOL momentsEnable;           //是否开启朋友圈入口 0：不开启 1：开启
@property (nonatomic, assign) BOOL momentsNotice;           //朋友圈信息提示（在“发现”按钮上面) 0：不提示 1：提示
@property (nonatomic, assign) int64_t updateTime;           //更新时间
@property (nonatomic, copy) NSString *blackList;          //黑名单
@property (nonatomic, copy) NSString *notCareList;        //不关注名单

@end
