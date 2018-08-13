#import "NIMSysProcessor.h"
#import "NIMSysManager.h"
#import "NIMCallBackManager.h"
#import "NIMGlobalProcessor.h"

#import "fb_login_rq_generated.h"
#import "fb_login_rs_generated.h"
#import "fb_server_discon_id_generated.h"
#import "fb_time_sync_rq_generated.h"
#import "fb_time_sync_rs_generated.h"
#import "fb_sms_valid_rq_generated.h"
#import "fb_sms_valid_rs_generated.h"
#import "fb_reg_rq_generated.h"
#import "fb_reg_rs_generated.h"

#import "NIMManager.h"
#import "SSIMSpUtil.h"
#import "PinYinManager.h"
#import "NSString+NIMMyDefine.h"
#import "SSIMPushHelper.h"
//#import "AFHTTPRequestOperationManager.h"
@interface NIMSysProcessor()
@property (nonatomic, strong) dispatch_queue_t offline_queue_t;

-(void)initCallBack;
@end

@implementation NIMSysProcessor
using namespace syspack;
using namespace commonpack;


static NSString * const CLASS_NAME = @"NIMSysProcessor";
- (id)init
{
    self = [super init];
    [self initCallBack];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USERINFO_RQ_ForMe:) name:NC_USERINFO_RQ_ForMe object:nil];
    
    return self;
}

- (void)dealloc
{
    DBLog(@"sadsadsa");
}

-(void)initCallBack
{
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_LOGIN_RS class_name:self func_name:@"recvLoginRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_HEART_RS class_name:self func_name:@"recvHeartRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SERVER_DISCON_ID class_name:self func_name:@"recvKickPack:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_TIME_SYNC_RS class_name:self func_name:@"recvServerTime:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_SMS_VALID_RS class_name:self func_name:@"recvSMSVaildRS:"];
    [[NetCenter sharedInstance] AttachNetMsg:NEW_DEF_REG_RS class_name:self func_name:@"recvSMSloginRS:"];
}

-(void) processEvent
{
    //心跳包
    uint64_t cur_time = [NIMBaseUtil GetMsTime];
    if(cur_time - [NetCenter sharedInstance].last_send_heart_time >= HEART_INTERVAL)
    {
        [self sendHeartRQ];
        [NetCenter sharedInstance].last_send_heart_time = cur_time;
    }
}

//发送验证码

-(void)sendSMSVaildRQ:(int64_t)mobile{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    //todo 这里需要获取pack_session_id
    int packetID = [NIMBaseUtil getPacketSessionID];

    T_SMS_VALID_RQBuilder sms_rq = T_SMS_VALID_RQBuilder(fbbuilder);
    
    const commonpack::S_RQ_HEAD s_rq(mobile,packetID,PLATFORM_APP);
    sms_rq.add_s_rq_head(&s_rq);
    sms_rq.add_nation_code(86);
    sms_rq.add_mobile(mobile);
    
    
    flatbuffers::Offset<T_SMS_VALID_RQ> offset_rq = sms_rq.Finish();
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_SMS_VALID_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_SMS_VALID_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvSMSVaildRS:(QBTransParam *) trans_param{
    T_SMS_VALID_RS * t_user_rs = (syspack:: T_SMS_VALID_RS *)GetT_SMS_VALID_RS(trans_param.buffer.bytes);
    DBLog(@"len:%d",trans_param.buf_len);
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"register_user_id:%llu",t_user_rs->s_rs_head()->user_id());
        return;
    }
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    [[NIMSysManager sharedInstance] recvSMSVaildRS];
}

