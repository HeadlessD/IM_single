//
//  NIMAccountsInfo.h
//  QianbaoIM
//
//  Created by MichaelRain on 16/5/1.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AcountType) {
    AcountTypeNone      = 0,
    AcountTypeEmail     = 1,
    AcountTypeQQ        = 2,
    AcountTypeSina      = 3,
    AcountTypeUserName  = 4,
};


@interface NIMAccountsInfo : NSObject <NSCoding>

@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,assign)BOOL    isShow;
@property(nonatomic,strong)NSString *avatar;

@property (nonatomic, assign) BOOL        isRememberPass;
@property (nonatomic, assign) BOOL        isAutoLogin;
@property (nonatomic, retain) NSString      *userid;
@property (nonatomic, assign) AcountType    acountType;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
