//
//  SSIMShortcutDefines.h
//  QianbaoIM
//
//  Created by 秦雨 on 17/5/11.
//  Copyright © 2017年 秦雨. All rights reserved.
//
/**
 *  APP使用的快捷宏声明
 */

#ifndef QianbaoIM_SSIMShortcutDefines_h
#define QianbaoIM_SSIMShortcutDefines_h

/************************************业务相关***************************************/
#define INVAILD_TIME    -1


#define _BADGESTR(__num__)  (__num__ > 99) ? (@"99+ ") : [NSString stringWithFormat:@"%d ",__num__]

#define kMAXLENGTH_NICKNAME                                     24

#define kMAX_TIME_OUT               16
#define kMAX_RESEND_TIME            3
#define kWAITER_TIME                10*60


#define USER_SEX_FEMALE         @"F" //女
#define USER_SEX_MALE           @"M" //男

#define REGISTER_ACCOUNT_TYPE_EMALL    @"1"
#define REGISTER_ACCOUNT_TYPE_PHONE    @"2"
#define REGISTER_ACCOUNT_TYPE_USERNAME @"3"

#define QBUDKeySignInfo                         @"QBUDKeySignInfo"
#define QBUDKeyUserInfo                         @"QBUDKeyUserInfo"
#define QBUDKeyPersonInfo                       @"QBUDKeyPersonInfo"
#define QBUDKeyProvinceListInfo                 @"QBUDKeyProvinceListInfo"
#define QBUDKeyTaskViewGuide                    @"QBUDKeyTaskViewGuide"
#define QBUDKeyQueryViewGuide                   @"QBUDKeyQueryViewGuide"
#define QBUDKeyGrantQinabaoMoney                @"QBUDKeyGrantQinabaoMoney"
#define QBUDKeyOldUserLoginInfo                 @"QBUDKeyOldUserLoginInfo"

#define QBUDKeyOldIMUserLoginInfo               @"QBUDKeyOldIMUserLoginInfo"

#define PUSH_DEVICE_TOKEN                       @"PUSH_DEVICE_TOKEN"

#define kRefetchAllDatabaseData @"RefetchAllDatabaseData"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kMidTimeLine    5*60

///获取全局delegate
#define _GET_APP_DELEGATE_(appDelegate)\
AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
#define _IF_CAN_PRESENT(present)\
AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;\
id present =appDelegate.window.rootViewController.presentedViewController;

//判断是否是空字符
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]) || ([(_ref) isEqual:@"<null>"])|| ([(_ref) isEqual:@"(null)"]))

#define _IM_StrFromFloat(F)     [NSString stringWithFormat: @"%f", F]
#define _IM_StrFromInt(I)       [NSString stringWithFormat: @"%d", I]

#define _IM_NumFromBOOL(B)      [NSNumber numberWithBool: B]
#define _IM_NumFromInt(I)       [NSNumber numberWithInt: I]
#define _IM_NumFromDouble(D)    [NSNumber numberWithDouble: D]

#define _IM_FormatStr(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]


#define _LINE_HEIGHT_1_PPI         (1/[UIScreen mainScreen].scale)


#define _UPDATE_BALANCE_(__changedBalance__)\
do\
{\
AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;\
QBWalletInfoModel *walletInfo = appDelegate.userDataInfo.walletInfo;\
if (walletInfo)\
{\
double newbalance = [walletInfo.m_balance doubleValue] + (__changedBalance__);\
walletInfo.m_balance = [NSString stringWithFormat:@"%.0f",newbalance];\
[walletInfo saveToLocal];\
}\
}while(0)\

#define _UPDATE_UNFINISHEDTASK_(__changedTask__)\
do\
{\
AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;\
if (appDelegate.userDataInfo.myInfo)\
{\
float newTask   = [appDelegate.userDataInfo.myInfo.home_unFinishedTaskCount floatValue] + (__changedTask__);\
newTask         = (newTask < 0)?0:newTask;\
appDelegate.userDataInfo.myInfo.home_unFinishedTaskCount = [NSString stringWithFormat:@"%.0f",newTask];\
[[NIMOperationBox sharedInstance] updateTaskHelperWithUnFinishNum:newTask];\
}\
}while(0)\


#define _SET_UNFINISHEDTASK_(__unfinishednum__)\
do\
{\
AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;\
if (appDelegate.userDataInfo.myInfo)\
{\
appDelegate.userDataInfo.myInfo.home_unFinishedTaskCount = [NSString stringWithFormat:@"%d",__unfinishednum__];\
[[NIMOperationBox sharedInstance] updateTaskHelperWithUnFinishNum:__unfinishednum__];\
}\
}while(0)\


