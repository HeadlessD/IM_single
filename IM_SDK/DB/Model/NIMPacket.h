//
//  NIMPacket.h
//  QianbaoIM
//
//  Created by ssQINYU on 17/1/5.
//  Copyright © 2017年 qianbao.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NIMPacket : NSObject
@property (nonatomic, assign) int64_t user_id;
@property (nonatomic, assign) int pack_id;
@property (nonatomic, assign) int result;

- (NSMutableDictionary *)compositeWithAttributes;
@end


@interface QBUserInfoPacket : NIMPacket
//@property (nonatomic,strong) NSString *user_name;      //请求类型
@property (nonatomic,assign) int age;
@property (nonatomic,assign) int64_t searchUserid;
@property (nonatomic,assign) int is_auth;
@property (nonatomic,assign) NSString *userSex;
@property (nonatomic,strong) NSString *avataStatus;      //请求类型
@property (nonatomic,strong) NSString *avatarPic;      //请求类型
@property (nonatomic,strong) NSString *avatarPic300;      //请求类型
@property (nonatomic,strong) NSString *city;      //请求类型
@property (nonatomic,strong) NSString *mobile;      //请求类型
@property (nonatomic,strong) NSString *nickName;      //请求类型
@property (nonatomic,strong) NSString *province;      //请求类型
@property (nonatomic,strong) NSString *remarkName;      //请求类型
@property (nonatomic,strong) NSString *messageBodyId;      //请求类型
@property (nonatomic,strong) NSString *mail;      //请求类型

@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *locationPro;
@property (nonatomic,strong) NSString *locationCity;
@property (nonatomic,strong) NSString *birthlandPro;
@property (nonatomic,strong) NSString *birthlandCity;
@property (nonatomic,strong) NSString *signature;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *enabled;
@property (nonatomic,strong) NSString *hyipUserId;
@property (nonatomic,strong) NSString *lastLoginTime;
@property (nonatomic,strong) NSString *md5PresenterCode;
@property (nonatomic,strong) NSString *presenterCode;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *verification;

@property (nonatomic,strong) NSString *userToken;


@end

@interface QBLoginPacket : NIMPacket
@property (nonatomic,strong) NSString *ap_ct;
@property (nonatomic,strong) NSString *ap_cookie;
@property (nonatomic,strong) NSString *client_version;
@property (nonatomic,strong) NSString *device_code;
@property (nonatomic,strong) NSString *os_type;
@property (nonatomic,assign) int8_t platform;
@property (nonatomic,assign) int8_t net_type;
@property (nonatomic,assign) uint64_t server_time;
@property (nonatomic,assign) int ap_id;
@end

@interface QBChatPacket : NIMPacket
@property (nonatomic,strong) NSString *send_user_name;
@property (nonatomic,strong) NSString *msg_content;
@property (nonatomic,assign) int64_t msg_time;
@property (nonatomic,assign) int64_t message_id;
@property (nonatomic,assign) short ap_id;
@property (nonatomic,assign) int16_t chat_type;
@property (nonatomic,assign) int32_t session_id;
@property (nonatomic,assign) int m_type;
@property (nonatomic,assign) int s_type;
@property (nonatomic,assign) int ext_type;
@property (nonatomic,assign) BOOL isSender;
@end

@interface QBSingleChatPacket : QBChatPacket
@property (nonatomic,assign) uint64_t op_user_id;
@property (nonatomic,assign) uint64_t b_id;
@property (nonatomic,assign) uint64_t w_id;
@property (nonatomic,assign) uint64_t c_id;
@end

@interface QBGroupChatPacket : QBChatPacket
@property (nonatomic,assign) uint64_t op_user_id;
@property (nonatomic,assign) uint64_t group_id;
@end

