//
//  NIMNetwork.h
//  QBSDK
//
//  Created by liu nian on 14-4-21.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import "AFHTTPSessionManager.h"


#if NS_BLOCKS_AVAILABLE
@class NIMResultMeta;
typedef void (^SuccessBlock)(NSURLSessionTask *operation, id responseData);
typedef void (^FailureBlock)(NSURLSessionTask *operation, NIMResultMeta *result);
#endif

/**
 *  该类定义一个请求管理
 */
@interface NIMNetwork : AFHTTPSessionManager

/**
 *  IM请求类
 *
 */
+ (instancetype)sharedClient;

/**
 *  钱宝请求类
 *
 */
+ (instancetype)sharedQBClient;


/*
 * HTTPS
 * add by shiji
 * 添加 https 请求
 *
 */
+ (instancetype)sharedHttps;


-(void)findMyFrinends;
- (void)setHTTPRequestHeaders:(NSDictionary *)headers;

- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                            parameters:(NSDictionary *)parameters
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock;

- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                         parameterType:(BOOL)jsonType       //默认为NO 为表单提交
                            parameters:(NSDictionary *)parameters
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock;


- (NSURLSessionTask *)requestURL:(NSString *)URLString
                            HttpMethod:(HttpMethod)method
                            parameters:(NSDictionary *)parameters
                             userCache:(BOOL)userCache
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock;




- (NSURLSessionTask *)requestURL:(NSString *)URLString
                                  json:(NSString *)json
                          successBlock:(SuccessBlock)successBlock
                          failureBlock:(FailureBlock)failureBlock;
@end
