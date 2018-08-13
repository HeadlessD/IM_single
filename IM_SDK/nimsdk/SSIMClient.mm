//
//  SSIMClient.m
//  SSIMClient
//
//  Created by 秦雨 on 17/5/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "SSIMClient.h"
#import "NetCenter.h"
#import "NIMMessageCenter.h"
#import "NIMGlobalProcessor.h"
#import "SSIMAppTypeDefines.h"
#import "nimncconstdef.h"
#import "NIMMessageCenter.h"
#import "NIMMessageErrorManager.h"
#import "NIMLatestVcardViewController.h"
#import "NIMMessageNotifyVC.h"
#import "NIMSelfViewController.h"

@interface SSIMClient()<BMKGeneralDelegate>

@property(nonatomic,strong)NSMutableDictionary *blockDict;
@property(nonatomic,strong)BMKMapManager *mapManager;
@end

@implementation SSIMClient

SingletonImplementation(SSIMClient)

-(instancetype)init
{
    self = [super init];
    if (self) {
        //初始化全局处理器
        [[NIMGlobalProcessor sharedInstance] InitProcessor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvMessage:) name:NC_SDK_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNetworkChange:) name:NC_SDK_NETWORK object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvPushToVC:) name:NC_SDK_PUSHTOVC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUcount:) name:NC_SDK_UCOUNT object:nil];
        [self registerBaiduMap];
        self.blockDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

-(void)loadLocalData:(int64_t)userid
{
    if (OWNERID != userid) {
        [[NIMSysManager sharedInstance] clearChat];
        [[NIMMomentsManager sharedInstance] clear];
        NSArray *messageList = [ChatListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"userId = %lld",userid]];
        [[NIMMessageManager sharedInstance] addChatList:messageList];
//        [[NIMMomentsManager sharedInstance] loadMomentDataWithUserId:userid offset:0];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
    }
    [[NIMOperationBox sharedInstance] checkRecordStatus];
}

-(void)setLoginInfo:(SSIMLogin *)loginInfo
{
    [self loadLocalData:loginInfo.user_id];
    [self setValue:@(loginInfo.user_id) forKey:NSStringFromSelector(@selector(owerid))];
    [self setValue:@(loginInfo.ap_id) forKey:NSStringFromSelector(@selector(appid))];
    [[NIMSysManager sharedInstance] SetLoginInfo:loginInfo];
    [[GroupManager sharedInstance] LoadData];
    [[NIMMsgCountManager sharedInstance] Load];
}

-(void)setIsQbaoLoginSuccess:(BOOL)isQbaoLoginSuccess
{
    [[NIMSysManager sharedInstance] setIsQbaoLoginSuccess:isQbaoLoginSuccess];
}

-(void)Connect:(NSString *)host port:(unsigned int)port
{
    [[NetCenter sharedInstance] Connect:host port:port domain:true];
}

-(void)reConnect
{
    [[NetCenter sharedInstance] CacheConnect];
}

-(void)disConnect
{
    [[NetCenter sharedInstance] DisConnect];
}

-(void)checkConnect
{
    [[NetCenter sharedInstance] CheckConnect];

}

-(void)sendMessage:(SSIMMessage *)message callBackBlock:(SSIMCallBack)callBackBlock
{
    //判断传入信息是否正确
    SDK_MESSAGE_RESULT result = [[NIMMessageErrorManager sharedInstance] getMessageStatus:message];
    
    if (result != SDK_MESSAGE_OK) {
        callBackBlock(nil,result);
        return;
    }
    int64_t msgid = [NIMStringComponents createMessageid:message.chatType];
    [self.blockDict setObject:callBackBlock forKey:@(msgid)];
    [[NIMMessageCenter sharedInstance] sendSDKMessage:message messageid:msgid];
}

-(void)shareMessage:(SSIMShareModel *)message
{
    [self nim_pushToShareVC:message];
}
-(void)updateUcount:(NSNotification *)noti
{
    if ([_delegate respondsToSelector:@selector(nimUpdateCount:)]) {
        NSInteger ucount = 0;
        if (noti.object == nil) {
            ucount = [[NIMMsgCountManager sharedInstance]GetAllUnreadCount];
        }else{
            ucount = [noti.object intValue];
        }

        [_delegate nimUpdateCount:ucount];
    }
    
}



