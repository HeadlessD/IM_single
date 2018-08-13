//
//  SSIMBusinessManager.m
//  qbnimclient
//
//  Created by 秦雨 on 17/11/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMBusinessManager.h"
#import "NIMChatUIViewController.h"
#import "NIMManager.h"
#import "NIMContactsViewController.h"
#import "SSIMThreadViewController.h"
#import "NIMSelfViewController.h"
#import "FCFriendQViewController.h"
#import "DFMainViewController.h"

@interface SSIMBusinessManager()<UITabBarControllerDelegate>

@end

@implementation SSIMBusinessManager

SingletonImplementation(SSIMBusinessManager)

-(void)setBusinessInfo:(SSIMBusinessModel *)info
{
    [[NIMBusinessOperationBox sharedInstance] setBusinessInfo:info];
}

-(void)nimPushToChatWithProductInfo:(SSIMProductModel *)info businessInfo:(SSIMBusinessModel *)businessInfo
{
    if (businessInfo == nil ||
        businessInfo.bid==0 ||
        info == nil) {
        [MBTip showTipsView:@"信息不全"];
        return;
    }
    [self nimPushChatBusinessInfo:businessInfo Type:SDK_CONTACT_TYPE_PRODUCT content:info];
    
}

-(void)nimPushToChatWithOrderInfo:(SSIMOrderModel *)info businessInfo:(SSIMBusinessModel *)businessInfo
{
    if (businessInfo == nil ||
        businessInfo.bid==0 ||
        info == nil) {
        [MBTip showTipsView:@"信息不全"];
        return;
    }
    [self nimPushChatBusinessInfo:businessInfo Type:SDK_CONTACT_TYPE_ORDER content:info];
}

-(void)nimPushChatBusinessInfo:(SSIMBusinessModel *)businessInfo Type:(SDK_CONTACT_TYPE)type content:(id)content
{
    UIViewController *topmostVC = [SSIMSpUtil topViewController];

    [MBProgressHUD showHUDAddedTo:topmostVC.view animated:YES];
    
    [[NIMManager sharedImManager] fetchWidsWithBid:businessInfo.bid CompleteBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:topmostVC.view animated:YES];
        });
        if (object) {
            NSArray *wids = [object objectForKey:@"data"];
            businessInfo.waiters = wids;
        }
        [self setBusinessInfo:businessInfo];
        E_MSG_CHAT_TYPE chatType = SHOP_BUSINESS;
        if (businessInfo.bType==1) {
            chatType = CERTIFY_BUSINESS;
        }
        NSString *messageBodyId = [NIMStringComponents createMsgBodyIdWithType:chatType toId:businessInfo.bid];
        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
        chatVC.content = content;
        chatVC.isGoods = type==SDK_CONTACT_TYPE_PRODUCT;
        chatVC.isOrder = type==SDK_CONTACT_TYPE_ORDER;
        chatVC.thread = messageBodyId;
        chatVC.actualThread = _IM_FormatStr(@"%@:%lld",messageBodyId,businessInfo.cid==0?businessInfo.bid:businessInfo.cid);
        chatVC.hidesBottomBarWhenPushed = YES;
        
        NSLog(@"%@",topmostVC);
        UINavigationController* controller            = topmostVC.navigationController;
        controller.modalPresentationStyle       = (IOS_VERSION < 8.0) ? UIModalPresentationCurrentContext : UIModalPresentationCustom ;
        [controller pushViewController:chatVC animated:YES];
    }];
}

-(UITabBarController *)loadTabbar
{
    UITabBarController * newTabbar = [[UITabBarController alloc]init];
    UINavigationController * messageNav = [[UINavigationController alloc] initWithRootViewController:[[SSIMThreadViewController alloc] init]];
    messageNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[UIImage imageNamed:@"消息"] tag:1];
    
//    NIMContactsViewController* contact = (NIMContactsViewController*)[[UIStoryboard storyboardWithName:@"NIMChat" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMContactsViewController"];
    UINavigationController * friendNav = [[UINavigationController alloc] initWithRootViewController:[[DFMainViewController alloc]init]];
    friendNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"朋友圈" image:[UIImage imageNamed:@"朋友圈"] tag:2];
    
//    NIMSelfViewController * selfView [[NIMSelfViewController alloc]init];
    
    NIMSelfViewController * selfView = [[NIMSelfViewController alloc]init];
    selfView.userid = OWNERID;
    selfView.feedSourceType = SystemRandomSource;
//    [feedProfileVC setHidesBottomBarWhenPushed:YES];
    UINavigationController * selfNav = [[UINavigationController alloc] initWithRootViewController:selfView];
    selfNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[UIImage imageNamed:@"个人中心"] tag:3];
    
    newTabbar.viewControllers = @[messageNav,friendNav,selfNav];
    newTabbar.delegate = self;
    return newTabbar;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[NIMSelfViewController class]]) {
        NSLog(@"sdsdsd");
    }
}

- (void)loginAction
{
    //开始连接服务器
    [[SSIMClient sharedInstance] Connect:SERVER_DOMAIN_IM_SOCKET port:SERVER_DOMAIN_IM_PORT];
    NSDictionary *dic = getObjectFromUserDefault(@"imuserInfo");
    int64_t userid = [[dic objectForKey:@"id"] integerValue];
    NSString * userToken = [dic objectForKey:@"token"];
    //登录信息设置TCP登陆
    SSIMLogin *ns_login = [[SSIMLogin alloc]init];
    ns_login.user_id = userid;
    ns_login.ap_id = APP_ID_TYPE_QB;
    ns_login.token = userToken;
    //SDK传入登陆信息
    [[SSIMClient sharedInstance] setLoginInfo:ns_login];
    [[NIMSysManager sharedInstance]sendTCPlogin:ns_login];
}
@end
