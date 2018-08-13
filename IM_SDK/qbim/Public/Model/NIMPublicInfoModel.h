//
//  NIMPublicInfoModel.h
//  QianbaoIM
//
//  Created by qianwang on 15/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QBPublicInfoListModel;
@class QBPublicInfoFanModel;

@interface NIMPublicInfoModel : NSObject
@property(nonatomic ,strong)NSString     *userName;
@property(nonatomic ,strong)NSString     *need_auth;
@property(nonatomic ,strong)NSString     *subscribed;
@property(nonatomic ,strong)NSString     *thread;
@property(nonatomic ,strong)NSString     *url;
@property(nonatomic ,strong)NSString     *avatarPic;
@property(nonatomic ,strong)NSString     *userId;
@property(nonatomic ,strong)NSString     *pubSwitch;
@property(nonatomic ,strong)NSString     *role;
@property(nonatomic ,strong)NSString     *chantype;
@property(nonatomic ,strong)NSString     *fansnum;
@property(nonatomic ,strong)NSString     *nickName;
@property(nonatomic ,strong)NSString     *publicInfoId;
@property(nonatomic ,strong)NSString     *pubsubject;//账号主体
@property(nonatomic ,strong)NSString     *pubaccount;//公众号账号
@property(nonatomic ,strong)NSString     *subjecttype;
@property(nonatomic ,strong)NSString     *authpass; //是否通过验证
//1是黄的  2是蓝的subjecttype默认1
@property(nonatomic ,strong)QBPublicInfoListModel *publicInfoModel;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface QBPublicInfoListModel : NSObject
@property(nonatomic ,strong)NSString     *channame;
@property(nonatomic ,strong)NSString     *channicon;
@property(nonatomic ,strong)NSString     *publicInfoDescription;
@property(nonatomic ,strong)NSArray      *publicInfoFans;
@property(nonatomic ,strong)NSString     *merchantype;// 0：不是商家 1： 是个人商家  2：是企业商家 merchantype
- (instancetype)initWithDic:(NSDictionary *)dic;

@end

@interface QBPublicInfoFanModel : NSObject
@property(nonatomic ,strong)NSString     *userName;
@property(nonatomic ,strong)NSString     *updateTime;
@property(nonatomic ,strong)NSString     *isAuth;
@property(nonatomic ,strong)NSString     *mobile;
@property(nonatomic ,strong)NSString     *avatarPic;
@property(nonatomic ,strong)NSString     *userId;
@property(nonatomic ,strong)NSString     *nickName;
@property(nonatomic ,strong)NSString     *fanId;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
