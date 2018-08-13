#import <Foundation/Foundation.h>
#import "SSIMModel.h"
#import "NIMSingelton.h"
@interface NIMSysManager: NSObject
{
@private
    SSIMLogin *_qb_login;
}
@property(nonatomic,assign)BOOL isQbaoLoginSuccess;
//网络连接状态
@property(nonatomic,strong)NSString *currentMbd; //当前会话框不需要消息提醒
@property(nonatomic,assign)NSInteger msgCount; //当前会话框外消息数
@property(nonatomic,assign)BOOL isInAssistant; //是否进入群助手
@property(nonatomic,assign)BOOL isInBuiness; //是否进入店铺列表
@property(nonatomic,strong)NSMutableDictionary *typeDict; //群类型
@property(nonatomic,strong)NSMutableDictionary *relationDict; //是否保存到通讯录
@property(nonatomic,strong)NSMutableDictionary *recvDict; //群操作
@property(nonatomic,strong)NSMutableDictionary *sidDict; //群操作
@property(nonatomic,strong)NSMutableArray      *gidsArr; //批量群信息
@property(nonatomic,strong)NSMutableArray      *offlinesArr; //分批群离线
@property(nonatomic,strong)NSMutableDictionary *remarkDict; //只获取一次群公告
@property(nonatomic,strong)NSMutableDictionary *progressDict; //每条图片消息对应进度
@property(nonatomic,strong)NSMutableDictionary *groupShowDict; //群主展示名称


SingletonInterface(NIMSysManager);

-(void) SetLoginInfo:(SSIMLogin *) qb_login;
-(SSIMLogin *)GetLoginInfo;
-(void)getServerTime;
- (void)removeAll;
- (void)clearChat;
- (void)clearLoginInfo;
//TCP连接状态
-(E_NET_STATUS)GetNetStatus;


-(void)sendSMSVaildRQ:(int64_t)mobile;
-(void)recvSMSVaildRS;

-(void)sendSMSloginRQ:(int64_t)mobile userToken:(NSString *)userToken type:(int64_t)type;
-(void)recvSMSloginRSwithUserid:(int64_t)userid userToken:(NSString *)userToken;

-(void)sendTCPlogin:(SSIMLogin *)login_info;

@end
