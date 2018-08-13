#import <Foundation/Foundation.h>
#import "nimplatform.h"

@interface QBTransParam : NSObject
@property(nonatomic, assign) WORD packet_id;
@property(nonatomic, assign) int socket;
@property(nonatomic, strong) NSData *buffer;
@property(nonatomic, assign) WORD buf_len;
@property(nonatomic, assign) uint err_type;
@property(nonatomic, assign) SESSIONID session_id;
@end

@interface QBFuncParam : NSObject
@property(nonatomic, assign) WORD packet_id;
@property(nonatomic, assign) id class_name;
@property(nonatomic, assign) SEL func_name;
@end

@interface QBNCParam : NSObject
@property(nonatomic, assign) uint64_t p_uint64;
@property(nonatomic, assign) int64_t p_int64;
@property(nonatomic, copy) NSString *p_string;
@property(nonatomic, copy) NSString *searchId;
@end
