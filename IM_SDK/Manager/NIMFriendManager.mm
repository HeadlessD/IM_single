//
//  NIMFriendManager.m
//  qbim
//
//  Created by 豆凯强 on 17/3/23.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMFriendManager.h"
#import "NIMGlobalProcessor.h"

#import "NIMManager.h"
#import <AddressBookUI/AddressBookUI.h>

#import "PinYinManager.h"

@implementation NIMFriendManager
SingletonImplementation(NIMFriendManager)

#pragma mark 发送好友请求
-(void)sendFriendAddRQ:(int64)peer_id opMsg:(NSString *)opMsg sourceType:(int64)sourceType{    
    //发送好友申请并进行存库操作
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendAddRQ:peer_id opMsg:opMsg sourceType:sourceType];
}

-(void)recvFriendAddRS:(NIMFriendPacket *)fdPack{
    if (fdPack.isComeBackFriend) {
        fdPack.opttype = FD_FRIEND_OP;
    }else{
        fdPack.opttype = FD_WAITCONFIRM_OP;
    }
    [self saveVcardFromFdPack:fdPack];
}

#pragma mark 收到好友请求包
-(void)recvServerAddRQ:(NIMFriendPacket *)fdPack{
    fdPack.opttype = FD_NEEDCONFIRM_OP;
    [self saveVcardFromFdPack:fdPack];
}

#pragma mark 删除好友
-(void)sendFriendDelRQ:(int64)user_id{
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendDelRQ:user_id];
}

-(void)recvFriendDelRS:(NIMFriendPacket *)fdPack
{
    fdPack.opttype = FD_OWN_DEL_OP;
    [self changeFDListWithFDpack:fdPack];
}
#pragma mark 收到好友删除
-(void)recvServerDelRQ:(NIMFriendPacket *)fdPack
{
    fdPack.opttype = FD_PEER_DEL_OP;
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 好友备注
-(void)sendFriendRemarkRQ:(int64)user_id remarkName:(NSString *)remarkName
{
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendRemarkRQ:user_id remarkName:remarkName];
}

-(void)recvFriendRemarkRS:(NIMFriendPacket *)fdPack
{
    fdPack.opttype = FD_REMARK_OP;
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 发送好友请求确认结果
-(void)sendFriendConRQ:(int64)peer_id result:(int)result{
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendConRQ:peer_id result:result];
}

-(void)recvFriendConRS:(NIMFriendPacket *)fdPack
{
    if (fdPack.opttype == FD_OUTLAST) {
        fdPack.opttype = FD_OUTLAST;
    }else{
        fdPack.opttype = FD_OWNCONFIRM_OP;
    }
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 收到对方好友确认结果包
-(void)recvServerAddConRQ:(NIMFriendPacket *)fdPack
{
    fdPack.opttype = FD_PEERCONFIRM_OP;
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 发送黑名单操作
-(void)addBlackListRQ:(int64)peerUser_id blackType:(NIMFDBlackShipType)blackType
{
    //0移除 1添加
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor addBlackListRQ:peerUser_id blackType:blackType];
}

-(void)recvBlackListRQ:(NIMFriendPacket *)fdPack
{
    //主动
    if (fdPack.blacktype == 0) {
        fdPack.blacktype = 0;
    }else if (fdPack.blacktype == 1){
        fdPack.blacktype = 2;
    }
    fdPack.opttype = FD_BLACK_OP;
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 收到黑名单操作
-(void)recvServerBlackRQ:(NIMFriendPacket *)fdPack
{
    //被动
    if (fdPack.blacktype == 0) {
        fdPack.blacktype = 1;
    }else if (fdPack.blacktype == 1){
        fdPack.blacktype = 3;
    }
    fdPack.opttype = FD_BLACK_OP;
    [self changeFDListWithFDpack:fdPack];
    
    //    0主动移除
    //    1被动移除
    //    2主动添加
    //    3被动添加
}

#pragma mark 删除新的朋友通知消息
-(void)sendDelUpdateFriendRQ:(int64)peer_id
{
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendDelUpdateFriendRQ:peer_id];
}

-(void)recvDelUpdateFriendRQ:(NIMFriendPacket *)fdPack
{
    fdPack.opttype = FD_INVALID_OP;
    [self changeFDListWithFDpack:fdPack];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_UPDATE_RQ object:@(fdPack.peer_user_id)];
}

