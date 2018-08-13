//
//  NIMLoginOperationBox.m
//  QianbaoIM
//
//  Created by liunian on 14/9/24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMLoginOperationBox.h"
#import "AFHTTPSessionManager.h"
#import "NIMDes.h"
#import "GTMBase64.h"
#import "NIMHttpRequestHeader.h"

#import "NIMAccountsManager.h"
#import "NIMManager.h"
#import "NIMCurrentUserInfo.h"
#import "MBTip.h"

#import "NIMGlobalProcessor.h"
#import "NIMSysManager.h"
#define QB_TICKETS      @"tickets"

#define SERVER_DOMAIN_QW_LOGIN_V10                             URLSTRINGFORMAT(SERVER_QW,API_VERSION_10)
#define API_VERSION_10                                       URLSTRINGFORMAT(API,VERSION_10)


#define SERVER_DOMAIN_V30                                      URLSTRINGFORMAT(SERVER_QB,API_VERSION_30)
#define API_VERSION_30                                       URLSTRINGFORMAT(API,VERSION_30)

#define SERVER_DOMAIN_QW_LOGIN_V34                             URLSTRINGFORMAT(SERVER_QW,API_VERSION_34)
#define SERVER_DOMAIN_QW_LOGIN_V35                             URLSTRINGFORMAT(SERVER_QW,API_VERSION_35)


@interface NIMLoginOperationBox ()
@property (nonatomic, assign) BOOL  isLoginRequesting;
@property (nonatomic, strong) NSString  *hashKey;

@end


@implementation NIMLoginOperationBox

- (void)dealloc
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"%s", __FUNCTION__);
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

SingletonImplementation(NIMLoginOperationBox);

#define VERSION_4_0_LOGIN  1

#pragma mark - 钱宝登录



- (void)loginWithUsername:(NSString *)name password:(NSString *)password type:(NSInteger)type completeBlock:(CompleteBlock)completeBlock{
    if (!name.length  || !password.length)
    {
        completeBlock(nil,[NIMResultMeta resultWithCode:0 error:@"" message:@"用户名或密码错误"]);
        return;
    }
    NSString *host = nil;
    unsigned int port = 8001;
    
    switch (type) {
        case 0:
            host = @"192.168.131.41";
            port = 8001;
            _hashKey = @"yuanqq";
            break;
        case 1:
            host = @"192.168.131.236";
            port = [NIMBaseUtil creatPort];
            _hashKey = @"yuanqq";

            break;
        case 2:
            host = @"221.228.203.11";
            port = [NIMBaseUtil creatPort];
            _hashKey = @"yuanqq";

            break;
        case 3:
            host = @"tim.qbao.com";
            port = [NIMBaseUtil creatPort];
            _hashKey = @"Pqb+E73fEMj8O";

            break;
            
        default:
            break;
    }
    
    [self fetchTGTWithUsername:name password:password completeBlock:^(id object, NIMResultMeta *result) {
        
        
        if (result.success) {
            
            //监控统计登录事件-TalkingData
            //            [QBClick event:kUMEventId_3061];
            
            NSDictionary *responseObject = object;
            NSDictionary  *dic = responseObject[@"data"];
            
            
            //登录信息设置TCP登陆
            SSIMLogin *ns_login = [[SSIMLogin alloc]init];
            ns_login.user_id = [[dic objectForKey:@"userId"] intValue];
            ns_login.ap_id = APP_ID_TYPE_QB;
            ns_login.token = [dic objectForKey:@"tgt"];

            //SDK传入登陆信息
            [[SSIMClient sharedInstance] setLoginInfo:ns_login];
            
            //开始连接服务器
            [[SSIMClient sharedInstance] Connect:host port:port];
            NSLog(@"TCP地址：%@",host);
           
            [[NIMSysManager sharedInstance] setIsQbaoLoginSuccess:YES];
            
            completeBlock(dic,nil);
        }else{
            
            [[NIMSysManager sharedInstance] setIsQbaoLoginSuccess:NO];
            
            completeBlock(nil,result);
        }
    }];
}

- (AFHTTPRequestSerializer *)requestSerializer{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *commonHeader = [[NIMHttpRequestHeader shareInstance] commonHeader];
    [commonHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [serializer setValue:obj forHTTPHeaderField:key];
    }];
    return serializer;
}
#pragma mark private method
- (void)getRandomCodeCompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: SERVER_DOMAIN_QW_LOGIN_V34]];
    [manager setRequestSerializer:[self requestSerializer]];

    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    
    [manager POST:@"getRandomCode" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        completeBlock(responseObject[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

    }];
    
}

