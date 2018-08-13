//
//  NIMCallBackManager.h
//  qbim
//
//  Created by ssQINYU on 17/1/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMCallBackManager  : NSObject


SingletonInterface(NIMCallBackManager )
-(void)addPacket:(WORD)packet_type buffer:(BYTE*)buffer buf_len:(WORD)buf_len packID:(WORD)pack_id msgId:(NSString *)msgId;
-(void)removePackByPackID:(WORD)pack_id;

-(void)checkCallBack;

-(void)resetMap;
@end
