//
//  NIMAdModel.m
//  QianbaoIM
//
//  Created by xuqing on 16/3/24.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMAdModel.h"

@implementation NIMAdModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.adtitle      = PUGetObjFromDict(@"adtitle",    dic, [NSString class]);
        self.adUrl  = PUGetObjFromDict(@"adurl", dic, [NSString class]);
    }
    return self;
}
@end
