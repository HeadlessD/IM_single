//
//  NIMHttpRequestHeader.m
//  Qianbao
//
//  Created by liyan1 on 13-12-24.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import "NIMHttpRequestHeader.h"
#import "NIMManager.h"
#import "NIMLoginUserInfo.h"

static NIMHttpRequestHeader *requestHeaderInstance;

@interface NIMHttpRequestHeader ()

@end

@implementation NIMHttpRequestHeader

- (void)dealloc
{
    RELEASE_SAFELY(_commonHeader);
}

+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestHeaderInstance = _ALLOC_OBJ_(NIMHttpRequestHeader);
    });
    return requestHeaderInstance;
}

#pragma mark -- getter
- (NSMutableDictionary*)commonHeader
{
    if(!_commonHeader)
    {
        
//        NSString *udidStr = [(AppDelegate *)[[UIApplication sharedApplication] delegate] qb_appIDFV];
//        _commonHeader = _ALLOC_OBJ_(NSMutableDictionary);
//        SET_PARAM(APP_DEV,                  @"devType",                 _commonHeader);
//        SET_PARAM(kAgient,                  @"User-Agent",              _commonHeader);
//        SET_PARAM(@"client",                @"sourceType",              _commonHeader);
//        SET_PARAM(@"Qianbao Test",               @"channel",                 _commonHeader);
//        SET_PARAM(APP_VERSION,              @"version",                 _commonHeader);
//        SET_PARAM(udidStr,         @"devId",                   _commonHeader);
//        SET_PARAM(@"application/json",      @"Response-Content-Type",   _commonHeader);
//        SET_PARAM(@"application/x-www-form-urlencoded; charset=UTF-8", @"Content-Type" , _commonHeader);
        
    }
    
    //LBS坐标,每次都重新取
    NSString *lat = [[NSUserDefaults standardUserDefaults]objectForKey:@"lat"];
//    if (lat.length > 0) {
        SET_PARAM(lat,@"lat",_commonHeader);
//    }
    
    NSString *lon = [[NSUserDefaults standardUserDefaults]objectForKey:@"lon"];
//    if (lon.length > 0) {
        SET_PARAM(lon,@"lon",_commonHeader);
//    }
    
    NSString *citycode = [[NSUserDefaults standardUserDefaults]objectForKey:@"city_code"];
    if (citycode.length > 0) {
        SET_PARAM(citycode,@"city_code",_commonHeader);
    }
    
    SET_PARAM(@"application/x-www-form-urlencoded; charset=UTF-8", @"Content-Type" , _commonHeader);
    NIMLoginUserInfo *userInfo = [[NIMManager sharedImManager] loginUserInfo];
    if (userInfo.userId)
    {
        NSString *usrID = [NSString stringWithFormat:@"%d",[userInfo.userId intValue]];
        SET_PARAM(usrID,      @"userId",      _commonHeader);
    }
    else
    {
        if ([_commonHeader objectForKey:@"userId"]) {
            [_commonHeader removeObjectForKey:@"userId"];
        }
    }
    if (userInfo.sessionId)
    {
        SET_PARAM(userInfo.sessionId,   @"jSessionId",  _commonHeader);
    }
    else
    {
        if ([_commonHeader objectForKey:@"jSessionId"]) {
            [_commonHeader removeObjectForKey:@"jSessionId"];
        }
    }
    return _commonHeader;
}


@end

