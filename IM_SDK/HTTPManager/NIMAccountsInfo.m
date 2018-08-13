//
//  NIMAccountsInfo.m
//  QianbaoIM
//
//  Created by MichaelRain on 16/5/1.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMAccountsInfo.h"

@implementation NIMAccountsInfo

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
//        self.userName                = PUGetObjFromDict(@"userName",           dic, [NSString class]) ;
//        self.passWord            = PUGetObjFromDict(@"password",       dic, [NSString class]);
//        self.avatar                = PUGetObjFromDict(@"avatar",           dic, [NSString class]);
//        self.isShow                = [PUGetObjFromDict(@"isShow",        dic, [NSString class])boolValue];
    }
    return self;
}

//对变量编码
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    [coder encodeObject:self.userName forKey:@"userName"];
    [coder encodeObject:self.passWord forKey:@"password"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeBool:self.isShow forKey:@"isShow"];
    [coder encodeBool:self.isRememberPass  forKey:@"isRememberPass"];
    [coder encodeBool:self.isAutoLogin     forKey:@"isAutoLogin"];
    [coder encodeObject:_userid forKey:@"userid"];
    [coder encodeObject:[NSNumber numberWithInteger:_acountType] forKey:@"acountType"];
    //... ... other instance variables
}

//对变量解码
- (id)initWithCoder:(NSCoder *)coder
{
    self.userName = [coder decodeObjectForKey:@"userName"];
    self.passWord = [coder decodeObjectForKey:@"password"];
    self.avatar = [coder decodeObjectForKey:@"avatar"];
    self.isShow = [coder decodeBoolForKey:@"isShow"];
    self.isRememberPass = [coder decodeBoolForKey:@"isRememberPass"];
    self.isAutoLogin    = [coder decodeBoolForKey:@"isAutoLogin"];
    self.userid = [coder decodeObjectForKey:@"userid"];
    self.acountType = [[coder decodeObjectForKey:@"acountType"] integerValue];
    return self;
}
@end

