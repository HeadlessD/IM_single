//
//  NIMBusinessTableVC.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/11/14.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBusinessTableVC.h"
//#import "NIMBusinessTableViewCell.h"
#import "NIMManager.h"
#import "NIMChatUIViewController.h"
#import "NIMSubTimeTableViewCell.h"
#import "NIMCCEaseRefresh.h"
#import "NIMNoneView.h"

@interface NIMBusinessTableVC ()<NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NIMCCEaseRefresh * pullRefresh;
}
@property (nonatomic, strong) NSFetchedResultsController * businFetchedResult;
@property (nonatomic, strong) UIView * noneView;

@end
@implementation NIMBusinessTableVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NIMSysManager sharedInstance] setIsInBuiness:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self cleanRed];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUI) name:NC_REFRESH_UI object:nil];

    self.view.backgroundColor =[SSIMSpUtil getColor:@"F1F1F1"];

    [self reloadFetchedResult];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self qb_setTitleText:@"店铺消息"];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    [self qb_setStatusBar_Default];
    self.businFetchedResult.delegate = self;
    
    
    _noneView = [[NIMNoneView alloc]initWithString:@"暂无商家消息"];
    [self.tableView addSubview:_noneView];

    //下拉刷新
    pullRefresh = [[NIMCCEaseRefresh alloc]initInScrollView:self.tableView];
    [pullRefresh addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [pullRefresh beginRefreshing];
 
    if (self.businFetchedResult.fetchedObjects.count ==0){
        _noneView.hidden =NO;
    }else{
        _noneView.hidden =YES;
    }
}

-(void)reflashUI{
    [self reloadFetchedResult];
}


- (void)dropViewDidBeginRefreshing:(NIMCCEaseRefresh *)refreshControl
{
    double delayInSeconds = 1.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        
        //[self endRefreshing];
        // iOS，离线好友会话消息，一键下拉清除后，未读提醒依然显示
        [self closeRefreshing];
    });
}


- (void)closeRefreshing{
    dispatch_queue_t queue = dispatch_queue_create("com.fsh.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSUInteger count = self.businFetchedResult.fetchedObjects.count;
        
        for (NSInteger i = 0 ; i < count; i++) {
            ChatListEntity *recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:i];
            if (recordList.badge != 0){
                recordList.badge = 0;
                [[NIMOperationBox sharedInstance] resetRecordListThread:recordList.messageBodyId isHomePageShow:YES];
            }
        }
    });
    //    __block AppDelegate* delegate;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        for (NIMSubTimeTableViewCell * cell in self.tableView.visibleCells){
            if (![cell.badgeLabel isHidden]) {
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [cell disAppearRedPointWtihCompletion:^(BOOL finished) {
                        dispatch_semaphore_signal(semaphore);
                    }];
                });
                dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
                if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                    NSLog(@"11111111111111111");
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadFetchedResult];
            //            delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            //            [delegate setBadgeValue:[NSString stringWithFormat:@"%d",0/*(long)taskList.badge*/] withIndex:1];
//            isRedAnimating = NO;
        });
    });
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NIMSubTimeTableViewCell *cell = (NIMSubTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kSubTimeReuseIdentifier];
    if (cell == nil) {
        cell = [[NIMSubTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSubTimeReuseIdentifier];
    }
    //取消点击背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    ChatListEntity * recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:indexPath.row];
    [cell updateWithRecordList:recordList isRedAnimating:nil];
    return cell;
}

//数据源赋值
-(NSFetchedResultsController *)businFetchedResult{
    if (_businFetchedResult != nil) {
        return _businFetchedResult;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId = %lld and (chatType == %d or chatType ==%d)",OWNERID,5,6];
    _businFetchedResult =  [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:pre sortedBy:@"messageBodyIdType,topAlign,ct" ascending:NO delegate:nil];
    
    _businFetchedResult.delegate = self;
    [NSFetchedResultsController deleteCacheWithName:nil];
    NSError *error;
    
    if (![_businFetchedResult performFetch:&error]) {
        DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
    }
    return _businFetchedResult;
}

//清除所有未读红点
-(void)cleanRed{
    NSManagedObjectContext * manageObject = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSArray * unreadArr = [ChatListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"shopAssistantRead > 0 and userId == %lld",OWNERID]];
    
    if (unreadArr.count > 0) {
        for (ChatListEntity * chatList in unreadArr) {
            chatList.shopAssistantRead = 0;
        }
    }
    [manageObject MR_saveToPersistentStoreAndWait];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    NSInteger numberOfRows =  self.businFetchedResult.fetchedObjects.count;
    
    return numberOfRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListEntity * recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:indexPath.row];
//    NBusinessEntity * busineEntity = [NBusinessEntity instancetypeFindBid:[NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId]];
    
    int64_t bid = [NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId];
    
    NSString *actualThread = [NSString stringWithFormat:@"%@:%lld",recordList.messageBodyId,bid];
    
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    
    chatVC.backReadClean = ^(void){
        NSIndexPath * indexPath_1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
       
        NSLog(@"返回刷单行");
    };

    chatVC.isGoods = NO;
    chatVC.thread = recordList.messageBodyId;
    chatVC.actualThread = actualThread;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListEntity * recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:indexPath.row];
    
    NSInteger badge =recordList.badge;
    
    UITableViewRowAction * deletAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSManagedObjectContext * manObj = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        
        //        NBusinessEntity * busineEntity = [NBusinessEntity instancetypeFindMsgBodyId:recordList.messageBodyId];
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"messageBodyId = %@",recordList.messageBodyId];
        
        [ChatListEntity NIM_deleteAllMatchingPredicate:pre];
        [ChatEntity NIM_deleteAllMatchingPredicate:pre];
        [[NIMMessageManager sharedInstance] removeAllMessageBy:recordList.messageBodyId];
        [manObj MR_saveToPersistentStoreAndWait];
        
        [self reloadFetchedResult];
    }];
    
    deletAction.backgroundColor =  [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    
    UITableViewRowAction * topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSManagedObjectContext * manObj = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        
        //        ChatListEntity * recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:indexPath.row];
        
        
        
        recordList.topAlign = !recordList.topAlign;
        
        [manObj MR_saveToPersistentStoreAndWait];
        
        [self reloadFetchedResult];
    }];
    topAction.backgroundColor =  [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    if(recordList.topAlign == YES)
    {
        topAction.title =@"取消\r置顶";
    }
    else{
        topAction.title = @"置顶";
    }
    
    UITableViewRowAction * readAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标记为已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //        ChatListEntity * recordList = (ChatListEntity *)[self.businFetchedResult.fetchedObjects objectAtIndex:indexPath.row];
        
        if(recordList.badge!=0){
            
            recordList.badge=0;
            
            NSArray *recordEntitys = [ChatEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(messageBodyId == %@) AND (unread == 1)",recordList.messageBodyId]];
            
            [recordEntitys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                ChatEntity *Entity = obj;
                [Entity setUnread:NO];
            }];
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            
        }else{
            recordList.badge=1;
        }
        
        [self reloadFetchedResult];
        
    }];
    
    
    if(badge!=0){
        readAction.title =@"标为\r已读";
    }else{
        readAction.title =@"标为\r未读";
    }
    
    
    readAction.backgroundColor =  [UIColor orangeColor];
    
    return @[deletAction,readAction,topAction];
}

- (void)reloadFetchedResult
{
    
    _businFetchedResult = nil;
    _businFetchedResult.delegate = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        if (_businFetchedResult.fetchedObjects.count ==0)
        {
            _noneView.hidden =NO;
        }else{
            _noneView.hidden =YES;
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
