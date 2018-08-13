//
//  NIMPChatTableViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/9/17.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPChatTableViewController.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMGroupCreateVC.h"
#import "NIMChatUIViewController.h"
#import "GroupList+CoreDataClass.h"
#import "ChatListEntity+CoreDataClass.h"
#import "ChatEntity+CoreDataClass.h"
#import "NIMSelfViewController.h"
#import "NIMMessageCenter.h"
#import "NIMGroupOperationBox.h"
#import "NIMUserOperationBox.h"
#import "NIMReportViewController.h"
#import "SSIMThreadViewController.h"
@interface NIMPChatTableViewController ()<GroupCreateViewControllerDelegate>
@property (nonatomic, strong) VcardEntity *vcardEntity;
@property (nonatomic, strong) ChatListEntity *chatListEntity;
@property (nonatomic, strong) FDListEntity *fdListEntity;

@property (nonatomic, weak) IBOutlet UIButton *avatarBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UISwitch *msgTopSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *msgNoticeSwitch;


@property (unsafe_unretained, nonatomic) IBOutlet UILabel *blackLabel;

@property (nonatomic, assign) BOOL deleteChatInfo;
@end

@implementation NIMPChatTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"聊天设置"];
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.vcardEntity = [VcardEntity instancetypeFindUserid:_userid];
    self.fdListEntity = [FDListEntity instancetypeFindMUTUALFriendId:_userid];
    [self updateWithVcardEntity:self.vcardEntity];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSingleStatus:) name:NC_SINGLE_CHAT_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvC_CLIENT_FRIEND_ADD_RQ:) name:NC_CLIENT_FRIEND_ADD_RQ object:nil];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:18];
//    Label.font = [UIFont systemFontOfSize:60];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    [_msgNoticeSwitch addTarget:self action:@selector(swwwwChange:) forControlEvents:UIControlEventTouchUpInside];
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


-(void)swwwwChange:(UISwitch *)sender
{
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        _msgNoticeSwitch.on = !sender.on;
        return;
    }
    
    if (!self.fdListEntity) {
        [MBTip showError:@"该用户不是你好友" toView:self.view];
        return;
    }
    if (self.fdListEntity.apnswitch==sender.on) {
        return;
    }
    [[NIMUserOperationBox sharedInstance] sendSingleChatStatusWithUserid:self.userid status:sender.on];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.msgNoticeSwitch.on = self.fdListEntity.apnswitch;
    //    [[NIMUserOperationBox sharedInstance]getSwitchUser:self.vcardEntity.thread completeBlock:^(id object, NIMResultMeta *result) {
    //        if (result)
    //        {
    //
    //        }
    //        else
    //        {
    //            BOOL isOpen = [object boolValue];
    //            self.msgNoticeSwitch.on =isOpen;//http://jira.qbao.com/browse/CLIENT-1173“新消息通知”默认开，改成“消息免打扰”默认关
    //        }
    //    }];
    if (self.chatListEntity) {
        _msgTopSwitch.on = self.chatListEntity.topAlign;
    }
    else
    {
        _msgTopSwitch.on = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(_deleteChatInfo){
        //        NSString* thread = self.vcardEntity.messageBodyId;
        NSString * thread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:self.vcardEntity.userid];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteChatLogFormNotification" object:thread];
    }
}

- (void)qb_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark config
- (void)updateWithVcardEntity:(VcardEntity *)vcardEntity{
    [self.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:USER_ICON_URL(self.userid)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];

    self.nameLabel.text = [NIMStringComponents finFristNameWithID:vcardEntity.userid];
}

#pragma mark private method
- (void)showProfileControllerWithuserid:(int64_t)userid{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType = ChatSource;

        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
    }
}

#pragma mark actions
- (IBAction)avatarClick:(id)sender{
    [self showProfileControllerWithuserid:self.userid];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            if (self.fdListEntity == nil ||
                (self.fdListEntity.fdFriendShip == FriendShip_Friended &&
                 self.fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK) ||
                (self.fdListEntity.fdFriendShip == FriendShip_Friended &&
                 self.fdListEntity.fdBlackShip == FD_BLACK_MUTUAL_BLACK) ||
                self.fdListEntity.fdFriendShip == FriendShip_UnilateralFriended)
            {
                [self showAlertWithFriend:self.fdListEntity];
                
            }else{
                NIMGroupCreateVC *groupCVC = (NIMGroupCreateVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupCreateVC"];
                groupCVC.delegate = self;
                groupCVC.friendUserId = self.userid;
                groupCVC.showSelected = NO;
                [self.navigationController pushViewController:groupCVC animated:YES];
            }
        }
    }
    
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [self clearnChatLog];
        }
    }
    if(indexPath.section == 3)
    {
        if(indexPath.row == 0)
        {
            //            NIMReportViewController* reportVC  =[[NIMReportViewController alloc] initWithNibName:@"NIMReportViewController" bundle:[NSBundle mainBundle]];
            NIMReportViewController* reportVC  =[[NIMReportViewController alloc]init];
            reportVC.reportType = @"2";
            reportVC.isTweet =NO;
            reportVC.uuid =[NSString stringWithFormat:@"%.lld",self.userid];
            reportVC.pushType=@"present";
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:reportVC];
            [self.navigationController presentViewController:nav animated:YES completion:^{
                
            }];
        }
    }
    
    
}


