//
//  NIMPublicInfoModel.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicInfoModel.h"

@implementation NIMPublicInfoModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.userName              = PUGetObjFromDict(@"userName",          dic, [NSString class]);
        self.need_auth             = PUGetObjFromDict(@"need_auth",         dic, [NSString class]);
        self.subscribed            = PUGetObjFromDict(@"subscribed",        dic, [NSString class]);
        self.thread                = PUGetObjFromDict(@"thread",            dic, [NSString class]);
        self.url                   = PUGetObjFromDict(@"url",               dic, [NSString class]);
        self.avatarPic             = PUGetObjFromDict(@"avatarPic",         dic, [NSString class]);
        self.userId                = PUGetObjFromDict(@"userId",            dic, [NSString class]);
        self.pubSwitch             = PUGetObjFromDict(@"switch",         dic, [NSString class]);
        self.role                  = PUGetObjFromDict(@"role",              dic, [NSString class]);
        self.chantype              = PUGetObjFromDict(@"chantype",          dic, [NSString class]);
        self.fansnum               = PUGetObjFromDict(@"fansnum",           dic, [NSString class]);
        self.nickName              = PUGetObjFromDict(@"nickName",          dic, [NSString class]);
        self.pubsubject          = PUGetObjFromDict(@"subjectname",      dic, [NSString class]);
        self.pubaccount          = PUGetObjFromDict(@"pubaccount",      dic, [NSString class]);
        self.subjecttype          = PUGetObjFromDict(@"subjecttype",      dic, [NSString class]);
        self.publicInfoId          = PUGetObjFromDict(@"id",      dic, [NSString class]);
        self.authpass          = PUGetObjFromDict(@"authpass",      dic, [NSString class]);
        NSDictionary *publicInfo   = PUGetObjFromDict(@"pubinfo",      dic, [NSDictionary class]);
        
        self.publicInfoModel  = [[QBPublicInfoListModel alloc]initWithDic:publicInfo];
    }
    return self;
}
@end


@implementation QBPublicInfoListModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.channame              = PUGetObjFromDict(@"channame",          dic, [NSString class]);
        self.channicon             = PUGetObjFromDict(@"channicon",         dic, [NSString class]);
        self.publicInfoDescription = PUGetObjFromDict(@"description",        dic, [NSString class]);
        self.merchantype          = PUGetObjFromDict(@"merchantype",      dic, [NSString class]);
        NSArray *arr =PUGetObjFromDict(@"few_fans",        dic, [NSArray class]);
        NSMutableArray  *temp       = NSMutableArray.new;
        for (NSDictionary *modelDic in arr)
        {
            QBPublicInfoFanModel *model = [[QBPublicInfoFanModel alloc]initWithDic:modelDic];
            [temp addObject:model];
        }
        self.publicInfoFans = temp;
    }
    return self;
}
@end

@implementation QBPublicInfoFanModel
-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.userName              = PUGetObjFromDict(@"userName",          dic, [NSString class]);
        self.updateTime            = PUGetObjFromDict(@"updateTime",         dic, [NSString class]);
        self.isAuth                = PUGetObjFromDict(@"isAuth",            dic, [NSString class]);
        self.mobile                = PUGetObjFromDict(@"mobile",               dic, [NSString class]);
        self.avatarPic             = PUGetObjFromDict(@"avatarPic",         dic, [NSString class]);
        self.userId                = PUGetObjFromDict(@"userId",            dic, [NSString class]);
        self.nickName              = PUGetObjFromDict(@"nickName",          dic, [NSString class]);
        self.fanId                 = PUGetObjFromDict(@"id",          dic, [NSString class]);
    }
    return self;
}
@end
