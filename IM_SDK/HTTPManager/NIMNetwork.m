//
//  NIMNetwork.m
//  QBSDK
//
//  Created by liu nian on 14-4-21.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import "NIMNetwork.h"
#import "NIMResultMeta.h"
//#import "QBIMDefine.h"
#import "NIMHttpRequestHeader.h"
#import "NIMLoginOperationBox.h"
#import "NIMCurrentUserInfo.h"
#import "NSOperationQueue+NIMQB.h"




//static NSString * const AFAppDotNetIMAPIBaseURLString = SERVER_DOMAIN_IM_HTTP;
static NSString * const AFAppDotNetAPIBaseURLString = SERVER_QB;

@interface NIMNetwork ()
{
    SuccessBlock    _successBlock;
    FailureBlock    _failureBlock;
}
@property (nonatomic, strong) SuccessBlock successBlock;
@property (nonatomic, strong) FailureBlock failureBlock;

#if NS_BLOCKS_AVAILABLE
- (void)setSuccessBlock:(SuccessBlock)successBlock;
- (void)setFailureBlock:(FailureBlock)failureBlock;
#endif
@end
@implementation NIMNetwork

//+ (instancetype)sharedClient {
//    static NIMNetwork *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [[NIMNetwork alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetIMAPIBaseURLString]];
//        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
//        _sharedClient.securityPolicy.validatesDomainName = NO;
////        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        [_sharedClient.reachabilityManager startMonitoring];
//    });
//
//    return _sharedClient;
//}

+ (instancetype)sharedQBClient {
    static NIMNetwork *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NIMNetwork alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
//        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        [_sharedClient.reachabilityManager startMonitoring];
    });

    return _sharedClient;
}


//+ (instancetype)sharedHttps {
//    static NIMNetwork *_sharedClient = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedClient = [[NIMNetwork alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetIMAPIBaseURLString]];
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        [AFHTTPSessionManager manager].securityPolicy = securityPolicy;
//        [_sharedClient.reachabilityManager startMonitoring];
//    });
//
//    return _sharedClient;
//}



#pragma mark cache response
- (id)cachedResponseObject:(NSURLSessionTask *)operation{
//    return nil;
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.currentRequest];
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    return responseObject;
}

#pragma mark finish


- (void)setSuccessBlock:(SuccessBlock)successBlock{
	_successBlock = [successBlock copy];
}

- (void)setFailureBlock:(FailureBlock)failureBlock{
    _failureBlock = [failureBlock copy];
}


- (void)setHTTPRequestHeaders:(NSDictionary *)headers{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [serializer setValue:obj forHTTPHeaderField:key];
    }];
    [self setRequestSerializer:serializer];
}


- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                            parameters:(NSDictionary *)parameters
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    return [self requestURL:URLString HttpMethod:method parameters:parameters userCache:YES successBlock:successBlock failureBlock:failureBlock];
}


- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                         parameterType:(BOOL)jsonType       //默认为NO 为表单提交
                            parameters:(NSDictionary *)parameters
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    if(jsonType)
    {
        return [self requestURL:URLString HttpMethod:method parameters:parameters userCache:NO parameterType:YES successBlock:successBlock failureBlock:failureBlock];
    }
    else
    {
        return [self requestURL:URLString HttpMethod:method parameters:parameters userCache:NO successBlock:successBlock failureBlock:failureBlock];
    }
}


- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                            parameters:(NSDictionary *)parameters
                             userCache:(BOOL)userCache
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    return [self requestURL:URLString HttpMethod:method parameters:parameters userCache:userCache parameterType:NO successBlock:successBlock failureBlock:failureBlock];
}