- (void)fetchTGTWithUsername:(NSString *)name password:(NSString *)password completeBlock:(CompleteBlock)completeBlock{
    
    NSString *encodePWD = [NSString encryptWithText:password];//DES加密
    DBLog(@"en:%@",encodePWD);
    [[NIMManager sharedImManager]cleanHttpCookie];
    [[NIMCurrentUserInfo currentInfo] clearCookie];
    [self getRandomCodeCompleteBlock:^(id object, NIMResultMeta *result) {
        
        if (result.success){
            
            NSString  *secKey = object;
            
            AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: SERVER_DOMAIN_QW_LOGIN_V35]];
            [manager setRequestSerializer:[self requestSerializer]];
            
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
            securityPolicy.allowInvalidCertificates = YES;
            securityPolicy.validatesDomainName = NO;
            manager.securityPolicy  = securityPolicy;
//            manager.securityPolicy.allowInvalidCertificates = YES;
//            [manager.securityPolicy setAllowInvalidCertificates:YES];
            
            NSString *secString = [NSString stringWithFormat:@"%@(\"%@\"%@\"qbao\")",name,_hashKey,password];
            DBLog(@"secString--- %@",secString);
            NSString *hmacString = [SSIMSpUtil hmacSha1:secKey text:secString];
            DBLog(@"hmacSecString--- %@",hmacString);
            NSDictionary *parmas = @{@"username":name,@"password":encodePWD,@"signature":hmacString};
            
            DBLog(@"%@",URLSTRINGFORMAT(@"cas", QB_TICKETS));
            
            [manager POST:URLSTRINGFORMAT(@"cas", QB_TICKETS) parameters:parmas progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];

                if (resultMeta.success) {
                    NSString  *tgt = responseObject[@"data"];
                    [self fetchSTWithTGT:tgt completeBlock:completeBlock];
                }else{
                    completeBlock(nil,resultMeta);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

            }];
            
        }else{
            completeBlock(nil,result);
        }
    }];
}

- (void)fetchSTWithTGT:(NSString *)tgt completeBlock:(CompleteBlock)completeBlock{
    if(tgt.length==0)
    {
        return;
    }
    self.imToken = tgt;
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_DOMAIN_QW_LOGIN_V10]];
    [manager setRequestSerializer:[self requestSerializer]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    NSString *service_url =[NSString stringWithFormat:@"%@/j_spring_cas_security_check",SERVER_QB];
    NSDictionary *params = @{@"service":service_url};
    [manager POST:[NSString stringWithFormat:@"cas/tickets/%@",tgt] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        if (resultMeta.success) {
            NSString  *st = responseObject[@"data"];
            [self authWithST:st completeBlock:completeBlock];
        }else{
            completeBlock(nil,resultMeta);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

    }];
    
}

- (void)authWithST:(NSString *)st completeBlock:(CompleteBlock)completeBlock{
    NSDictionary *parmas = @{@"st":st};
    
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_DOMAIN_V31]];
    [manager setRequestSerializer:[self requestSerializer]];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:nil forHTTPHeaderField:@"jSessionId"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    for (NSHTTPCookie *sessionCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:sessionCookie];
    }
    NSMutableDictionary *header =[[NIMHttpRequestHeader shareInstance] commonHeader];
    if ([header objectForKey:@"Cookie"]) {
        [header removeObjectForKey:@"Cookie"];
    }
    
    [[NIMCurrentUserInfo currentInfo] clearCookie];
    
    
    [manager POST:URLSTRINGFORMAT(@"account4Client", @"login") parameters:parmas progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
//        [NIMCurrentUserInfo currentInfo].setcookie = [operation.response.allHeaderFields objectForKey:@"Set-Cookie"];
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:dict];
        completeBlock(dict,resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
        
    }];

}

/*********************************************************************
 函数名称 : getShowRedPacketFlag
 函数描述 : 请求服务器看是否需要展示红包
 参数  :N/A
 返回值 :N/A
 作者 : yanhao
 *********************************************************************/
-(void)getShowRedPacketFlag
{
    _isShowRedPacket = NO;
    //    [[NIMManager sharedImManager] qb_httpRequestMethod:HttpMethodPost url:SERVERURL_showRedEnvelop parameterType:NO parameters:nil successBlock:^(id object, NIMResultMeta *result) {
    //        if ([object isKindOfClass:[NSDictionary class]])
    //        {
    //            NSDictionary *responseData = object;
    //            NSNumber *isServiceAccess = PUGetObjFromDict(@"isServiceAccess", responseData, [NSNumber class]);
    //            _isShowRedPacket = [isServiceAccess boolValue];
    //        }
    //    } failedBlock:^(id object, NIMResultMeta *result) {
    //
    //    }];
    
}


@end
