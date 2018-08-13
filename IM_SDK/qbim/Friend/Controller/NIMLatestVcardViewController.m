//
//  NIMLatestVcardViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/9/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMLatestVcardViewController.h"
#import "NIMDefaultTableViewCell.h"
#import "NIMGroupCreateVC.h"

@interface NIMLatestVcardViewController ()<NSFetchedResultsControllerDelegate, GroupCreateViewControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@end

@implementation NIMLatestVcardViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    [self qb_setTitleText:@"选择"];
    [self reloadFetchedResults:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageStatus:) name:NC_MESSAGE_STATUS object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark data
- (void)reloadFetchedResults:(NSNotification*)note
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
        
        if (note) {
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark actions
- (void)qb_back{
    
    if (_isShare) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [_delegate latestVcardViewController:self didSendThread:@"" completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
        
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)backAction:(id)sender{
    
    [self qb_back];
}

- (void)showVcardController{
    [self showGroupCreateViewController];
    return;
}

- (void)sendMessageToThread:(NSString *)thread{
    
    if ([_delegate respondsToSelector:@selector(latestVcardViewController:didSendThread:completeBlock:)]) {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_delegate latestVcardViewController:self didSendThread:thread completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            [MBTip showError:@"已发送" toView:self.view];
            [self performSelector:@selector(backAction:) withObject:nil afterDelay:1.0];
        }];
    }
}


//-(void)messageStatus:(NSNotification *)noti
//{
//    id object = noti.object;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if (!object) {
//            [MBTip showError:@"转发失败" toView:nil];
//        }else{
//            [MBTip showError:@"已发送" toView:nil];
//            [self performSelector:@selector(backAction:) withObject:nil afterDelay:1.0];
//        }
//    });
//}

- (void)showGroupCreateViewController{
    NIMGroupCreateVC *groupCVC = (NIMGroupCreateVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupCreateVC"];
    groupCVC.groupCreateType = GroupCreateTypeForward;
    groupCVC.delegate = self;
    [self.navigationController pushViewController:groupCVC animated:YES];
}

-(void)didSelectRowWithMbd:(NSString *)messageBodyId
{
    NSString *name = nil;
    E_MSG_CHAT_TYPE type = [NIMStringComponents chatTypeWithMsgBodyId:messageBodyId];
    int64_t opuserid = [NIMStringComponents getOpuseridWithMsgBodyId:messageBodyId];

    switch (type) {
        case GROUP:
        {
            GroupList * groupList =  [GroupList instancetypeFindGroupId:opuserid];
            if (groupList) {
                name = groupList.name;
            }
        }
            break;
        case PUBLIC:
        {
            NOffcialEntity * offcialEntity =  [NOffcialEntity findFirstWithOffcialid:opuserid];
            if (offcialEntity) {
                name = offcialEntity.name;
            }
        }
            break;
        case PRIVATE:
        {
            name = [NIMStringComponents finFristNameWithID:opuserid];

        }
            break;
            
        default:
            break;
    }
    //未查找到的用户暂时显示ID
    if (!name) name = [NSString stringWithFormat:@"%lld",opuserid];
    NSString *tips = [NSString stringWithFormat:@"确定发送给\"%@\"",name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_isShare) {
            SSIMShareModel *model = self.objectForward;
            SSIMMessage *message = [[SSIMMessage alloc] init];
            NSDictionary *dict = [[NSDictionary alloc] init];
            if (model) {
                dict = @{@"product_title":model.title?:@"",
                         @"main_img":model.imgUrl?:@"",
                         @"product_name":model.desc?:@"",
                         @"source_img":model.sourceImg?:@"",
                         @"source_txt":model.sourceTxt?:@"",
                         @"url":model.url?:@""
                         };
            }
            message.userid = OWNERID;
            message.chatType = [NIMStringComponents chatTypeWithMsgBodyId:messageBodyId];
            message.toid = [NIMStringComponents getOpuseridWithMsgBodyId:messageBodyId];
            message.mtype = ITEM;
            message.stype = CHAT;
            message.etype = DEFAULT;
            message.msgContent = dict;
            
            [[SSIMClient sharedInstance] sendMessage:message callBackBlock:^(id object, SDK_MESSAGE_RESULT result) {
                if (result) {
                    [MBTip showError:_IM_FormatStr(@"发送失败(%d)",result) toView:nil];
                }else{
                    [MBTip showError:@"已发送" toView:nil];
                    [self performSelector:@selector(backAction:) withObject:nil afterDelay:1.0];
                }
            }];
        }else{
            [self sendMessageToThread:messageBodyId];
        }
    }];
    
    UIAlertAction *canAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:canAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark GroupCreateViewControllerDelegate
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didBackWithCompleteBlock:(VcardCompleteBlock)completeBlock{
    completeBlock(VcardSelectedActionTypeForward,nil,nil);
}
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectedThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    
    completeBlock(VcardSelectedActionTypeForward,self.objectForward,nil);

}

-(void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectRow:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock
{
    [self didSelectRowWithMbd:thread];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0) {
        return 1;
    }
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section-1];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberOfRows = 0;
    if (self.fetchedResultsController) {
        numberOfRows = [[self.fetchedResultsController sections] count];
    }
    return numberOfRows+1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = @"创建新聊天";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    NIMDefaultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
    NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    [self configureCell:cell atIndexPath:theIndexPath];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *titleForHeader = nil;
    if (section == 1) {
        titleForHeader = @"最近聊天";
    }
    return titleForHeader;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ) {
        return 20;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController objectAtIndexPath:theIndexPath];
        NSString *thread = recordList.actualThread;
        [self didSelectRowWithMbd:thread];
    }else {
        [self showVcardController];
    }
}



- (void)configureCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    E_MSG_CHAT_TYPE chatType = recordList.chatType;
    NSString *thread = recordList.messageBodyId;
    
    switch (chatType) {
        case GROUP:
        {
            GroupList *groupEntity = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",thread]];
            [cell updateWithGroupEntity:groupEntity];
        }
            break;
        case PRIVATE:
        {
            int64_t userid = [NIMStringComponents getOpuseridWithMsgBodyId:thread];
            VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:userid];
            if (vcardEntity==nil) {
                vcardEntity = [VcardEntity NIM_createEntity];
                vcardEntity.userid = userid;
            }
            [cell updateWithVcardEntity:vcardEntity];
        }
            break;
        default:
            break;
    }
    [cell makeConstraints];
}


#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(controller.fetchedObjects.count>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
        });
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(controller.fetchedObjects.count>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView endUpdates];
        });
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableView *tableView = self.tableView;
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
        NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section +1];
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:theNewIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadData];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:theNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
            case NSFetchedResultsChangeDelete:
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
            default:
                break;
        }
    });
    
}

#pragma mark getter
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((chatType == %d) OR (chatType == %d)) AND userId == %lld",GROUP,PRIVATE,OWNERID];
    _fetchedResultsController = [ChatListEntity NIM_fetchAllGroupedBy:nil
                                                withPredicate:predicate sortedBy:@"ct" ascending:NO delegate:self];
    return _fetchedResultsController;
}

@end
