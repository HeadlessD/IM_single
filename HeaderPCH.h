//
//  HeaderPCH.h
//  IM_single
//
//  Created by 豆凯强 on 2018/1/9.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#ifndef HeaderPCH_h
#define HeaderPCH_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import "NIMConstHeader.h"
#import "SSIMSpUtil.h"
#import "UIViewController+NIMPushVC.h"
#import "SSIMClient.h"
#import "NIMTableViewController.h"
#import "UIAlertView+NIMBlocks.h"
#import "SSIMModel.h"
#import "AppDelegate.h"
#import "DFModel.h"
#import <DFToolUtil.h>
//#import "NIMLoginViewController.h"

//管理类
#import "NIMSysManager.h"
#import "NIMFriendManager.h"
#import "NIMGroupOperationBox.h"
#import "NIMOperationBox.h"
#import "NIMUserOperationBox.h"
#import "NIMOfficialOperationBox.h"
#import "NIMErrorManager.h"
#import "SSIMBundleTool.h"
#import "NIMUtility.h"
#import "SSIMBackgroundManager.h"
#import "SSIMPushHelper.h"
#import "PinYinManager.h"
#import "NIMBusinessOperationBox.h"
#import "NIMCallBackManager.h"
#import "NIMMessageErrorManager.h"
#import "NIMMessageManager.h"
#import "GroupManager.h"
#import "NIMMsgCountManager.h"
#import "NIMRedBagManage.h"
#import "NIMMomentsManager.h"
#import <DFSandboxHelper.h>
#import "DFFileManager.h"
#import "NIMLoginManager.h"
#import "ZLDefine.h"

//数据库
#import "NSManagedObject+NIM.h"
#import "GroupList+CoreDataClass.h"
#import "FDListEntity+CoreDataClass.h"
#import "ChatListEntity+CoreDataClass.h"
#import "PhoneBookEntity+CoreDataClass.h"
#import "NOffcialEntity+CoreDataClass.h"
#import "GMember+CoreDataClass.h"
#import "NBusinessEntity+CoreDataClass.h"
#import "NWaiterEntity+CoreDataClass.h"
#import "NUnreadEntity+CoreDataClass.h"
#import "NIMRedBagEntity+CoreDataClass.h"
#import "MomentEntity+CoreDataClass.h"
#import "CommentEntity+CoreDataClass.h"

//三方库
#import <Masonry.h>
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <DOUAudioStreamer/DOUAudioStreamer.h>

#import <AFNetworking.h>
#import <MapKit/MapKit.h>
#import <SDImageCache.h>
#import "GTMBase64.h"
#import "MBProgressHUD.h"
#import "OHAttributedLabel.h"
#import "Reachability.h"
#import "NIMAttributedLabel.h"
#import "lame.h"


#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#endif /* QBNIMClientHeader_pch */

#endif /* HeaderPCH_h */
