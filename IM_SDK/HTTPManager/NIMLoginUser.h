//
//  NIMLoginUser.h
//  QianbaoIM
//
//  Created by liu nian on 14-4-10.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMAccountsInfo.h"
@interface NIMLoginUser : NSObject
{
    NSString    *_userName;
    NSString    *_password;
}

@property (nonatomic, retain) NSString    *userName;
@property (nonatomic, retain) NSString    *password;

@property (nonatomic, retain) NSString    *avatarURL;
@property (nonatomic, retain) NSString    *nickname;

@property (nonatomic, assign) BOOL        isRememberPass;
@property (nonatomic, assign) BOOL        isAutoLogin;

@property (nonatomic, retain) NSString      *userid;
@property (nonatomic, assign) AcountType    acountType;
@end