#pragma mark 收到好友恢复
-(void)recvServerRestorRQ:(NIMFriendPacket *)fdPack{
    fdPack.opttype = FD_COMEBACK;
    [self changeFDListWithFDpack:fdPack];
}

#pragma mark 好友列表获取
-(void)sendFriendListRQ:(int64)user_id{
    
}

-(void)recvFriendListRS:(NIMFriendPacket *)fdPack
{
    for (QBFriendInfoPacket * fdInfoPack in fdPack.friendInfoArr) {
        
        NIMFriendPacket * opPack = [[NIMFriendPacket alloc]init];
        opPack.peer_user_id = fdInfoPack.user_id;
        opPack.op_msg = fdInfoPack.op_msg;
        opPack.peer_nick_name = fdInfoPack.nick_name;
        
        if (!IsStrEmpty(fdInfoPack.remark_name)) {
            opPack.peer_remark_name = fdInfoPack.remark_name;
        }
        opPack.addToken = fdInfoPack.fdOPToken;
        opPack.sourcetype = fdInfoPack.sourcetype;
        opPack.opttype = fdInfoPack.opttype;
        opPack.msgsource = fdInfoPack.msgsource;
        opPack.optime = fdInfoPack.optime;
        
        if (!fdInfoPack.blacktype) {
            opPack.blacktype = FD_BLACK_NOT_BLACK;
        }else{
            opPack.blacktype = fdInfoPack.blacktype;
        }
        [self saveVcardFromFdPack:opPack];
    }
}

//存库操作
-(void)saveVcardFromFdPack:(NIMFriendPacket *)fdPack{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    VcardEntity *  vcard = [VcardEntity instancetypeFindUserid:fdPack.peer_user_id];
    if (vcard == nil) {
        vcard = [VcardEntity NIM_createEntity];
    }
    vcard.userid = fdPack.peer_user_id;
    vcard.avatar = USER_ICON_URL(fdPack.peer_user_id);
    vcard.ct = [fdPack.addToken integerValue]*1000;
    if (fdPack.op_msg) {
        if (fdPack.opttype != FD_WAITCONFIRM_OP) {
            vcard.fdExtrInfo = fdPack.op_msg;
        }
    }
    if (fdPack.peer_user_name) {
        vcard.userName = fdPack.peer_user_name;
    }
    if (fdPack.peer_nick_name) {
        vcard.nickName = fdPack.peer_nick_name;
    }
    vcard.fullLitter =[PinYinManager getFullPinyinString:[vcard defaultName]];;
    vcard.fLitter = [PinYinManager getFirstLetter:[vcard defaultName]];
    
    FDListEntity * fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,fdPack.peer_user_id]];
    if (!fdListEntity) {
        fdListEntity = [FDListEntity NIM_createEntity];
    }
    fdListEntity.fdOwnId = OWNERID;
    fdListEntity.ct = [fdPack.addToken integerValue]*1000;
    fdListEntity.fdPeerId = fdPack.peer_user_id;
    fdListEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
    fdListEntity.fdAvatar = USER_ICON_URL(fdPack.peer_user_id);
    
    fdListEntity.fdNickName = [vcard defaultNickName];
    if (fdPack.addToken) {
        fdListEntity.addToken = fdPack.addToken;
    }
    if (fdPack.op_msg) {
        if (fdPack.opttype != FD_WAITCONFIRM_OP) {
            fdListEntity.fdAddInfo = fdPack.op_msg;
        }
    }
    if (!IsStrEmpty(fdPack.peer_remark_name)) {

        fdListEntity.fdRemarkName = fdPack.peer_remark_name;
        fdListEntity.fullCNLitter = fdPack.peer_remark_name;
    }else{
        fdListEntity.fullCNLitter = fdPack.peer_nick_name;
    }
    
    if (fdPack.msgsource == 2) { //全量拉取好友
        fdListEntity.fdFriendShip = FriendShip_Friended;
        if (!fdPack.blacktype) {
            fdListEntity.fdBlackShip = FD_BLACK_NOT_BLACK;
        }else{
            fdListEntity.fdBlackShip = fdPack.blacktype;
        }
    }
    
    NSString * firstName= [NIMStringComponents finFristNameWithID:fdListEntity.fdPeerId];
    fdListEntity.fullLitter = [PinYinManager getFullPinyinString:firstName];
    fdListEntity.firstLitter = [PinYinManager getFirstLetter:firstName];
    fdListEntity.fullAllLitter = [PinYinManager getAllFullPinyinString:firstName];
    fdListEntity.vcard = vcard;
    
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    
    [self changeFDListWithFDpack:fdPack];
    
    NSLog(@"%lld存储_token:%@",OWNERID,fdPack.addToken);
    [[NSUserDefaults standardUserDefaults] setObject:fdPack.addToken forKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]];
}

