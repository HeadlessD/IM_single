//
//  NIMManager.m
//  QianbaoIM
//
//  Created by liu nian on 6/7/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMManager.h"
//#import "JSON.h"
#import "NIMMessageCenter.h"
#import "NIMUserOperationBox.h"
#import "NIMNetwork.h"
//#import "FeedEntity.h"
#import "NSOperationQueue+NIMQB.h"
#import "NSString+NIMMD5.h"
//#import "AFHTTPRequestOperationManager.h"
//#import "PublicEntity.h"
#import "NIMLoginOperationBox.h"
#import "NIMHttpRequestHeader.h"
#import "NIMAlertView.h"


@interface NIMManager ()
@property (nonatomic, strong) dispatch_queue_t download_queue_t;
@property (nonatomic, strong) NSOperationQueue  *uploadOperationQueue;

@end

@implementation NIMManager
+ (instancetype)sharedImManager
{
    static id shared_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared_  = [[[self class] alloc] init];
    });
    return shared_;
}



- (void)cleanHttpCookie
{
//    [ASIHTTPRequest setSessionCookies:nil];
//    [ASIHTTPRequest clearSession];
    DBLog(@"cookis:%@",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]);
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    
    NSMutableDictionary *header =[[NIMHttpRequestHeader shareInstance] commonHeader];
    if ([header objectForKey:@"Cookie"]) {
        [header removeObjectForKey:@"Cookie"];
    }
}

- (void)httpRequestMethod:(HttpMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters completeBlock:(CompleteBlock)completeBlock{
    NSURLSessionTask *opreration = nil;
    opreration  = [[NIMNetwork sharedClient] requestURL:url HttpMethod:method parameters:parameters successBlock:^(NSURLSessionTask *operation, id responseData) {
        if (completeBlock) {
            completeBlock (responseData,nil);
        }
    } failureBlock:^(NSURLSessionTask *operation, NIMResultMeta *result) {
        if (completeBlock) {
            completeBlock (nil,result);
        }
    }];
    
    
//    opreration.completionQueue = [NSOperationQueue findCurrentQueue];
}

- (void)qbHttpRequestMethod:(HttpMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters completeBlock:(CompleteBlock)completeBlock{
    DBLog(@"%@",url);
    NSURLSessionTask *opreration = nil;
    opreration  = [[NIMNetwork sharedQBClient] requestURL:url HttpMethod:method parameters:parameters successBlock:^(NSURLSessionTask *operation, id responseData) {
        if (completeBlock) {
            completeBlock (responseData,nil);
        }
    } failureBlock:^(NSURLSessionTask *operation, NIMResultMeta *result) {
        if (completeBlock) {
            completeBlock (nil,result);
        }
    }];
    
//    opreration.completionQueue = [NSOperationQueue findCurrentQueue];
}


- (void)postURL:(NSString *)url parameters:(NSDictionary *)parameters completeBlock:(CompleteBlock)completeBlock
{
    [self httpRequestMethod:HttpMethodPost url:url parameters:parameters completeBlock:completeBlock];
}

- (void)getURL:(NSString *)url parameters:(NSDictionary *)parameters completeBlock:(CompleteBlock)completeBlock
{
    [self httpRequestMethod:HttpMethodGet url:url parameters:parameters completeBlock:completeBlock];
}

#pragma mark message
#pragma mark ==========================================NEW SEND MESSAGE=================================================


#pragma mark =================================================END=======================================================
#pragma mark search



#pragma mark ===========================================================================================================

#pragma mark user
- (AFHTTPRequestSerializer *)requestSerializer{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *commonHeader = [[NIMHttpRequestHeader shareInstance] commonHeader];
    [commonHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [serializer setValue:obj forHTTPHeaderField:key];
    }];
    return serializer;
}

//https://m.qbao.com/api/v32/userinfo4Client/getUserInfo
//https://m.qbao.com/api/v30/userinfo4Client/getUserInfo
//登录之后获取自己的用户信息
- (void)fetchSelfUsesrInfoCompleteBlock:(CompleteBlock)completeBlock
{
    NSURL * urlstr = [NSURL URLWithString: URLSTRINGFORMAT(SERVER_SELF_USER, @"api/v32/userinfo4Client")];
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:urlstr];
    [manager setRequestSerializer:[self requestSerializer]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy  = securityPolicy;//    NSDictionary *params = @{@"userId":@(userID),@"appId":@"im_service"};

    [manager POST:@"getUserInfo" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completeBlock(responseObject[@"data"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,nil);
    }];
}

//通过ID获取用户信息
- (void)fetchInfoByUserid:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_UCSLAVE_USER, @"api/load/userInfo")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    NSDictionary *params = @{@"userId":@(userID),@"appId":@"im_service"};
//    [manager POST:@"userId" parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
////        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
//        completeBlock(responseObject[@"data"],responseObject);
//    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
//        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
//    }];
    
    [manager POST:@"userId" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completeBlock(responseObject[@"data"],responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

    }];
}

