#import "NetMsgMgr.h"

@implementation NetMsgMgr

static NSString * const CLASS_NAME = @"NetMsgMgr";


- (id)init
{
    self = [super init];
    net_msg_dic = [[NSMutableDictionary alloc]initWithCapacity: 65535 / 2];
    return self;
}

- (void)dealloc
{
    
}

-(bool) AttachNetMsg:(WORD) packet_id class_name:(id) class_name func_name:(SEL) func_name
{
    QBFuncParam *func_param = [net_msg_dic objectForKey: [NSNumber numberWithUnsignedShort:packet_id]];
    if(func_param)
    {
        NSLog(@"[%@ AttachNetMsg] package_id = %d exist", CLASS_NAME, packet_id);
        return false;
    }
    
    func_param = [[QBFuncParam alloc] init];
    func_param.packet_id = packet_id;
    func_param.class_name = class_name;
    func_param.func_name = func_name;
    [net_msg_dic setObject:func_param forKey:[NSNumber numberWithUnsignedShort:packet_id]];
    return true;
}

-(int) ProcessNetMsg: (QBTransParam*) trans_param
{
    QBFuncParam *func_param = [net_msg_dic objectForKey: [NSNumber numberWithUnsignedShort:trans_param.packet_id]];
    if(!func_param)
    {
        NSLog(@"[%@ ProcessNetMsg] package_id = %d not found", CLASS_NAME, trans_param.packet_id);
        return -1;
    }
    
    [func_param.class_name performSelector:func_param.func_name withObject: trans_param afterDelay:0.0];
    return 1;
}

@end
