//
//  NIMAllPublicInfoVC.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/15.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMAllPublicInfoVC.h"
#import "NIMUserOperationBox.h"
#import "NIMPublicInfoModel.h"
#import "NIMDefaultTableViewCell.h"
#import "NIMSysPublicTextCell.h"
#import "NIMPublicInfoTableViewCell.h"
//#import "PublicEntity.h"
#import "NIMPublicFansTableViewCell.h"
#import "NIMPublicForApnsTableViewCell.h"
#import "NIMPublicOperationBox.h"
#import "NIMLatestVcardViewController.h"
//#import "MessageNIMOperationBox.h"
#import "NIMChatUIViewController.h"
#import "NIMPublicAttentionUserListVC.h"
//#import "QBWebViewController.h"
//#import "QBHtmlWebViewController.h"
#import "NIMOldTableViewCell.h"
#import "NIMMessageCenter.h"
//#import "QBClick.h"
@interface NIMAllPublicInfoVC ()<UITableViewDataSource,UITableViewDelegate,VcardForwardDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIButton *subcribeBtn;
@property (nonatomic, strong) UITableView                  *tableView;
@property (nonatomic, strong) NIMPublicInfoModel            *publicModel;
@property (nonatomic, strong) UIBarButtonItem              *rightBar;

@end

@implementation NIMAllPublicInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:@"wapLoginCallBackNotification" object:nil];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recvUserinfo:) name:NC_USERINFORQ object:nil];

    if(! [NIMSysManager sharedInstance].isQbaoLoginSuccess)
    {
        [self requestPublicInfoNotLogin];
    }
    else
    {
        [self requestPublicInfoNetWork];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self qb_setTitleText:@"详细资料"];
//    if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeSunscribed)
//    {
//        self.qb_rightBarButton.enabled=YES;
//
//        [self qb_showRightButton:nil andBtnImg:IMGGET(@"icon_public_more")];
//    }
//    else
//    {
//      [self qb_showRightButton:nil andBtnImg:nil];
//
//        self.qb_rightBarButton.enabled=NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)loginSuccess
{
    [self requestPublicInfoNetWork];

}

