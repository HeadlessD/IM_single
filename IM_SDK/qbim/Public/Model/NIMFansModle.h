//
//  NIMFansModle.h
//  QianbaoIM
//
//  Created by xuqing on 16/4/26.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMFansModle : NSObject
@property(nonatomic,assign)double userId;
@property(nonatomic,strong)NSString *remarkName;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *avatarPic;
@property(nonatomic,strong)NSString *signature;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,strong)NSString *sex;

-(id)initWithDic:(NSDictionary*)dic;
@end
