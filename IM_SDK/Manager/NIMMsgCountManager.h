//
//  NIMMsgCountManager.h
//  SSIMSDK
//
//  Created by shiyunjie on 2017/12/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIMMsgCountManager : NSObject
{
@private
    NSMutableDictionary *sc_count_dic;
    NSMutableDictionary *gc_count_dic;
    NSMutableDictionary *oc_count_dic;
    NSMutableDictionary *bc_count_dic;
    NSMutableDictionary *ec_count_dic;
}

SingletonInterface(NIMMsgCountManager)

-(void)Load;
-(void)Clear:(BOOL)clear_db;
-(int)UpsertUnreadCount:(int64_t) sesson_id chat_type:(int) chat_type unread_count:(int) unread_count;
-(void)RemoveUnreadCount:(int64_t) session_id chat_type:(int) chat_type;
-(int)GetUnreadCount:(int64_t) session_id chat_type:(int) chat_type;
-(int)SumSCCount;
-(int)SumGCCount;
-(int)SumOCCount;
-(int)GetAllUnreadCount;
-(int)GetShowUnreadCount;
@end