- (BOOL)isActiveDomainForURLString:(NSString *)urlstring
{
    NSString *host = nil;
    NSRange rg = [SERVER_ACTIVE_QB rangeOfString:@"http://"];
    if (rg.location != NSNotFound) {
        host = [SERVER_ACTIVE_QB substringFromIndex:rg.location+rg.length];
    }
 
    if ([[NSURL URLWithString:urlstring].host isEqualToString:host])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDomain:(NSString *)domain ForURLString:(NSString *)urlstring
{
    NSString *host = nil;
    NSRange rg = [domain rangeOfString:@"http://"];
    if (rg.location != NSNotFound) {
        host = [domain substringFromIndex:rg.location+rg.length];
    }
    
    if ([[NSURL URLWithString:urlstring].host isEqualToString:host])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isRedEnvelopDomainForURLString:(NSString *)urlstring
{
    NSString *host = nil;
    NSRange rg = [SESSION_REDENVELOP_QB rangeOfString:@"http://"];
    if (rg.location != NSNotFound) {
        host = [SESSION_REDENVELOP_QB substringFromIndex:rg.location+rg.length];
    }
    
    if ([[NSURL URLWithString:urlstring].host isEqualToString:host])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)isCouponsDomainForURLString:(NSString *)urlstring
{
    NSString *host = nil;
    NSRange rg = [SESSION_COUPONS_QB rangeOfString:@"http://"];
    if (rg.location != NSNotFound) {
        host = [SESSION_COUPONS_QB substringFromIndex:rg.location+rg.length];
    }
    
    if ([[NSURL URLWithString:urlstring].host isEqualToString:host])
    {
        return YES;
    }
    
    return NO;
}


- (NSString *)isUserDomainForURLString:(NSString *)urlstring
{
    NSString *host = nil;
    NSRange rg = [SERVER_USER_QB rangeOfString:@"http://"];
    if (rg.location != NSNotFound) {
        host = [SERVER_USER_QB substringFromIndex:rg.location+rg.length];
    }
    
    if ([[NSURL URLWithString:urlstring].host isEqualToString:host])
    {
        return host;
    }
    
    return nil;
}

- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                            parameters:(NSDictionary *)parameters
                             userCache:(BOOL)userCache
                         parameterType:(BOOL)jsonType
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    // 本地Hack，添加请求头
    NSMutableDictionary *commonHeader = [[NIMHttpRequestHeader shareInstance] commonHeader];
    
    {
        NIMCurrentUserInfo *info = [NIMCurrentUserInfo currentInfo];
        NSString *cookie = info.setcookie;
        
        NSDictionary *cookies = [info.cookies mutableCopy];
        
        NSString *schemeurl = [[NSURL URLWithString:URLString]host];
        NSLog(@">>>>>>>>>>>>>>>>>>>> url = %@, cookies = %@",schemeurl,cookies);
        BOOL isfind = NO;
        if (schemeurl) {
            for (NSString *domainkey in cookies.allKeys) {
                NSRange found = [domainkey rangeOfString:schemeurl];
                if (found.location != NSNotFound) {
                    NSString *cookie = cookies[domainkey];
                    if (cookie) {
                        [commonHeader setObject:cookie forKey:@"Cookie"];
                        NSLog(@"=================");
                        isfind = YES;
                    }
                    break;
                }
            }
        }

        if (!isfind && cookie.length >0) {
            [commonHeader setObject:cookie forKey:@"Cookie"];
        }
        /*
        //如果是推广活动的
        NSString *host = nil;
        NSString *host1 =nil;
        NSString *userHost = nil;
        NSRange rg = [SERVER_APPSTORE_QB rangeOfString:@"http://"];
        if (rg.location != NSNotFound) {
            host = [SERVER_APPSTORE_QB substringFromIndex:rg.location+rg.length];
        }
        NSRange rg1 = [SERVER_SIGN_QB rangeOfString:@"http://"];
        if (rg1.location !=NSNotFound) {
            host1 = [SERVER_SIGN_QB substringFromIndex:rg1.location+rg1.length];

        }

        if (host.length > 0 && [schemeurl isEqualToString:host]) {
            //fsh
            NSString *activeCookie = info.appstoreCook;
            if (activeCookie.length > 0) {
                [commonHeader setObject:activeCookie forKey:@"Cookie"];
            }
        }
        else if (host1.length > 0 && [schemeurl isEqualToString:host1])
        {
            NSString *activeCookie = info.signCookie;
            if (activeCookie.length > 0) {
                [commonHeader setObject:activeCookie forKey:@"Cookie"];
            }
        }
        else if ([self isActiveDomainForURLString:URLString]) //如果是活动的
        {
            NSString *activeCookie = info.setActiveCookie;
            if (activeCookie.length > 0) {
                [commonHeader setObject:activeCookie forKey:@"Cookie"];
            }
        }
        else if ([self isRedEnvelopDomainForURLString:URLString]) //如果是发红包
        {
            NSString *redEnvelopCookie = info.setRedEnvelopCookie;
            if (redEnvelopCookie.length > 0) {
                [commonHeader setObject:redEnvelopCookie forKey:@"Cookie"];
            }
        }
        else if ([self isDomain:SERVER_BAOYUE ForURLString:URLString])
        {
            NSString *baoyueCookie = info.setBaoyueCookie;
            if (baoyueCookie.length > 0) {
                [commonHeader setObject:baoyueCookie forKey:@"Cookie"];
            }
        }
        else if ([self isCouponsDomainForURLString:URLString]) //如果是优惠券
        {
            NSString *couponsCookie = info.setCouponsCookie;
            if (couponsCookie.length > 0) {
                [commonHeader setObject:couponsCookie forKey:@"Cookie"];

            }
        }
        else if ([self isDomain:SERVER_BANYAN ForURLString:URLString])//钱宝助手
        {
            NSString *banYanCookie = info.setBanYanCookie;
            if (banYanCookie.length > 0) {
                [commonHeader setObject:banYanCookie forKey:@"Cookie"];
            }
        }
        else if ([self isDomain:SERVER_TICKET ForURLString:URLString])//钱宝有票
        {
            NSString *tickCookie = info.setTicketCookie;
            if (tickCookie.length > 0) {
                [commonHeader setObject:tickCookie forKey:@"Cookie"];
            }
        }
        else if ([self isUserDomainForURLString:URLString])
        {
            NSArray *cookieArr = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:URLString]];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSHTTPCookie *cookie in cookieArr)
            {
                NSString *tmp = [NSString stringWithFormat:@"%@=%@",cookie.name,cookie.value];
                [tempArr addObject:tmp];
            }
            
            NSString *userCookieString = [tempArr componentsJoinedByString:@";"];
            [commonHeader setObject:userCookieString forKey:@"Cookie"];
            
        }
        else //使用原来的
        {
            if(cookie.length >0)
            {
                [commonHeader setObject:cookie forKey:@"Cookie"];
                
            }
        }
         */
    }
    
    int64_t ownerid = OWNERID;
    if (ownerid > 0)
    {
        NSNumber *userid = [NSNumber numberWithLongLong:ownerid];
//        NIMLoginUserInfo *NIMLoginUserInfo = [[NIMUserManager shareIntance] getLastNIMLoginUserInfo];
        NSString *sha = [NSString stringWithFormat:@"QW:%@:TGT:%@:CT:",[userid stringValue], [NIMLoginOperationBox sharedInstance].imToken];
        NSString *hash = [[SSIMSpUtil sha1:sha] uppercaseString];
        [commonHeader setObject:[NSString stringWithFormat:@"%lld",ownerid] forKey:@"userId"];
        [commonHeader setObject:hash forKey:@"Hash"];
    }
    else
    {
        [commonHeader removeObjectForKey:@"Hash"];
    }
    if(jsonType == YES)
    {
        [commonHeader setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        [commonHeader setObject:@"application/json" forKey:@"Response-Content-Type"];
    }
    else
    {
        [commonHeader setObject:@"application/x-www-form-urlencoded; charset=UTF-8" forKey:@"Content-Type"];
        [commonHeader setValue:@"text/html" forKey:@"Response-Content-Type"];
    }
   
    [self setHTTPRequestHeaders:commonHeader];
    
    if(jsonType == YES)
    {
        [self.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
            if([parameters isKindOfClass:[NSDictionary class]])
            {
                NSString *json =  [SSIMSpUtil convertObjectToJSON:parameters];
                return json;
            }
            else
            {
                return nil;
            }
        }];
    }
    else
    {
        [self.requestSerializer setQueryStringSerializationWithBlock:nil];
    }
    
    DBLog(@"http request headers:::::%@",commonHeader);
    NSURLSessionTask *opreration = nil;
    //add new
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    if (method == HttpMethodPost)
    {
        
        NSMutableDictionary * formDataDic = @{}.mutableCopy;
        
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
            if ([obj isKindOfClass:[UIImage class]])
             {
                 // 添加上传的图片
                 CGFloat compression = 0.5f;
                 CGFloat maxCompression = 0.1f;
                 int maxFileSize = 1024*1024;
                 
                 NSData *imgData = UIImageJPEGRepresentation(obj, compression);
                 while (imgData.length > maxFileSize && compression > maxCompression)
                 {
                     compression -= 0.1;
                     imgData = UIImageJPEGRepresentation(obj, compression);
                 }
                 
                 [formDataDic setObject:imgData forKey:key];
             }
         }];
        NSMutableDictionary *newParameters = parameters.mutableCopy;
        [newParameters removeObjectsForKeys:formDataDic.allKeys];

        if([[formDataDic allKeys] count] >0)
        {
            return [self POST:URLString parameters:newParameters userCache:userCache constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 [formDataDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
                  {
                      NSString *fileName =[NSString stringWithFormat:@"%@.jpg", key];
                      [formData appendPartWithFileData:obj name:key fileName:fileName mimeType:@"image/png"];
                  }];
             } successBlock:successBlock failureBlock:failureBlock];
        }
        opreration =[self POST:URLString parameters:parameters userCache:userCache successBlock:successBlock failureBlock:failureBlock];
    }
    else if (method == HttpMethodGet)
    {
        opreration = [self Get:URLString parameters:parameters userCache:userCache successBlock:successBlock failureBlock:failureBlock];
    }
    else if (method == HttpMethodDelete)
    {
        //opreration = [self DELETE:URLString parameters:parameters userCache:userCache successBlock:successBlock failureBlock:failureBlock ];
    }
    dispatch_queue_t currentQueue = [NSOperationQueue nim_findCurrentQueue];
