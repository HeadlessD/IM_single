//
//  NIMFriendNoticeViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/8/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMFriendNoticeViewController.h"
#import "NIMSelfViewController.h"
#import "NIMSubAccessoryTableViewCell.h"
#import "NIMFriendNoticeDetailViewController.h"
#import "NIMNoneView.h"

#import "NIMUserOperationBox.h"
//#import "MessageNIMOperationBox.h"
#import "NIMChatUIViewController.h"
#import "NIMNoneView.h"

#import "NIMAddDescViewController.h"

@interface NIMFriendNoticeViewController ()<NSFetchedResultsControllerDelegate, VcardTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * noneView;


@end

@implementation NIMFriendNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reloadFetchedResult];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = NO;
//    [self setExtendedLayoutIncludesOpaqueBars:NO];

    [self qb_setTitleText:@"新的朋友"];
    self.view.backgroundColor =[SSIMSpUtil getColor:@"F1F1F1"];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];

    _noneView = [[NIMNoneView alloc]initWithString:@"暂未收到新的好友申请"];
    [self.tableView addSubview:_noneView];
    
    if (self.fetchedResultsController.fetchedObjects.count ==0){
        _noneView.hidden =NO;
    }else{
        _noneView.hidden =YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recvNC_FRIEND_UPDATE_RQ:) name:NC_FRIEND_UPDATE_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSomeOneAddMeNotification) name:NC_SERVER_FRIEND_ADD_RQ object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView setFrame:CGRectMake(0, IPX_TOP_SAFE_H, SCREEN_WIDTH, SCREEN_HEIGHT - IPX_NAVI_H - IPX_BOTTOM_SAFE_H)];
}

//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    if (KIsiPhoneX) {
//        [self.tableView setFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-118)];
//    }
//}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)recvSomeOneAddMeNotification
{
    [self reloadFetchedResult];
}

//清除所有未读红点
-(void)cleanRed{
    NSManagedObjectContext * manageObject = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    NSArray * unreadCounts = [FDListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and isInNewFriend == 1 and fdUnread == 1",OWNERID]];
    if (unreadCounts > 0) {
        for (FDListEntity * fdlist in unreadCounts) {
            fdlist.fdUnread = NO;
        }
    }
    [manageObject MR_saveToPersistentStoreAndWait];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //离开页面 清除红点
    [self cleanRed];
    //[[NIMUserOperationBox sharedInstance] resetNewFriendBadgeNotification];
    [super viewWillDisappear:animated];
//    _fetchedResultsController = nil;
//    _fetchedResultsController.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadFetchedResult
{
    self.fetchedResultsController = nil;
    self.fetchedResultsController.delegate = nil;
    [self.tableView reloadData];
    
    if (self.fetchedResultsController.fetchedObjects.count ==0){
        _noneView.hidden =NO;
    }else{
        _noneView.hidden =YES;
    }
}
- (void)showNewFriendRequestDetail:(VcardEntity*)user animated:(BOOL)animated
{
    NIMFriendNoticeDetailViewController *noticeDetail = [[NIMFriendNoticeDetailViewController alloc] init];
    noticeDetail.vcardEntity = user;
    [noticeDetail setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:noticeDetail animated:YES];
}

- (void)showFeedProfileWithuserid:(int64_t)userid animated:(BOOL)animated
{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType = SearchSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

#pragma mark config
- (void)updateCell:(NIMSubAccessoryTableViewCell *)cell withNContactEntity:(VcardEntity *)contactEntity{
    cell.delegate = self;
    [cell makeConstraints];
    
    FDListEntity * fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,contactEntity.userid]];
    
    NIMFriendshipType friendshipType = fdlist.fdFriendShip;
    
    NSLog(@"vcardEntity.friendship:%ld",(long)friendshipType);
    
    [cell updateWithVcardEntity:contactEntity];
}

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FDListEntity *friendEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (friendEntity.fdPeerId) {
        [self showFeedProfileWithuserid:friendEntity.fdPeerId animated:YES];
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){
        NSManagedObjectContext * manageObject = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        FDListEntity * friendEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        if (friendEntity.fdFriendShip != FriendShip_Friended) {
            [[NIMFriendManager sharedInstance] sendDelUpdateFriendRQ:friendEntity.fdPeerId];
        }else{
            friendEntity.isInNewFriend = NO;
        }
        [manageObject MR_saveToPersistentStoreAndWait];
        [self reloadFetchedResult];
    }];
    deleteRowAction.backgroundColor =[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    return @[deleteRowAction];
}

