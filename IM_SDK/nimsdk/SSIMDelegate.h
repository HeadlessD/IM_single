//
//  SSIMDelegate.h
//  qbnimclient
//
//  Created by 秦雨 on 17/10/19.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSIMDelegate <NSObject>

@optional

/**************网络相关***********/

//连接失败
-(void)onConnectFailure;
//连接关闭
-(void)onClose;
//连接出错
-(void)onError;
//连接成功
-(void)onConnected;
//登录成功
-(void)onLogined;
//登录被踢
-(void)onBekicked;

/**************界面跳转***********/

//前往公众号列表界面
-(void)nimPushToOfficialListVC;
//前往公众号聊天界面
-(void)nimPushToOfficialChatVC;
//前往任务助手界面
-(void)nimPushToTaskVC;
//前往订阅助手界面
-(void)nimPushToSubscribeVC;
//前往到发红包
-(void)nimPushToSendRedBagVC:(SSIMRedbagModel *)redBagModel;
//前往到拆红包
-(void)nimPushToOpenRedBagVC:(SSIMRedbagModel *)redBagModel;
//前往到链接界面
-(void)nimPushToItemVC:(NSString *)url;
//前往到收藏界面
-(void)nimPushToFavorVC:(NSString *)messageBodyId;
//返回到首页
-(void)nimBackToHomeVC;
//前往到订单信息
-(void)nimPushToOrderVC:(NSDictionary *)orderInfo;
/**************功能相关***********/

//更新未读消息数（用于首页铃铛小红点显示）
-(void)nimUpdateCount:(NSInteger)count;
@end