#define logEvent(x, y) ([Flurry logEvent:[NSString stringWithFormat:@"%@_%@", x, y] withParameters:nil])
#define AVLogEvent(x, y) [AVAnalytics event:x label:y];
#define omniLog(x, y) logEvent(x, @{x:y}); AVLogEvent(x, y)

/**************************************业务全局通知***************************************/
#define QB_NOTIICATION_MART_TAG_UPDATE          @"QB_NOTIICATION_MART_TAG_UPDATE"
#define QB_NOTIICATION_MART_GOOD_COLLECT        @"QB_NOTIICATION_MART_GOOD_COLLECT"
#define QB_NOTIICATION_TASK_COLLECT             @"QB_NOTIICATION_TASK_COLLECT"

#define kNOTICENEEDAUTH                                         @"needAuth"
//版本更新
#define kNotificationVersionUpdate                              @"kNotificationVersionUpdate"

#define NOTIFICATION_LOGIN_SUCCESS                              @"notification_login_success"

#define NOTIFICATION_RECVTASK_SUCCESS                           @"notification_recvtask_success"

#define NOTIFICATION_BINDPHONE_SUCCESS                          @"notification_bind_success"

#define NOTIFICATION_UPDATE_MYINFO                              @"bitification_update_myinfo"

#define NOTIFICATION_FIRSTLANUCH                                @"first_lanuch"

#define BOUND_PHONE_FINISHED                                @"bindPhoneFinished"
#define BOUND_ACCOUNT_RELOGIN                               @"bindAccountRelogin"

#define NOTIFICATION_DISSMISS_POPVIEW                                         @"notification_dissmiss_popview"
#define NOTIFICATION_DISSMISS_REDPACKET                                         @"notification_dissmiss_redpacket"

#define NOTIFICATION_GET_DOCTORID                               @"notification_get_doctorId"
/**************************************提示***************************************/

#ifndef __FAILDMESSAGE__
#define __FAILDMESSAGE__            @"网络异常"
#endif

#define kERRORMESSAGE_LOGINONANOTHERDEVICE                    @"Login on another device"
#define kERRORMESSAGE_DISCONNECT                              @"服务器断开链接"

/**************************************字体***************************************/
#define FONT_TITLE(X)                   [UIFont systemFontOfSize:X]
#define BOLDFONT_TITLE(X)               [UIFont boldSystemFontOfSize:X]
#define FONT_NUM_LIGHT(__fontSize__)    [UIFont fontWithName:@"Helvetica-Light" size:__fontSize__]
#define FONT_NUM_Arial(__fontSize__)    [UIFont fontWithName:@"Arial Regular" size:__fontSize__]
#define FONT_NUM_Helvetica(__fontSize__)    [UIFont fontWithName:@"Helvetica Regular" size:__fontSize__]



#define STRSIZE(__str__, __fontsize__)\
[__str__ sizeWithAttributes:@{NSFontAttributeName:FONT_TITLE(__fontsize__)}]


/************************************其它作用***************************************/

//创建单例
#define _SINGLETON_FOR_CLASS(classname) \
\
+ (classname*)shareInstance \
{ \
static dispatch_once_t pred = 0; \
__strong static classname* _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = [[self alloc] init]; \
}); \
return _sharedObject;\
}

/************************************UI布局宏***************************************/
//对齐方式
#define ALIGN_LEFT      [SSIMSpUtil getAlign:ALIGNTYPE_LEFT]
#define ALIGN_CENTER    [SSIMSpUtil getAlign:ALIGNTYPE_CENTER]
#define ALIGN_RIGHT     [SSIMSpUtil getAlign:ALIGNTYPE_RIGHT]

#define _CGP(x, y)                                   CGPointMake(x, y)
#define _CGS(w, h)                                   CGSizeMake(w, h)
#define _CGR(x, y, w, h)                             CGRectMake(x, y, w, h)
#define _CGC(__Frame__)                              CGPointMake(CGRectGetMidX(__Frame__),CGRectGetMidY(__Frame__))
#define GetOriginX(UI)              CGRectGetMinX(UI.frame)
#define GetOriginY(UI)              CGRectGetMinY(UI.frame)
#define GetWidth(UI)                CGRectGetWidth(UI.frame)
#define GetHeight(UI)               CGRectGetHeight(UI.frame)
#define OffSetX(UI)                 CGRectGetMaxX(UI.frame)
#define OffSetY(UI)                 CGRectGetMaxY(UI.frame)