//好友关系处理
-(void)changeFDListWithFDpack:(NIMFriendPacket *)fdPack{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    
    FDListEntity * fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,fdPack.peer_user_id]];
    
    ChatListEntity * chatListNow = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id]]];
    
    switch (fdPack.opttype) {
            //正常好友包
        case FD_FRIEND_OP:{
            
            fdListEntity.fdFriendShip = FriendShip_Friended;
            if (fdPack.isComeBackFriend) {
                              if (!chatListNow) {
                    chatListNow = [ChatListEntity NIM_createEntity];
                }
                chatListNow.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
                chatListNow.actualThread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
                chatListNow.chatType = PRIVATE;
                chatListNow.userId = OWNERID;
                chatListNow.messageBodyIdType = None;
                chatListNow.topAlign = NO;
                chatListNow.isflod = NO;

                if ([fdPack.addToken integerValue] > 0) {
                    chatListNow.ct = [fdPack.addToken integerValue]*1000;
                }else{
                    chatListNow.ct = msg_time;
                }
                
                [privateContext MR_saveToPersistentStoreAndWait];

                [self createNewFriendTips:chatListNow strType: @"已通过好友验证，现在可以开始聊天了"];
                
                //                NSDictionary * dicts = @{@"userId":@(fdPack.peer_user_id),@"fdResult":@0};
                
                NSDictionary * dicts = @{@"userId":@(fdPack.peer_user_id),@"isComeBack":@1};
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_CLIENT_FRIEND_ADD_RQ object:dicts];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
            }
        }
            break;
            
            //别人同意加我为好友
        case FD_PEERCONFIRM_OP:{
            fdListEntity.fdFriendShip = FriendShip_Friended;
            
            if (fdListEntity.isInNewFriend == YES) {
                fdListEntity.isInNewFriend = NO;
            }
            
            if (!chatListNow) {
                chatListNow = [ChatListEntity NIM_createEntity];
            }
            chatListNow.messageBodyIdType = None;
            chatListNow.topAlign = NO;
            chatListNow.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
            chatListNow.actualThread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
            chatListNow.chatType = PRIVATE;
            chatListNow.userId = OWNERID;
            chatListNow.isflod = NO;
            chatListNow.preview =  @"已通过好友验证，现在可以开始聊天了";

            if ([fdPack.addToken integerValue] > 0) {
                chatListNow.ct = [fdPack.addToken integerValue]*1000;
            }else{
                chatListNow.ct = msg_time;
            }
            
            [privateContext MR_saveToPersistentStoreAndWait];
            [self createNewFriendTips:chatListNow strType: @"已通过好友验证，现在可以开始聊天了"];
     
            NSDictionary * dicts = @{@"userId":@(fdPack.peer_user_id),@"fdResult":@0};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
            NSDictionary *dict = @{@"userid":@(fdListEntity.fdPeerId),@"isRemove":@NO};
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_FRIEND_SHIP_TIME object:dict];

        }
            break;
            
            //主动加好友待验证
        case FD_WAITCONFIRM_OP:{
            if (fdListEntity.fdFriendShip == FriendShip_Ask_Me){
//                fdListEntity.isInNewFriend = YES;
//                fdListEntity.fdUnread = YES;
            }else if(fdListEntity.fdFriendShip == FriendShip_UnilateralFriended){

            }else{
                fdListEntity.fdFriendShip = FriendShip_Ask_Peer;
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_CLIENT_FRIEND_ADD_RQ object:@"123"];
        }
            break;  
            //被加好友待验证
        case FD_NEEDCONFIRM_OP:{
            
            fdListEntity.isInNewFriend = YES;

            if (fdListEntity.fdFriendShip != FriendShip_Ask_Me) {
                fdListEntity.fdUnread = YES;
                fdListEntity.fdFriendShip = FriendShip_Ask_Me;
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_SERVER_FRIEND_ADD_RQ object:nil];
        }
            break;
            //确认别人的请求
        case FD_OWNCONFIRM_OP:{
            fdListEntity.fdConsent = FriendShip_Consent_Peer;
            fdListEntity.fdFriendShip = FriendShip_Friended;
            fdListEntity.isInNewFriend = YES;
            
            if (!chatListNow) {
                chatListNow = [ChatListEntity NIM_createEntity];
            }
            chatListNow.messageBodyIdType = None;
            chatListNow.topAlign = NO;
            chatListNow.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
            chatListNow.actualThread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
            chatListNow.chatType = PRIVATE;
            chatListNow.userId = OWNERID;
            chatListNow.ct = msg_time;
            chatListNow.isflod = NO;

            chatListNow.preview =  @"已通过好友验证，现在可以开始聊天了";
            [self createNewFriendTips:chatListNow strType: @"已通过好友验证，现在可以开始聊天了"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_CLIENT_FRIEND_CONFIRM_RQ object:@"123"];
        }
            break;
            
            //过期
        case FD_OUTLAST:{
            fdListEntity.fdFriendShip = FriendShip_Outlast;
        }
            break;
            
            //备注
        case FD_REMARK_OP:{
//            fdListEntity.fdFriendShip = FriendShip_Friended;
            if (fdPack.peer_remark_name.length != 0) {
                fdListEntity.firstLitter = [PinYinManager getFirstLetter:fdPack.peer_remark_name];
                fdListEntity.fullLitter = [PinYinManager getFullPinyinString:fdPack.peer_remark_name];
                fdListEntity.fullAllLitter = [PinYinManager getAllFullPinyinString:fdPack.peer_remark_name];
                fdListEntity.fullCNLitter = fdPack.peer_remark_name;
                fdListEntity.fdRemarkName = fdPack.peer_remark_name;
            }else{
                fdListEntity.fdRemarkName = nil;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_REMARK_RQ object:@{@"userId":[NSString stringWithFormat:@"%llu",fdPack.peer_user_id],@"remark":fdPack.peer_remark_name}];
        }
            break;
            //收到黑名单操作
        case FD_BLACK_OP:{
            
            if (fdPack.blacktype == 0) {                               //主动移除
                if (fdListEntity.fdBlackShip == FD_BLACK_ACTIVE_BLACK){       //主动变正常
                    fdListEntity.fdBlackShip = FD_BLACK_NOT_BLACK;
                }else if (fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK){ //互相变被动
                    fdListEntity.fdBlackShip = FD_BLACK_PASSIVE_BLACK;
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_ADD_BLACK_RQ object:@"0"];
            }else if (fdPack.blacktype == 2){                          //主动添加
                if (fdListEntity.fdBlackShip == FD_BLACK_NOT_BLACK) {         //正常变主动
                    fdListEntity.fdBlackShip = FD_BLACK_ACTIVE_BLACK;
                }else if (fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK){//被动变相互
                    fdListEntity.fdBlackShip = FD_BLACK_MUTUAL_BLACK;
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_ADD_BLACK_RQ object:@"1"];
            }else if (fdPack.blacktype == 1){                          //被动移除
                if (fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK){      //被动变正常
                    fdListEntity.fdBlackShip = FD_BLACK_NOT_BLACK;
                    NSDictionary *dict = @{@"userid":@(fdListEntity.fdPeerId),@"isRemove":@NO};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_FRIEND_SHIP_TIME object:dict];
                }else if (fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK){ //互相变主动
                    fdListEntity.fdBlackShip = FD_BLACK_ACTIVE_BLACK;
                }
            }else if (fdPack.blacktype == 3){                          //被动添加
                if (fdListEntity.fdBlackShip == FD_BLACK_NOT_BLACK) {         //正常变被动
                    fdListEntity.fdBlackShip = FD_BLACK_PASSIVE_BLACK;
                    NSDictionary *dict = @{@"userid":@(fdListEntity.fdPeerId),@"isRemove":@YES};
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_FRIEND_SHIP_TIME object:dict];
                }else if (fdListEntity.fdBlackShip == FD_BLACK_ACTIVE_BLACK){ //主动变相互
                    fdListEntity.fdBlackShip = FD_BLACK_MUTUAL_BLACK;
                }
            }
        }
            break;
            //被动删除好友包
        case FD_PEER_DEL_OP:{

            fdListEntity.isInNewFriend = NO;
            
            if (fdListEntity.fdFriendShip == FriendShip_Friended) {
                //改为单方面好友
                fdListEntity.fdFriendShip = FriendShip_UnilateralFriended;
                NSDictionary *dict = @{@"userid":@(fdListEntity.fdPeerId),@"isRemove":@YES};
                [[NSNotificationCenter defaultCenter]postNotificationName:NC_FRIEND_SHIP_TIME object:dict];
            }
            
            //修改黑名单状态
            if (fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK){
                //被动变正常
                fdListEntity.fdBlackShip = FD_BLACK_NOT_BLACK;
            }else if (fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK){
                //互相变主动
                fdListEntity.fdBlackShip = FD_BLACK_ACTIVE_BLACK;
            }
            //            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SERVER_FRIEND_DEL_RQ object:@(fdPack.peer_user_id)];
        }
            break;
            //主动删除好友包
        case FD_OWN_DEL_OP:{

            [FDListEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,fdPack.peer_user_id]];
            [ChatListEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id]]];
            [ChatEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_DEL_RQ object:@(fdPack.peer_user_id)];
            NSString *messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:fdPack.peer_user_id];
            if ([[[NIMSysManager sharedInstance] currentMbd]isEqualToString:messageBodyId]) {
                [[NIMSysManager sharedInstance] setCurrentMbd:nil];
            }
            [[NIMMessageManager sharedInstance] removeAllMessageBy:messageBodyId];

        }
            break;
            //删除无效通知
        case FD_INVALID_OP:{
            fdListEntity.isInNewFriend = NO;
        }
            break;
            
            //收到恢复好友
        case FD_COMEBACK:{
            fdListEntity.fdFriendShip = FriendShip_Friended;
            NSDictionary *dict = @{@"userid":@(fdListEntity.fdPeerId),@"isRemove":@NO};
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_FRIEND_SHIP_TIME object:dict];
        }
            break;
            
        default:{
            
        }
            break;
    }
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];

    NSLog(@"%lld存储_token:%@",OWNERID,fdPack.addToken);
    [[NSUserDefaults standardUserDefaults] setObject:fdPack.addToken forKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

-(void)createNewFriendTips:(ChatListEntity *)chatent strType:(NSString *)strType
{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    // int64_t time = [NIMBaseUtil GetServerTime]/1000;
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    chatEntity.chatType = PRIVATE;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = JSON;
    chatEntity.stype = GROUP_ADD_AGREE;
    chatEntity.ct = chatent.ct;
    chatEntity.isSender = YES;
    chatEntity.messageBodyId = chatent.messageBodyId;
    chatEntity.messageId = [[NetCenter sharedInstance] CreateMsgID];
    chatEntity.unread = NO;
    chatEntity.sendUserName = @"提示";
    chatEntity.opUserId = chatent.userId;
    NSString *content = strType;
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    textEntity.text = content;
    [chatEntity setTextFile:textEntity];
    [chatEntity setMsgContent:content];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];

    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",chatEntity.messageBodyId]];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId  = chatEntity.messageBodyId;
        chatList.chatType = PRIVATE;
        chatList.messageBodyIdType = None;
        chatList.topAlign = NO;
        chatList.userId = OWNERID;
    }
    chatList.ct = chatent.ct;
    chatList.preview = content;
    [privateContext MR_saveToPersistentStoreAndWait];
}


