//
//  publicMode.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/29.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicMode.h"

@implementation publicMode
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.userName                 = PUGetObjFromDict(@"userName",         dic, [NSString class]);
        self.userId                 = PUGetObjFromDict(@"userId",       dic, [NSString class]);
        self.publicid           = PUGetObjFromDict(@"id",       dic, [NSString class]);
        self.avatarPic                 = PUGetObjFromDict(@"avatarPic",         dic, [NSString class]);
        self.need_auth                 = PUGetObjFromDict(@"need_auth",       dic, [NSString class]);
        self.url                 = PUGetObjFromDict(@"url",       dic, [NSString class]);
        self.nickName             = PUGetObjFromDict(@"nickName",         dic, [NSString class]);
        self.desc                 = PUGetObjFromDict(@"desc",       dic, [NSString class]);
        self.userAccount           = PUGetObjFromDict(@"pubaccount",       dic, [NSString class]);
        self.subjecttype           = PUGetObjFromDict(@"subjecttype",       dic, [NSString class]);
        self.recommend           = PUGetObjFromDict(@"recommend",       dic, [NSString class]);
        self.authpass           = PUGetObjFromDict(@"authpass",       dic, [NSString class]);
        self.subscribed         = PUGetObjFromDict(@"subscribed",       dic, [NSString class]);

    }
    return self;
}

@end
