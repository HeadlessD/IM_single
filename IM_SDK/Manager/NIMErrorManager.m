#import "NIMErrorManager.h"

@implementation NIMErrorManager
SingletonImplementation(NIMErrorManager)

- (id)init
{
    self = [super init];
    err_msg_dic = [[NSMutableDictionary alloc]initWithCapacity: 65535];
    [self initErrorDetail];
    return self;
}

- (void)dealloc
{
}

-(NSString*) getErrorDetail:(uint64_t) error_code
{
    NSString* err_detail = [err_msg_dic objectForKey:[NSNumber numberWithUnsignedLongLong:error_code]];
    if(err_detail == NULL)
    {
        err_detail = [NSString stringWithFormat:@"%@%lld",@"未知的错误信息:", error_code];
    }
    return err_detail;
}

-(void) setErrorDetail:(unsigned int) error_code detail:(NSString *)detail
{
    [err_msg_dic setObject:detail forKey:[NSNumber numberWithUnsignedInt:error_code]];
}

-(void) initErrorDetail
{
//////////////////////////////////////sys start//////////////////////////////////////
    [self setErrorDetail:RET_SYS_DISCON_USER_KICKED detail:@"此账号在另一处登录了"];
    [self setErrorDetail:RET_UNPACK_FAILED_RESULT detail:@"服务器解包失败"];
    [self setErrorDetail:RET_PLATFORM_ERROR detail:@"错误的登录平台"];
    [self setErrorDetail:RET_REQ_FAST_ERROR detail:@"请求过于频繁"];
    [self setErrorDetail:RET_REQ_REDIS_ERROR detail:@"redis操作失败"];
    [self setErrorDetail:RET_SYS_PACK_TYPE_INVALID detail:@"服务异常，请稍后再试"];
    [self setErrorDetail:RET_SYS_REPEAT_LOGINED detail:@"此账号已登录"];
    [self setErrorDetail:RET_REG_FAILED detail:@"注册失败"];
    [self setErrorDetail:RET_INVALID_VERITY_CODE detail:@"无效的验证码"];
    [self setErrorDetail:RET_VERIFY_CODE_FREQUENCY detail:@"验证码获取太频繁"];
//////////////////////////////////////sys end///////////////////////////////////////

//////////////////////////////////////user start//////////////////////////////////////
    [self setErrorDetail:RET_USERINFO_BASE detail:@"用户不存在"];
    [self setErrorDetail:RET_ADDUSER_BASE detail:@"用户已存在"];
    [self setErrorDetail:RET_UPDATEUSERINFO_BASE detail:@"用户属性不存在"];
    [self setErrorDetail:RET_GETUSERINFO_BASE detail:@"用户信息已是最新"];
    [self setErrorDetail:RET_NOATTRIBUTE_BASE detail:@"上传用户信息属性不全(user_name和mobile为必填项)"];
    [self setErrorDetail:RET_USERNAME_BASE detail:@"user_name已存在"];
    [self setErrorDetail:RET_MOBILE_BASE detail:@"mobile已存在"];
    [self setErrorDetail:RET_MAIL_BASE detail:@"mail已存在"];
    [self setErrorDetail:RET_COMPLAINTTYPE_BASE detail:@"举报类型错误"];
    [self setErrorDetail:RET_NEW_MOBILE_BASE detail:@"新手机号码不能与旧手机号码相同"];
    [self setErrorDetail:RET_CHECK_MOBILE_BASE detail:@"mobile验证失败"];
    [self setErrorDetail:RET_NEW_MAIL_BASE detail:@"新邮箱不能与旧邮箱相同"];
    [self setErrorDetail:RET_CHECK_MAIL_BASE detail:@"旧邮箱验证失败"];
//////////////////////////////////////user end///////////////////////////////////////

//////////////////////////////////////chat start//////////////////////////////////////
    [self setErrorDetail:RET_CHAT_UPLOAD_METHOD detail:@"上传方式不正确"];
    [self setErrorDetail:RET_CHAT_UPLOAD_TYPE detail:@"上传格式不正确"];
    [self setErrorDetail:RET_CHAT_UPLOAD_RESULT detail:@"上传失败"];
    [self setErrorDetail:RET_CHAT_SINGLE_STATUS_OP_USER_ID_INVALID detail:@"对端用户id错误"];
    [self setErrorDetail:RET_CHAT_MSG_CONTENT_MAX detail:@"消息内容过长"];
//////////////////////////////////////chat end///////////////////////////////////////

//////////////////////////////////////friend start//////////////////////////////////////
    [self setErrorDetail:RET_FRIEND_ALREADY_EXISTED detail:@"好友已存在"];
    [self setErrorDetail:RET_FRIEND_LIST_ERROR detail:@"查询好友列表失败"];
    [self setErrorDetail:RET_FRIEND_ADD_ERROR detail:@"添加好友失败"];
    [self setErrorDetail:RET_FRIEND_DEL_ERROR detail:@"删除好友失败"];
    [self setErrorDetail:RET_FRIEND_MODIFY_ERROR detail:@"修改好友信息失败"];
    [self setErrorDetail:RET_FRIEND_CONFIRM_TIMEOUT_ERROR detail:@"好友确认请求超时"];
    [self setErrorDetail:RET_FRIEND_AGREE_ERROR detail:@"好友同意失败"];
    [self setErrorDetail:RET_FRIEND_REFUSE_ERROR detail:@"好友拒绝失败"];
    [self setErrorDetail:RET_FRIEND_BLACK_LIST_ERROR detail:@"黑名单设置失败"];
    [self setErrorDetail:RET_FRIEND_HAS_BLACK_ERROR detail:@"添加好友失败，是对方的黑名单用户"];
    [self setErrorDetail:RET_FRIEND_SETTING_STATUS_ERROR detail:@"设置状态失败"];
    [self setErrorDetail:RET_FRIEND_HAVE_BLACK_ERROR detail:@"已经在黑名单里"];
    [self setErrorDetail:RET_FRIEND_BE_DELETE_ERROR detail:@"被删除好友，恢复好友关系"];
    [self setErrorDetail:RET_FRIEND_RELATION_ERROR detail:@"等待好友处理"];
    [self setErrorDetail:RET_FRIEND_MAXCNT_ERROR detail:@"你已达到好友上限"];
    [self setErrorDetail:RET_FRIEND_PEERMAXCNT_ERROR detail:@"对方好友达到上限"];
    [self setErrorDetail:RET_FRIEND_REMARK_ERROR detail:@"好友备注名过长"];
//////////////////////////////////////friend end///////////////////////////////////////

//////////////////////////////////////group start//////////////////////////////////////
    [self setErrorDetail:RET_CREATE_USER_LIST_EMPTY detail:@"建群用户列表为空"];
    [self setErrorDetail:RET_OPERATE_TYPE_ERROR detail:@"用户操作无效"];
    [self setErrorDetail:RET_GROUP_ID_INVALID detail:@"群组不存在"];
    [self setErrorDetail:RET_GROUP_OPREATE_USER_ID_INVALID detail:@"用户不是群主"];
    [self setErrorDetail:RET_GROUP_USER_NOT_JOIN detail:@"用户未加入群"];
    [self setErrorDetail:RET_GROUP_USER_HAS_JOIN detail:@"用户已经加入该群"];
    [self setErrorDetail:RET_GROUP_OPERATE_INFO_ERROR detail:@"踢人或者邀请用户信息错误"];
    [self setErrorDetail:RET_GROUP_CREATE_MAX_COUNT detail:@"建群超过默认最大数"];
    [self setErrorDetail:RET_GROUP_INVITE_FAILED detail:@"添加用户失败"];
    [self setErrorDetail:RET_GROUP_KICK_FAILED detail:@"踢人失败"];
    [self setErrorDetail:RET_GROUP_LEADER_CHANGE_SELF detail:@"已经是群主"];
    [self setErrorDetail:RET_GROUP_LEADER_NAME_IS_NIL detail:@"被转让用户参数有误"];
    [self setErrorDetail:RET_GROUP_AGREE_DEFAULT detail:@"群当前为默认加入"];
    [self setErrorDetail:RET_GROUP_AGREE_USER detail:@"群当前为需要群主同意"];
    [self setErrorDetail:DEF_GROUP_AGREE_OLD_MESSAGE_ID_INVALID detail:@"群主同意失败"];
    [self setErrorDetail:RET_GROUP_ADD_ERROR detail:@"添加群组失败"];
    [self setErrorDetail:RET_GROUP_ADD_EXSIST detail:@"当前群组已经存在"];
    [self setErrorDetail:RET_GROUP_MEMBER_LIST_ERROR detail:@"获取群成员列表失败"];
    [self setErrorDetail:RET_GROUP_MEMBER_CHANGE_ERROR detail:@"群主转让失败"];
    [self setErrorDetail:RET_GROUP_ADD_MESSAGE_ERROR detail:@"群消息保存失败"];
    [self setErrorDetail:RET_GROUP_MAX_LIMIT_ERROR detail:@"群人数已上限"];
    [self setErrorDetail:RET_GROUP_SINGLE_LIMIT_ERROR detail:@"单次拉人上限"];
    [self setErrorDetail:RET_GROUP_MODIFY_REMARK_ERROR detail:@"修改群公告失败"];
    [self setErrorDetail:RET_GROUP_MESSAGE_ID_INVALID detail:@"群聊消息id无效"];
    [self setErrorDetail:RET_GROUP_BATCH_GET_LIST_EMPTY detail:@"批量获取群信息列表为空"];
    [self setErrorDetail:RET_GROUP_BATCH_LIST_INVALID detail:@"批量获取群信息列表过大"];
    [self setErrorDetail:RET_GROUP_OFFLINE_MAX_COUNT detail:@"批量获取群离线超过上限"];
    [self setErrorDetail:RET_GROUP_MODIFY_NAME_ERROR detail:@"修改群名称失败名称过长"];
    [self setErrorDetail:RET_GROUP_MODIFY_NICK_NAME_ERROR detail:@"修改群成员昵称失败昵称过长"];
    [self setErrorDetail:RET_GROUP_REPEATED_PACK detail:@"收到重发群信息包"];
//////////////////////////////////////group end///////////////////////////////////////

//////////////////////////////////////offcial start//////////////////////////////////////
    [self setErrorDetail:RET_OFFCIALMSG_BASE detail:@"公众号消息发送过于频繁"];
    [self setErrorDetail:RET_OFFCIALNAME_BASE detail:@"公众号用户名不能为空"];
    [self setErrorDetail:RET_OFFCIALMSG_CONTENT_BASE detail:@"公众号消息结构不全"];
//////////////////////////////////////offcial end///////////////////////////////////////

//////////////////////////////////////business start//////////////////////////////////////
    [self setErrorDetail:RET_MOMENTS_ARTICLE_SAVED_ERROR detail:@"朋友圈保存异常，请稍后再试!"];
    [self setErrorDetail:RET_MOMENTS_ARTICLE_DELETED_ERROR detail:@"朋友圈删除异常，请稍后再试!"];
    [self setErrorDetail:RET_MOMENTS_ARTICLE_QUERY_ERROR detail:@"没有找到信息，请稍后再试!"];
    [self setErrorDetail:RET_MOMENTS_COMMENT_SAVE_ERROR detail:@"评论保存异常，请稍后再试!"];
    [self setErrorDetail:RET_MOMENTS_COMMENT_DELETED_ERROR detail:@"评论删除异常，请稍候再试!"];
    [self setErrorDetail:RET_MOMENTS_SETTING_SAVE_ERROR detail:@"朋友圈设置保存异常，请稍候再试!"];
    [self setErrorDetail:RET_MOMENTS_SETTING_LIST_SAVE_ERROR detail:@"朋友圈黑名单,不关注名单设置保存异常，请稍候再试!"];
    [self setErrorDetail:RET_MOMENTS_SETTING_QUERY_ERROR detail:@"朋友圈配置查询异常，请稍候再试!"];
    [self setErrorDetail:RET_MOMENTS_PARAM_ERROR detail:@"操作参数错误！"];
//////////////////////////////////////business end///////////////////////////////////////

}

@end
