//
//  NIMLoginUser.m
//  QianbaoIM
//
//  Created by liu nian on 14-4-10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMLoginUser.h"

@implementation NIMLoginUser
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize userid = _userid;

- (void)dealloc
{
    _userName = nil;
    _password = nil;
    _avatarURL = nil;
    _nickname = nil;
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.password = [aDecoder decodeObjectForKey:@"password"];

        self.isRememberPass = [aDecoder decodeBoolForKey:@"isRememberPass"];
        self.isAutoLogin    = [aDecoder decodeBoolForKey:@"isAutoLogin"];
        
        self.avatarURL     = [aDecoder decodeObjectForKey:@"avatarURL"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        
        self.userid = [aDecoder decodeObjectForKey:@"userid"];
        self.acountType = [[aDecoder decodeObjectForKey:@"acountType"] integerValue];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_password forKey:@"password"];

    [aCoder encodeBool:self.isRememberPass  forKey:@"isRememberPass"];
    [aCoder encodeBool:self.isAutoLogin     forKey:@"isAutoLogin"];
    
    [aCoder encodeObject:_avatarURL forKey:@"avatarURL"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    
    [aCoder encodeObject:_userid forKey:@"userid"];
    [aCoder encodeObject:[NSNumber numberWithInteger:_acountType] forKey:@"acountType"];
}


@end
