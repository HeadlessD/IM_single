//
//  NIMGroupVC.m
//  QianbaoIM
//
//  Created by liunian on 14/8/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMGroupVC.h"
#import "NIMSubDetailTableViewCell.h"
#import "NIMGroupCreateVC.h"
#import "NIMChatGroupSettingVC.h"
#import "NIMChatUIViewController.h"
#import "NIMLatestVcardViewController.h"
#import "NIMNoneView.h"

@interface NIMGroupVC ()<NSFetchedResultsControllerDelegate,GroupCreateViewControllerDelegate, VcardTableViewCellDelegate,NIMSubDetailTableViewCellDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong)UILabel *blankLabel;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic, strong) UIView * noneView;

@end

@implementation NIMGroupVC
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.refreshControl = [[UIRefreshControl alloc]init];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self action:@selector(refreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NIMSubDetailTableViewCell class] forCellReuseIdentifier:kSubDetailReuseIdentifier];
    //self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    self.automaticallyAdjustsScrollViewInsets = NO;

    _noneView = [[NIMNoneView alloc]initWithString:@"你可通过群聊中的“保存到通讯录”选项,将其保存到这里"];
    [self.tableView addSubview:_noneView];

    if (_fromCreateGroup) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.fetchedResultsController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchGroupList:) name:NC_FETCH_GROUP_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupAvatarModify:) name:NC_GROUP_AVATAR_MODIFY object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.fetchedResultsController.fetchedObjects.count ==0)
    {
        _noneView.hidden=NO;
    }
    else
    {
        _noneView.hidden=YES;
    }
}

-(void)fetchGroupList:(NSNotification *)notification
{
    [self reloadDataFromDB];
    [self.refreshControl endRefreshing];
    id object = notification.object;
    if (object==nil) {
        NSLog(@"获取群列表失败");
    }
}

-(void)groupAvatarModify:(NSNotification *)notification
{
    if (notification.object) {
        NSDictionary *dict = notification.object;
        int64_t groupid = [[dict objectForKey:@"key1"] longLongValue];
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:groupList];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (IBAction)addGroupChat:(id)sender
{
    NIMGroupCreateVC *groupCVC = (NIMGroupCreateVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupCreateVC"];
    groupCVC.delegate = self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:groupCVC];
    [self.navigationController presentViewController:nav animated:YES completion:^{
    }];
}
#pragma mrak VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GroupList *groupEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self showGroup:groupEntity animated:YES];
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


////////////
#pragma mark fetch


- (void)reloadDataFromDB{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        DLog(@"%@",[error debugDescription]);
    }else{
        if (self.fetchedResultsController.fetchedObjects.count ==0){
            _noneView.hidden = NO;
        }else{
            _noneView.hidden = YES;
        }
        
        NSArray *fs = self.fetchedResultsController.fetchedObjects;
//        DBLog(@"fs=%@",fs);
        
        for (GroupList *glist in fs)
        {
            NSLog(@"glist = %lu",glist.members.count);
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
 
}
#pragma mark actions


#pragma mark push
- (void)showChatControllerWithGroup:(GroupList *)group{
//    [[NIMGroupOperationBox sharedInstance] sendGroupModifyChangeRQWithType:KICK_USER opUserid:614401 groupid:group.groupId];
    
    
    if ([_delegate respondsToSelector:@selector(groupViewController:didSelectedWithGroupEntity:completeBlock:)]) {
        [_delegate groupViewController:self didSelectedWithGroupEntity:group completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (actionTyoe) {
                    case VcardSelectedActionTypeForward:
                    {
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[NIMLatestVcardViewController class]]) {
                                [self.navigationController popToViewController:controller animated:YES];
                                break;
                            }
                        }
                        if ([_delegate respondsToSelector:@selector(groupViewController:didSelectRow:completeBlock:)]) {
                            [_delegate groupViewController:self didSelectRow:group.messageBodyId completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
                                
                            }];
                        }
                    }
                        break;
                    case VcardSelectedActionTypeChat:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
                
            });
        }];
        return;
    }
    
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    [chatVC setThread:group.messageBodyId];
    [chatVC setActualThread:group.messageBodyId];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];

}

- (void)showGroup:(GroupList *)group animated:(BOOL)animated{
    if (group) {
        NIMChatGroupSettingVC* groupSetting = (NIMChatGroupSettingVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMChatGroupSettingIdentity"];
        groupSetting.groupList = group;
        [self.navigationController pushViewController:groupSetting animated:YES];
    }
}

#pragma mark config
- (void)configureCell:(NIMSubDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GroupList *groupEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell updateWithGroupList:groupEntity];
    cell.delegate = self;
    if (indexPath.row == self.fetchedResultsController.fetchedObjects.count - 1) {
        cell.hasLineLeadingLeft = YES;
        
    }
    [cell makeConstraints];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    return numberOfRows;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return @"搜索结果";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMSubDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubDetailReuseIdentifier forIndexPath:indexPath];
    cell.datasource=self;//让控制器成为cell的代理
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
#pragma mark - UITableViewDelegate
//cell加载完成 再刷新一次获取群头像
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
//        //end of loading
//        
//        NSUserDefaults *reload = [NSUserDefaults standardUserDefaults];
//        
//        BOOL re = [reload objectForKey:@"re"];
//        
//        if (re) {
//            return;
//        }
//        [self.tableView reloadData];
//        [reload setBool:YES forKey:@"re"];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 1) {
        return 0.1;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupList *groupEntity  = nil;
    groupEntity = (GroupList *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [self showChatControllerWithGroup:groupEntity];
}


- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];;
}

#pragma mark fetch
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSPredicate *pre = nil;
    if (_fromCreateGroup) {
        pre = [NSPredicate predicateWithFormat:@"memberid=%lld AND type != %d",OWNERID,NIM_INGROUP_STATUS_BANNED];

    }else{
        pre = [NSPredicate predicateWithFormat:@"savedwitch=%d AND memberid=%lld AND type != %d",YES,OWNERID,NIM_INGROUP_STATUS_BANNED];

    }
    _fetchedResultsController = [GroupList NIM_fetchAllSortedBy:@"allFullLitter" ascending:YES withPredicate:pre groupBy:nil delegate:self];
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

-(void)dealloc{
    self.fetchedResultsController.delegate=nil;
    self.fetchedResultsController=nil;
    self.dic=nil;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    if(controller.fetchedObjects.count>0)
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    if(controller.fetchedObjects.count>0)
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView endUpdates];
    });
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath;{
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableView *tableView = self.tableView;
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
                
            case NSFetchedResultsChangeUpdate:
            {
                if (!newIndexPath) {
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]        withRowAnimation:UITableViewRowAnimationNone];
                }
                break;
            }
                
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
        NSInteger newSectionIndex = sectionIndex;
        
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
                
            case NSFetchedResultsChangeDelete:
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            case NSFetchedResultsChangeUpdate:break;
            case NSFetchedResultsChangeMove:break;
        }
    });
    
}

@end