//    opreration.completionQueue = currentQueue;
    return opreration;
}

- (NSURLSessionTask *)Get:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                      userCache:(BOOL)userCache
                   successBlock:(SuccessBlock)successBlock
                   failureBlock:(FailureBlock)failureBlock
{
    NSURLSessionTask *opreration = nil;
    opreration = [self GET:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        NIMResultMeta *resultMeta       = [NIMResultMeta resultWithAttributes:responseObject];
        [resultMeta setRequestForurl:operation.currentRequest.URL];
        if (resultMeta.success) {
            successBlock(operation,responseObject[@"data"]);
        }else{
            failureBlock(operation, resultMeta);
        }
        //modify by ZT
        [self qbf_handleErrorCode:resultMeta];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSString *responestring = [operation taskDescription];
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithCode:@"" error:@"" message:@""];
        [resultMeta setRequestForurl:operation.currentRequest.URL];
        if (responestring) {
            NSData *m_Data        = [responestring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                          options:NSJSONReadingMutableLeaves
                                                                            error:nil];
            if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                resultMeta = [NIMResultMeta resultWithAttributes:jsonResponse];
            }
        }
        if(userCache)
        {
            if ([self cachedResponseObject:operation]) {
                if(successBlock)
                    successBlock(operation,[self cachedResponseObject:operation]);
            }else if(failureBlock)
                failureBlock(operation, resultMeta);
        }
        else
        {
            failureBlock(operation,resultMeta);
        }
        [self qbf_handleErrorCode:resultMeta];

    }];
    return opreration;
}