//手机账号登陆
-(void)sendSMSloginRQ:(int64_t)mobile userToken:(NSString *)userToken type:(int64_t)type{
    flatbuffers::FlatBufferBuilder fbbuilder;
    
    
    auto name = fbbuilder.CreateString([[NSString stringWithFormat:@"%lld",mobile] UTF8String]);

    auto token = fbbuilder.CreateString([userToken UTF8String]);

    int packetID = [NIMBaseUtil getPacketSessionID];
   
    ACCOUNT_INFOBuilder accBuilder = ACCOUNT_INFOBuilder(fbbuilder);
    
    accBuilder.add_target_user_token(token);
    accBuilder.add_target_user_name(name);
    accBuilder.add_target_user_id(mobile);
    accBuilder.add_account_type(0x01);
    flatbuffers::Offset<commonpack::ACCOUNT_INFO> accinfo = accBuilder.Finish();

    T_REG_RQBuilder sms_rq = T_REG_RQBuilder(fbbuilder);

    const commonpack::S_RQ_HEAD s_rq(123,packetID,PLATFORM_APP);
   
    sms_rq.add_s_rq_head(&s_rq);

    sms_rq.add_account_info(accinfo);
   
    flatbuffers::Offset<T_REG_RQ> offset_rq = sms_rq.Finish();
    
    fbbuilder.Finish(offset_rq);
    BYTE*    buf = fbbuilder.GetBufferPointer();
    WORD    len = (WORD)fbbuilder.GetSize();
    [[NetCenter sharedInstance] SendPack:NEW_DEF_REG_RQ buffer:buf buf_len:len];
    //加入回调
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_REG_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}

-(void)recvSMSloginRS:(QBTransParam *) trans_param{
    T_REG_RS * t_user_rs = (syspack:: T_REG_RS *)GetT_REG_RS(trans_param.buffer.bytes);
    DBLog(@"len:%d",trans_param.buf_len);
    //检查头
    if(!t_user_rs || ![super checkHead:t_user_rs->s_rs_head()]){
        DBLog(@"register_user_id:%llu",t_user_rs->s_rs_head()->user_id());
        return;
    }
    
    int64_t userid =  t_user_rs->user_id();
    NSString * userToken = [NSString stringWithCString:t_user_rs->reg_token()->c_str() encoding:NSUTF8StringEncoding];
    ACCOUNT_INFO *info = (ACCOUNT_INFO *)t_user_rs->account_info();
    uint64_t name = info->target_user_id();
    [[NIMLoginManager sharedInstance] updateAccount:_IM_FormatStr(@"%lld",name)];
    //todo 删除pack_session_id
    int pack_id = t_user_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    [[NIMSysManager sharedInstance]recvSMSloginRSwithUserid:userid userToken:userToken];
}

//登录包
-(bool)sendLoginRQ:(SSIMLogin *) login_info
{
    [[NetCenter sharedInstance] SetNetStatus:LOGINING];
    flatbuffers::FlatBufferBuilder fbbuilder;
    //todo 这里需要获取pack_session_id
    int packetID = [NIMBaseUtil getPacketSessionID];
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    int64_t client_time = [NIMBaseUtil GetServerTime];
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *os_type = [NIMBaseUtil deviceVersion];
    
    NSString *cookie = [NSString stringWithFormat:@"%lld%@%@%lld",login_info.user_id,login_info.token,uuid,client_time];
    
    NSData *cookieData = [cookie dataUsingEncoding:kCFStringEncodingUTF8];
    uint8_t *bytes = (uint8_t *)[cookieData bytes];
    
    commonpack::S_RQ_HEAD s_rq_head(login_info.user_id, packetID,PLATFORM_APP);
    auto tgt = fbbuilder.CreateString([login_info.token UTF8String]);
    auto sName = fbbuilder.CreateString([os_type UTF8String]);
    auto device_code = fbbuilder.CreateString([uuid UTF8String]);
    auto version = fbbuilder.CreateString([appVerion UTF8String]);
    
    //cookie加密
    [[NetCenter sharedInstance] EncryptCookie:(unsigned char *)bytes length:cookieData.length];
    
    auto enCookie = fbbuilder.CreateVector((const uint8_t *)bytes,cookieData.length);
    
    
    T_LOGIN_RQBuilder loginrq = T_LOGIN_RQBuilder(fbbuilder);
    loginrq.add_s_rq_head(&s_rq_head);
    loginrq.add_tgt(tgt);
    loginrq.add_ap_id(login_info.ap_id);
    loginrq.add_client_time(client_time);
    loginrq.add_os_type(sName);
    loginrq.add_net_type([self getNetwork]);
    loginrq.add_device_code(device_code);
    loginrq.add_client_version(version);
    loginrq.add_platform(PLATFORM_APP);
    loginrq.add_cookie(enCookie);
    
    fbbuilder.Finish(loginrq.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    //登陆包加密
    [[NetCenter sharedInstance] EncryptBody:buf length:len];
    [[NetCenter sharedInstance] SendPack:NEW_DEF_LOGIN_RQ buffer:buf buf_len:len];
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_LOGIN_RQ buffer:buf buf_len:len packID:packetID msgId:0];
    return true;
}

