//
//  NIMCallBackManager .m
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMCallBackManager.h"
#import "NetCenter.h"
#import "NIMCallBackStruct.h"
#import "NIMSearchUserManager.h"
@interface NIMCallBackManager  ()
@property (nonatomic, strong) NSMutableDictionary *packetDic;
@property (nonatomic, strong) dispatch_queue_t coredata_queue_t;

@end


@implementation NIMCallBackManager
SingletonImplementation(NIMCallBackManager )

-(instancetype)init
{
    self = [super init];
    if (self) {
        //错误码观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleError:) name:NC_NET_ERROR object:nil];
    }
    return self;
}


-(void)addPacket:(WORD)packet_type buffer:(BYTE *)buffer buf_len:(WORD)buf_len packID:(WORD)pack_id msgId:(NSString*)msgId
{
    NSDate *nowDate=[NSDate date];
    NSTimeInterval time = [nowDate timeIntervalSince1970];
    NSData *data = [NSData dataWithBytes:buffer length:buf_len];
    
    NIMCallBackStruct *model = [[NIMCallBackStruct alloc] init];
    model.pack_type = packet_type;
    model.pack_id = pack_id;
    model.data = data;
    model.time = time;
    model.msgId = msgId;
    model.resend_time = 0;
    [self.packetDic setObject:model forKey:[@(pack_id) description]];
}


-(void)removePackByPackID:(WORD)pack_id
{
    if (pack_id == 0) {
        return;
    }
    if([self.packetDic objectForKey:[@(pack_id) description]]){
        [self.packetDic removeObjectForKey:[@(pack_id) description]];
    }
}