//http://ucslaveapi.qbao.com/api/load/userDetail/userId
//通过ID获取手机号
- (void)fetchMobileByUserid:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_UCSLAVE_USER, @"api/load/userDetail")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    NSDictionary *params = @{@"userId":@(userID),@"appId":@"im_service"};
    [manager POST:@"userId" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completeBlock(responseObject[@"data"],responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

    }];
}

- (void)fetchInfoByUseridt:(int64_t)userID CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_UCSLAVE_USER, @"api/load/user")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
//    [manager POST:[NSString stringWithFormat:@"%lld/new",userID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
//        completeBlock(responseObject[@"data"],resultMeta);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
//    }];
    
    [manager POST:[NSString stringWithFormat:@"%lld/new",userID] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject == nil) {
            return ;
        }
        
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        completeBlock(responseObject[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);

    }];
}

//通过用户名获取用户信息
- (void)fetchInfoByUserName:(NSString *)userName CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_LOGINAPI_USER, @"api/query/userId")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    
    NSDictionary *dict = @{@"userName":userName,@"appId":@"im_service"};
    
    [manager POST:@"userName" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        completeBlock(responseObject[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];
}


//通过ID获取朋友用户信息
- (void)fetchInfoByFriendsUserid:(int64_t)userID postDic:(NSDictionary *)dict CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_API_USER, @"/api/")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;

    [manager POST:@"getFriendListInfoNew.html" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseJson];
        completeBlock(responseJson[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];
}

//TODO:获取趣味相投的人列表
- (void)fetchInterestListCompleteBlock:(CompleteBlock)completeBlock
{
    [self qbHttpRequestMethod:HttpMethodPost url:SERVERURL_interestList parameters:nil completeBlock:^(id object, NIMResultMeta *result) {
        completeBlock(object,result);
    }];
}

- (void)fetchInterestListCompleteBlocknew:(CompleteBlock)completeBlock
{
    
    [self qbHttpRequestMethod:HttpMethodPost url:SERVERURL_interestList parameters:nil completeBlock:^(id object, NIMResultMeta *result) {
        if (result) {
            completeBlock(object, result);
        }else{
            //            completeBlock(object, result);
            NSArray *friends = object;
            NSMutableArray *vFriends = @[].mutableCopy;
            [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *dic = obj;
                /*
                 avatar = "<null>";
                 desc = "\U4efb\U52a1\U8fbe\U4eba";
                 isFriend = n;
                 showName = "186***38";
                 userId = 100996;
                 */
                NSMutableDictionary *vDic = @{}.mutableCopy;
                vDic[@"userId"] = dic[@"userId"];
                vDic[@"nickName"] = dic[@"showName"];
                vDic[@"avatarPic"] = dic[@"avatar"];
                if ([dic[@"isFriend"] isEqualToString:@"n"]) {
                    vDic[@"friendship"] = @0;
                }else if ([dic[@"isFriend"] isEqualToString:@"y"]) {
                    vDic[@"friendship"] = @2;
                }
                if ([dic[@"status"] isEqualToString:@"3"]) {
                    vDic[@"friendship"] = @4;
                }
                else
                {
                    vDic[@"friendship"] = @0;
                }
                [vFriends addObject:vDic];
            }];
            completeBlock(object, result);
//            [self operateVcardArrays:vFriends completeBlock:^(id object, QBResultMeta *result) {
//
//            }];
        }
    }];
}

//通过ID获取用户名
- (void)fetchUserNameByUserId:(int64_t)userId CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_API_USER, @"api/v11/uc")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    
    NSDictionary *dict = @{@"username":@(userId)};
    
    [manager POST:@"queryUserNameByUserId" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        completeBlock(responseObject[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];

}

//通过手机和邮箱获取用户名
- (void)fetchUserNameByMobileOrEmail:(NSString *)MEM CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_API_USER, @"api/v11/uc")]];
    [manager setRequestSerializer:[self requestSerializer]];
    manager.securityPolicy.allowInvalidCertificates = NO;
    
    NSString * md =  [SSIMSpUtil encryptPassword:MEM userName:@"qianbao666"];

    NSDictionary * dict = @{@"account":MEM,@"sign":md};
    
    
    [manager POST:@"getUsername" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseObject];
        completeBlock(responseObject[@"data"],resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];

}

