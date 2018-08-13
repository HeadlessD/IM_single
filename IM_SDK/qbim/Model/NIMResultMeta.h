//
//  NIMResultMeta.h
//  QBSDK
//
//  Created by liu nian on 14-4-21.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类定义一个请求结果描述模型
 */
@interface NIMResultMeta : NSObject
@property (nonatomic, assign) int32_t code;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) BOOL  success;
@property (nonatomic, readonly) NSURL *requesturl;

+ (instancetype)resultWithAttributes:(NSDictionary *)attributes;
+ (instancetype)resultWithCode:(int32_t)code error:(NSString *)error message:(NSString *)message;
+ (instancetype)resultWithNSError:(NSError *)error;
- (void)setRequestForurl:(NSURL *)url;
@end