-(void)createHBTipsWithOpID:(int64_t)opID redID:(int64_t)redID strType:(NSString *)strType
{
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
     int64_t time = [NIMBaseUtil GetServerTime]/1000;
    ChatEntity * chatEntity = [ChatEntity NIM_createEntity];
    chatEntity.chatType = PRIVATE;
    chatEntity.userId = OWNERID;
    chatEntity.mtype = JSON;
    chatEntity.stype = GROUP_ADD_AGREE;
    chatEntity.ct = time;
    chatEntity.packId = redID;
    chatEntity.isSender = YES;
    chatEntity.messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:opID];
    chatEntity.messageId = [[NetCenter sharedInstance] CreateMsgID];
    chatEntity.unread = NO;
    chatEntity.sendUserName = @"红包提示";
    chatEntity.opUserId = opID;
    NSString *content = strType;
    TextEntity *textEntity = [TextEntity NIM_createEntity];
    textEntity.text = content;
    [chatEntity setTextFile:textEntity];
    [chatEntity setMsgContent:content];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_MESSAGE_OP object:chatEntity];
    
    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",chatEntity.messageBodyId]];
    if (chatList==nil) {
        chatList = [ChatListEntity NIM_createEntity];
        chatList.messageBodyId  = chatEntity.messageBodyId;
        chatList.chatType = PRIVATE;
        chatList.messageBodyIdType = None;
        chatList.topAlign = NO;
        chatList.userId = OWNERID;
    }
    chatList.ct = time;
    chatList.preview = content;
    [privateContext MR_saveToPersistentStoreAndWait];
}



