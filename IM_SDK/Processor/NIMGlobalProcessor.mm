#import "NIMGlobalProcessor.h"
#import "NIMSysManager.h"
#import "NIMCallBackManager.h"

@interface NIMGlobalProcessor ()
//定时器(主线程)
-(void)startTimer;
-(void)stopTimer;
-(void)startEventTimer;
-(void)prcessEvent;
//检查网络状态
-(bool)checkNetStatus;
@end

@implementation NIMGlobalProcessor
static NSString * const CLASS_NAME = @"NIMGlobalProcessor";

SingletonImplementation(NIMGlobalProcessor)
- (id)init
{
    self = [super init];
    //初始化定时器
    [self startTimer];
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    self.sys_processor = nil;
    self.user_processor = nil;
    self.msg_processor  = nil;
    self.offline_msg_processor = nil;
    self.nim_groupProcessor = nil;
    self.NIMFriendProcessor = nil;
    self.momentsProcessor = nil;
}

-(void)InitProcessor
{
    self.sys_processor  = [[NIMSysProcessor alloc] init];
    self.user_processor = [[NIMUserProcessor alloc] init];
    self.msg_processor  = [[NIMMessageProcessor alloc] init];
    self.offline_msg_processor = [[NIMOfflineMessageProcessor alloc] init];
    self.nim_groupProcessor = [[NIMGroupProcessor alloc] init];
    self.NIMFriendProcessor = [[NIMFriendProcessor alloc]init];
    self.businessProcessor = [[NIMBusinessProcessor alloc] init];
    self.momentsProcessor = [[NIMMomentsProcessor alloc] init];
}

-(void)startTimer
{
    if (!event_timer)
    {
        [self performSelectorOnMainThread:@selector(startEventTimer) withObject:nil waitUntilDone:NO];
    }
}

-(void)stopTimer
{
    if (event_timer)
    {
        [event_timer invalidate];
        //        [event_timer release];
        event_timer = nil;
    }
}

-(void)startEventTimer
{
    if (!event_timer)
    {
        NSTimeInterval ti = 1;
        event_timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(prcessEvent) userInfo:nil repeats:YES];
    }
}

-(void)prcessEvent
{
    if([self checkNetStatus])
    {
        [self.sys_processor processEvent];
    }
    [[NIMCallBackManager  sharedInstance] checkCallBack];
    [[NetCenter sharedInstance] PrcessEvent];
}

-(bool)checkNetStatus
{
    bool result = false;
    switch ([[NetCenter sharedInstance] GetNetStatus])
    {
        case CLOSED:
        {
            //这里需要主动去连接
            NSLog(@"[%@ checkNetStatus] CLOSED", CLASS_NAME);
            break;
        }
        case CONNECTING:
        {
            //连接中
            NSLog(@"[%@ checkNetStatus] CONNECTING", CLASS_NAME);

            break;
        }
        case CONNECTED:
        {
            //连接上了需要发登录包
            NSLog(@"[%@ checkNetStatus] CONNECTED", CLASS_NAME);
            SSIMLogin *ns_login = [[NIMSysManager sharedInstance] GetLoginInfo];
            if(ns_login.user_id>0){
                [self.sys_processor sendLoginRQ:ns_login];
                [self.sys_processor getServerTime];
            }
            break;
        }
        case LOGINING:
        {
            //登录中
            NSLog(@"[%@ checkNetStatus] LOGINING", CLASS_NAME);
            break;
        }
        case LOGINED:
        {
            //已登录之后可以做逻辑处理了
            //NSLog(@"[%@ checkNetStatus] LOGINED", CLASS_NAME);
            result = true;
            break;
        }
        case LOGINFAIL:
        {
            //登录失败 该干嘛干嘛吧
            NSLog(@"[%@ checkNetStatus] LOGINFAIL", CLASS_NAME);
            break;
        }
        case DISCONNECT:
        {
            //开始重新连接
            //todo 检查网络，最大连接次数限制，弹框提示，CLOSED
            NSLog(@"[%@ checkNetStatus] DISCONNECT", CLASS_NAME);
            [[NetCenter sharedInstance] CacheConnect];
            break;
        }
        case BEKICKED:
        {
            //被踢了
            NSLog(@"[%@ checkNetStatus] BEKICKED", CLASS_NAME);
            break;
        }
        default:
            break;
    }
    
    return result;
}

@end
