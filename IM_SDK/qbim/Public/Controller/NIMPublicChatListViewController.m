//
//  QBPublicChatListViewController.m
//  QianbaoIM
//
//  Created by qianwang on 15/6/16.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicChatListViewController.h"
#import "NIMSubTimeTableViewCell.h"
#import "NIMChatUIViewController.h"
#import "NIMOperationBox.h"

@interface NIMPublicChatListViewController ()<UITableViewDataSource,UITableViewDelegate,VcardTableViewCellDelegate,NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController   *fetchedResultsController;
@property (nonatomic, strong) UITableView                  *tableView;

@end

@implementation NIMPublicChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout               = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self qb_setTitleText:@"公众号消息"];
    [self fetchedResultsController];
    [self.tableView registerClass:[NIMSubTimeTableViewCell class] forCellReuseIdentifier:kSubTimeReuseIdentifier];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self fetchedResultsController];
//    int totalUnreadCount  = 0;
//    for (int i = 0; i < _fetchedResultsController.fetchedObjects.count; i ++)
//    {
//        NRecordList *recd = [_fetchedResultsController.fetchedObjects objectAtIndexedSubscript:i];
//        totalUnreadCount += recd.badge;
//    }
//    [[NIMOperationBox sharedInstance] updatePublicPacketUnreadShow:NO];
}

-(void)reflashTableData
{
    NSError *error = nil;
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
        [self fetchedResultsController];
        if (_fetchedResultsController) {
            if (![_fetchedResultsController performFetch:&error])
            {
                DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [self.tableView reloadData];
        }

}

#pragma mark configure
- (void)configureCell:(NIMSubTimeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.delegate = self;
    [cell updateWithRecordList:recordList isRedAnimating:NO];
    if (indexPath.row == self.fetchedResultsController.fetchedObjects.count - 1) {
        cell.hasLineLeadingLeft = YES;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.fetchedResultsController) {
        NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
        return numberOfRows;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMSubTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSubTimeReuseIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_OfficialChat)];

    ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    chatVC.thread = recordList.messageBodyId;
    chatVC.actualThread = recordList.actualThread;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self deleteChatLog:recordList.messageBodyId];
    
    [self fetchedResultsController];
    
    /*
    if (self.fetchedResultsController.fetchedObjects.count == 0)
    {
        NRecordList *recordList = [NRecordList  NIM_findFirstByAttribute:@"thread" withValue:kPublicPacketThread];
        [recordList NIM_deleteEntity];
        [[CoreDataManager currentCoreDataManager] saveDataToDisk];
    }
     */
    [[NIMOperationBox sharedInstance] arrangeTheneworder];
}

- (void)deleteChatLog:(NSString*)thread
{
    ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:thread];
    NSArray* records = [ChatEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",thread]];
    [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[ChatEntity class]])
        {
            ChatEntity* r = (ChatEntity*)obj;
            [r NIM_deleteEntity];
        }
    }];
    [recordList NIM_deleteEntity];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
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
    //    if(controller.fetchedObjects.count>0)
    [self.tableView beginUpdates];
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //    if(controller.fetchedObjects.count>0)
    [self.tableView endUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
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
            [self configureCell:(NIMSubTimeTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
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
}


#pragma mark NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"isflod == %d AND userId == %lld",YES,OWNERID];
    _fetchedResultsController = [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:pre sortedBy:@"ct" ascending:NO delegate:self];
    return _fetchedResultsController;
}

- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight =0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        [self.view addSubview:_tableView];
        [_tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
        }];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
