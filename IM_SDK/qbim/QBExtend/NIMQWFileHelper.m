//
//  QBFileHelper.m
//  Qianbao
//
//  Created by zhangtie on 14-2-25.
//  Copyright (c) 2014年 qianwang365. All rights reserved.
//

#import "NIMQWFileHelper.h"

#define USER_CACHE_PLISTNAME        @"userPlist.plist"

static NIMQWFileHelper *shareFileObj = nil;

@interface NIMQWFileHelper ()

- (NSString *)getUserCacheFilePath;

@end

@implementation NIMQWFileHelper

+ (NIMQWFileHelper*)shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareFileObj = _ALLOC_OBJ_(NIMQWFileHelper);
    });
    
    return shareFileObj;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        NSString *filePath = [self getUserCacheFilePath];
        
        [self createFileAtPath:filePath content:nil];
    }
    return self;
}

- (BOOL)qw_fileExistsAtPath:(NSString*)filePath
{
     return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString*)getDocumentPath
{
    NSArray *arrPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [arrPath objectAtIndex:0];
    return documentsDirectory;
}

- (BOOL)createDirectory:(NSString*)dir attribute:(NSDictionary*)attr
{
    NSFileManager *fileMangaer = [NSFileManager defaultManager];
    
    BOOL result = [fileMangaer createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:attr error:nil];
    
    return result;
}

- (BOOL)createFileAtPath:(NSString*)path content:(NSData*)contentData
{
    NSFileManager *fileMangaer = [NSFileManager defaultManager];
    
    BOOL isExisted  = [fileMangaer fileExistsAtPath:path isDirectory:NO];
    
    BOOL result     = YES;
    if(!isExisted)
    {
        result = [fileMangaer createFileAtPath:path contents:contentData attributes:nil];
    }
    return result;
}

#pragma mark -- usercache相关
- (NSString *)getUserCacheFilePath
{
    NSString *filePath  = [[NIMQWFileHelper getDocumentPath] stringByAppendingPathComponent:USER_CACHE_PLISTNAME];
    BOOL isExisted      = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO];
    if(isExisted)
    {
        [self createFileAtPath:filePath content:nil];
    }
    return filePath;
}

- (void)setObjectToUserCache:(id)data forKey:(NSString*)key
{
    NSString *filePath       = [self getUserCacheFilePath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    if(data)
    {
        [dic setObject:data forKey:key];
        [self saveDataToUserCache:dic];
    }
}

- (void)saveDataToUserCache:(NSDictionary*)dict
{
    NSString *filePath = [self getUserCacheFilePath];
    [dict writeToFile:filePath atomically:YES];
}

- (id)getObjectFromUserCacheForKey:(NSString*)key
{
    NSString *filePath  = [self getUserCacheFilePath];
    NSDictionary *dic   = [NSDictionary dictionaryWithContentsOfFile:filePath];
    id val = [dic objectForKey:key];
    return val;
}

- (void)removeObjectFromUserCacheForKey:(NSString*)key
{
    NSString *filePath       = [self getUserCacheFilePath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    if(dic)
    {
        [dic removeObjectForKey:key];
        
        [self saveDataToUserCache:dic];
    }
}

@end
