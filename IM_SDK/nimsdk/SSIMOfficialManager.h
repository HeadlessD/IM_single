//
//  NIMOfficialMnager.h
//  NIMSDK1
//
//  Created by 秦雨 on 17/5/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSIMOfficialManager;
@protocol SSIMOfficialMnagerDelegate <NSObject>

@optional
//实时接收公众号消息
-(void)OnRecvOfficialMessage:(uint64_t)messageid;
//实时接收公众号离线消息
-(void)OnRecvOfflineOffcialMessage:(NSArray *)offlineMsgs;

@end
@interface SSIMOfficialManager : NSObject

@property(nonatomic,weak)id<SSIMOfficialMnagerDelegate> delegate;

//单例初始化
+ (instancetype)sharedInstance;

//获取公众号消息列表
-(NSArray *)fetchOfficialMessage:(uint64_t)officialid offset:(NSInteger)offset limit:(NSInteger)limit;

//通过消息ID得到具体消息
-(SSIMMessage *)getMessageByMessageid:(uint64_t)messageid;

//公众号头像、名称传入（用于消息列表展示）
-(void)addOffcialInfoWithOffcialid:(int64_t)offcialid name:(NSString *)name avatar:(NSString *)avatar;


@end
