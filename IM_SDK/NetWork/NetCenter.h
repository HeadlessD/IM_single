#import <Foundation/Foundation.h>
#import "IProtocolCallBack.h"
#import "ITcpManager.h"
#import "NetMsgMgr.h"
class NetCallBack;
#define MAX_RECON_COUNT 5


@protocol NetCenterDelegate <NSObject>

@required
- (void)imWithConnectStatus:(NSNumber *)iMConnectStatus result:(NIMResultMeta *)result;
@end



@interface NetCenter : NSObject
{
@private
    //tcp层连接接口
    ITcpManager *tcp_manager;
    //网络回调接口
    IProtocolCallBack *net_call_back;
    //回调管理类
    NetMsgMgr *net_msg_mgr;
    
    uint32 start_random;
    
    //后台管理
    bool is_background;
    
    //网络线程
    NSThread *net_thread;
    
    //连接地址
    NSString *last_host;
    unsigned int last_port;
    bool last_domain;
    
    //网络连接状态
    E_NET_STATUS e_net_status;
    //重连次数
    int recon_count;
}

//网络连接类型
@property(nonatomic, assign)NETWORK_TYPE network_type;
//心跳时间
@property(nonatomic, assign)uint64_t last_send_heart_time;

@property(nonatomic, weak)id<NetCenterDelegate> delegate;

//对应C++网络层处理函数
//@begin
-(bool) Connect:(NSString *)host port:(unsigned int) port domain:(bool) domain;
-(bool) CacheConnect;
-(void) DisConnect;
-(void) CheckConnect;
-(int) SendPack: (WORD)packet_id buffer:(BYTE*)buffer buf_len:(WORD)buf_len;
-(int) OnRecvData:(WORD)packet_id socket:(int)socket buffer:(BYTE*)buffer buf_len:(WORD)buf_len;
-(int) OnRecvData_Impl: (QBTransParam*) param;
-(int) OnError:(uint)err_type;
-(int) OnClose:(int)socket client_closed:(bool)client_closed;
-(int) OnConnected:(int)socket;
-(int) OnConnectFailure:(int)socket;
-(void) Process;
-(void) getType;
-(int) ProcessNetMsg: (QBTransParam*) param;
-(void)EncryptBody:(unsigned char*)buf length:(unsigned long)length;
-(void)EncryptCookie:(unsigned char*)cookie length:(unsigned long)length;

//@end

////消息订阅接口
-(bool) AttachNetMsg:(WORD) packet_id class_name:(id) class_name func_name:(NSString *) func_name;

//通过随机数和当前时间创建客户端唯一id
- (uint64)CreateMsgID;

//通知服务端，当前切换前后台状态
- (void)SetBackground:(BOOL)is_back;

//处理器(1s更新一次)
-(void)PrcessEvent;

//e_net_status set get
-(void)SetNetStatus:(E_NET_STATUS) e_status;
-(E_NET_STATUS)GetNetStatus;

SingletonInterface(NetCenter);
- (void)addObserver:(id<NetCenterDelegate>)observer;
@end


//连接C++与OC
class NetCallBack : public IProtocolCallBack
{
public:
    NetCallBack(){}
    ~NetCallBack(){}
    virtual int OnRecvData(WORD packet_id, int socket, BYTE* buffer, WORD buf_len)
    {
        return [[NetCenter sharedInstance] OnRecvData:packet_id socket:socket buffer:buffer buf_len:buf_len];
    }

    virtual int OnError(uint err_type)
    {
        return [[NetCenter sharedInstance] OnError:err_type];
    }
    
    virtual int OnClose(int socket, bool client_closed)
    {
        return [[NetCenter sharedInstance] OnClose:socket client_closed:client_closed];
    }
    
    virtual int  OnConnected(int socket)
    {
        return [[NetCenter sharedInstance] OnConnected:socket];
    }
    
    virtual int OnConnectFailure(int socket)
    {
        return [[NetCenter sharedInstance] OnConnectFailure:socket];
    }
};
