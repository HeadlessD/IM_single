#import <Foundation/Foundation.h>
#import "NIMSysProcessor.h"
#import "NIMUserProcessor.h"
#import "NIMMessageProcessor.h"
#import "NIMOfflineMessageProcessor.h"
#import "NIMGroupProcessor.h"
#import "NIMFriendProcessor.h"
#import "NIMBusinessProcessor.h"
#import "NIMMomentsProcessor.h"
#import "NIMSingelton.h"

@interface NIMGlobalProcessor : NSObject
{
@private
    //事件定时器
    NSTimer *event_timer;
}
//此处添加全局的处理器
@property(nonatomic, strong) NIMSysProcessor *sys_processor;
@property(nonatomic, strong) NIMUserProcessor *user_processor;
@property(nonatomic, strong) NIMMessageProcessor *msg_processor;
@property(nonatomic, strong) NIMOfflineMessageProcessor *offline_msg_processor;
@property(nonatomic, strong) NIMGroupProcessor *nim_groupProcessor;
@property(nonatomic, strong) NIMFriendProcessor *NIMFriendProcessor;
@property(nonatomic, strong) NIMBusinessProcessor *businessProcessor;
@property(nonatomic, strong) NIMMomentsProcessor *momentsProcessor;


-(void)InitProcessor;



SingletonInterface(NIMGlobalProcessor);
@end
