#import "nimnetstruct.h"
@implementation QBTransParam
- (void)dealloc
{    
    self.buffer = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.packet_id = 0;
        self.socket = 0;
        self.buffer = nil;
        self.buf_len = 0;
        self.err_type = 0;
        self.session_id = 0;
    }
    
    return self;
    
}
@end

@implementation QBFuncParam
- (void)dealloc
{
}

- (id)init
{
    self = [super init];
    return self;
    
}
@end

@implementation QBNCParam
- (void)dealloc
{
}

- (id)init
{
    self = [super init];
    self.p_string = nil;
    return self;
    
}
@end