-(void)recvMessage:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[SSIMMessage class]]) {
        SSIMMessage *message = object;
        SSIMCallBack callBackBlock = [self.blockDict objectForKey:@(message.messageId)];
        if (callBackBlock) {
            callBackBlock(message,SDK_MESSAGE_OK);
            [self.blockDict removeObjectForKey:@(message.messageId)];
        }
    }else if ([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = object;
        int64_t msgid = [[dict objectForKey:@"msgid"] longLongValue];
        SDK_MESSAGE_RESULT result = (SDK_MESSAGE_RESULT)[[dict objectForKey:@"result"] integerValue];
        SSIMCallBack callBackBlock = [self.blockDict objectForKey:@(msgid)];
        callBackBlock(nil,result);
        [self.blockDict removeObjectForKey:@(msgid)];
    }
}

-(void)recvNetworkChange:(NSNotification *)notification
{
    SDK_NET_STATUS status = (SDK_NET_STATUS)[notification.object intValue];
    switch (status) {
        case SDK_CONNECTED:
            if ([_delegate respondsToSelector:@selector(onConnected)]) {
                [_delegate onConnected];
            }
            break;
        case SDK_CLOSED:
            if ([_delegate respondsToSelector:@selector(onClose)]) {
                [_delegate onClose];
            }
            break;
        case SDK_FAILURE:
            if ([_delegate respondsToSelector:@selector(onConnectFailure)]) {
                [_delegate onConnectFailure];
            }
            break;
        case SDK_ERROR:
            if ([_delegate respondsToSelector:@selector(onError)]) {
                [_delegate onError];
            }
            break;
        case SDK_BEKICKED:
            if ([_delegate respondsToSelector:@selector(onBekicked)]) {
                [_delegate onBekicked];
            }
            break;
        case SDK_LOGINED:
            if ([_delegate respondsToSelector:@selector(onLogined)]) {
                [_delegate onLogined];
            }
            break;
            
        default:
            break;
    }
}

-(void)recvPushToVC:(NSNotification *)notification
{
    SDK_PUSH_VC_TYPE status = SDK_PUSH_NOTFOUND;
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        status = (SDK_PUSH_VC_TYPE)[[object objectForKey:@"push_type"] intValue];
    }else{
        status = (SDK_PUSH_VC_TYPE)[notification.object intValue];
    }
    switch (status) {
        case SDK_PUSH_Task:
            if ([_delegate respondsToSelector:@selector(nimPushToTaskVC)]) {
                [_delegate nimPushToTaskVC];
            }
            break;
        case SDK_PUSH_Subscribe:
            if ([_delegate respondsToSelector:@selector(nimPushToSubscribeVC)]) {
                [_delegate nimPushToSubscribeVC];
            }
            break;
        case SDK_PUSH_OfficialList:
            if ([_delegate respondsToSelector:@selector(nimPushToOfficialListVC)]) {
                [_delegate nimPushToOfficialListVC];
            }
            break;
        case SDK_PUSH_OfficialChat:
            if ([_delegate respondsToSelector:@selector(nimPushToOfficialChatVC)]) {
                [_delegate nimPushToOfficialChatVC];
            }
            break;
        case SDK_PUSH_BackHome:
            if ([_delegate respondsToSelector:@selector(nimBackToHomeVC)]) {
                [self updateUcount:nil];
                [_delegate nimBackToHomeVC];
            }
            break;
        case SDK_PUSH_RedBag:
            if ([[object objectForKey:@"isSend"] boolValue]) {
                //发红包
                if ([_delegate respondsToSelector:@selector(nimPushToSendRedBagVC:)]) {
                    SSIMRedbagModel * redBag = [[SSIMRedbagModel alloc]init];
                    redBag.target_id = [object objectForKey:@"target_id"];
                    redBag.isGroup = [[object objectForKey:@"isGroup"] boolValue];
                    [_delegate nimPushToSendRedBagVC:redBag];
                }
            }else{
                //拆红包
                if ([_delegate respondsToSelector:@selector(nimPushToOpenRedBagVC:)]) {
                    SSIMRedbagModel * redBag = [[SSIMRedbagModel alloc]init];
                    redBag.redbag_desc = [object objectForKey:@"desc"];
                    redBag.redbag_id = [object objectForKey:@"id"];
                    redBag.redbag_type = [object objectForKey:@"type"];
                    redBag.open_user_name = [object objectForKey:@"user_name"];
                    redBag.target_id = [object objectForKey:@"target_id"];
                    redBag.desc = [object objectForKey:@"desc"];
                    redBag.isGroup = [[object objectForKey:@"isGroup"] boolValue];
                    redBag.send_user_id = [object objectForKey:@"send_user_id"];
                    [_delegate nimPushToOpenRedBagVC:redBag];
                }
            }
            break;
        case SDK_PUSH_Item:
            if ([_delegate respondsToSelector:@selector(nimPushToItemVC:)]) {
                NSString *url = [object objectForKey:@"url"];
                [_delegate nimPushToItemVC:url];
            }
            break;
        case SDK_PUSH_Favor:
            if ([_delegate respondsToSelector:@selector(nimPushToFavorVC:)]) {
                NSString *messageBodyId = [object objectForKey:@"messageBodyId"];
                [_delegate nimPushToFavorVC:messageBodyId];
            }
            break;
        case SDK_PUSH_Order:
            if ([_delegate respondsToSelector:@selector(nimPushToOrderVC:)]) {
                [_delegate nimPushToOrderVC:object];
            }
            break;
        default:
            break;
    }
}

