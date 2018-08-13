//
//  NIMLoginUserInfo.m
//  QianbaoIM
//
//  Created by liu nian on 14-4-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMLoginUserInfo.h"
#import "NIMCurrentUserInfo.h"

@interface NIMLoginUserInfo()
{
    NSMutableDictionary             *_cookies;
}

@end

@implementation NIMLoginUserInfo

- (void)dealloc
{
}

+ (id)createWithDict:(NSDictionary *)dict
{
    return [[NIMLoginUserInfo alloc] initWithDict:dict];
}

SingletonImplementation(NIMLoginUserInfo);

- (void)updateWithDict:(NSDictionary *)dict
{
    if(isDictWithCountMoreThan0(dict))
    {
        self.authInfo = dict;
        if(isDictContainKey(dict, @"userId"))
            self.userId  = PUGetObjFromDict(@"userId",       dict, [NSString class]);
        if(isDictContainKey(dict, @"imToken"))
            self.imToken = PUGetObjFromDict(@"imToken",      dict, [NSString class]);
        if(isDictContainKey(dict, @"realName"))
            self.realName  = PUGetObjFromDict(@"realName",   dict, [NSString class]);
        if(isDictContainKey(dict, @"sessionId"))
            self.sessionId = PUGetObjFromDict(@"jSessionId", dict, [NSString class]);
        if(isDictContainKey(dict, @"tGrantingTicket"))
            self.tGrantingTicket = PUGetObjFromDict(@"tgt",  dict, [NSString class]);
        if(isDictContainKey(dict, @"userName"))
            self.userName = PUGetObjFromDict(@"userName",    dict, [NSString class]);
        if(isDictContainKey(dict, @"username"))
            self.userName = PUGetObjFromDict(@"username",    dict, [NSString class]);
        if(isDictContainKey(dict, @"realNameAuthenticated"))
            self.realNameAuthenticated = [PUGetObjFromDict(@"isAuthenticated",  dict, [NSNumber class]) boolValue];
        if(isDictContainKey(dict, @"isSpringFestival"))
            self.isSpringFestival = [PUGetObjFromDict(@"isSpringFestival", dict, [NSNumber class]) boolValue];
        if(isDictContainKey(dict, @"idCode"))
            self.idCode   = PUGetObjFromDict(@"idCode", dict, [NSString class]);
        
        self.bindPhone = PUGetObjFromDict(@"bindingMobile",       dict, [NSString class]);
        self.avatar = PUGetObjFromDict(@"avatar",       dict, [NSString class]);
    }
}


- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.authInfo = dict;
        self.userId                = PUGetObjFromDict(@"userId", dict, [NSString class]);
        self.imToken               = PUGetObjFromDict(@"imToken", dict, [NSString class]);
        self.realName              = PUGetObjFromDict(@"realName", dict, [NSString class]);
        self.sessionId             = PUGetObjFromDict(@"jSessionId", dict, [NSString class]);
        self.tGrantingTicket       = PUGetObjFromDict(@"tgt", dict, [NSString class]);
        self.userName              = PUGetObjFromDict(@"userName", dict, [NSString class]);
        if (!self.userName) {
            self.userName              = PUGetObjFromDict(@"username", dict, [NSString class]);
        }
        self.realNameAuthenticated = [PUGetObjFromDict(@"isAuthenticated",  dict, [NSNumber class]) boolValue];

        self.isSpringFestival      = [PUGetObjFromDict(@"isSpringFestival", dict, [NSNumber class]) boolValue];

        self.idCode                = PUGetObjFromDict(@"idCode", dict, [NSString class]);
        self.bindPhone =            PUGetObjFromDict(@"bindingMobile",       dict, [NSString class]);
        self.avatar = PUGetObjFromDict(@"avatar",       dict, [NSString class]);
        
        _cookies = [[NSMutableDictionary alloc]init];
        //新的用户单例
        [NIMCurrentUserInfo currentInfo].authInfo = dict;
        [NIMCurrentUserInfo currentInfo].userId = self.userId;
        [NIMCurrentUserInfo currentInfo].imToken = self.imToken;
        [NIMCurrentUserInfo currentInfo].realName = self.realName;
        [NIMCurrentUserInfo currentInfo].sessionId = self.sessionId;
        [NIMCurrentUserInfo currentInfo].tGrantingTicket = self.tGrantingTicket;
        [NIMCurrentUserInfo currentInfo].userName = self.userName;
        [NIMCurrentUserInfo currentInfo].realNameAuthenticated = self.realNameAuthenticated;
        [NIMCurrentUserInfo currentInfo].isSpringFestival = self.isSpringFestival;
        [NIMCurrentUserInfo currentInfo].idCode = self.idCode;
        [NIMCurrentUserInfo currentInfo].bindPhone = self.bindPhone;
        [NIMCurrentUserInfo currentInfo].avatar = self.avatar;
        
    }

    return self;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.userId                = [aDecoder decodeObjectForKey:@"userId"];
        self.sessionId             = [aDecoder decodeObjectForKey:@"sessionId"];
        self.tGrantingTicket       = [aDecoder decodeObjectForKey:@"tGrantingTicket"];
        self.realNameAuthenticated = [aDecoder decodeBoolForKey:@"realNameAuthenticated"];
        self.realName              = [aDecoder decodeObjectForKey:@"realName"];
        self.userName              = [aDecoder decodeObjectForKey:@"userName"];
        self.imToken               = [aDecoder decodeObjectForKey:@"imToken"];
        self.bindPhone             = [aDecoder decodeObjectForKey:@"bindPhone"];

        self.isSpringFestival      = [aDecoder decodeBoolForKey:@"springfestival"];
        self.idCode                = [aDecoder decodeObjectForKey:@"idCode"];
        self.lat                   = [aDecoder decodeObjectForKey:@"lat"];
        self.lon                   = [aDecoder decodeObjectForKey:@"lon"];
        self.avatar                = [aDecoder decodeObjectForKey:@"avatar"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userId              forKey:@"userId"];
    [aCoder encodeObject:_sessionId           forKey:@"sessionId"];
    [aCoder encodeObject:_tGrantingTicket     forKey:@"tGrantingTicket"];
    [aCoder encodeBool:_realNameAuthenticated forKey:@"realNameAuthenticated"];
    [aCoder encodeObject:_realName            forKey:@"realName"];
    [aCoder encodeObject:_userName            forKey:@"userName"];
    [aCoder encodeObject:_imToken             forKey:@"imToken"];
    [aCoder encodeBool:_isSpringFestival      forKey:@"springfestival"];
    [aCoder encodeObject:_idCode              forKey:@"idCode"];
    [aCoder encodeObject:_lat                 forKey:@"lat"];
    [aCoder encodeObject:_lon                 forKey:@"lon"];
    [aCoder encodeObject:_bindPhone           forKey:@"bindPhone"];
    [aCoder encodeObject:_avatar              forKey:@"avatar"];
}

- (void)clearCookie
{
    _setcookie = nil;
    
    [_cookies removeAllObjects];
}

- (NSString *)getDomainCookie:(NSString *)domain
{
    for (NSString *domainkey in self.cookies.allKeys)
    {
        if([SSIMSpUtil stringA:domain containString:domainkey] && [domain hasPrefix:domainkey])
        {
            NSString *domainCookie = self.cookies[domainkey];
            if (domainCookie)
            {
                return domainCookie;
            }
            break;
        }
    }
    return nil;
}

- (void)cleanCookieForDomain:(NSString *)domain
{
    NSString *key = nil;
    for (NSString *domainkey in self.cookies.allKeys)
    {
        if([SSIMSpUtil stringA:domain containString:domainkey] && [domain hasPrefix:domainkey])
        {
            key = domainkey;
            
            break;
        }
    }
    
    if (key) {
        [_cookies removeObjectForKey:key];
    }
    
}

- (NSDictionary *)cookies
{
    return [NSDictionary dictionaryWithDictionary:_cookies];
}

- (void)addCookie:(NSString *)cookie withDomain:(NSString *)domain
{
    if (cookie && domain) {
        if (!_cookies) {
            _cookies = [[NSMutableDictionary alloc]init];
        }
        [_cookies setObject:cookie forKey:domain];
    }
}

@end
