//
//  NIMHttpRequestHeader.h
//  Qianbao
//
//  Created by liyan1 on 13-12-24.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMHttpRequestHeader : NSObject

@property(nonatomic, retain)NSMutableDictionary *commonHeader;

+ (id)shareInstance;

@end