-(void)checkCallBack
{
    
    if (self.packetDic.count == 0) {
        return;
    }

        
        [self.packetDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDate *nowDate=[NSDate date];
            NSTimeInterval nowTime = [nowDate timeIntervalSince1970];
            NIMCallBackStruct *model = obj;
            
            //装包时间
            NSTimeInterval preTime = model.time;
            //包类型
            WORD type = model.pack_type;
            //包内容
            BYTE *buf = (BYTE *)(model.data.bytes);
            //包长度
            WORD buf_len = model.data.length;
            
            if ((nowTime-preTime) <= kMAX_TIME_OUT) {
                return;
            }
            if (model.resend_time < kMAX_RESEND_TIME){
                model.resend_time++;
                model.time = nowTime;
                [self.packetDic setObject:model forKey:key];
                [[NetCenter sharedInstance] SendPack:type buffer:buf buf_len:buf_len];
                NSLog(@"重发包ID:%hu",type);
                return;
            }
            model.resend_time = 0;
            NSLog(@"超时包ID:%hu",type);
            [self.packetDic removeObjectForKey:[key description]];
           
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:@(model.pack_id) forKey:@"sessionID"];
            [dict setValue:@0 forKey:@"result"];
            [dict setValue:@"请求超时" forKey:@"error"];
            
            //观察者模式进行UI交互（测试）
            switch (type) {
                case NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RQ:
                case NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RQ:
                case NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RQ:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                       
                            ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:model.msgId.longLongValue];
                            chatEntity.status = QIMMessageStatuUpLoadFailed;
                            [[NIMMessageManager sharedInstance] updateMessage:chatEntity isPost:YES isChange:NO];
                            [privateContext MR_saveToPersistentStoreAndWait];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NC_MESSAGE_STATUS object:nil];
                        
                        
                    });
                    
                    
                }
                case NEW_DEF_GROUP_LIST_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_FETCH_GROUP_LIST object:nil];
                    break;
                case NEW_DEF_GROUP_CREATE_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_CREATE_GROUP object:nil];
                    break;
                case NEW_DEF_GROUP_DETAIL_INFO_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_DETAIL object:@(model.pack_id)];
                    break;
                case NEW_DEF_GROUP_LEADER_CHANGE_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUPLEADERCHANGE object:nil];
                    break;
                    
                case NEW_DEF_GROUP_MODIFY_CHANGE_RQ:
                {
                    NSInteger type = model.msgId.integerValue;
                    switch (type) {
                        case GROUP_OFFLINE_CHAT_ADD_USER:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ADD object:nil];
                            break;
                        case GROUP_OFFLINE_CHAT_KICK_USER:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_MODIFY object:nil];
                            break;
                        case GROUP_OFFLINE_CHAT_EXIT:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_EXIT_GROUP object:nil];
                            break;
                        case GROUP_AGREE_ENTER:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ENTER_AGREE object:nil];
                            break;
                        case GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_REMARK_MODIFY object:nil];
                            break;
                        case GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_NAME_MODIFY object:nil userInfo:@{@"type":@(GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME)}];
                            break;
                            
                        case GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME:
                            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_NAME_MODIFY object:nil userInfo:@{@"type":@(GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME)}];
                            break;
                        default:
                            break;
                    }
                }
                    break;
                    
                case NEW_DEF_ME_INFO_RQ:
                    [[NIMSearchUserManager sharedInstance] getSelfInfoFailureSearchCon:model.msgId errorStr:@"连接超时"];
                    break;
                case NEW_DEF_USER_INFO_RQ:
                    [[NIMSearchUserManager sharedInstance] getUserInfoFailureSearchCon:model.msgId errorStr:@"连接超时" type:[[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d",model.pack_id]] intValue]];
                    break;
                    
                    
                    //用户登陆包
                case NEW_DEF_REG_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_REG_RQ object:nil];
                    break;
                    //短信验证码包
                case NEW_DEF_SMS_VALID_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_SMS_VALID_RQ object:nil];
                    break;

                    
                    //更新用户信息
                case NEW_DEF_USER_CHANGE_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
                    break;
                    //修改用户邮箱
                case NEW_DEF_CHANGE_MAIL_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
                    break;
                    //修改用户手机
                case NEW_DEF_CHANGE_MOBILE_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
                    break;
                case NEW_DEF_USER_COMPLAINT_RQ:
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_COMPLAINT_RQ object:nil];
                    break;
                case NEW_DEF_CLIENT_FRIEND_ADD_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_CLIENT_FRIEND_ADD_RQ object:nil];
                    break;
                case NEW_DEF_FRIEND_DEL_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_DEL_RQ object:nil];
                    break;
                case NEW_DEF_FRIEND_REMARK_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_REMARK_RQ object:nil];
                    break;
                case NEW_DEF_FRIEND_UPDATE_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_UPDATE_RQ object:nil];
                    break;
                case NEW_DEF_CLIENT_FRIEND_BLACKLIST_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_ADD_BLACK_RQ object:nil];
                    
                case NEW_DEF_CLIENT_FRIEND_CONFIRM_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_CLIENT_FRIEND_CONFIRM_RQ object:nil];
                    break;
                case NEW_DEF_GROUP_REMARK_DETAIL_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_REMARK_DETAIL object:nil];
                    break;
                case NEW_DEF_BUSINESS_GETFREEWAITER_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_FREE_WAITER object:nil];
                    break;
                case NEW_DEF_GROUP_MESSAGE_STATUS_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_MESSAGE_STATUS object:nil];
                    break;
                case NEW_DEF_USERLST_INFO_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERLST_INFO_RQ object:nil];
                    break;
                case NEW_DEF_SINGLE_CHAT_STATUS_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SINGLE_CHAT_STATUS object:nil];
                    break;
                case NEW_DEF_GROUP_SCAN_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_INFO object:nil];
                    break;
                case NEW_DEF_GROUP_TYPE_LIST_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_TYPE_LIST object:nil];
                    break;
                    
                case NEW_DEF_MOMENTS_ADDCOMMENT_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_COMMENT object:nil];
                    break;
                case NEW_DEF_MOMENTS_QUERYTIMELIME_RQ:
                case NEW_DEF_MOMENTS_QUERYBYIDS_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_ARTICLE object:nil];
                    break;
                case NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_BLACK_LIST object:nil];
                    break;
                case NEW_DEF_MOMENTS_UPDSETTING_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_MODIFY object:nil];
                    break;
                case NEW_DEF_MOMENTS_QUERYSETTING_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_QUERY object:nil];
                    break;
                case NEW_DEF_MOMENTS_DELCOMMENT_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_COMMENT object:nil];
                    break;
                case NEW_DEF_MOMENTS_QUERYBYUSER_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_USER_QUERY object:nil];
                    break;
                default:
                    break;
            }
            //超时断连
            [[NetCenter sharedInstance] DisConnect];
            [self resetMap];
            return;
        }];    
}

