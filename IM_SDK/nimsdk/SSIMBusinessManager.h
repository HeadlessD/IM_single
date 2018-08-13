//
//  SSIMBusinessManager.h
//  qbnimclient
//
//  Created by 秦雨 on 17/11/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSIMBusinessManager : NSObject
//单例初始化
+ (instancetype)sharedInstance;

//商品界面联系商家
-(void)nimPushToChatWithProductInfo:(SSIMProductModel *)info businessInfo:(SSIMBusinessModel *)businessInfo;

//订单界面联系商家
-(void)nimPushToChatWithOrderInfo:(SSIMOrderModel *)info businessInfo:(SSIMBusinessModel *)businessInfo;
-(UITabBarController *)loadTabbar;

- (void)loginAction;
@end