/// 声明变量同时初始化为nil
#define _NIL_POINT(__class__,__pname__)\
__class__ *__pname__ = nil;\

//UILabel
#define _CREATE_LABEL(__label__, __frame__, __fontsize__)\
_CREATE_LABEL_ALIGN(__label__, __frame__, ALIGN_LEFT, __fontsize__)

#define _CREATE_LABEL_ALIGN(__label__, __frame__, __align__, __fontsize__)\
{\
__label__ = _ALLOC_OBJ_WITHFRAME_(UILabel, __frame__);\
[__label__ setBackgroundColor:[UIColor clearColor]];\
[__label__ setTextAlignment:__align__];\
[__label__ setFont:FONT_TITLE(__fontsize__)];\
}

#define _CREATE_LABEL_ALIGN_BOLDFONT(__label__, __frame__, __align__, __boldfontsize__)\
{\
__label__ = _ALLOC_OBJ_WITHFRAME_(UILabel, __frame__);\
[__label__ setBackgroundColor:[UIColor clearColor]];\
[__label__ setTextAlignment:__align__];\
[__label__ setFont:BOLDFONT_TITLE(__boldfontsize__)];\
}


#define _CREATE_LABEL_ALIGN_AND_ADDSUBVIEW(__label__, __frame__, __align__, __font__,__superView__)\
{\
__label__ = _ALLOC_OBJ_WITHFRAME_(UILabel, __frame__);\
[__label__ setBackgroundColor:[UIColor clearColor]];\
[__label__ setTextAlignment:__align__];\
[__label__ setFont:__font__];\
[__superView__ addSubview:__label__];\
}

#define _CREATE_LABEL_AND_ADDSUBVIEW(__label__, __frame__, __align__, __font__,__superView__,__text__,__color__)\
{\
__label__ = _ALLOC_OBJ_WITHFRAME_(UILabel, __frame__);\
[__label__ setBackgroundColor:[UIColor clearColor]];\
[__label__ setTextAlignment:__align__];\
[__label__ setFont:__font__];\
[__superView__ addSubview:__label__];\
[__label__ setText:__text__];\
[__label__ setTextColor:[SSIMSpUtil getColor:__color__]];\
}

//UIImageView
#define _CREATE_UIIMAGEVIEW_NANME(__imageview__, __imagename__)\
{\
__imageview__ = [[UIImageView alloc]initWithImage:IMGFROMBUNDLE(__imagename__)];\
}

#define _CREATE_UIIMAGEVIEW_NANME_POINT_AND_ADDSUBVIEW(__imageview__, __imagename__, __superView__,__centerPoint__)\
{\
UIImage *img = IMGFROMBUNDLE(__imagename__);\
CGRect frame = CGRectMake(__centerPoint__.x - img.size.width/2  , __centerPoint__.y -img.size.height/2  , img.size.width , img.size.height);\
_CREATE_UIIMAGEVIEW_NANME_FRAME_AND_ADDSUBVIEW(__imageview__, __imagename__, __superView__, frame)\
}\

#define _CREATE_UIIMAGEVIEW_NANME_FRAME_AND_ADDSUBVIEW(__imageview__, __imagename__, __superView__, __frame__)\
{\
UIImage *img = IMGFROMBUNDLE(__imagename__);\
__imageview__ = [[UIImageView alloc]initWithImage:img];\
[__superView__ addSubview:__imageview__];\
[__imageview__ setFrame:__frame__];\
}\

#define _CREATE_UIIMAGEVIEW_URLNANME_FRAME_AND_ADDSUBVIEW(__imageview__, __imgurl__, __superView__, __frame__, __placeholdername__)\
{\
__imageview__ = [[UIImageView alloc]initWithFrame:__frame__];\
[__imageview__ setImageWithURLString:__imgurl__ placeholderImage:IMGFROMBUNDLE(__placeholdername__)];\
[__imageview__ setBackgroundColor:[UIColor whiteColor]];\
[__superView__ addSubview:__imageview__];\
}\

#define _CREATE_UIIMAGEVIEW(__imageview__, __frame__, __imagename__)\
{\
_CREATE_UIIMAGEVIEW_IMAGE(__imageview__, __frame__, IMGFROMBUNDLE(__imagename__));\
}

