//
//  NIMFansModle.m
//  QianbaoIM
//
//  Created by xuqing on 16/4/26.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMFansModle.h"

@implementation NIMFansModle
-(id)initWithDic:(NSDictionary*)dic
{
    self =[super init];
    if (self) {
        self.userId         = [PUGetObjFromDict(@"userId", dic, [NSNumber class]) doubleValue];
        self.remarkName  = PUGetObjFromDict(@"alias", dic,[NSString class]);
        self.nickName    = PUGetObjFromDict(@"nickName", dic, [NSString class]);
        self.userName    = PUGetObjFromDict(@"userName", dic, [NSString class]);
        self.avatarPic   = PUGetObjFromDict(@"avatarPic", dic, [NSString class]);
        self.signature   = PUGetObjFromDict(@"signature", dic, [NSString class]);
        self.age         = [PUGetObjFromDict(@"age", dic, [NSNumber class]) integerValue];
        self.sex         = PUGetObjFromDict(@"sex", dic, [NSString class]);
    }
    return self;
}
@end
