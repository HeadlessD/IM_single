//
//  QBGroupAssistantVC.m
//  QianbaoIM
//
//  Created by fengsh on 30/10/15.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMGroupAssistantVC.h"
#import "NIMSubTimeTableViewCell.h"
#import "NIMOperationBox.h"
#import "ChatListEntity+CoreDataClass.h"
#import "ChatEntity+CoreDataClass.h"
//#import "QBGroupNotificationVC.h"
//#import "QBGroupAssistantItemView.h"
#import "NIMGroupTipsView.h"
#import "NIMGroupNoDataView.h"
#import "GroupList+CoreDataClass.h"
#import "NIMChatUIViewController.h"
#import "GMember+CoreDataClass.h"
#import "NIMMessageStruct.h"
#import "NIMManager.h"
@interface NIMGroupAssistantVC ()<UITableViewDataSource,UITableViewDelegate,VcardTableViewCellDelegate,NSFetchedResultsControllerDelegate>
///获取群消息
@property (nonatomic, strong) NSFetchedResultsController   *fetchGroupMsgController;
@property (nonatomic, strong) NSFetchedResultsController   *fetchGroupNtfConrroller;
@property (nonatomic, strong) UITableView                  *tableView;
//@property (nonatomic, strong) QBGroupAssistantItemView     *topView;
@property (nonatomic, strong) NIMGroupTipsView              *tipsView;
@property (nonatomic, strong) NIMGroupNoDataView            *nodataView;
@property (nonatomic, assign) BOOL                          hasRecord;
@end

@implementation NIMGroupAssistantVC

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hasGroupNotification:)
                                                name:@"recvGroupNotifcation" object:nil];
    
}

- (void)unRegisterNotification
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.nodataView = [[NIMGroupNoDataView alloc]init];
    self.nodataView.lbnodataTips.text = @"暂时没有群消息";
    self.nodataView.nodatalogo.image = IMGGET(@"icon_news");
    [self.view addSubview:self.nodataView];
    [self.nodataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
//    self.topView = [[QBGroupAssistantItemView alloc]init];
//    self.topView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.topView];
    
//    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)];
//    
//    [self.topView addGestureRecognizer:tapgesture];
//    
//    
//    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(0);
//        make.leading.equalTo(0);
//        make.trailing.equalTo(0);
//        make.height.equalTo(70);
//    }];
    
    self.tipsView   = [[NIMGroupTipsView alloc]init];
    self.tipsView.tips.text = @"以下为“收入群助手且不提醒”的群消息";
    [self.view addSubview:self.tipsView];
    [self.tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NIMSubTimeTableViewCell class] forCellReuseIdentifier:kSubTimeReuseIdentifier];

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //[self unRegisterNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;

    [self registerNotification];
    
    [self qb_setTitleText:@"群助手"];
    
    [[NIMSysManager sharedInstance] setCurrentMbd:kGroupAssistantThread];
    [[NIMSysManager sharedInstance] setIsInAssistant:YES];
    [self refresh];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NIMSysManager sharedInstance] setCurrentMbd:nil];
    [self refreshDataFromDB];
}

- (void)hasGroupNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
    });
}

- (void)checkDataisEmpty
{
    self.hasRecord = NO;
    
    //[self refreshTopTitleView];
    
    [self refreshDataFromDB];
    
    //当没有群消息及没有群通知时删除群助手
    if (!self.hasRecord) {
        [[NIMOperationBox sharedInstance]deleteGroupAssistant];
    }
}

- (void)refresh
{
    [self checkDataisEmpty];
    
    [self.tableView reloadData];
}

- (void)refreshTopTitleView
{
    //从DB中获取
    ChatEntity *chat = [self getNotifyInfo];
    if (chat)
    {
        NSString *body = chat.msgContent;
        
        NSData *dt = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:dt options:NSJSONReadingAllowFragments error:nil];
        
        body = dic[@"desc"];
        if (body.length == 0) {
            body = dic[@"description"];
        }
        
        //[self.topView setMsg:body withTimestamp:re.timestamp];
        
        self.hasRecord = YES;
    }
    else
    {
        //[self.topView setMsg:nil withTimestamp:0];
    }
}

- (void)onTapClick:(UITapGestureRecognizer *)gesture
{
//    NIMGroupNotificationVC *gnvc = [[NIMGroupNotificationVC alloc]init];
//    [self nim_pushToVC:gnvc animal:YES];
}

#pragma mark configure
- (void)configureCell:(NIMSubTimeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];
    cell.delegate = self;
    [cell updateWithRecordList:recordList isRedAnimating:NO];
    if (indexPath.row == self.fetchGroupMsgController.fetchedObjects.count - 1)
    {
        cell.hasLineLeadingLeft = YES;
    }
}


/**
 *  swTableCellDelegate
 *
 *  @param NSInteger
 *
 *  @return
 */
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ChatListEntity *recordList=nil;
    
    recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];

    BOOL topAlen = recordList.topAlign;
    NSInteger badge =recordList.badge;
    
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteChatLog:recordList.messageBodyId];
//        [self fetchGroupMsgController];
    }];
    deleteRowAction.backgroundColor =  [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    
    UITableViewRowAction * topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (recordList.topAlign==YES) {
            [[NIMGroupOperationBox sharedInstance] swithTop:NO withGroupMsgBodyId:recordList.messageBodyId];
        }else{
            [[NIMGroupOperationBox sharedInstance] swithTop:YES withGroupMsgBodyId:recordList.messageBodyId];
        }
        
    }];
    
    if(topAlen==YES)
    {
        topRowAction.title =@"取消\r置顶";
    }
    else{
        topRowAction.title = @"置顶";
    }
    
    topRowAction.backgroundColor =  [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    
    return @[deleteRowAction,topRowAction];

    
    
//    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){
//        ChatListEntity *recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];
//        
//        [self deleteChatLog:recordList.messageBodyId];
//        
//        [self fetchGroupMsgController];
//        
//    }];
//    deleteRowAction.backgroundColor =[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
//    return @[deleteRowAction];
}



