//
//  NIMRedBagManage.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMRedBagManage.h"

@implementation NIMRedBagManage
SingletonImplementation(NIMRedBagManage)



-(void)sendRedBagWithChat:(ChatEntity *)chatEntity
{
    NSLog(@"拆红包了");
    
    NSDictionary * chatDic = [NSDictionary dictionary];
    if (![chatEntity.msgContent isKindOfClass:[NSDictionary class]]) {
        chatDic= [NIMUtility jsonWithJsonString:chatEntity.msgContent];
    }else{
        chatDic = chatEntity.msgContent;
    }
    VcardEntity * vcard = [VcardEntity instancetypeFindUserid:OWNERID];
    
    //是否是口令红包
    //    if ([[chatDic objectForKey:@"type"] isEqualToString:@"WORD"]) {
    //        [self.keyboardView.textView becomeFirstResponder];
    //        self.keyboardView.textView.text = [chatDic objectForKey:@"desc"];
    //
    //    }else{
    NSMutableDictionary * redDic = [NSMutableDictionary dictionaryWithDictionary:chatDic];
    [redDic setValue:[vcard defaultName] forKey:@"user_name"];
    [redDic setValue:@(SDK_PUSH_RedBag) forKey:@"push_type"];
    [redDic setValue:@0 forKey:@"isSend"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:redDic];
    //    }
    
}


-(void)saveWordRedBagWith:(SSIMRedbagModel*)redBagModel chatType:(E_MSG_CHAT_TYPE)chatType msgBdID:(NSString *)msgBdID {
    
    int64_t msg_time = [NIMBaseUtil GetServerTime]/1000;
    NIMRedBagEntity * redEntity = [NIMRedBagEntity NIM_createEntity];
    redEntity.rb_desc = redBagModel.redbag_desc;
    redEntity.rb_type = redBagModel.redbag_type;
    redEntity.rb_messageID = [NSString stringWithFormat:@"%lld",[NIMStringComponents createMessageid:chatType]];
    redEntity.rb_msgBodyId = nil;
    redEntity.rb_isGroup = redBagModel.isGroup;
    redEntity.rb_sendID = [NSString stringWithFormat:@"%@",OWNERID];
    redEntity.rb_wait = [NSString stringWithFormat:@"%@",msg_time];
}



@end
