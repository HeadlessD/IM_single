//
//  NIMResultMeta.m
//  QBSDK
//
//  Created by liu nian on 14-4-21.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import "NIMResultMeta.h"

@implementation NIMResultMeta
+ (instancetype)resultWithAttributes:(NSDictionary *)attributes{
    return [[NIMResultMeta alloc] initWithDict:attributes];
}

+ (instancetype)resultWithCode:(int32_t)code error:(NSString *)error message:(NSString *)message{
    message                  = message == nil? @"":message;
    error                    = error == nil ? @"":error;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:code],@"responseCode",
                                error,@"errorCode",
                                message,@"errorMsg", nil];
    return [[NIMResultMeta alloc] initWithDict:attributes];
}

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]){
        
        self.code = [[dict objectForKey:@"responseCode"] intValue];
        if ([dict objectForKey:@"errorCode"]){
            self.error = [NSString stringWithFormat:@"%@", [dict objectForKey:@"errorCode"]];
        }
        if ([dict objectForKey:@"errorMsg"]){
            self.message = [dict objectForKey:@"errorMsg"];
            if (IsStrEmpty(self.message)) self.message = @"";
            
            if(self.message.length == 0){
                if ([dict[@"responseCode"] integerValue]==1000){
                    self.message = @"没有最新数据";
                }else{
                    self.message = __FAILDMESSAGE__;
                }
            }
        }

        if (self.code == 1000) {
            self.success = YES;
        }else{
            self.success = NO;
        }
    }
    return self;
}

+ (instancetype)resultWithNSError:(NSError *)error{
    NSDictionary *userInfo = error.userInfo;
    
    NSString *message = [userInfo objectForKey:@"NSLocalizedDescription"];
    if (IsStrEmpty(message)) {
        message = __FAILDMESSAGE__;
    }
    
    return [NIMResultMeta resultWithCode:error.code error:[error domain] message:message];
}
/*
- (BOOL)success{
    if (self.code == QBIMErrorOk) {
        return YES;
    }
    return NO;
}
*/
- (void)setRequestForurl:(NSURL *)url
{
    if (url) {
        _requesturl = [url copy];
    }
}


@end
