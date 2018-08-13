//
//  NIMAccountsManager.h
//  QianbaoIM
//
//  Created by MichaelRain on 16/5/1.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLocalAccountKey @"QBLastLoginAccounts"

#import "NIMAccountsInfo.h"
#import "NIMLoginUserInfo.h"

@interface NIMAccountsManager : NSObject

+ (NIMAccountsManager *)shareIntance;


/**
 *  更新本地帐户
 *
   array 账号数组
 */
- (void)updateLocalByNewAccountsInfo:(NIMAccountsInfo *)accountInfo;


/**
 *  删除某个帐户
 *
   array 账号数组
 */
- (void)deleteLocalByAccountsInfo:(NIMAccountsInfo *)accountInfo;

/**
 *  获取本地缓存的所有账号
 */
- (NSArray *)getLocalAccounts;

/**
 *  获取本地最后一个账号
 */
- (NIMAccountsInfo *)getLastLocalAccout;

- (void)setNIMLoginUserInfo:(NIMLoginUserInfo *)userInfo;

- (NIMLoginUserInfo *)getLastNIMLoginUserInfo;
@end