#pragma mark UITableViewDataSource




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0; //群通知
    if ([[self.fetchGroupMsgController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchGroupMsgController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.fetchGroupMsgController)
    {
        NSInteger numberOfRows = [[self.fetchGroupMsgController sections] count];
        return numberOfRows;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMSubTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSubTimeReuseIdentifier forIndexPath:indexPath];
    cell.isBlue = YES;
    cell.delegate=self;

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];
    [recordList messageBodyId];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];
    [recordList messageBodyId];
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    [chatVC setThread:recordList.messageBodyId];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchGroupMsgController objectAtIndexPath:indexPath];
    
    [self deleteChatLog:recordList.messageBodyId];
    
    [self fetchGroupMsgController];
    
    //[[OperationBox sharedInstance] arrangeTheneworder];
}


- (void)deleteChatLog:(NSString*)thread
{
    ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:thread];
    [ChatEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",thread]];
    [recordList NIM_deleteEntity];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NIMMessageManager sharedInstance] removeAllMessageBy:thread];

}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.05;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.05;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView endUpdates];
    });
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableView *tableView = self.tableView;
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
                
                break;
                
            case NSFetchedResultsChangeDelete:
            {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                //栓查是否有通知
                [self checkDataisEmpty];
            }
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(NIMSubTimeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
        }
    });
    
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case NSFetchedResultsChangeInsert:
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            }
                break;
            case NSFetchedResultsChangeDelete:
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            }
                break;
            default:
                break;
        }
    });
}


#pragma mark NSFetchedResultsController
- (void)refreshDataFromDB
{
    //查询已设置为收到群助手的所有群
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid=%lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
    NSArray *list = [GroupList NIM_findAllWithPredicate:pre];
    
    NSMutableArray *source = [NSMutableArray array];
    for (GroupList *item in list)
    {
        [source addObject:item.messageBodyId];
    }
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"messageBodyId in %@ and userId=%lld",source,OWNERID];
    self.fetchGroupMsgController = [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:filter sortedBy:@"topAlign,ct" ascending:NO delegate:self];
    
    if (self.fetchGroupMsgController.fetchedObjects.count == 0)
    {
        self.tipsView.hidden = YES;
        self.tableView.hidden = YES;
        self.nodataView.hidden = NO;
    }
    else
    {
        self.tipsView.hidden = NO;
        self.tableView.hidden = NO;
        self.hasRecord = YES;
        self.nodataView.hidden = YES;
        
        /*
        NSMutableArray *offlines = [NSMutableArray arrayWithCapacity:10];

        for (ChatListEntity *chatList in self.fetchGroupMsgController.fetchedObjects) {
            int64_t msgid = [getObjectFromUserDefault(_IM_FormatStr(@"%@_lateid",chatList.messageBodyId)) longLongValue];
            
            int64_t gid = [NIMStringComponents getOpuseridWithMsgBodyId:chatList.messageBodyId];
            
            QBGroupOfflineBody *body = [[QBGroupOfflineBody alloc] initWithNextMsgId:msgid+1 groupid:gid];
            [offlines addObject:body];
        }
        [[NIMGroupOperationBox sharedInstance] fetchGroupOffline:offlines];
         */
    }
    
    //更新群助手为最后一条非通知类或通知类的消息内容（注意，通知是不管所在的群是否设置了提醒）
    NSPredicate *msg = [NSPredicate predicateWithFormat:@"chatType == 2 AND messageBodyId in %@",source,(long)OWNERID];
    
    NSArray *infos = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:msg];
    if (infos.count > 0)
    {
        NSMutableString *pre = [[NSMutableString alloc] init];
        ChatEntity *itemrecord = infos[0];
        GroupList *group = [GroupList instancetypeFindGroupId:itemrecord.groupId];
        NSString *s = [[NIMOperationBox sharedInstance]getPreviewForGroupAssistantBy:itemrecord];
        
        BOOL isMe = itemrecord.opUserId == OWNERID;
        if (!isMe) {
            NSString *name = group.name;
            if (name.length>12) {
                name = [NSString stringWithFormat:@"%@...：",[name substringToIndex:12]];
            }
            [pre appendString:name];
        }
        [pre appendString:s];
        [[NIMOperationBox sharedInstance]updateGroupAssistant:pre];
    
    }
}

- (NRecordEntity *)getNotifyInfo
{
//    PacketSubtypeTypeGroupAdd         = 301,//邀请好友进群       //消息
//    PacketSubtypeTypeGroupQuit        = 302,//用户主动退群       //消息
//    PacketSubtypeTypeGroupBan         = 303,//群组踢人          //通知
//    PacketSubtypeTypeGroupJoin        = 304,//主动加群          //消息
//    PacketSubtypeTypeGroupChangeCard  = 305,//修改自己的群昵称    //消息
//    PacketContentTypeGroupAgree       = 306,//自己同意入群       //消息
//    PacketContentTypeInvateGroup      = 705,//入群邀请          //通知
//    PacketContentTypeGroupDelete      = 307 //群主解散          //通知
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"((contentSubType == 303 and sender !=%ld) OR contentSubType == 307 OR contentSubType == 705)",(long)OWNERID];

    NSArray *records = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:pre];
    
    if (records.count > 0)
    {
        return records[0];
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