//处理错误码->发送通知
-(void)handleError:(NSNotification *)noti
{
    QBNCParam *param = noti.object;
    NSLog(@"错误信息：%@",param.p_string);
    NIMCallBackStruct *model = [self.packetDic objectForKey:[@(param.p_int64) description]];
    //包类型
    WORD packet_type = model.pack_type;
    [self.packetDic removeObjectForKey:[@(param.p_int64) description]];
   
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@(model.pack_id) forKey:@"sessionID"];
    [dict setValue:@0 forKey:@"result"];
    [dict setValue:param.p_string forKey:@"error"];

    switch (packet_type) {
        case NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RQ:
        case NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RQ:
        case NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RQ:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                
                    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:model.msgId.longLongValue];
                    chatEntity.status = QIMMessageStatuUpLoadFailed;
                    [privateContext MR_saveToPersistentStoreAndWait];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:NC_MESSAGE_STATUS object:nil];
            
                
            });
            
        }
        case NEW_DEF_GROUP_LIST_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FETCH_GROUP_LIST object:param];
            break;
        case NEW_DEF_GROUP_CREATE_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_CREATE_GROUP object:param];
            break;
        case NEW_DEF_GROUP_DETAIL_INFO_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_DETAIL object:@{@"packid":@(model.pack_id),@"content":param}];
            break;
        case NEW_DEF_GROUP_LEADER_CHANGE_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUPLEADERCHANGE object:param];
            break;
        case NEW_DEF_GROUP_MODIFY_CHANGE_RQ:
        {
            NSInteger type = model.msgId.integerValue;
            switch (type) {
                case GROUP_OFFLINE_CHAT_ADD_USER:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ADD object:param];
                    break;
                case GROUP_OFFLINE_CHAT_KICK_USER:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_MODIFY object:param];
                    break;
                case GROUP_OFFLINE_CHAT_EXIT:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_EXIT_GROUP object:param];
                    break;
                case GROUP_AGREE_ENTER:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_ENTER_AGREE object:param];
                    break;
                case GROUP_OFFLINE_CHAT_MODIFY_GROUP_REMARK:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_REMARK_MODIFY object:param];
                    break;
                case GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME:case GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_NAME_MODIFY object:param];
                default:
                    break;
            }
        }
            
            
        case NEW_DEF_ME_INFO_RQ:
            [[NIMSearchUserManager sharedInstance] getSelfInfoFailureSearchCon:model.msgId errorStr:param.p_string];
            break;
        case NEW_DEF_USER_INFO_RQ:
            [[NIMSearchUserManager sharedInstance] getUserInfoFailureSearchCon:model.msgId errorStr:param.p_string type:[[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%d",model.pack_id]] intValue]];
            break;
            

            //用户登陆包
        case NEW_DEF_REG_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_REG_RQ object:param];
            break;
            //短信验证码包
        case NEW_DEF_SMS_VALID_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_SMS_VALID_RQ object:param];
            break;

            //更新用户信息
        case NEW_DEF_USER_CHANGE_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
            break;
            //修改用户邮箱
        case NEW_DEF_CHANGE_MAIL_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
            break;
            //修改用户手机
        case NEW_DEF_CHANGE_MOBILE_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_USER object:dict];
            break;
            
        case NEW_DEF_USER_COMPLAINT_RQ:
            [[NSNotificationCenter defaultCenter]postNotificationName:NC_USER_COMPLAINT_RQ object:param];
            break;
        case NEW_DEF_CLIENT_FRIEND_ADD_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_CLIENT_FRIEND_ADD_RQ object:param];
            break;
        case NEW_DEF_FRIEND_DEL_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_DEL_RQ object:param];
            break;
        case NEW_DEF_FRIEND_REMARK_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_REMARK_RQ object:param];
            break;
        case NEW_DEF_FRIEND_UPDATE_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_FRIEND_UPDATE_RQ object:param];
            break;
        case NEW_DEF_CLIENT_FRIEND_BLACKLIST_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_ADD_BLACK_RQ object:param];
        case NEW_DEF_CLIENT_FRIEND_CONFIRM_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_CLIENT_FRIEND_CONFIRM_RQ object:param];
            break;
        case NEW_DEF_GROUP_REMARK_DETAIL_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_REMARK_DETAIL object:param];
            break;
        case NEW_DEF_BUSINESS_GETFREEWAITER_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_FREE_WAITER object:param];
            break;
        case NEW_DEF_GROUP_MESSAGE_STATUS_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_MESSAGE_STATUS object:param];
            break;
        case NEW_DEF_USERLST_INFO_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_USERLST_INFO_RQ object:param];
            break;
        case NEW_DEF_SINGLE_CHAT_STATUS_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SINGLE_CHAT_STATUS object:param];
            break;
        case NEW_DEF_GROUP_SCAN_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_INFO object:param];
            break;
        case NEW_DEF_GROUP_TYPE_LIST_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_TYPE_LIST object:param];
            break;
        case NEW_DEF_MOMENTS_ADDCOMMENT_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_COMMENT object:param];
            break;
        case NEW_DEF_MOMENTS_QUERYTIMELIME_RQ:
        case NEW_DEF_MOMENTS_QUERYBYIDS_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_ARTICLE object:param];
            break;
        case NEW_DEF_MOMENTS_UPDBLACKNOTCARELIST_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_BLACK_LIST object:param];
            break;
        case NEW_DEF_MOMENTS_UPDSETTING_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_MODIFY object:param];
            break;
        case NEW_DEF_MOMENTS_QUERYSETTING_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SET_QUERY object:param];
            break;
        case NEW_DEF_MOMENTS_DELCOMMENT_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_DELETE_COMMENT object:param];
            break;
        case NEW_DEF_MOMENTS_QUERYBYUSER_RQ:
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_USER_QUERY object:param];
            break;
        default:
            
            break;
    }
}