//add by ZT 2014-10-9
- (void)qbf_handleErrorCode:(NIMResultMeta*)metaData
{
    if (metaData.code == QBIMErrorJsessionInvalid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTICENEEDAUTH object:metaData];
    }
    else if(metaData.code == QBIMErrorNeedUpdate ||
            metaData.code == QBIMErrorNewAPI)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVersionUpdate object:metaData];
    }
}

- (NSURLSessionTask *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                       userCache:(BOOL)userCache
                    successBlock:(SuccessBlock)successBlock
                    failureBlock:(FailureBlock)failureBlock
{
    NSURLSessionTask *opreration = nil;
    DBLog(@"---------------%@",parameters);

    
    opreration = [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask *operation, id responseObject) {
        DBLog(@"%@",responseObject);
        NIMResultMeta *resultMeta       = [NIMResultMeta resultWithAttributes:responseObject];
        [resultMeta setRequestForurl:operation.currentRequest.URL];
        if (resultMeta.success && ( ! resultMeta.error || [resultMeta.error isEqualToString:@"0"] || [resultMeta.error isEqualToString:@"<null>"]))
        {
            successBlock(operation,responseObject[@"data"]);
        }
        else if (resultMeta.success && ![resultMeta.error isEqualToString:@"0"])
        {
            
            failureBlock(operation, resultMeta);
        }
        else
        {
            if(userCache)
            {
                if ([self cachedResponseObject:operation]) {
                    if(successBlock)
                        successBlock(operation,[self cachedResponseObject:operation]);
                }else if(failureBlock){
                    failureBlock(operation, resultMeta);

                }
            }
            else
            {
                failureBlock(operation, resultMeta);
            }
        }
        //modify by ZT
        [self qbf_handleErrorCode:resultMeta];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSString *responestring = [operation taskDescription];
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithCode:0 error:@"" message:@""];
        [resultMeta setRequestForurl:operation.currentRequest.URL];
        if (responestring) {
            NSData *m_Data        = [responestring dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                          options:NSJSONReadingMutableLeaves
                                                                            error:nil];
            if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                resultMeta = [NIMResultMeta resultWithAttributes:jsonResponse];
            }
        }
        if(userCache)
        {
            if ([self cachedResponseObject:operation]) {
                if(successBlock)
                    successBlock(operation,[self cachedResponseObject:operation]);
            }else if(failureBlock)
                failureBlock(operation, resultMeta);
        }
        else
        {
            failureBlock(operation,resultMeta);
        }
        [self qbf_handleErrorCode:resultMeta];
    }];
    return opreration;
}