//获取商家的小二列表
- (void)fetchWidsWithBid:(int64_t)bid CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_ENTERPRISE, @"im")]];
//    [manager setRequestSerializer:[self requestSerializer]];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = NO;
    NSString *post = [NSString stringWithFormat:@"consumer/waiters.html?bid=%lld",bid];
    [manager POST:post parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseJson];
        completeBlock(responseJson,resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];

}

//获取订单
- (void)fetchOrdersWithSellerId:(int64_t)sellerId buyId:(int64_t)buyId CompleteBlock:(CompleteBlock)completeBlock
{
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: URLSTRINGFORMAT(SERVER_GET_ORDERS, @"api")]];
    //    [manager setRequestSerializer:[self requestSerializer]];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = NO;
    
    NSDictionary *dict = @{@"sellerId":@(sellerId),
                           @"buyerId":@(buyId)};
    
    NSString *post = [NSString stringWithFormat:@"recently/orderInfo.html"];
    [manager POST:post parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NIMResultMeta *resultMeta = [NIMResultMeta resultWithAttributes:responseJson];
        completeBlock(responseJson,resultMeta);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithNSError:error]);
    }];
    
}

//图片、语音服务器
- (void)postFile:(id)file userid:(int64_t)userid toId:(int64_t)toId msgid:(int64_t)msgid fileType:(int)fileType  completeBlock:(CompleteBlock)completeBlock{
    NSData *data                   = nil;
    if ([file isKindOfClass:[UIImage class]]) {
        CGFloat compression            = 0.5f;
        CGFloat maxCompression         = 0.1f;
        int maxFileSize                = 500*1024;
        
        data                   = UIImageJPEGRepresentation(file, compression);
        while (data.length > maxFileSize && compression > maxCompression)
        {
            compression                    -= 0.1;
            data                           = UIImageJPEGRepresentation(file, compression);
        }
    } else if ([file isKindOfClass:[NSData class]])
    {
        data = file;
    }
      else if ([file isKindOfClass:[NSURL class]] && [[NSFileManager defaultManager] fileExistsAtPath:[(NSURL*)file path]])
    {
        data                           = [NSData dataWithContentsOfURL:file];
    } else {
        NIMResultMeta *meta = [NIMResultMeta resultWithCode:0 error:@"" message:@"文件类型不对，无法上传"];
        completeBlock(nil,meta);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://39.104.84.2:8088/uploadfile?key1=%lld&key2=%lld&message_id=%lld&file_type=%ld",userid,toId,msgid,(long)fileType];
    
    NSString *fileName = nil;
    
    if (fileType == FILE_TYPE_AUDIO) {
        fileName = [NSString stringWithFormat:@"%lld.mp3",msgid];
    } else if (fileType == FILE_TYPE_IMAGE) {
        fileName = [NSString stringWithFormat:@"%lld.jpg",msgid];
    } else {
        fileName = [NSString stringWithFormat:@"%lld.mov",msgid];
    }
    
//    NSString *url = [NSString stringWithFormat:@"%@/upload",SERVER_FIM_HTTP];
    
    [self uploadWithUploadFile:data groupid:0 url:url fileName:fileName completeBlock:completeBlock];
}

//群头像服务器
- (void)uploadGroupIcon:(id)file groupid:(uint64_t)groupid completeBlock:(CompleteBlock)completeBlock{
    int fileType                   = 1;
    NSData *data                   = nil;
    if ([file isKindOfClass:[UIImage class]]) {
        fileType                       = 2;
        CGFloat compression            = 0.5f;
        CGFloat maxCompression         = 0.1f;
        int maxFileSize                = 400*1024;
        
        data                   = UIImageJPEGRepresentation(file, compression);
        while (data.length > maxFileSize && compression > maxCompression)
        {
            compression                    -= 0.1;
            data                           = UIImageJPEGRepresentation(file, compression);
        }
    }
    else if([file isKindOfClass:[NSURL class]] && [[NSFileManager defaultManager] fileExistsAtPath:[(NSURL*)file path]])
    {
        fileType                       = 1;
        data                           = [NSData dataWithContentsOfURL:file];
    }else{
        NIMResultMeta *meta = [NIMResultMeta resultWithCode:0 error:@"" message:@"文件类型不对，无法上传"];
        completeBlock(nil,meta);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"http://39.104.84.2:8088/uploadicon?key1=%lld",groupid];

//    NSString *url = [NSString stringWithFormat:@"%@/gupload",SERVER_FIM_HTTP];

    NSString *fileName = [NSString stringWithFormat:@"%lld.jpg",[NIMBaseUtil GetServerTime]/1000000];
    
    [self uploadWithUploadFile:data groupid:groupid url:url fileName:fileName completeBlock:completeBlock];
}

//用户头像服务器
- (void)uploadUserIcon:(id)file userid:(uint64_t)userid completeBlock:(CompleteBlock)completeBlock{
    int fileType                   = 1;
    NSData *data                   = nil;
    if ([file isKindOfClass:[UIImage class]]) {
        fileType                       = 2;
        data                   = UIImageJPEGRepresentation(file, 1.0);
    }
    else if([file isKindOfClass:[NSURL class]] && [[NSFileManager defaultManager] fileExistsAtPath:[(NSURL*)file path]])
    {
        fileType                       = 1;
        data                           = [NSData dataWithContentsOfURL:file];
    }else{
        NIMResultMeta *meta = [NIMResultMeta resultWithCode:0 error:@"" message:@"文件类型不对，无法上传"];
        completeBlock(nil,meta);
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/uploadhead?key1=%lld",SERVER_FIM_HTTP,userid];
    
    NSString *fileName = [NSString stringWithFormat:@"%lld.jpg",[NIMBaseUtil GetServerTime]/1000000];
    
    [self uploadWithUploadFile:data groupid:0 url:url fileName:fileName completeBlock:completeBlock];
}


//朋友圈
- (void)uploadArticle:(id)file articleId:(int64_t)articleId index:(int)index  completeBlock:(CompleteBlock)completeBlock{
    int fileType                   = 1;
    NSData *data                   = nil;
    if ([file isKindOfClass:[UIImage class]]) {
        fileType                       = 2;
        CGFloat compression            = 0.5f;
        CGFloat maxCompression         = 0.1f;
        int maxFileSize                = 400*1024;
        
        data                   = UIImageJPEGRepresentation(file, compression);
        while (data.length > maxFileSize && compression > maxCompression)
        {
            compression                    -= 0.1;
            data                           = UIImageJPEGRepresentation(file, compression);
        }
    }
    else if([file isKindOfClass:[NSURL class]] && [[NSFileManager defaultManager] fileExistsAtPath:[(NSURL*)file path]])
    {
        fileType                       = 1;
        data                           = [NSData dataWithContentsOfURL:file];
    }else{
        NIMResultMeta *meta = [NIMResultMeta resultWithCode:0 error:@"" message:@"文件类型不对，无法上传"];
        completeBlock(nil,meta);
        return;
    }
    NSString *url = ARTICLE_IMAGE_UPLOAD(articleId, index);
    
    //    NSString *url = [NSString stringWithFormat:@"%@/gupload",SERVER_FIM_HTTP];
    
    NSString *fileName = [NSString stringWithFormat:@"%lld.jpg",articleId];
    
    [self uploadWithUploadFile:data groupid:0 url:url fileName:fileName completeBlock:completeBlock];
}


- (void)uploadWithUploadFile:(NSData *)fileData groupid:(int64_t)groupid url:(NSString *)url fileName:(NSString *)fileName completeBlock:(CompleteBlock)completeBlock
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求格式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html",@"application/octet-stream",@"multipart/form-data",nil];
    
    /*
    if (groupid == 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",OWNERID] forHTTPHeaderField:@"userid"];

    }else{
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",groupid] forHTTPHeaderField:@"groupid"];

    }
    
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"verification"];
    */
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        int result = [[jsonDic objectForKey:@"result"] intValue];
        if(!CHECK_RESULT(result))
        {
            NSString *errDetail = [[NIMErrorManager sharedInstance] getErrorDetail:result];
            completeBlock(nil,[NIMResultMeta resultWithCode:result error:@"" message:errDetail]);
        }else{
            completeBlock(jsonDic,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completeBlock(nil,[NIMResultMeta resultWithCode:0 error:@"" message:@"连接服务器失败"]);
    }];
    
}

- (NSOperationQueue *)uploadOperationQueue{
    if (!_uploadOperationQueue) {
        _uploadOperationQueue = [[NSOperationQueue alloc] init];
        [_uploadOperationQueue setMaxConcurrentOperationCount:20];
    }
    return _uploadOperationQueue;
}

- (dispatch_queue_t)download_queue_t{
    if (_download_queue_t == nil) {
        _download_queue_t = dispatch_queue_create("com.nim.downloadQueue", DISPATCH_QUEUE_CONCURRENT);
        
    }
    return _download_queue_t;
}

@end