#define _CREATE_UIIMAGEVIEW_IMAGE(__imageview__, __frame__, __image__)\
{\
__imageview__       = _ALLOC_OBJ_WITHFRAME_(UIImageView, __frame__);\
__imageview__.image = __image__;\
}

//UIView
#define _CREATE_VIEW(__view__, __frame__, __bgcolor__)\
{\
__view__ = _ALLOC_OBJ_WITHFRAME_(UIView, __frame__);\
[__view__ setBackgroundColor:__bgcolor__];\
}

//UIButton
#define _CREATE_ALLOC_BUTTON(__btn__, __frame__, __selector__)\
{\
__btn__       = _ALLOC_OBJ_WITHFRAME_(UIButton, __frame__);\
[__btn__ addTarget:self action:__selector__ forControlEvents:UIControlEventTouchUpInside];\
}

#define _CREATE_BUTTON(__btn__, __frame__, __title__, __titlefontsize__, __selector__)\
{\
__btn__       = [UIButton buttonWithType:UIButtonTypeCustom];\
__btn__.frame = __frame__;\
[__btn__ addTarget:self action:__selector__ forControlEvents:UIControlEventTouchUpInside];\
[__btn__ setTitle:__title__ forState:UIControlStateNormal];\
[__btn__.titleLabel setFont:FONT_TITLE(__titlefontsize__)];\
}

//UIScrollView
#define _CREATE_SCROLLVIEW(__scrollview__, __frame__)\
{\
__scrollview__ = _ALLOC_OBJ_WITHFRAME_(UIScrollView, __frame__);\
[__scrollview__ setBackgroundColor:[UIColor clearColor]];\
[__scrollview__ setShowsHorizontalScrollIndicator:NO];\
[__scrollview__ setShowsVerticalScrollIndicator:NO];\
}

//tableView
#define _CREATE_TABLEVIEW(__table__, __frame__, __tabletype__)\
{\
__table__ = [[UITableView alloc]initWithFrame:__frame__ style:__tabletype__];\
__table__.delegate         = self;\
__table__.dataSource       = self;\
[__table__ setBackgroundColor:[UIColor clearColor]];\
}

#define _IM_SET_TABLE_DATASOURCE_AND_DELEGATE(__table__,__self__)\
{\
__table__.dataSource = __self__;\
__table__.delegate   = __self__;\
}\