- (NSURLSessionTask *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                       userCache:(BOOL)userCache
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                    successBlock:(SuccessBlock)successBlock
                    failureBlock:(FailureBlock)failureBlock
{
    NSURLSessionTask *opreration = nil;
    opreration = [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *operation, id responseObject) {

        NIMResultMeta *resultMeta       = [NIMResultMeta resultWithAttributes:responseObject];
        [resultMeta setRequestForurl:operation.currentRequest.URL];
        if (resultMeta.success) {
            successBlock(operation,responseObject[@"data"]);
        }else{
            if(userCache)
            {
                if ([self cachedResponseObject:operation]) {
                    if(successBlock)
                        successBlock(operation,[self cachedResponseObject:operation]);
                }else if(failureBlock){
                    failureBlock(operation, resultMeta);;
                }
            }
            else
            {
                failureBlock(operation, resultMeta);
            }
        }
        //modify by ZT
        [self qbf_handleErrorCode:resultMeta];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
            NSString *responestring = [operation taskDescription];
            NIMResultMeta *resultMeta = [NIMResultMeta resultWithCode:0 error:@"" message:@""];
            [resultMeta setRequestForurl:operation.currentRequest.URL];
            if (responestring) {
                NSData *m_Data        = [responestring dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonResponse  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                              options:NSJSONReadingMutableLeaves
                                                                                error:nil];
                if ([jsonResponse isKindOfClass:[NSDictionary class]]) {
                    resultMeta = [NIMResultMeta resultWithAttributes:jsonResponse];
                }
            }
            if(userCache)
            {
                if ([self cachedResponseObject:operation]) {
                    if(successBlock)
                        successBlock(operation,[self cachedResponseObject:operation]);
                }else if(failureBlock)
                    failureBlock(operation, resultMeta);
            }
            else
            {
                failureBlock(operation,resultMeta);
            }
            [self qbf_handleErrorCode:resultMeta];
    }];
    return opreration;
}




@end