//todo 判断基本头信息
-(void)recvLoginRS:(QBTransParam *) trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = syspack::VerifyT_LOGIN_RSBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"登陆回包错误需特殊处理");
        return;
    }
    DBLog(@"[%@ RecvLoginRS] recv", CLASS_NAME);
    syspack::T_LOGIN_RS *t_login_rs = (syspack::T_LOGIN_RS*)syspack::GetT_LOGIN_RS(trans_param.buffer.bytes);
    if(!t_login_rs)
    {
        [[NetCenter sharedInstance]DisConnect];
        return;
    }
    //检查头
    if(![super checkHead:t_login_rs->s_rs_head()])
    {
        [[NetCenter sharedInstance]DisConnect];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_SDK_UCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_LOGINED)];
    //todo 删除pack_session_id
    int pack_id = t_login_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    [NIMBaseUtil SetServerTime: t_login_rs->server_time()];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_LOGINED object:nil];
    [[NetCenter sharedInstance] SetNetStatus:LOGINED];
    [[NIMOperationBox sharedInstance] makeTaskHelper];
    [[NIMOperationBox sharedInstance] makeSubscribeHelper];
    //登陆获取离线消息是否完成
    setObjectToUserDefault(KEY_Single_Offline, @(NO));
    setObjectToUserDefault(KEY_Group_Offline, @(NO));

    //判断本地没有该用户的好友token 初始化为0
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]]){
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]];
    }
    
    //登录成功获取用户信息
    [[NIMUserOperationBox sharedInstance] sendGetSelfInfoRQ:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isNotFirst = [userDefaults boolForKey:[NSString stringWithFormat:@"%lld_first",OWNERID]];
    if (isNotFirst) {
        //获取群ID列表信息
        [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupidListRQWithIndex:0];
    }else{
        //获取群列表信息
        [[NIMGlobalProcessor sharedInstance].nim_groupProcessor sendGroupListRQWithindex:0];
    }
    //获取好友列表
    NSLog(@"%lld使用_token:%d",OWNERID,[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]] intValue]);
    [[NIMGlobalProcessor sharedInstance].NIMFriendProcessor sendFriendListRQ:OWNERID withToken:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IM_FDListToken_%lld",OWNERID]] integerValue]];
    //注册推送通知
    [SSIMPushHelper registerRemoteNotification:nil];
    [[NIMMomentsManager sharedInstance] settingQueryRQ:OWNERID];
    
//    NSArray *arr = [NOffcialEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"fansid == %lld",OWNERID]];
//    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:5];
//    for (NOffcialEntity *offcialEntity in arr) {
//        [ids addObject:@(offcialEntity.offcialid)];
//    }
//    [ids addObject:@1000];
//    dispatch_async(self.offline_queue_t, ^{
//        
//        [[NIMGroupOperationBox sharedInstance] fetchOffcialOffline:ids];
////        [[NIMGroupOperationBox sharedInstance] fetchSysOffline];
//
//    });

}

-(bool)sendHeartRQ
{
    [[NetCenter sharedInstance] SendPack:NEW_DEF_HEART_RQ buffer:nil buf_len:0];
    return true;
}

