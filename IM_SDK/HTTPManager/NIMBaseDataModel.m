//
//  NIMBaseDataModel.m
//  QianbaoIM
//
//  Created by tiezhang on 14-9-17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMBaseDataModel.h"

@implementation NIMBaseDataModel

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (nil!=self)
    {
        
    }
    return self;
}

+ (id)baseDataWithDecode:(NSString *)userID
{
    id  info = nil;
    NSString * className =  _IM_FormatStr(@"%@_%@",NSStringFromClass([self class]),userID);
    @try {
        NSData  *infoData = getObjectFromUserDefault(className);
        if (infoData)
        {
            info = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
    return info;
}

- (void)saveToLocal
{
    if (self)
    {
        NSData * infoData = [NSKeyedArchiver archivedDataWithRootObject:self];
        if (infoData)
        {
            setObjectToUserDefault([self savaName], infoData);
        }
    }
    else
    {
        removeObjectFromUserDefault([self savaName]);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)clearLocal
{
    if (self)
    {
        removeObjectFromUserDefault([self savaName]);
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
//    [super encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (NSString *)savaName
{
    NSAssert(0, @"子类需要实现此方法");
    return nil;
}

@end
