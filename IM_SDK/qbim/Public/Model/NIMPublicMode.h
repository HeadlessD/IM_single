//
//  publicMode.h
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/29.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface publicMode : NSObject
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *need_auth;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *avatarPic;
@property(nonatomic,strong)NSString *publicid;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *userAccount;
@property(nonatomic,strong)NSString *subjecttype;
@property(nonatomic,strong)NSString *recommend;
@property(nonatomic,strong)NSString *authpass;
@property(nonatomic,strong)NSString *subscribed;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
