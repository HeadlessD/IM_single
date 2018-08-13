#import <Foundation/Foundation.h>

@interface NetMsgMgr : NSObject
{
@private
    NSMutableDictionary *net_msg_dic;
}


-(bool) AttachNetMsg:(WORD) packet_id class_name:(id) class_name func_name:(SEL) func_name;
-(int) ProcessNetMsg:(QBTransParam*) trans_param;

@end