-(void)recvUserinfo:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showTipsView:param.p_string atView:self.view];
            }else{
                [MBTip showTipsView:@"查找成功" atView:self.view];
            }
        }else{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
            
//            [MBTip showError:@"查找失败" toView:self.view];
        }
    });
}
-(void)qb_back
{
    
    NIMPublicForApnsTableViewCell* cell =(NIMPublicForApnsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (![cell isKindOfClass:[NIMPublicForApnsTableViewCell class]]) {
        [super qb_back];
        return;
    }
    if(cell.apnsSwitch.on != self.publicModel.pubSwitch.boolValue)
    {
        [super qb_back];
    }
    else
    {
        [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicModel.userId.doubleValue
                                                       switchValue:cell.apnsSwitch.on
                                                     completeBlock:^(id object, NIMResultMeta *result) {
                                                         dispatch_sync(dispatch_get_main_queue(), ^{
                                                             if(result)
                                                             {
                                                                 [MBTip showError:result.message toView:self.view];
                                                             }
                                                             else
                                                             {
                                                                 [self saveTo];
                                                                 
                                                             }
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         });
                                                     }];
    
    }

}
-(void)requestPublicInfoNotLogin
{
    [self qb_showLoading];
    
    /*
    [[NIMUserOperationBox sharedInstance] fetchUseridNotLogin:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
        void (^callBack)();
        callBack = ^(){
            [self qb_hideLoadingWithCompleteBlock:^{
                
            }];
            if (!object){
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该公众号停止服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertV.tag =100;
                [alertV show];
                return ;
            }
            NSDictionary *dic = object;
            [self reloadUI:dic];
        };
        if([NSThread isMainThread]){
            callBack();
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack();
            });
        }
    }];
     */

}
-(void)requestPublicInfoNetWork
{
    [self qb_showLoading];
    /*
    [[NIMUserOperationBox sharedInstance] fetchUserid3:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
        void (^callBack)();
        callBack = ^(){
            [self qb_hideLoadingWithCompleteBlock:^{
                
            }];
            if (!object){
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该公众号停止服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertV.tag =100;
                [alertV show];
                return ;
            }
            NSDictionary *dic = object;
            [self reloadUI:dic];
        };
        if([NSThread isMainThread]){
            callBack();
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack();
            });
        }
    }];
*/
}

-(void)reloadUI:(NSDictionary *)dic{
//    self.publicModel = [[NIMPublicInfoModel alloc]initWithDic:dic];
//    NSString *subTips = @"关注";
//    if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone)
//    {
//        [self.subcribeBtn setImage:IMGGET(@"icon_bottom_add") forState:UIControlStateNormal];
//        [self.subcribeBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [self.subcribeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.subcribeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.subcribeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    }
//    else
//    {
//        subTips = @"进入公众号";
//        [self.subcribeBtn setImage:nil forState:UIControlStateNormal];
//        [self.subcribeBtn setTitle:subTips forState:UIControlStateNormal];
//        [self.subcribeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    }
//    if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeSunscribed)
//    {
//         self.qb_rightBarButton.enabled=YES;
//      [self qb_showRightButton:nil andBtnImg:IMGGET(@"icon_public_more")];
//    }
//   else
//   {
//        self.qb_rightBarButton.enabled=NO;
//       [self qb_showRightButton:nil andBtnImg:nil];
//
//   }
//    [self.tableView reloadData];
}



#pragma mark VcardForwardDelegate
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock
{
    if(thread.length==0)return;
    
    /*
    [[MessageNIMOperationBox sharedInstance] sendMessage:[NSNumber numberWithDouble:self.publicid] thread:thread packetContentType:PacketContentTypeJson packetSubtypeType:PacketSubtypeTypeVCard cardType:CardTypePublic completeBlock:^(id object, NIMResultMeta *result)
     {
         completeBlock(VcardSelectedActionTypeForward, object, result);
     }];
     */
}
-(void)qb_rightButtonAction
{
    /*
    NIMRIButtonItem* cancel = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    NIMRIButtonItem* friend = [NIMRIButtonItem itemWithLabel:@"推荐给朋友" action:^{
        [self showLatestVcardViewController:YES];
    }];
    
    NIMRIButtonItem* exit = [NIMRIButtonItem itemWithLabel:@"取消关注" action:^{
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消关注么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    }];
    UIActionSheet* sheet = nil;
    if(self.publicModel.subscribed.integerValue == PublicSubscribedTypeSys){
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancel destructiveButtonItem:nil otherButtonItems:friend, nil];
    }
    else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancel destructiveButtonItem:exit otherButtonItems:friend, nil];
    }
    _GET_APP_DELEGATE_(app);
    app.applicationActionSheet = sheet;
    [sheet showInView:self.view];
     */

}
#pragma mark action
- (void)subcribePublicButtonClick:(id)sender{
    //    }
    
//    _GET_APP_DELEGATE_(appDelegate);
    if(! [NIMSysManager sharedInstance].isQbaoLoginSuccess)
    {
//        [appDelegate.window.rootViewController presentViewController:appDelegate.authNavigationC animated:YES completion:^{
//            
//        }];
    }
    else
    {
//        if (self.publicModel.subscribed.integerValue != PublicSubscribedTypeNone) {
//
//            NIMPublicForApnsTableViewCell* cell =(NIMPublicForApnsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//
//            if(cell.apnsSwitch.on == self.publicModel.pubSwitch.boolValue){
//                [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicModel.userId.doubleValue
//                                                               switchValue:cell.apnsSwitch.on
//                                                             completeBlock:^(id object, NIMResultMeta *result) {
//                                                                 dispatch_sync(dispatch_get_main_queue(), ^{
//                                                                     if(result){
//                                                                         [MBTip showError:result.message toView:self.view];
//                                                                     }
//                                                                     else{
//                                                                         [self saveTo];
//                                                                     }
//                                                                 });
//                                                             }];
//            }
//
//            NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
//            [chatVC setThread:self.publicModel.thread];
//            chatVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:chatVC animated:YES];
//        }else{
//            [self subcribePublic];
//        }
    }
    
}
-(void)saveTo
{
//    NIMPublicForApnsTableViewCell* cell =(NIMPublicForApnsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//    NSManagedObjectContext *managedObjectContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [managedObjectContext performBlockAndWait:^{
//        PublicEntity  *publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//        publicEntity.apn = cell.apnsSwitch.on;
        //TODO:save
//        [managedObjectContext MR_saveOnlySelfAndWait];
//    }];
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else if (buttonIndex == 1)
    {
        [self unSubcribePublic];
    }
}

- (void)showLatestVcardViewController:(BOOL)animated{
    
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.delegate = self;
    }
    [self.navigationController presentViewController:latestVcardNavigation animated:YES completion:^{
        
    }];
}