-(void)resetMap
{

        if (self.packetDic.count<=0) {
            return;
        }
        [self.packetDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NIMCallBackStruct *model = obj;
            //包类型
            WORD type = model.pack_type;
            [self.packetDic removeObjectForKey:[key description]];
            //观察者模式进行UI交互（测试）
            switch (type) {
                case NEW_DEF_CHAT_CLIENT_SEND_MESSAGE_RQ:
                case NEW_DEF_GROUP_CLIENT_SEND_MESSAGE_RQ:
                case NEW_DEF_CLIENT_FANS_SEND_MESSAGE_RQ:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                        
                            ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:model.msgId.longLongValue];
                            chatEntity.status = QIMMessageStatuUpLoadFailed;
                            [[NIMMessageManager sharedInstance] updateMessage:chatEntity isPost:YES isChange:NO];
                            [privateContext MR_saveToPersistentStoreAndWait];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
                            [[NSNotificationCenter defaultCenter]postNotificationName:NC_MESSAGE_STATUS object:nil];
                    
                        
                    });
                }
                    case NEW_DEF_MOMENTS_ADDCOMMENT_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SEND_COMMENT object:nil];
                    break;
                    case NEW_DEF_MOMENTS_QUERYTIMELIME_RQ:
                    case NEW_DEF_MOMENTS_QUERYBYIDS_RQ:
                    [[NSNotificationCenter defaultCenter] postNotificationName:NC_GET_ARTICLE object:nil];
                    break;
                default:
                    break;
            }
        }];
        [self.packetDic removeAllObjects];

}

-(NSMutableDictionary *)packetDic{
    
    @synchronized (self) {
        if (!_packetDic) {
            _packetDic=[NSMutableDictionary dictionary];
        }
        return _packetDic;
    }
    
}

- (dispatch_queue_t)coredata_queue_t{
    if (_coredata_queue_t == nil) {
        _coredata_queue_t = dispatch_queue_create("com.RevSerialQueue", DISPATCH_QUEUE_CONCURRENT);
        //        _coredata_queue_t = dispatch_get_main_queue();
    }
    return _coredata_queue_t;
}

@end
