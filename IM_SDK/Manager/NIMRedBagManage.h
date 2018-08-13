//
//  NIMRedBagManage.h
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMRedBagManage : NSObject
SingletonInterface(NIMRedBagManage)


-(void)sendRedBagWithChat:(ChatEntity *)chatEntity;

-(void)saveWordRedBagWith:(SSIMRedbagModel*)redBagModel chatType:(E_MSG_CHAT_TYPE)chatType msgBdID:(NSString *)msgBdID;


@end