#define _IM_AUTORELEASE_COMMON_TABLEVIEW_CELL(__cell__ ,__cell_class__,__identifier__)\
__cell_class__  *__cell__ = (__cell_class__ *)[tableView dequeueReusableCellWithIdentifier:__identifier__];\
if(!__cell__)\
{\
__cell__ = _IM_AUTORELEASE([[__cell_class__ alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:__identifier__]);\
}


#define _IM_CLEAR_TABLE_FOOTERVIEW(__table__)\
[__table__ setTableFooterView:_IM_AUTORELEASE([[UIView alloc] initWithFrame:CGRectZero])];

#define _IM_CLEAR_TABLE_SEPARATORY_NONE(__table__)\
[__table__ setSeparatorStyle:UITableViewCellSeparatorStyleNone];


//========================================setter宏=======================================/

#define __SETTER_RETAIN__(__property__)\
{\
if(_##__property__ != __property__)\
{\
RELEASE_SAFELY(_##__property__);\
_##__property__ = __property__;\
}\
}

#define _SETTER_COPY(__property__)\
{\
if(_##__property__ != __property__)\
{\
RELEASE_SAFELY(_##__property__);\
_##__property__ = [__property__ copy];\
}\
}

#define _GETTER_BEGIN(__class__, __property__) \
- (__class__*)__property__ \
{\
if(!_##__property__)\
{\


#define _GETTER_END(__property__) \
}\
return _##__property__;\
}


#define _GETTER_ALLOC_BEGIN(__class__, __property__) \
- (__class__*)__property__ \
{\
if(!_##__property__)\
{\
_##__property__ = _ALLOC_OBJ_(__class__);

#define _GETTER_ALLOC_FRAME_BEGIN(__class__, __property__, __frame__) \
- (__class__*)__property__ \
{\
if(!_##__property__)\
{\
_##__property__ = _ALLOC_OBJ_WITHFRAME_(__class__, __frame__);


//=========setter宏============

///==========================alloc 和release==============================
#ifndef _ALLOC_OBJ_
#define _ALLOC_OBJ_(__obj_class__) \
[[__obj_class__ alloc]init]
#endif

#ifndef _ALLOC_OBJ_AUTORELEASE_
#define _ALLOC_OBJ_AUTORELEASE_(__obj_class__) \
[[[__obj_class__ alloc]init] autorelease]
#endif

#ifndef _ALLOC_OBJ_WITHFRAME_
#define _ALLOC_OBJ_WITHFRAME_(__obj_class__, __frame__) \
[[__obj_class__ alloc]initWithFrame:__frame__]
#endif

#ifndef _ALLOC_VC_CLASS_
#define _ALLOC_VC_CLASS_(__vc_class__)\
_ALLOC_VC_CLASS_XIB_(__vc_class__, NSStringFromClass(__vc_class__))
#endif

#ifndef _ALLOC_VC_CLASS_XIB_
#define _ALLOC_VC_CLASS_XIB_(__vc_class__, __xib_name__)\
[[__vc_class__ alloc]initWithNibName:__xib_name__ bundle:nil];
#endif


#ifndef _ALLOC_CELL_CLASS_XIB_
#define _ALLOC_CELL_CLASS_XIB_(__cell_class__)\
[[UIView class] qb_loadCellXib:__cell_class__]

#endif


#ifndef _ALLOC_CELL_CLASS_XIB_OWNER_
#define _ALLOC_CELL_CLASS_XIB_OWNER_(__cell_class__, __owner__)\
[[UIView class] qb_loadCellXib:__cell_class__ owner:__owner__]

#endif

#ifndef _ALLOC_OBJ_WITHFRAME_AUTORELEASE_
#define _ALLOC_OBJ_WITHFRAME_AUTORELEASE_(__obj_class__, __frame__) \
[[[__obj_class__ alloc]initWithFrame:__frame__] autorelease]
#endif

#ifndef _ALLOC_OBJ_WITHDICT_
#define _ALLOC_OBJ_WITHDICT_(__obj_class__, __dict__) \
[[__obj_class__ alloc]initWithDictionary:__dict__]
#endif

#ifndef _CLEAR_BACKGROUND_COLOR_
#define _CLEAR_BACKGROUND_COLOR_(_view_) \
do {[_view_ setBackgroundColor:[UIColor clearColor]];} while(0)
#endif

#ifndef _SET_FRAME_
#define _SET_FRAME_(_view_,_frame_)\
do {[_view_ setFrame:_frame_];}while(0)
#endif

/***********************************userDefault*************************************/
//从userDefault中获取值
#ifndef getObjectFromUserDefault
#define getObjectFromUserDefault(__key__) \
[[NSUserDefaults standardUserDefaults] objectForKey:__key__]
#endif

//setuserDefault值
#ifndef setObjectToUserDefault
#define setObjectToUserDefault(__key__, __val__) \
[[NSUserDefaults standardUserDefaults] setObject:__val__ forKey:__key__];
#endif

//从userDeufalt中移除值
#ifndef removeObjectFromUserDefault
#define removeObjectFromUserDefault(__key__) \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__key__];
#endif
/**************************************字典***************************************/
//字典赋值
#ifndef SET_PARAM
#define SET_PARAM(__value__, __key__, __parms__) \
if (nil!=__value__) {\
[__parms__ setObject:__value__ forKey:__key__];\
}\
else\
{\
if(!__key__)\
{}\
else\
{\
[__parms__ removeObjectForKey:__key__];\
}\
}

#endif

//字典赋值
#ifndef __IM__SET_PARAM
#define __IM__SET_PARAM(__value__, __key__, __parms__) \
if (nil!=__value__) {\
[__parms__ setObject:__value__ forKey:__key__];\
}
#endif

//字典是否有K-V
#ifndef isDictWithCountMoreThan0

#define isDictWithCountMoreThan0(__dict__) \
(__dict__!=nil && \
[__dict__ isKindOfClass:[NSDictionary class] ] && \
__dict__.count>0)

#endif

#define isDictContainKey(__dic__, __key__)\
!(nil == [__dic__ objectForKey:__key__])


//获取字典中的错误信息
#define getErrMsg(dict)     [dict objectForKey:KEY_ERRORMSG]
#define getData(dict)       [dict objectForKey:KEY_RETURNDATA]

//解析字典
#define PUGetElemForKeyFromDict(__key, __dict)   [SSIMSpUtil getElementForKey:__key fromDict:__dict]
#define PUGetObjFromDict(__key, __dict, __class) [SSIMSpUtil getElementForKey:__key fromDict:__dict forClass:__class]
#define PUGetNotNilStringForKeyFromDict(__key, __dict) [NSString strToShowText:PUGetObjFromDict(__key,__dict, [NSString class])]
#define PUGetObjFromDictWithCharaterSet(__key, __dict, __characterSet) \
[SSIMSpUtil getElementForKey:__key fromDict:__dict character:__characterSet]
#define PUGetTotalCountFromData(__dict__)       [PUGetObjFromDict(@"totalcount", __dict__,[NSString class]) integerValue]
#define PUGetDataListFromData(__dict__)         PUGetObjFromDict(@"dataList", __dict__, [NSArray class])
#define PUGetString(__Obj__) [NSString stringWithFormat:@"%@",__Obj__]

/**************************************数组***************************************/
//数组是否有
#ifndef isArrayWithCountMoreThan0

#define isArrayWithCountMoreThan0(__array__) \
(__array__!=nil && \
[__array__ isKindOfClass:[NSArray class] ] && \
__array__.count>0)

#endif

/*************************************ALTER提示框***************************************/
#define _SIMPLE_ALERT_S_C_(__title, __message, __delegate)\
{\
UIAlertView* __alert__ = [[UIAlertView alloc] initWithTitle:__title message:__message delegate:__delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];\
[__alert__ show];\
RELEASE_SAFELY(__alert__);\
}

#define _SIMPLE_ALERT_(__title, __message, __btnTitle)\
{\
UIAlertView* __alert__ = [[UIAlertView alloc] initWithTitle:__title message:__message delegate:nil cancelButtonTitle:__btnTitle otherButtonTitles:nil,nil];\
[__alert__ show];\
RELEASE_SAFELY(__alert__);\
}

/**************************************Image***************************************/
//图片资源获取
#define __IMAGE_PLACEHODER_USERICON__ [UIImage imageNamed:@"fclogo"]


#define IMGGET( X )             [UIImage imageNamed:X]

#define IMG2XFROMBUNDLE( X )	 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",[X stringByDeletingPathExtension]] ofType:@"png" ]]
#define IMGFROMBUNDLE( X )	     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[X stringByDeletingPathExtension] ofType:@"png" ]]

#define IMG2XFROMBUNDLE_JPG( X )	 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",[X stringByDeletingPathExtension]] ofType:@"jpg" ]]
#define IMGFROMBUNDLE_JPG( X )	     [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[X stringByDeletingPathExtension] ofType:@"jpg" ]]

#define IMGNAMED( X )	     [UIImage imageNamed:X]

#define KEY_ERRORMSG            @"errorMsg"
#define KEY_RETURNDATA          @"data"
#define FAILDMESSAGE            @"网络异常"
/*************************************当前用户ID***************************************/
#define OWNERID [[SSIMClient sharedInstance] owerid]
#define APP_ID  [[SSIMClient sharedInstance] appid]

//userDeufalt中的KEY
#define KEY_Earphone [NSString stringWithFormat:@"%lld_isEarphone",OWNERID]
#define KEY_Single_Offline [NSString stringWithFormat:@"%lld_SingleOffline",OWNERID]
#define KEY_Group_Offline [NSString stringWithFormat:@"%lld_GroupOffline",OWNERID]
#define KEY_Message_Mode [NSString stringWithFormat:@"%lld_MessageMode",OWNERID]
#define KEY_Group_Icon( ID ) [NSString stringWithFormat:@"%lld_%lld_Group_Icon",OWNERID,ID]
#define KEY_Group_Create_Del [NSString stringWithFormat:@"%lld_Create_Del",OWNERID]
#define KEY_Group_Create_Bla [NSString stringWithFormat:@"%lld_Create_Bla",OWNERID]
#define KEY_Wid_List( BID ) [NSString stringWithFormat:@"%lld_%lld_Wid_List",OWNERID,BID]
#define KEY_Member_Fetch(groupid) [NSString stringWithFormat:@"%lld_%lld_fetch",OWNERID,groupid]
#define KEY_Message_Status(mbd) [NSString stringWithFormat:@"%@_status",mbd]
#define KEY_Member_Index(groupid) [NSString stringWithFormat:@"%lld_%lld_Index",OWNERID,groupid]
#define KEY_Image_ID(ID) [NSString stringWithFormat:@"%lld_%lld_image",OWNERID,ID]

#endif