@interface QBGroupInfoPacket : NIMPacket
@property (nonatomic,assign) int64_t group_id;
@property (nonatomic,strong) NSString *group_name;
@property (nonatomic,strong) NSString *group_img_url;
@property (nonatomic,strong) NSString *group_remark;
@property (nonatomic,assign) int16_t group_count;
@property (nonatomic,assign) int64_t group_manager_user_id;
@property (nonatomic,assign) int32_t group_max_count;
@property (nonatomic,assign) int32_t group_add_max_count;
@property (nonatomic,assign) int64_t group_ct;
@property (nonatomic,assign) int32_t group_type;
@property (nonatomic,assign) int message_status;
@property (nonatomic,assign) BOOL group_add_is_agree;


@end

@interface QBGroupCreatePacket : QBGroupInfoPacket
@property (nonatomic,strong) NSMutableArray *user_id_list;
@property (nonatomic,assign) int64_t message_id;

@end

@interface QBGroupOperatePacket : NSObject
@property (nonatomic,assign) int64_t msg_time;
@property (nonatomic,strong) NSString *operate_user_name;
@property (nonatomic,strong) NSString *group_modify_content;
@property (nonatomic,strong) NSMutableArray *user_info_list;

@end


@interface QBGroupOfflinePacket : QBGroupInfoPacket
@property (nonatomic,assign) int64_t message_id;
@property (nonatomic,assign) int32_t big_msg_type;
@property (nonatomic,assign) int64_t message_old_id;
@property (nonatomic,strong) QBGroupOperatePacket *groupOperate;
@property (nonatomic,strong) QBChatPacket *chat;

@end



@interface QBGroupListPacket : NIMPacket
@property (nonatomic,strong) NSMutableArray *groupList;
@property (nonatomic,assign) int64_t group_id;

@end

@interface QBGroupModifyPacket : NIMPacket
@property (nonatomic,strong) QBGroupOperatePacket *groupOperate;
@property (nonatomic,strong) QBGroupInfoPacket *groupInfo;
@property (nonatomic,assign) int32_t big_msg_type;

@end

@interface QBFriendInfoPacket :NSObject

@property (nonatomic,assign) int8_t    sourcetype;
@property (nonatomic,assign) int64_t user_id;
@property (nonatomic,copy) NSString *  op_msg;
@property (nonatomic,assign) int64_t  opttype;
@property (nonatomic,assign) int64_t  blacktype;
@property (nonatomic,assign) int64_t  optime;
@property (nonatomic,assign) int32_t  msgsource;
@property (nonatomic,copy) NSString * remark_name;
@property (nonatomic,copy) NSString * nick_name;
@property (nonatomic,copy) NSString *  avatar;
@property (nonatomic,copy) NSString *  fdOPToken;

@end

@interface NIMFriendPacket : NIMPacket
@property (nonatomic,assign) int64_t msgid;
@property (nonatomic,strong) NSString *op_msg;
@property (nonatomic,assign) int8_t  sourcetype;
@property (nonatomic,assign) int8_t blacktype;
@property (nonatomic,assign) int64_t msgsource;
@property (nonatomic,assign) int64_t  opttype;
//@property (nonatomic,assign) BOOL  isFriend;
@property (nonatomic,assign) BOOL  isComeBackFriend;
@property (nonatomic,assign) int64_t peer_user_id;
@property (nonatomic,assign) NSString * addToken;
@property (nonatomic,strong) NSString *peer_nick_name;
@property (nonatomic,strong) NSString *peer_user_name;
@property (nonatomic,strong) NSString *peer_remark_name;
@property (nonatomic,strong) NSMutableArray * friendInfoArr;
@property (nonatomic,assign) int64_t  optime;

//@property (nonatomic,assign) int32_t result;

@end

@interface QBOffcialChatPacket : QBChatPacket
@property (nonatomic,assign) int64_t offcialid;
@property (nonatomic,assign) uint64_t b_id;
@property (nonatomic,assign) uint64_t w_id;
@property (nonatomic,assign) uint64_t c_id;
@end