-(void)showAlertWithFriend:(FDListEntity *)fdListEntity
{
    NSString *tips = nil;
    UIAlertAction *okAction = nil;
    UIAlertAction *cancle = nil;
    
    NSString *firstName = [NIMStringComponents finFristNameWithID:fdListEntity.fdPeerId];

    if (fdListEntity ==nil ||
        fdListEntity.fdFriendShip == FriendShip_UnilateralFriended){

        tips = [NSString stringWithFormat:@"%@未把你添加到通讯录，需要发送好友申请，等对方通过。是否发送？",firstName];
        okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            FDListEntity * fdlist = [FDListEntity instancetypeFindMUTUALFriendId:fdListEntity.fdPeerId];
            
            if (!fdlist) {
                    [[NIMFriendManager sharedInstance] sendFriendAddRQ:self.userid opMsg:nil sourceType:ChatSource];
            }else{
                [MBTip showError:@"对方已经是您的好友了" toView:self.view.window];
            }
        }];
        cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    }else{
        tips = [NSString stringWithFormat:@"%@拒绝加入群聊。",firstName];
        okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancle) {
        [alertController addAction:cancle];
        
    }
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




-(void)recvC_CLIENT_FRIEND_ADD_RQ:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        id object = noti.object;
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * addDic = object;
                if ([addDic objectForKey:@"isComeBack"]) {
                    [MBTip showError:@"添加好友成功" toView:self.view.window];
                    NSDictionary * dicts = @{@"userId":[addDic objectForKey:@"userId"],@"fdResult":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
                }
            }else if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view.window];

            }else{
                [MBTip showError:@"请求发送成功" toView:self.view.window];
            }
        }else{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
//            [MBTip showError:@"请求发送失败" toView:self.view.window];
        }
    });

}

- (IBAction)msgTop:(UISwitch *)sender {
    [[NIMGroupOperationBox sharedInstance] swithTop:sender.on withGroupMsgBodyId:self.acMsgBodyID];
}

- (IBAction)msgNotify:(UISwitch *)sender {


}


-(void)recvSingleStatus:(NSNotification *)notification
{
    id object = notification.object;
    
    if (!object) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBTip showError:@"请求超时" toView:self.view];
//        });
        UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [netAlert addAction:nAction];
        [self presentViewController:netAlert animated:YES completion:^{
        }];
    }else{
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            NSDictionary *dict = object;
            int status = [[dict objectForKey:@"status"] intValue];
            [self.fdListEntity setApnswitch:status];
            //TODO:save
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
        }
    }
    
}

- (void)clearnChatLog
{
    NSString *firstName = [NIMStringComponents finFristNameWithID:_vcardEntity.userid];
    NSString * message = [NSString stringWithFormat:@"清空聊天记录将会删除会话框,确定清空和%@的聊天记录吗？",firstName];
    _deleteChatInfo = YES;
    __weak typeof(self) weakSelf = self;
    NIMRIButtonItem* b1 = [NIMRIButtonItem itemWithLabel:@"清空" action:^{
        [[NIMMessageCenter sharedInstance] deleteRecordsThread:self.chatListEntity.messageBodyId completeBlock:^(id object, NIMResultMeta *result) {
            ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:_msgBodyID];
            [ChatEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",_msgBodyID]];
            [recordList NIM_deleteEntity];
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            [[NIMMessageManager sharedInstance] removeAllMessageBy:_msgBodyID];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SSIMThreadViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }
            /*
            if (_delegate && [_delegate respondsToSelector:@selector(reloadTableIfClearDataSource)]) {
                [_delegate reloadTableIfClearDataSource];
            }*/
        }];
    }];
    NIMRIButtonItem* b2 = [NIMRIButtonItem itemWithLabel:@"取消"
                                            action:^{
                                                
                                            }];
    UIAlertView* alert = [[UIAlertView alloc]initWithNimTitle:@"提醒"
                                                   message:message
                                          cancelButtonItem:nil
                                          otherButtonItems:b2, b1, nil];
    [alert show];
}

#pragma mark GroupCreateViewControllerDelegate
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didCreatedGroup:(GroupList *)groupEntity{
    if (groupEntity == nil) {
        return;
    }
    if(groupEntity.messageBodyId)
    {
        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
        [chatVC setThread:groupEntity.messageBodyId];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
}
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectedThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    completeBlock(VcardSelectedActionTypeChat,nil,nil);
}
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didBackWithCompleteBlock:(VcardCompleteBlock)completeBlock{
    completeBlock(VcardSelectedActionTypeChat,nil,nil);
}

-(ChatListEntity *)chatListEntity
{
    if (!_chatListEntity) {
        _chatListEntity = [ChatListEntity findFirstWithMessageBodyId:self.msgBodyID];
    }
    return _chatListEntity;
}

-(FDListEntity *)fdListEntity
{
    if (!_fdListEntity) {
        _fdListEntity = [FDListEntity instancetypeFindFriendId:self.userid];
    }
    return _fdListEntity;
}
@end
