//
//  NIMSearchUserManager.h
//  QBNIMClient
//
//  Created by 豆凯强 on 17/5/24.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMSearchUserManager : NSObject
SingletonInterface(NIMSearchUserManager)




-(void)getSelfInfoSuccessPacket:(int64)userId;

-(void)getSelfInfoFailureSearchCon:(NSString *)searchCon errorStr:(NSString *)errorStr;




-(void)getUserInfoSuccessPacket:(int64)userId type:(int32)type;

-(void)getUserInfoFailureSearchCon:(NSString *)searchCon errorStr:(NSString *)errorStr type:(int32)type;


@end
