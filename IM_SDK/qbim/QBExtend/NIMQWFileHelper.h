//
//  QBFileHelper.h
//  Qianbao
//
//  Created by zhangtie on 14-2-25.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMQWFileHelper : NSObject

+ (NIMQWFileHelper*)shareIntance;

+ (NSString*)getDocumentPath;

- (BOOL)qw_fileExistsAtPath:(NSString*)filePath;

- (BOOL)createDirectory:(NSString*)dir attribute:(NSDictionary*)attr;

- (BOOL)createFileAtPath:(NSString*)path content:(NSData*)contentData;

#pragma mark -- usercache相关
- (void)setObjectToUserCache:(id)data forKey:(NSString*)key;

- (id)getObjectFromUserCacheForKey:(NSString*)key;

- (void)removeObjectFromUserCacheForKey:(NSString*)key;

@end