- (void)moreAction:(id)Sender{
    
    /*
    NIMRIButtonItem* cancel = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
        
    }];
    NIMRIButtonItem* friend = [NIMRIButtonItem itemWithLabel:@"推荐给朋友" action:^{
        [self showLatestVcardViewController:YES];
    }];
    
    NIMRIButtonItem* exit = [NIMRIButtonItem itemWithLabel:@"取消关注" action:^{
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定取消关注么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
    }];
    UIActionSheet* sheet = nil;
    if(self.publicModel.subscribed.integerValue == PublicSubscribedTypeSys){
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancel destructiveButtonItem:nil otherButtonItems:friend, nil];
    }
    else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:cancel destructiveButtonItem:exit otherButtonItems:friend, nil];
    }
    _GET_APP_DELEGATE_(app);
    app.applicationActionSheet = sheet;
    [sheet showInView:self.view];
     */
}

- (void)subcribePublic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NIMPublicOperationBox sharedInstance] subscribePublic:self.publicid andSource:self.publicSourceType completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (result) {
                [MBTip showError:result.message toView:self.view];
            }else{
                
                if (self.m_indexPath) {
                     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:self.m_indexPath forKey:@"index"];
                    [dic setObject:@"1" forKey:@"statue"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADCELL" object:dic];
                }
               
                self.navigationItem.rightBarButtonItem = self.rightBar;
                [self requestPublicInfoNetWork];

            }
        });
    }];
}

