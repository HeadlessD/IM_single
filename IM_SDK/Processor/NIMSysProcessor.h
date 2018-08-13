#import <Foundation/Foundation.h>
#import "NetCenter.h"
#import "NIMBaseProcessor.h"

@interface NIMSysProcessor : NIMBaseProcessor
{
@private
}


//发送验证码
-(void)sendSMSVaildRQ:(int64_t)mobile;

//手机账号登陆
-(void)sendSMSloginRQ:(int64_t)mobile userToken:(NSString *)userToken type:(int64_t)type;

//tick处理时间函数
-(void) processEvent;

//登录包
-(bool)sendLoginRQ:(SSIMLogin *) login_info;

//心跳包
-(bool)sendHeartRQ;

//获取服务器时间
-(void)getServerTime;



@end
