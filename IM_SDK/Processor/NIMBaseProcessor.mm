#import "NIMBaseProcessor.h"
#import "NIMCallBackManager.h"
@implementation NIMBaseProcessor
- (id)init
{
    self = [super init];
    return self;
}

- (void)dealloc
{
}

-(void) processEvent
{
    
}

//检查头信息
-(bool) checkHead:(const commonpack::S_RS_HEAD *) s_rs_head;
{
    if(!s_rs_head)
    {
        return false;
    }
    
    if(!s_rs_head->user_id())
    {
        return false;
    }
    
    if(!s_rs_head->pack_session_id())
    {
        return false;
    }
    
    //todo根据不同的错误码返回通知上层显示不同的消息
    if(!CHECK_RESULT(s_rs_head->result()))
    {
        QBNCParam *ns_nc_param = [[QBNCParam alloc] init];
        ns_nc_param.p_uint64 = s_rs_head->result();
        ns_nc_param.p_int64 = s_rs_head->pack_session_id();
        NSString *errDetail = [[NIMErrorManager sharedInstance] getErrorDetail:s_rs_head->result()];
        ns_nc_param.p_string = errDetail;
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_NET_ERROR object:ns_nc_param];
        return false;
    }
    return true;
}

@end
