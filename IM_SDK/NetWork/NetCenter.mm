#import "NetCenter.h"
@interface NetCenter (){
    NetworkStatus _netWorkStatus;
}
@property (nonatomic) Reachability *internetReachability;
//初始化随机数
- (void)initRandom:(uint64_t) value;
//收包线程
-(void)startThread;
-(void)stopThread;
@end


@implementation NetCenter
SingletonImplementation(NetCenter)

static NSString * const CLASS_NAME = @"NetCenter";

- (id)init
{
    self = [super init];
    
    //初始化
    //TCP管理器
    CreateNetTCP("TcpManager", (void **)&tcp_manager);
    //网络回调
    net_call_back = new NetCallBack;
    tcp_manager->InitCallBack(net_call_back);
    //回调管理类
    net_msg_mgr = [[NetMsgMgr alloc] init];
    
    //初始化随机数
    [self initRandom:[NIMBaseUtil GetMsTime]];
    
    //初始化线程
    net_thread = nil;
    [self startThread];
    
    //初始化网络状态
    [self SetNetStatus:CLOSED];
    recon_count = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChanged:) name:NC_NET_CHANGE object:nil];
    _netWorkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self reachability:self.internetReachability];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    return self;
}

- (void)dealloc
{
    [self stopThread];
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self reachability:curReach];
}

- (void)reachability:(Reachability *)reachability
{
    NetworkStatus fromStatus = _netWorkStatus;
    
    NetworkStatus toStatus = [reachability currentReachabilityStatus];
    
    _netWorkStatus = toStatus;
    
    NSLog(@"---------%ld   网络发生变化   %ld--------- ",(long)fromStatus,(long)toStatus);
    if (fromStatus != toStatus) {
        if (toStatus == NotReachable) {
            //            [self SetNetStatus:CLOSED];
            [self DisConnect];
            
            if ([_delegate respondsToSelector:@selector(imWithConnectStatus:result:)]) {
                [_delegate imWithConnectStatus:[NSNumber numberWithInteger:DISCONNECT] result:[NIMResultMeta resultWithCode:QBIMErrorDisconnect error:@"" message:@"未连接"]];
            }
            
        }else{
            [self SetNetStatus:DISCONNECT];
        }
        
    }
    
}

-(void)SetNetStatus:(E_NET_STATUS) e_status
{
    if(e_net_status == e_status)
    {
        if(e_status != DISCONNECT)
        {
            return;
        }
        //超过最大重连次数CLOSED
        if(recon_count++ < MAX_RECON_COUNT)
        {
            return;
        }
        
        e_status = CLOSED;
    }
    
    //如果已经是关闭状态了
//    if(e_status == DISCONNECT && e_net_status == CLOSED)
//    {
//        return;
//    }
    
    //如果已经被踢状态了
    if(e_net_status == BEKICKED &&
       (e_status == CLOSED || e_status == DISCONNECT))
    {
        return;
    }
    
    e_net_status = e_status;
    
    //登陆成功
    if(e_net_status == LOGINED)
    {
        recon_count = 0;
    }
    
    //网络状态改变抛出消息通知上层
    QBNCParam *ns_nc_param = [[QBNCParam alloc] init];
    ns_nc_param.p_uint64 = e_net_status;
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_NET_CHANGE object:ns_nc_param];
}

-(E_NET_STATUS)GetNetStatus
{
    return e_net_status;
}

-(bool) Connect:(NSString *)host port:(unsigned int) port domain:(bool) domain
{
    last_host = host;
    last_port = port;
    last_domain = domain;
    [[NIMCallBackManager sharedInstance] resetMap];
    return [self CacheConnect];
}

-(bool) CacheConnect
{
    if(!last_host || last_port <= 0)
    {
        NSLog(@"[%@ CacheConnect] host port not exist", CLASS_NAME);
        return false;
    }
    if([self GetNetStatus] == CLOSED ||
       [self GetNetStatus] == CLOSING ||
       [self GetNetStatus] == DISCONNECT ||
       [self GetNetStatus] == BEKICKED)
    {
        
    }else{
        [self DisConnect];
    }
    [self SetNetStatus:CONNECTING];
    bool ret = false;
    ret = tcp_manager->Connect([last_host cStringUsingEncoding:NSASCIIStringEncoding],last_port, last_domain);
    NSLog(@"重连Port-%d",last_port);
    return ret;
}

-(void) DisConnect
{
    if([self GetNetStatus] == CLOSED ||
       [self GetNetStatus] == CLOSING)
    {
        return;
    }
    
    tcp_manager->Close();
    [self SetNetStatus:CLOSING];
}

-(void)CheckConnect
{
    if([self GetNetStatus] == CONNECTING ||
       [self GetNetStatus] == CONNECTING ||
       [self GetNetStatus] == LOGINING ||
       [self GetNetStatus] == LOGINED)
    {
        return;
    }
    [self CacheConnect];
}

-(int) SendPack: (WORD)packet_id buffer:(BYTE*)buffer buf_len:(WORD)buf_len
{
    bool ret = false;
    ret = tcp_manager->SendPack(packet_id, (char*)buffer, buf_len);
    
    return ret;
}