-(void)searchContent{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD showHUDAddedTo:self.view.window animated:NO];
//    });
    
    ABAddressBookRef addressBook = NULL;
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    //如果没有授权则退出
    if (!accessGranted) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
//        });
        [MBTip showTipsView:@"通讯录未授权"];
        return ;
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *persons = [NSMutableArray arrayWithCapacity:0];
    
    dispatch_group_async(group, kBgQueue, ^{
        for(int i = 0; i < CFArrayGetCount(results); i++){
            
            @autoreleasepool {
                
                ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                for (int k = 0; k < ABMultiValueGetCount(phone); k++)
                {
                    
                    NSString *phonenum = nil;
                    NSString *sha1 = nil;
                    NSString *avatar = nil;
                    NSString *name = nil;
                    
                    
                    //获取該Label下的电话值
                    NSString * personPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, k));
                    phonenum = [SSIMSpUtil handlePhonenum:personPhone];
                    sha1 = [NSString stringWithFormat:@"CONTACT:%@:END",phonenum];
                    sha1 = [[SSIMSpUtil sha1:sha1] uppercaseString];
                    NSData *imagedata = (NSData *)CFBridgingRelease(ABPersonCopyImageDataWithFormat(person,kABPersonImageFormatThumbnail));
                    if (imagedata) {
                        UIImage *img = [UIImage imageWithData:imagedata];
                        [SSIMSpUtil cacheAddressAvatar:img phoneNum:phonenum];
                        avatar = [SSIMSpUtil cacheAddressPhoneNum:phonenum];
                    }
                    NSMutableString *string = [NSMutableString stringWithCapacity:0];
                    //读取lastname
                    NSString *lastname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                    if(lastname != nil)
                        [string appendFormat:@"%@",lastname];
                    //读取middlename
                    NSString *middlename = (NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
                    if(middlename != nil)
                        [string appendFormat:@"%@",middlename];
                    //读取firstname
                    NSString *personName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                    if(personName != nil)
                        [string appendFormat:@"%@",personName];
                    
                    if (phonenum && [SSIMSpUtil isValidateMobile:phonenum]) {
                        name = string;
                        NSMutableDictionary *phoneDic = @{}.mutableCopy;
                        
                        if (name.length > 0) {
                            [phoneDic setObject:name forKey:@"name"];
                        }else{
                            if (phonenum) {
                                [phoneDic setObject:phonenum forKey:@"name"];
                            }
                        }
                        if (avatar) {
                            [phoneDic setObject:avatar forKey:@"avatar"];
                        }
                        if (phonenum) {
                            [phoneDic setObject:phonenum forKey:@"phonenum"];
                        }
                        if (sha1) {
                            [phoneDic setObject:sha1 forKey:@"sha1"];
                        }
                        [persons addObject:phoneDic];
                    }
                }
            }  //auto pool
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        CFRelease(results);
        //        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self matchContacts:persons];
        });
    });
}