- (void)unSubcribePublic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NIMPublicOperationBox sharedInstance] unsubscribePublic:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (result) {
                [MBTip showError:result.message toView:self.view];
            }else{
                if (self.m_indexPath) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:self.m_indexPath forKey:@"index"];
                    [dic setObject:@"0" forKey:@"statue"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADCELL" object:dic];
                }
                self.navigationItem.rightBarButtonItem = nil;
                [self requestPublicInfoNetWork];
            }
        });
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if(section == 1)
    {
        return 2;
    }
    else
    {
//        if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone) {
//        return 1;//屏蔽历史消息 改成 1 打开历史消息
//        }
        return 2;//屏蔽历史消息 改成 2 打开历史消息
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NIMPublicInfoTableViewCell *cell = (NIMPublicInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NIMPublicInfoTableViewCellID"];
            if(!cell){
                cell = [[NIMPublicInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NIMPublicInfoTableViewCellID"];
            }
            [cell setDataSource:self.publicModel];
            return cell;
        }
        else if (indexPath.row == 1){
            NIMSysPublicTextCell* cell = [tableView dequeueReusableCellWithIdentifier:kPublicTextBodyCellReuseIdentifier];
            if(!cell){
                cell = [[NIMSysPublicTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPublicTextBodyCellReuseIdentifier];
            }
            NSString *desc = nil;
            if (IsStrEmpty(self.publicModel.pubsubject)) {
                desc = @"";
            }
            else
            {
                desc = [NSString stringWithFormat:@"账号主体：%@",self.publicModel.pubsubject];
                [cell updateWithPublicText:desc];
            }
            return cell;
        }
        else{
            NIMSysPublicTextCell* cell = [tableView dequeueReusableCellWithIdentifier:kPublicTextCellReuseIdentifier];
            if(!cell){
                cell = [[NIMSysPublicTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPublicTextCellReuseIdentifier];
            }
            NSString *desc = @"暂无描述";
            if (!IsStrEmpty(self.publicModel.publicInfoModel.publicInfoDescription)) {
                desc = self.publicModel.publicInfoModel.publicInfoDescription;
            }
            [cell updateWithPublicText:desc];
            return cell;
        }
        
    }
    else if(indexPath.section == 1){
        
    }
//    {
//        if (indexPath.row == 0) {
//            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"publicFansNumID"];
//            if(!cell){
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"publicFansNumID"];
//            }
//            if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeSys) {
//                cell.textLabel.text = nil;
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            else{
//                if ([SSIMSpUtil isEmptyOrNull:self.publicModel.fansnum] ||self.publicModel.fansnum.intValue==0) {
//                    cell.textLabel.text = nil;
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                }
//                else
//                {
//                cell.textLabel.text = [NSString stringWithFormat:@"%@人关注",self.publicModel.fansnum];
//                cell.textLabel.textColor = [SSIMSpUtil getColor:@"262626"];
//                cell.textLabel.font = [UIFont systemFontOfSize:14];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                }
//            }
//            return cell;
//        }
//        else
//        {
//            NIMPublicFansTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NIMPublicFansTableViewCellID"];
//            if(!cell){
//                cell = [[NIMPublicFansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NIMPublicFansTableViewCellID"];
//            }
//            if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeSys) {
//
//            }
//            else
//            {
//                if ([SSIMSpUtil isEmptyOrNull:self.publicModel.fansnum] ||self.publicModel.fansnum.intValue==0)
//                {
//
//                }
//                else
//                {
//                [cell setDataSource:self.publicModel];
//                }
//            }
//            return cell;
//        }
//
//    }
//    else
//    {
//        if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone) {
//            NIMOldTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QBPublicHistoryTableViewCellID"];
//            if(!cell){
//                cell = [[NIMOldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QBPublicHistoryTableViewCellID"];
//            }
//
//            cell.textLabel.text = @"历史消息";
//            cell.textLabel.textColor = [SSIMSpUtil getColor:@"262626"];
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
////            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            return cell;
//
//        }
//        else{
//            if (indexPath.row == 0) {
//                NIMPublicForApnsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NIMPublicForApnsTableViewCellID"];
//                if(!cell){
//                    cell = [[NIMPublicForApnsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NIMPublicForApnsTableViewCellID"];
//                }
//                //            cell.delegate = self;
//                if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone) {
//
//                }
//                else
//                {
//                    [cell setDataSource:self.publicModel];
//                }
//                return cell;
//            }
//            else
//            {
//                NIMOldTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QBPublicHistoryTableViewCellID"];
//                if(!cell){
//                    cell = [[NIMOldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QBPublicHistoryTableViewCellID"];
//                }
//                cell.textLabel.text = @"历史消息";
//                cell.textLabel.textColor = [SSIMSpUtil getColor:@"262626"];
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
////                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                return cell;
//            }
//        }
//    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
//            [QBClick event:kUMEventId_3020];
            NIMPublicAttentionUserListVC* attentionlist = (NIMPublicAttentionUserListVC*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMPublicAttentionUserList"];
            attentionlist.publicid = self.publicid;
            [self.navigationController pushViewController:attentionlist animated:YES];
        }
    }
    else if(indexPath.section == 2)
    {
        
        /*
         if(indexPath.row == 1 || self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone)
         {

             NSString *contentUrl = [NSString stringWithFormat:@"http://mp.qbao.com/api/gethistorymessages?pubid=%.0f",self.publicid];

   
             NSMutableDictionary *dic = @{}.mutableCopy;
             [dic setObject:contentUrl forKey:@"url"];
             NSURL *url =[NSURL URLWithString:dic[@"url"]];
             WEBFILTER_RESULT t_filterResult = [[NIMWebViewFilter shareFilter] filterForUrl:[url absoluteString]  info:nil];
             if (t_filterResult==WEBFILTER_RESULT_BAOGOU_IM)
             {
                 
             }
             else
             {

             QBHtmlWebViewController *htmlWebVC = [[UIStoryboard storyboardWithName:@"NIMChatUI" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMHtmlWebViewController"];
             htmlWebVC.linkDict = dic;
             htmlWebVC.actualTitle = @"历史消息";
             htmlWebVC.userId =[NSString stringWithFormat:@"%.f",self.publicid];
             htmlWebVC.senderId =[NSString stringWithFormat:@"%.f",self.publicid];
             [self.navigationController pushViewController:htmlWebVC animated:YES];
             }
         }
         */
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//{
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0){
//            return 90;
//        }
//        else if (indexPath.row == 1){
//            if (IsStrEmpty(self.publicModel.pubsubject)) {
//                return 0;
//            }
//            else
//            {
//               NSString *desc = [NSString stringWithFormat:@"账号主体：%@",self.publicModel.pubsubject];
//                return [NIMSysPublicTextCell heightSysPublicTextCellWithText:desc];
//            }
//        }
//        else
//        {
//            NSString *desc = @"暂无描述";
//            if (!IsStrEmpty(self.publicModel.publicInfoModel.publicInfoDescription)) {
//                desc = self.publicModel.publicInfoModel.publicInfoDescription;
//            }
//            return [NIMSysPublicTextCell heightSysPublicTextCellWithText:desc];
//
//        }
//    }
//    else if(indexPath.section == 1)
//    {
//        if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeSys) {
//            return 0;
//        }
//        else
//        {
//            if ([SSIMSpUtil isEmptyOrNull:self.publicModel.fansnum] ||self.publicModel.fansnum.intValue==0)
//            {
//                return 0;
//            }
//            else
//            {
//            if (indexPath.row == 0){
//                return 35;
//            }
//            else
//            {
//                if (self.publicModel.publicInfoModel.publicInfoFans.count <9) {
//                    return 60;
//                }
//                return 120;
//            }
//            }
//        }
//
//    }
//    else
//    {
//        if (self.publicModel.subscribed.integerValue == PublicSubscribedTypeNone) {
//            return 44;
//        }else{
//            if (indexPath.row == 0){
//
//                return 44;
//            }else{
//                return 44;
//            }
//
//        }
//    }
//
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.05;
    }
    if (section == 1) {
//        NSInteger subscribed = self.publicModel.subscribed.integerValue;
//        if (subscribed == PublicSubscribedTypeSys) {
//            return 0.05;
//        }
        return 20;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.05;

}

- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.estimatedRowHeight =0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;

        [self.view addSubview:_tableView];
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
            make.top.offset(0);
            make.bottom.offset(-50);
        }];
    }
    return _tableView;
}
- (UIBarButtonItem*)rightBar{
    if(!_rightBar){
        _rightBar = [[UIBarButtonItem alloc] initWithImage:IMGGET(@"icon_public_more") style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    }
    return _rightBar;
}

- (UIButton*)subcribeBtn{
    if(!_subcribeBtn){
        _subcribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subcribeBtn setBackgroundColor:[UIColor whiteColor]];
        [_subcribeBtn setTitleColor:[SSIMSpUtil getColor:@"43A81D"] forState:UIControlStateNormal];
        [_subcribeBtn addTarget:self action:@selector(subcribePublicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_subcribeBtn];
        [_subcribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.view.mas_leading);
            make.trailing.equalTo(self.view.mas_trailing);
            make.bottom.equalTo(self.view.mas_bottom);
            make.width.equalTo(self.view.mas_width);
            make.height.equalTo(@50);
        }];
    }
    return _subcribeBtn;
}

//-(NIMPublicInfoModel *)publicInfoModel
//{
//    if (!_publicInfoModel) {
//        _publicInfoModel = [NIMPublicInfoModel new];
//    }
//    return _publicInfoModel;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