-(int) OnRecvData:(WORD)packet_id socket:(int)socket buffer:(BYTE*)buffer buf_len:(WORD)buf_len
{
    QBTransParam *trans_param = [[QBTransParam alloc] init];
    trans_param.packet_id = packet_id;
    trans_param.socket = socket;
//    trans_param.buffer = new BYTE[8192];
//    memcpy(trans_param.buffer, buffer, buf_len);
    trans_param.buf_len = buf_len;
    trans_param.buffer = [NSData dataWithBytes:buffer length:buf_len];
    [self performSelectorOnMainThread:@selector(OnRecvData_Impl:) withObject:trans_param waitUntilDone:NO];
    return 1;
}

-(int) OnRecvData_Impl: (QBTransParam*) param
{
    //每次收到包可以延迟心跳发送时间
    self.last_send_heart_time = [NIMBaseUtil GetMsTime];
    
    return [net_msg_mgr ProcessNetMsg:param];
}

-(int)ProcessNetMsg:(QBTransParam *)param
{
    return [net_msg_mgr ProcessNetMsg:param];
}

-(int) OnError:(uint)err_type
{
     [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_ERROR)];

    NSLog(@"[%@ OnError type = %d]", CLASS_NAME, err_type);
    return 1;
}

-(int) OnClose:(int)socket client_closed:(bool)client_closed
{
    [[NIMCallBackManager sharedInstance] resetMap];
    [[NIMSysManager sharedInstance] removeAll];
    NSLog(@"[%@ OnClose client_closed = %d]", CLASS_NAME, client_closed);
    if(client_closed)
    {
        [self SetNetStatus:CLOSED];
    }
    else
    {
        [self SetNetStatus:DISCONNECT];
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_CLOSED)];

    return 1;
}

-(int)OnConnected:(int)socket
{
    NSLog(@"[%@ OnConnected]", CLASS_NAME);
    [self SetNetStatus:CONNECTED];
    
    [[NIMSysManager sharedInstance] getServerTime];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_CONNECTED)];
    return 1;
}

-(int) OnConnectFailure:(int)socket
{
     [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_NETWORK object:@(SDK_FAILURE)];
    NSLog(@"[%@ OnConnectFailure]", CLASS_NAME);
//    [self SetNetStatus:CLOSED];
    return 1;
}

-(void) Process
{
    while (true)
    {
        if(!tcp_manager)
        {
            //1s
            sleep(1);
            continue;
        }
        
        tcp_manager->Update();
    }
}


-(bool) AttachNetMsg:(WORD) packet_id class_name:(id) class_name func_name:(NSString *) func_name
{
    return [net_msg_mgr AttachNetMsg:packet_id class_name:class_name func_name:NSSelectorFromString(func_name)];
}

- (void)initRandom:(uint64_t) value
{
    uint64_t value_seed = [NIMBaseUtil GetMsTime] + value;
    srand((unsigned int)value_seed);
    int temp_rand = (rand() + value_seed) % 8 + 4;
    for(int i=0; i<temp_rand; i++)
        rand();
    
    start_random = rand();
}

//- (uint64) CreateMsgID
//{
//    uint64 msg_id = 0;
//    @synchronized(self)
//    {
//        uint64_t server_time = [NIMBaseUtil GetServerTime];
//        start_random++;
//        msg_id = (server_time << 22)&0xffffffff00000000LL;
//        msg_id = msg_id + start_random;
//        NSLog(@"[%@ CreateMsgID] msg_id = %qu", CLASS_NAME, msg_id);
//    }
//    return msg_id;
//}
- (uint64) CreateMsgID
{
    uint64 msg_id = 0;
    @synchronized(self)
    {
        uint64_t server_time = [NIMBaseUtil GetServerTime]/1000;
        start_random++;
        start_random = start_random & 0x3FFFFF;
        msg_id = (server_time << 22)&0xFFFFFFFFFFC00000LL;
        msg_id = msg_id + start_random;
        NSLog(@"[%@ CreateMsgID] msg_id = %qu", CLASS_NAME, msg_id);
    }
    return msg_id;
}

- (void)SetBackground:(BOOL)is_back;
{
    is_background = is_back;
    //todo 告诉服务器
}


-(void)PrcessEvent
{
    //todo 处理网络类型
    
    //这里可以增加代理方法
}


-(void)EncryptBody:(unsigned char *)buf length:(unsigned long)length
{
    tcp_manager->EncryptBody(buf, length);
}

-(void)EncryptCookie:(unsigned char *)cookie length:(unsigned long)length
{
    tcp_manager->EncryptCookie(cookie, length);
}



-(void)startThread
{
    //单线程所以没加锁
    if (!net_thread)
    {
        net_thread = [[NSThread alloc] initWithTarget:self selector:@selector(Process) object:nil];
        [net_thread start];
    }
}

-(void)stopThread
{
    if (!net_thread)
    {
        [net_thread cancel];
        net_thread = nil;
    }
}
-(void)getType
{
    NSLog(@"network_type:%lu",(unsigned long)self.network_type);
}


/*******************网络****************/

- (void)addObserver:(id<NetCenterDelegate>)observer
{
    _delegate = observer;
}

- (void)removeObserver:(id<NetCenterDelegate>)observer
{
    _delegate = nil;
}

//网络状态改变通知方法
-(void)networkStatusDidChanged:(NSNotification *)noti
{
    QBNCParam *param = noti.object;
    E_NET_STATUS status = (E_NET_STATUS)param.p_uint64;
    
    if ([_delegate respondsToSelector:@selector(imWithConnectStatus:result:)]) {
        [_delegate imWithConnectStatus:[NSNumber numberWithInteger:status] result:[NIMResultMeta resultWithCode:QBIMErrorDisconnect error:@"" message:param.p_string]];
    }
}

@end
