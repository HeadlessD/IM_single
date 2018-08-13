#import <Foundation/Foundation.h>
#import "IProcessor.h"
#import "common_generated.h"

@interface NIMBaseProcessor : NSObject<IProcessor>
//tick处理时间函数
-(void) processEvent;
//检查头信息
-(bool) checkHead:(const commonpack::S_RS_HEAD *) s_rs_head;
@end
