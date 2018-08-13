//
//  NIMOffcialInfo.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/6/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMOffcialInfo.h"

@implementation NIMOffcialInfo
-(instancetype)initWithOffcialid:(int64_t)offcial name:(NSString *)name avatar:(NSString *)avatar
{
    self = [super init];
    if (self) {
        _offcialid = offcial;
        _name = name;
        _avatar = avatar;
    }
    return self;
}
@end