#pragma mark -- 加载百度地图
-(void)registerBaiduMap
{
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:kMapAppkey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)nim_pushToShareVC:(SSIMShareModel *)message
{
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.objectForward = message;
        latestVVC.isShare = YES;
        latestVcardNavigation.navigationBar.hidden                = YES;
        
        UIViewController *topmostVC = [SSIMSpUtil topViewController];

        UINavigationController* controller            = topmostVC.navigationController;
        controller.modalPresentationStyle       = (IOS_VERSION < 8.0) ? UIModalPresentationCurrentContext : UIModalPresentationCustom ;
        
        [controller pushViewController:latestVVC animated:YES];
    }
    
}

-(void)sendMyFavorMessage:(id)myMessage messageBodyId:(NSString *)messageBodyId
{
    int64_t toid = [NIMStringComponents getOpuseridWithMsgBodyId:messageBodyId];
    E_MSG_CHAT_TYPE chatType = [NIMStringComponents chatTypeWithMsgBodyId:messageBodyId];
    SSIMMessage *message = [[SSIMMessage alloc] init];
    message.userid = OWNERID;
    message.toid = toid;
    message.chatType = chatType;
    if ([myMessage isKindOfClass:[SSIMShareModel class]])
    {
        message.mtype = ITEM;
        message.stype = CHAT;
    }else{
        message.mtype = JSON;
        message.stype = ARTICLE;
    }
    message.etype = DEFAULT;
    message.msgContent = [[NIMMessageErrorManager sharedInstance] getMyFavorJsonByContent:myMessage];
    [self sendMessage:message callBackBlock:^(id object, SDK_MESSAGE_RESULT result) {
        
    }];
}

//发送红包之后返回Model
-(void)sendRedBagComeBack:(SSIMRedbagModel *)redBagModel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SSIM_SENDREDBAGE object:redBagModel];
}

-(void)openRedBagComeBack:(SSIMRedbagModel *)redBagModel{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SSIM_OPENREDBAGE object:redBagModel];
}

//消息设置
-(void)setNewMessageSetting{
    
    NIMMessageNotifyVC *manager = (NIMMessageNotifyVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMMessageNotifyVC"];

    UIViewController *topmostVC = [SSIMSpUtil topViewController];
    
    UINavigationController* controller            = topmostVC.navigationController;
    controller.modalPresentationStyle       = (IOS_VERSION < 8.0) ? UIModalPresentationCurrentContext : UIModalPresentationCustom ;
    
    [controller pushViewController:manager animated:YES];
}

@end
