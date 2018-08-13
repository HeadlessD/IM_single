//
//  NIMAccountsManager.m
//  QianbaoIM
//
//  Created by MichaelRain on 16/5/1.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMAccountsManager.h"
#import "NIMQWFileHelper.h"

static NIMAccountsManager *accountMag = nil;
@implementation NIMAccountsManager

+ (NIMAccountsManager *)shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountMag = [[NIMAccountsManager alloc] init];
        
    });
    return accountMag;
}

- (void)deleteLocalByAccountsInfo:(NIMAccountsInfo *)accountInfo
{
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:[self getLocalAccounts]];
    for (int i = 0; i < historyArray.count; i++)
    {
        NIMAccountsInfo *acount =(NIMAccountsInfo*)[historyArray objectAtIndex:i];
        if ([acount.userName isEqualToString:accountInfo.userName])
        {
            [historyArray removeObjectAtIndex:i];
            break;
        }
    }
    
    NSArray * acarray = [NSArray arrayWithArray:historyArray];
    NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:acarray];
    [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:kLocalAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateLocalByNewAccountsInfo:(NIMAccountsInfo *)accountInfo
{
    
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:[self getLocalAccounts]];
    for (int i = 0; i < historyArray.count; i++)
    {
        NIMAccountsInfo *acount =(NIMAccountsInfo*)[historyArray objectAtIndex:i];
        if ([acount.userName isEqualToString:accountInfo.userName])
        {
            [historyArray removeObjectAtIndex:i];
            break;
        }
    }
    if (historyArray.count >= 5)
    {
        [historyArray removeObjectAtIndex:0];
        [historyArray addObject:accountInfo];
    }
    else
    {
        [historyArray addObject:accountInfo];
    }
    
    NSArray * acarray = [NSArray arrayWithArray:historyArray];
    NSData *archiveCarPriceData = [NSKeyedArchiver archivedDataWithRootObject:acarray];
    [[NSUserDefaults standardUserDefaults] setObject:archiveCarPriceData forKey:kLocalAccountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getLocalAccounts
{
    NSData *arraydata =[[NSUserDefaults standardUserDefaults] objectForKey:kLocalAccountKey];
    NSArray *array =@[];
//    if (arraydata) {
//    array = [NSKeyedUnarchiver unarchiveObjectWithData: arraydata];
//
//    }
    return array;
}

- (NIMAccountsInfo *)getLastLocalAccout
{
    return (NIMAccountsInfo *)[[[NIMAccountsManager shareIntance] getLocalAccounts] lastObject];
}


- (void)setNIMLoginUserInfo:(NIMLoginUserInfo *)userInfo
{
    
    if (userInfo)
    {
        NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
        if (userData)
        {
            [[NIMQWFileHelper shareIntance] setObjectToUserCache:userData forKey:QBUDKeyOldIMUserLoginInfo];
        }
    }
    else
    {
        [[NIMQWFileHelper shareIntance] removeObjectFromUserCacheForKey:QBUDKeyOldIMUserLoginInfo];
    }
}

- (NIMLoginUserInfo *)getLastNIMLoginUserInfo
{
    NSData  *userData = [[NIMQWFileHelper shareIntance] getObjectFromUserCacheForKey:QBUDKeyOldIMUserLoginInfo];
    NIMLoginUserInfo * userInfo = nil;
    if (userData)
    {
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    return userInfo;
}
@end