-(void)recvHeartRS: (QBTransParam *) trans_param
{
    DBLog(@"[%@ RecvHeartRS] recv", CLASS_NAME);
}

-(void)recvKickPack:(QBTransParam *)trans_param
{
    T_SERVER_DISCON_ID * t_user_rs = (syspack::T_SERVER_DISCON_ID*)GetT_SERVER_DISCON_ID(trans_param.buffer.bytes);
    
    QBNCParam *ns_nc_param = [[QBNCParam alloc] init];
    ns_nc_param.p_uint64 = t_user_rs->result();
    
    NSString *errDetail = [[NIMErrorManager sharedInstance] getErrorDetail:t_user_rs->result()];
    ns_nc_param.p_string = errDetail;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_NET_ERROR object:ns_nc_param];
    [[NetCenter sharedInstance] SetNetStatus:BEKICKED];
    if (t_user_rs->result() == RET_SYS_PACK_TYPE_INVALID) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_NET_BEKICK object:ns_nc_param];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_BEKICKED)];
}


-(void)getServerTime
{
    flatbuffers::FlatBufferBuilder fbbuilder;
    //todo 这里需要获取pack_session_id
    int packetID = [NIMBaseUtil getPacketSessionID];
    
    int64 ownT;
    
    if (OWNERID) {
        ownT = OWNERID;
    }else{
        ownT = 1;
    }
    commonpack::S_RQ_HEAD s_rq_head(ownT, packetID,PLATFORM_APP);
    T_TIME_SYNC_RQBuilder time_sync = T_TIME_SYNC_RQBuilder(fbbuilder);
    time_sync.add_s_rq_head(&s_rq_head);
    
    fbbuilder.Finish(time_sync.Finish());
    BYTE*	buf = fbbuilder.GetBufferPointer();
    WORD	len = (WORD)fbbuilder.GetSize();
    
    [[NetCenter sharedInstance] SendPack:NEW_DEF_TIME_SYNC_RQ buffer:buf buf_len:len];
    [[NIMCallBackManager  sharedInstance] addPacket:NEW_DEF_TIME_SYNC_RQ buffer:buf buf_len:len packID:packetID msgId:0];
}


-(void)recvServerTime:(QBTransParam *)trans_param
{
    flatbuffers::Verifier verifier((uint8_t *)trans_param.buffer.bytes,trans_param.buffer.length);
    bool is_fbs = syspack::VerifyT_TIME_SYNC_RSBuffer(verifier);
    if (!is_fbs) {
        DBLog(@"登陆回包错误需特殊处理");
        return;
    }
    syspack::T_TIME_SYNC_RS *time_rs = (syspack::T_TIME_SYNC_RS*)syspack::GetT_TIME_SYNC_RS(trans_param.buffer.bytes);
    if(!time_rs)
    {
        return;
    }
    //检查头
    if(![super checkHead:time_rs->s_rs_head()])
    {
        return;
    }
    //todo 删除pack_session_id
    int pack_id = time_rs->s_rs_head()->pack_session_id();
    [[NIMCallBackManager  sharedInstance] removePackByPackID:pack_id];
    DBLog(@"获取的服务器时间：%lld",time_rs->server_time());
    [NIMBaseUtil SetServerTime: time_rs->server_time()];
    
}

-(NETWORK_TYPE)getNetwork
{
    // 状态栏是由当前app控制的，首先获取当前app
//    UIApplication *app = [UIApplication sharedApplication];
//
//    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//
//    NETWORK_TYPE type = NETWORK_TYPE_NONE;
//    for (id child in children) {
//        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
//            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
//        }
//    }
    return 0;
}

-(dispatch_queue_t)offline_queue_t{
    if (_offline_queue_t == nil) {
        _offline_queue_t = dispatch_queue_create("com.QianbaoOfflineQueue", DISPATCH_QUEUE_SERIAL);
        //        _coredata_queue_t = dispatch_get_main_queue();
    }
    return _offline_queue_t;
}
@end
