//
//  NSObject+NIMSysManager.m
//  qbim
//
//  Created by shiyunjie on 17/1/18.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMSysManager.h"
#import "NIMGlobalProcessor.h"
#import "SSIMBusinessManager.h"
@implementation NIMSysManager
static NSString * const CLASS_NAME = @"NIMSysManager";
SingletonImplementation(NIMSysManager)
- (void)dealloc
{
    
}

- (id)init
{
    self = [super init];
    self->_qb_login = nil;
    self.typeDict = [[NSMutableDictionary alloc] init];
    self.relationDict = [[NSMutableDictionary alloc] init];
    self.recvDict = [[NSMutableDictionary alloc] init];
    self.sidDict = [[NSMutableDictionary alloc] init];
    self.remarkDict = [[NSMutableDictionary alloc] init];
    self.gidsArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.offlinesArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.progressDict = [[NSMutableDictionary alloc] init];;
    self.groupShowDict = [[NSMutableDictionary alloc] init];;
    return self;
}

- (void)removeAll
{
    self.typeDict = [[NSMutableDictionary alloc] init];
    self.relationDict = [[NSMutableDictionary alloc] init];
    self.recvDict = [[NSMutableDictionary alloc] init];
    self.sidDict = [[NSMutableDictionary alloc] init];
    self.remarkDict = [[NSMutableDictionary alloc] init];
    self.gidsArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.offlinesArr = [[NSMutableArray alloc] initWithCapacity:10];
    self.progressDict = [[NSMutableDictionary alloc] init];
    self.groupShowDict = [[NSMutableDictionary alloc] init];;
//    _qb_login = nil;
}

- (void)clearChat
{
    [[NIMMessageManager sharedInstance].chatDict removeAllObjects];
    [[NIMMessageManager sharedInstance].chatListDict removeAllObjects];
}

- (void)clearLoginInfo
{
    [[SSIMClient sharedInstance] setValue:@(0) forKey:NSStringFromSelector(@selector(owerid))];
    _qb_login = nil;
}

-(void) SetLoginInfo:(SSIMLogin *) ns_login
{
    self->_qb_login = ns_login;
}

-(SSIMLogin *)GetLoginInfo
{
    return self->_qb_login;
}

-(void)getServerTime
{
//    if ([[NetCenter sharedInstance] GetNetStatus]==LOGINED) {
        [[NIMGlobalProcessor sharedInstance].sys_processor getServerTime];
//    }
}

-(E_NET_STATUS)GetNetStatus
{
    return [[NetCenter sharedInstance] GetNetStatus];
}

-(void)sendSMSVaildRQ:(int64_t)mobile{
    [[NIMGlobalProcessor sharedInstance].sys_processor sendSMSVaildRQ:mobile];
}

-(void)recvSMSVaildRS{
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_SMS_VALID_RQ object:@(YES)];
}

-(void)sendSMSloginRQ:(int64_t)mobile userToken:(NSString *)userToken type:(int64_t)type{
    [[NIMGlobalProcessor sharedInstance].sys_processor sendSMSloginRQ:mobile userToken:userToken type:type];
}

-(void)recvSMSloginRSwithUserid:(int64_t)userid userToken:(NSString *)userToken{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setValue:@(userid) forKey:@"userid"];
    [dic setValue:userToken forKey:@"usertoken"];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_REG_RQ object:dic];
}

-(void)sendTCPlogin:(SSIMLogin *)login_info{
    [[NIMGlobalProcessor sharedInstance].sys_processor sendLoginRQ:login_info];
}


@end