- (void)matchContacts:(NSArray *)contacts{
    
    if (contacts.count <= 0) {
//        [MBProgressHUD hideHUDForView:self.view.window animated:NO];
        [MBTip showError:@"通讯录无联系人，请导入数据再进行匹配" toView:[UIApplication sharedApplication].keyWindow];
        return;
    }else{
        NSManagedObjectContext *privateObjectContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        
        [privateObjectContext performBlock:^{
            [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *phoneDic = obj;
                
                NSString *sha1 = [phoneDic objectForKey:@"sha1"];
                
                PhoneBookEntity *phoneBookEntity = [PhoneBookEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"sha1 = %@",sha1]];
                if (phoneBookEntity == nil) {
                    phoneBookEntity = [PhoneBookEntity NIM_createEntity];
                    [phoneBookEntity setCt:[[NSDate date] timeIntervalSinceNow]];
                }
                phoneBookEntity.name = [phoneDic objectForKey:@"name"];
                phoneBookEntity.phoneNum = [phoneDic objectForKey:@"phonenum"];
                phoneBookEntity.sha1 = [phoneDic objectForKey:@"sha1"];
                
                if ([phoneDic objectForKey:@"avatar"]) {
                    phoneBookEntity.avatar = [phoneDic objectForKey:@"avatar"];
                }
                
                phoneBookEntity.fullLitter = [PinYinManager getFullPinyinString:[phoneDic objectForKey:@"name"]];
                phoneBookEntity.firstLitter = [PinYinManager getFirstLetter:[phoneDic objectForKey:@"name"]];
                phoneBookEntity.fullAllLitter = [PinYinManager getAllFullPinyinString:[phoneDic objectForKey:@"name"]];
                phoneBookEntity.fullCNLitter = [phoneDic objectForKey:@"name"];
                

                VcardEntity * phVcard =  [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"mobile = %@",phoneBookEntity.phoneNum]];

                if (phVcard) {
                    phoneBookEntity.userid = phVcard.userid;
                    phoneBookEntity.vcard = phVcard;
                    
                    FDListEntity * phFdlist =  [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,phVcard.userid]];
                    if (phFdlist) {
                        phoneBookEntity.fdList = phFdlist;
                        
                        if (phFdlist.fdRemarkName) {
                            phoneBookEntity.fullCNLitter = [NSString stringWithFormat:@"%@(%@)",phoneBookEntity.name,phFdlist.fdRemarkName];
                        }
                        
                        if (phFdlist.fdFriendShip == FriendShip_Friended) {
                            phoneBookEntity.sorted = @"3";
                        }else{
                            phoneBookEntity.sorted = @"1";
                        }
                    }
                }
                //过滤自己
                if (phoneBookEntity.userid == OWNERID) {
                    phoneBookEntity.phoneNum = nil;
                }
            }];
            
            [privateObjectContext MR_saveToPersistentStoreAndWait];
        }];
        
        
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        if (contacts.count <= 50) {
            [randomSet addObjectsFromArray:contacts];
        }else{
            while ([randomSet count] < 3) {
                int r = arc4random() % [contacts count];
                [randomSet addObject:[contacts objectAtIndex:r]];
            }
        }
        NSMutableArray * phoneArrs = [NSMutableArray array];
        for (NSDictionary * conDic in [randomSet allObjects]) {
            NSString * phone = [conDic objectForKey:@"phonenum"];
            [phoneArrs addObject:phone];
        }
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NIMUserOperationBox sharedInstance] sendUserInfoListRQ:nil phone:phoneArrs];
        });
    }
}

@end