- (void)tableViewCell:(NIMDefaultTableViewCell *)cell didSelectedWithType:(FriendActionType)type userid:(int64_t)userid{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (type == FriendActionTypeTypeToAdd) {
        NIMAddDescViewController *descViewController = [[NIMAddDescViewController alloc] init];
        descViewController.userId = userid;
        descViewController.addSourceType = FD_ADD_TYPE_CONTACTS;
        descViewController.addBackRefesh = ^(){
            [self reloadFetchedResult];
        };
        
        UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: descViewController];
        [self presentViewController:presNavigation animated:YES completion:nil];
    }else if (type == FriendActionTypeTypeToAgree){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_CLIENT_FRIEND_CONFIRM_RQ:) name:NC_CLIENT_FRIEND_CONFIRM_RQ object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        });
        [[NIMFriendManager sharedInstance] sendFriendConRQ:userid result:0];
    }
}

-(void)recvNC_CLIENT_FRIEND_CONFIRM_RQ:(NSNotification *)noti
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }
        [self reloadFetchedResult];
    }else{
        UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [netAlert addAction:nAction];
        [self presentViewController:netAlert animated:YES completion:^{
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    return numberOfRows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMSubAccessoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubAccessoryReuseIdentifier];
    if (cell == nil) {
        cell = [[NIMSubAccessoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSubAccessoryReuseIdentifier];
    }
    //    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate=self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark config
- (void)configureCell:(NIMSubAccessoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    FDListEntity * fDListEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    VcardEntity * vcardEntity = fDListEntity.vcard;
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:fDListEntity.fdPeerId];
    }
    if (vcardEntity) {
        cell.delegate = self;
        [cell updateWithVcardEntity:vcardEntity];
        if (indexPath.row == self.fetchedResultsController.fetchedObjects.count - 1) {
            cell.hasLineLeadingLeft = YES;
        }
    }else{
        cell.introLablel.text = @"加载中";
    }
    [cell makeConstraints];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    FDListEntity * fdlist = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    VcardEntity *vcard = fdlist.vcard;
    if (vcard == nil) {
        vcard = [VcardEntity instancetypeFindUserid:fdlist.fdPeerId];
    }
    
    NIMFriendshipType friendshipType = fdlist.fdFriendShip;
    int64_t balance = (([NIMBaseUtil GetServerTime]/1000) - fdlist.ct)/1000;
    
    if (friendshipType == FriendShip_Ask_Me && (balance < (259200/30))) {
        [self showNewFriendRequestDetail:vcard animated:YES];
    }else{
        [self showFeedProfileWithuserid:vcard.userid animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //if(controller.fetchedObjects.count>0)
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //if(controller.fetchedObjects.count>0)
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableView *tableView = self.tableView;
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
            case NSFetchedResultsChangeMove:
                
            {
                [self reloadFetchedResult];
                
                //            NIMSubAccessoryTableViewCell *cell = (NIMSubAccessoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                //            [self configureCell:cell atIndexPath:indexPath];
                //            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
        }
    });
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger newSectionIndex = sectionIndex;
        
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:break;
            case NSFetchedResultsChangeMove:break;
        } 
    });
}
- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];;
}

#pragma mark fetch
- (NSFetchedResultsController *)fetchedResultsController{
    {
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController;
        }
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and isInNewFriend = %d and fdFriendShip != %d and fdFriendShip != %d",OWNERID,YES,FriendShip_Ask_Peer,FriendShip_NotFriend];
        NSFetchRequest * preRequest = [FDListEntity NIM_requestAllSortedBy:@"ct" ascending:NO withPredicate:pre];
        _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:preRequest managedObjectContext:[[NIMCoreDataManager currentCoreDataManager] privateObjectContext] sectionNameKeyPath:nil cacheName:nil];
        
        _fetchedResultsController.delegate = self;
                
        NSError *error;
        
        if (![_fetchedResultsController performFetch:&error]) {
            DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
        }
        return _fetchedResultsController;
    }
}

-(void)recvNC_FRIEND_UPDATE_RQ:(NSNotification *)noti{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showTipsView:param.p_string atView:self.view];
            }else{
                [MBTip showTipsView:@"删除成功" atView:self.view];
                [self reloadFetchedResult];
            }
        }else{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
        }
    });
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight =0;
        self.tableView.estimatedSectionHeaderHeight =0;
        self.tableView.estimatedSectionFooterHeight =0;

        [self.view addSubview:_tableView];
        
         [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.leading.equalTo(@0);
         make.top.equalTo(@0);
         make.trailing.equalTo(@0);
         make.bottom.equalTo(@0);
         }];
        
    }
    return _tableView;
}

- (void)dealloc{
//    _fetchedResultsController = nil;
//    _fetchedResultsController.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
