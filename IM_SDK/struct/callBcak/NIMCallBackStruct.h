//
//  CallBackStruct.h
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "nimplatform.h"

@interface NIMCallBackStruct : NSObject
@property(nonatomic,assign)NSTimeInterval time;
@property(nonatomic,assign)int resend_time;
@property(nonatomic,assign)WORD pack_id;
@property(nonatomic,assign)WORD pack_type;
@property(nonatomic,strong)NSData *data;
@property(nonatomic,copy)NSString *msgId;

@end
