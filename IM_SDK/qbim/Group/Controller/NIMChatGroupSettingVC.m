//
//  GroupSettingViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/8/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMChatGroupSettingVC.h"
#import "NIMGroupOperationBox.h"
#import "NIMVcardCollectionViewCell.h"
//#import "GroupList.h"
 
 
#import "GMember+CoreDataClass.h"
//#import "VcardEntity+CoreDataClass.h"
#import "NIMSelfViewController.h"
#import "NIMMemberVC.h"
#import "NIMGroupAddVC.h"
#import "NIMGroupRemoveVC.h"
#import "NIMGroupCardInfoVC.h"
#import "NIMEditGroupNameVC.h"
#import "NIMMessageCenter.h"
#import "NIMGroupManagerVC.h"
#import "NIMGroupRemarkVC.h"
#import "SSIMThreadViewController.h"
#import "NIMActionSheet.h"

@interface NIMChatGroupSettingVC ()<NSFetchedResultsControllerDelegate,NIMEditGroupNameVCDelegate, VcardCollectionViewCellDelegate>
@property(nonatomic, strong) NSArray *memberDatasource;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController* fetchedMembersResultsController;
@property (nonatomic, assign) BOOL deleteChatInfo;
@property (nonatomic, weak) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

//本人为群主？
@property (nonatomic, assign) BOOL selfisMaster;
@property (nonatomic, assign) BOOL isBanned;

@end

@implementation NIMChatGroupSettingVC
NSString * const  TIPS = @"非群成员不可操作";
- (void)dealloc{
    _fetchedResultsController.delegate = self;
    _fetchedResultsController = nil;
    _memberDatasource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"群聊设置"];
    self.viewRedpoint.layer.cornerRadius = 5;
    self.viewRedpoint.backgroundColor = [UIColor redColor];
    self.viewRedpoint.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    _isBanned = NO;
    _swNewsNotfication.on = _groupList.apnswitch;//http://jira.qbao.com/browse/CLIENT-1173“新消息通知”默认开，改成“消息免打扰”默认关
    _swShowNickName.on = _groupList.showname;
    _swSaveBook.on = _groupList.savedwitch;
    ChatListEntity *chatListEntity = [ChatListEntity findFirstWithMessageBodyId:self.groupList.messageBodyId];
    _swSetTop.on = chatListEntity.topAlign;
    [self.collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:kvcardIdentifier];
    self.tableView.backgroundColor = [UIColor whiteColor];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    [self.swSaveBook addTarget:self action:@selector(saveBooks:) forControlEvents:UIControlEventTouchUpInside];
    [self reloadResult];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1];
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupDeatil:) name:NC_GROUP_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvExitGroup:) name:NC_EXIT_GROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvKicketGroup:) name:NC_KICKET_GROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadResult) name:NC_GROUPMEMBERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadResult) name:NC_GROUPLEADERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvgroupMsgStatus:) name:NC_GROUP_MESSAGE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvgroupSaveStatus:) name:NC_GROUP_SAVE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvRemarkDetail:) name:NC_GROUP_REMARK_DETAIL object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isBanned) {
        _swSaveBook.on = NO;
    }
    [self addObserver];
    [self request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dataSave];
    if(_deleteChatInfo)
    {
        NSString* thread = self.groupList.messageBodyId;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteChatLogFormNotification" object:thread];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataSave
{
    
    if (!_groupList) {
        return;
    }
    
    if((_groupList.apnswitch)!=_swNewsNotfication.on)
    {
//        [[NIMGroupOperationBox sharedInstance] switchGroup:self.groupList.groupId
//                                               apnWitch:_swNewsNotfication.on
//                                          completeBlock:^(id object, NINIMesultMeta *result) {
//                                              if(!result)
//                                              {
//                                
//                                              }
//                                              
//                                          }];
    }
    
    if(self.groupList.savedwitch!=_swSaveBook.on)
    {
//        [[NIMGroupOperationBox sharedInstance] switchGroup:self.groupList.groupId
//                                      toAddressBookSave:_swSaveBook.on
//                                          completeBlock:^(id object, NINIMesultMeta *result) {
//                                              if(!result)
//                                              {
//
//                                              }
//                                          }];
    }

    if(self.groupList.showname!=_swShowNickName.on)
    {
//        [[NIMGroupOperationBox sharedInstance] switchNameShow:_swShowNickName.on withGroupThread:_groupList.thread];
        if (_delegate && [_delegate respondsToSelector:@selector(reloadTableIfNameShow)]) {
            [_delegate reloadTableIfNameShow];
        }
    }
    [self.tableView reloadData];
    
//    [[NIMGroupOperationBox sharedInstance] swithTop:_swSetTop.on withGroupThread:_groupList.thread];
}
- (void)qb_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCellValues
{
    _labGroupNumber.text = [NSString stringWithFormat:@"%lu人",(unsigned long)self.groupList.membercount];
    _labGroupName.text = self.groupList.name;
    _labUserNickName.text = @"暂无";
    _capacityLabel.text = [NSString stringWithFormat:@"%d 人",self.groupList.capacity];
    _remarkLabel.text = self.groupList.remark;
    
    NSString *notify = nil;
    switch (self.groupList.switchnotify) {
        case GROUP_MESSAGE_STATUS_NORMAL:
            notify = @"接收消息并提醒";
            break;
        case GROUP_MESSAGE_STATUS_NO_HIT:
            notify = @"接收消息但不提醒";
            break;
        case GROUP_MESSAGE_IN_HELP_NO_HIT:
            notify = @"收进群助手且不提醒";
            break;
            
        default:
            break;
    }
    
    _labNotify.text = notify;
    if (!IsStrEmpty(self.groupList.selfcard)) {
        _myNickNameLabel.text = self.groupList.selfcard;
    }
    else
    {
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:OWNERID];
        _myNickNameLabel.text =vcardEntity.defaultName;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showFeedProfileWithUserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType =ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

#pragma mark VcardCollectionViewCellDelegate
- (void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIImageView *)avatar{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row < self.memberDatasource.count) {
//        GMember *memberEntity = [self.memberDatasource objectAtIndex:indexPath.row];
//        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:memberEntity.userid];
        [self showFeedProfileWithUserid:cell.uid animated:YES];
    }
//    else{
//        NIMGroupAddVC *groupAVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupAddVC"];
//        groupAVC.groupEntity = self.groupList;
//        [self.navigationController pushViewController:groupAVC animated:YES];
//    }
}
- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *imageStr = nil;

    cell.vcardDelegate = self;

    if (indexPath.row < self.memberDatasource.count)
    {
        GMember *memberEntity = [self.memberDatasource objectAtIndex:indexPath.row];
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:memberEntity.userid];
        cell.uid = memberEntity.userid;
        imageStr = vcardEntity.avatar;
        
        [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:IsStrEmpty(imageStr)?USER_ICON_URL(memberEntity.userid):imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
        [cell updateConstraints];
        
        BOOL isNoMaster = (memberEntity.userid != self.groupList.ownerid);
        
        if (!isNoMaster)
        {
            self.selfisMaster = (memberEntity.userid == OWNERID);
        }
        
        cell.lbIsGroupMaster.hidden = isNoMaster;
    }
//    else{
//        [cell.avatarBtn setBackgroundImage:IMGGET(@"bt_photoadd") forState:UIControlStateNormal];
//    }
}
#pragma mark UICollectionViewDelegate
- (void)updateMembers:(NSSet *)members{
//    NSArray *allObjs = members.allObjects;
//    NSSortDescriptor *secondDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupIndex" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:secondDescriptor, nil];
//    
//    NSArray *allobjects =  [allObjs sortedArrayUsingDescriptors:sortDescriptors];
//    
//    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:10];
//    [allobjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        GMember *gmember = (GMember *)obj;
//        [tmpArr addObject:gmember];
//        if (gmember.userid==self.groupList.ownerid) {
//            [tmpArr removeObject:gmember];
//            [tmpArr insertObject:gmember atIndex:0];
//        }
//    }];
    self.memberDatasource = self.fetchedMembersResultsController.fetchedObjects;
    
    [self.collectionView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        int64_t ownerid = OWNERID;
        if (ownerid ==self.groupList.ownerid) {
            return 4;
        }
        else
        {
            return 3;
        }
    }
    else if (section == 1)
    {
        int64_t ownerid = OWNERID;
        if (ownerid ==self.groupList.ownerid)
        {
//            self.viewRedpoint.hidden = (self.groupList.isModifyName == 1);
            self.viewRedpoint.hidden = YES;

        }
        else
        {
            self.viewRedpoint.hidden = YES;
        }
        return 4;

    }
    else if (section == 2)
    {
        return 2;
    }
    else if (section == 3)
    {
//        if (self.groupList.type == 2)//0 讨论组   1群组   2推荐人的群
//        {
//            return 3;
//        }else
//        {
//            return 3;
//        }
        return 3;
    }
    else
    {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0)
    {
        if (_isBanned) {
            [self operateTips];
            return;
        }

        if (indexPath.row == 0) {
            NIMMemberVC *memberVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"memberIdentifier"];
            memberVC.groupEntity = self.groupList;
            [self.navigationController pushViewController:memberVC animated:YES];
        }else if (indexPath.row == 2){
            
            NIMGroupAddVC *groupAVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupAddVC"];
            groupAVC.groupEntity = self.groupList;
            [self.navigationController pushViewController:groupAVC animated:YES];

        }else if (indexPath.row == 3){
            
            NIMGroupRemoveVC *groupAVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupRemoveVC"];
            groupAVC.groupEntity = self.groupList;
            [self.navigationController pushViewController:groupAVC animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        if (_isBanned && indexPath.row != 1) {
            [self operateTips];
            return;

        }
        if(indexPath.row ==0)
        {
            NIMEditGroupNameVC* edit = (NIMEditGroupNameVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMEditGroupNameIdentity"];
            edit.groupEntity = self.groupList;
            edit.delegate = self;
            edit.type = groupEditType;
            [self.navigationController pushViewController:edit animated:YES];
            
        }
        if(indexPath.row == 1)
        {
            NIMGroupCardInfoVC* card = [[NIMGroupCardInfoVC alloc] initWithGroupName:_groupList.name groupIp:_groupList.groupId];
            [self.navigationController pushViewController:card animated:YES];
        }
        if(indexPath.row ==3)
        {
            
            NIMGroupRemarkVC *remark = [[NIMGroupRemarkVC alloc] init];
            RemarkEntity *remarkEntity = [RemarkEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"groupid=%lld",self.groupList.groupId]];
            BOOL isLeader = NO;
            if (OWNERID ==self.groupList.ownerid) {
                isLeader = YES;
            }
            if (!IsStrEmpty(self.groupList.remark)) {
                remark.remark = self.groupList.remark;
            }else{
                if (!isLeader) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"只有群主可以编辑群公告" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return;
                }
            }
            if (remarkEntity) {
                remark.remarkEntity = remarkEntity;
            }
            remark.isLeader = isLeader;
            remark.groupid = self.groupList.groupId;
            [self.navigationController pushViewController:remark animated:YES];
        }
//        if(indexPath.row ==4)
//        {
//            NIMGroupManagerVC *manager = (NIMGroupManagerVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMChatGroupManagerIdentity"];
//            manager.groupEntity = self.groupList;
//            [self.navigationController pushViewController:manager animated:YES];
//        }
    }
    else if (indexPath.section ==2)
    {
        if (indexPath.row == 0)
        {
            if (_isBanned) {
                [self operateTips];
                return;
            }
            //设置我在群中的昵称
            NIMEditGroupNameVC* edit = (NIMEditGroupNameVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMEditGroupNameIdentity"];
            edit.groupEntity = self.groupList;
            edit.delegate = self;
            edit.type = groupCardEditType;
            [self.navigationController pushViewController:edit animated:YES];
        }
        else if (indexPath.row == 1)
        {

        }
    }
    else if (indexPath.section ==3)
    {
        if (indexPath.row == 2) {
            
            if ([[NIMSysManager sharedInstance] GetNetStatus] != LOGINED) {
                UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"提示"];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            if (_isBanned) {
                [self operateTips];
                return;
            }
            
            UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
            
            UILabel *lb = (UILabel *)[cell viewWithTag:101010];
            
            
            NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"接收消息并提醒",@"接收消息但不提醒",@"收进群助手且不提醒"] AttachTitle:@"请选译该群的消息提醒方式"];
            [action SelectImageAndIndex:self.groupList.switchnotify+1];

//            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
            
            [action ButtonIndex:^(NSInteger Buttonindex) {
                
                [action SelectImageAndIndex:Buttonindex];
                
                switch (Buttonindex) {

                    case 1:
                    {
                        if (self.groupList.switchnotify != GROUP_MESSAGE_STATUS_NORMAL) {
                            [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_STATUS_NORMAL];
                            //[self handleMessageStatus:GROUP_MESSAGE_STATUS_NORMAL];
                        }

                    }
                        break;
                    case 2:
                    {
                        if (self.groupList.switchnotify != GROUP_MESSAGE_STATUS_NO_HIT) {
                            [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_STATUS_NO_HIT];
                            //[self handleMessageStatus:GROUP_MESSAGE_STATUS_NO_HIT]
                        }

                    }
                        break;
                    case 3:
                    {
                        if (self.groupList.switchnotify != GROUP_MESSAGE_IN_HELP_NO_HIT) {
                            [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_IN_HELP_NO_HIT];
                            //[self handleMessageStatus:GROUP_MESSAGE_IN_HELP_NO_HIT];
                        }
 
                    }
                        break;
                    default:
                        break;
                }
                
                
            }];

            
//            UIAlertController *alertController= [UIAlertController alertControllerWithTitle:@"请选译该群的消息提醒方式" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
//            
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }];
//            UIAlertAction *recvtips = [UIAlertAction actionWithTitle:@"接收消息并提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                lb.text = @"接收消息并提醒";
//                if (self.groupList.switchnotify != GROUP_MESSAGE_STATUS_NORMAL) {
//                    [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_STATUS_NORMAL];
//                    //[self handleMessageStatus:GROUP_MESSAGE_STATUS_NORMAL];
//                }
//            }];
//            
//            UIAlertAction *recvnotips = [UIAlertAction actionWithTitle:@"接收消息并不提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                lb.text = @"接收消息并不提醒";
//                if (self.groupList.switchnotify != GROUP_MESSAGE_STATUS_NO_HIT) {
//                    [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_STATUS_NO_HIT];
//                    //[self handleMessageStatus:GROUP_MESSAGE_STATUS_NO_HIT]
//                }
//            }];
//            UIAlertAction *norecvnotips = [UIAlertAction actionWithTitle:@"收进群助手且不提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                lb.text = @"收进群助手且不提醒";
//                if (self.groupList.switchnotify != GROUP_MESSAGE_IN_HELP_NO_HIT) {
//                    [[NIMGroupOperationBox sharedInstance] sendGroupMessageStatue:self.groupList.groupId status:GROUP_MESSAGE_IN_HELP_NO_HIT];
//                    //[self handleMessageStatus:GROUP_MESSAGE_IN_HELP_NO_HIT];
//                }
//            }];
//            [alertController addAction:cancelAction];
//            [alertController addAction:recvtips];
//            [alertController addAction:recvnotips];
//            [alertController addAction:norecvnotips];
//
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    else if (indexPath.section ==4)
    {
        if(indexPath.row == 0)
        {
            _deleteChatInfo = YES;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"你确定要清空聊天记录吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NIMMessageCenter sharedInstance] deleteRecordsThread:self.groupList.messageBodyId completeBlock:^(id object, NIMResultMeta *result) {
                    if (_delegate && [_delegate respondsToSelector:@selector(reloadTableIfClearDataSource)]) {
                        [_delegate reloadTableIfClearDataSource];
                    }
                }];
            }];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:cancle];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }

}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numerOfItems = 0;
    numerOfItems = self.memberDatasource.count;
    if (numerOfItems > 6) {
        numerOfItems = 6;
    }
    return numerOfItems;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = (self.view.frame.size.width-70)/6.0;
    if (height>45) {
        height = 45;
    }
    return CGSizeMake(height, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kvcardIdentifier forIndexPath:indexPath];
    [self configCollectionViewCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.memberDatasource.count) {
        GMember *memberEntity = [self.memberDatasource objectAtIndex:indexPath.row];
        [self showFeedProfileWithUserid:memberEntity.userid animated:YES];
    }
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(controller.fetchedObjects.count>0){
            [self.tableView endUpdates];
        }
    });
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableView *tableView = self.tableView;
        self.groupList = anObject;
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
            {
                
                [self reloadResult];
            }
                break;
                
            case NSFetchedResultsChangeMove:
                [self reloadResult];
                
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

#pragma mark NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [GroupList NIM_fetchAllSortedBy:nil
                                                     ascending:YES
                                                 withPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",self.groupList.messageBodyId]
                                                       groupBy:nil
                                                      delegate:self];
    
    return _fetchedResultsController;
}

-(NSFetchedResultsController *)fetchedMembersResultsController
{
    _fetchedMembersResultsController = [GMember NIM_fetchAllSortedBy:@"ct"
                                                      ascending:YES
                                                  withPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@ AND userid != %d",self.groupList.messageBodyId,0]
                                                        groupBy:nil
                                                       delegate:nil];
    
    return _fetchedMembersResultsController;
}
#pragma mark fetch
- (void)reloadResult{
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        self.groupList = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",self.groupList.messageBodyId]];
        _capacityLabel.text = [NSString stringWithFormat:@"%d 人",self.groupList.capacity];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reload];
        });
    }
}

#pragma mark fetch
- (void)reload{
    [self updateMembers:self.groupList.members];
    _swSaveBook.on = _groupList.savedwitch;
    _swNewsNotfication.on = _groupList.apnswitch;//http://jira.qbao.com/browse/CLIENT-1173“新消息通知”默认开，改成“消息免打扰”默认关
    _swShowNickName.on = _groupList.showname;
    
    ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:self.groupList.messageBodyId];
    if (recordList) {
        _swSetTop.on = recordList.topAlign;
    }
    [self setCellValues];
    [self.tableView reloadData];

}

- (void)request{
    
    int index = [getObjectFromUserDefault(KEY_Member_Index(self.groupList.groupId)) intValue];
    if (self.groupList.members.count != self.groupList.membercount || index !=-1) {
        setObjectToUserDefault(KEY_Member_Index(self.groupList.groupId), @(0));
        [[NIMGroupOperationBox sharedInstance] sendGroupMemberRQ:self.groupList.groupId complete:nil];
    }
    BOOL isFetch = [[[NIMSysManager sharedInstance].remarkDict objectForKey:@(self.groupList.groupId)] boolValue];
    if (!isFetch) {
        [[NIMGroupOperationBox sharedInstance] fetchGroupRemarkDetail:self.groupList.groupId];
    }
    
}

-(void)recvGroupDeatil:(NSNotification *)noti
{
    id object = noti.object;
    
    if (!object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }else{
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            if (self.groupList.membercount != self.groupList.members.count) {
                self.groupList.membercount = self.groupList.members.count;
            }
            if ([NSThread isMainThread]) {
                [self reloadResult];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadResult];
                });
            }
        }
        
    }
}


- (IBAction)exitGroup:(UIButton *)sender {

    
    
    NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"确定"] AttachTitle:@"退出后将不再接收此群消息，同时删除该群的聊天记录"];
    
    //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
    
    [action ButtonIndex:^(NSInteger Buttonindex) {
        
        if (Buttonindex == 1) {
            
            if (_isBanned) {
                
                int64_t groupid = self.groupList.groupId;
                [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId=%lld AND memberid=%lld", groupid,OWNERID]];
                NSPredicate*predicate=[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]];
                //删除所有不该存在本机的recordlist消息
                [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
                [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }else{
                //TODO:退群
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                });
                [[NIMGroupOperationBox sharedInstance] exitGroup:self.groupList.groupId];
                
            }
            
        }
        
        
    }];

    
//    NSString *ts = @"退出后将不再接收此群消息，同时删除该群的聊天记录";
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:ts preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        if (_isBanned) {
//            
//            int64_t groupid = self.groupList.groupId;
//            [GroupList NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"groupId=%lld AND memberid=%lld", groupid,OWNERID]];
//            NSPredicate*predicate=[NSPredicate predicateWithFormat:@"messageBodyId = %@",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]];
//            //删除所有不该存在本机的recordlist消息
//            [ChatListEntity NIM_deleteAllMatchingPredicate:predicate];
//            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            });
//        }else{
//            //TODO:退群
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            });
//            [[NIMGroupOperationBox sharedInstance] exitGroup:self.groupList.groupId];
//
//        }
//
//    }];
//    
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    
//    [alertController addAction:cancle];
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)recvExitGroup:(NSNotification *)noti
{   
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                int64_t groupid = [object longLongValue];
                [ChatEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]]];
                [[NIMMessageManager sharedInstance] removeAllMessageBy:[NIMStringComponents createMsgBodyIdWithType:GROUP toId:groupid]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"退出群聊失败"];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    });

    
}

-(void)recvKicketGroup:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        id object = noti.object;
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                _isBanned = YES;
                _swSaveBook.on = NO;
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你被群主移出该群" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    BOOL isPop = YES;
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[SSIMThreadViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            isPop = NO;
                            break;
                        }
                    }
                    if (isPop) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    });
    
}


-(void)recvgroupMsgStatus:(NSNotification *)notification
{
    id object = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                NSDictionary *dict = object;
                GROUP_MESSAGE_STATUS status = [[dict objectForKey:@"status"] intValue];
                [self handleMessageStatus:status];
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showTipsView:@"更改状态失败" atView:self.view];
            });
        }
    });
    
    
}

-(void)recvgroupSaveStatus:(NSNotification *)notification
{
    id object = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                NSDictionary *dict = object;
                NIM_GROUP_SAVE_TYPE status = [[dict objectForKey:@"status"] intValue];
                NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
                if (self.groupList) {
                    self.groupList.savedwitch = status;
                    //TODO:save
                    [privateContext MR_saveOnlySelfAndWait];
                }
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showTipsView:@"更改状态失败" atView:self.view];
            });
            
        }
    });
    
    
}


-(void)handleMessageStatus:(GROUP_MESSAGE_STATUS)status
{
    GroupList *groupList=[GroupList instancetypeFindGroupId:self.groupList.groupId];
    groupList.switchnotify = status;
    switch (status) {
            
        case GROUP_MESSAGE_STATUS_NORMAL: case GROUP_MESSAGE_STATUS_NO_HIT:
        {
            BOOL ok = [[NIMOperationBox sharedInstance]checkIsCanDeleteGroupAssistant];
            if (ok)
            {
                [[NIMOperationBox sharedInstance]deleteGroupAssistant];
            }
            
            //更新到折叠群里的最新一条消息
            ChatEntity *itema = [[NIMOperationBox sharedInstance]getfoldGroupAtLeastTime];
            if (itema)
            {
                NSString *s = [[NIMOperationBox sharedInstance]getPreviewForGroupAssistantBy:itema];
                [[NIMOperationBox sharedInstance]updateGroupAssistant:s];
            }
            else
            {
                //即然没有通知也没有群消息内容，则删除首页的群助手
                [[NIMOperationBox sharedInstance]deleteGroupAssistant];
                
            }
            
        }
            break;
            
        case GROUP_MESSAGE_IN_HELP_NO_HIT:
        {
            
            //检查是否有群组手没有创建一个
            ChatEntity *itema = [[NIMOperationBox sharedInstance]getfoldGroupAtLeastTime];
            if (itema)
            {
                //折叠前看是否有群助手了，没有就产生一条呗
                NSPredicate *pd = [NSPredicate predicateWithFormat:@"messageBodyId == %@",itema.messageBodyId];
                NSArray *rcd = [ChatListEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:pd];
                if (rcd.count > 0)
                {
                    ChatListEntity *item = rcd[0];
                    [[NIMOperationBox sharedInstance]makeGroupAssistantPacket:item withUsePrivew:YES];
                }
                NSString *s = [[NIMOperationBox sharedInstance]getPreviewForGroupAssistantBy:itema];
                
                [[NIMOperationBox sharedInstance]updateGroupAssistant:s];
                
            }
        }
            break;
            
        default:
            break;
    }
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_REFRESH_UI object:nil];
    

}


- (IBAction)setTopChangeValue:(id)sender
{
    UISwitch *switchTop = sender;
    [[NIMGroupOperationBox sharedInstance] swithTop:switchTop.on withGroupMsgBodyId:self.groupList.messageBodyId];

}

- (IBAction)notficationChangeValue:(id)sender {
    UISwitch *switchNo = sender;
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [self.groupList setApnswitch:switchNo.on];
    //TODO:save
    [privateContext MR_saveToPersistentStoreAndWait];
}

- (IBAction)showNameValue:(id)sender {
    UISwitch *nameSwitch = sender;
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    if (self.groupList) {
        
        self.groupList.showname = nameSwitch.on;
        [[NIMSysManager sharedInstance].groupShowDict setObject:@(nameSwitch.on) forKey:@(self.groupList.groupId)];
        
        //TODO:save
        [privateContext MR_saveOnlySelfAndWait];
        if (_delegate && [_delegate respondsToSelector:@selector(reloadTableIfNameShow)]) {
            [_delegate reloadTableIfNameShow];
        }
        
    }
    
}
- (IBAction)saveBooke:(UISwitch *)sender {
    
}

-(void)saveBooks:(UISwitch *)sender
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        _swSaveBook.on = !sender.on;
        return;
    }
    
    if (_isBanned) {
        [self operateTips];
        _swSaveBook.on = NO;
        return;
    }
    
    if (self.groupList.savedwitch != sender.on) {
        [[NIMGroupOperationBox sharedInstance] sendGroupSave:self.groupList.groupId status:sender.on];
    }
}
-(void)operateTips
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:TIPS preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isPop = YES;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[SSIMThreadViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                isPop = NO;
                break;
            }
        }
        if (isPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)setingFinish:(GroupList *)groupEntity
{
    self.groupList = groupEntity;
    self.labGroupName.text = self.groupList.name;
}


-(void)recvRemarkDetail:(NSNotification *)notification
{
    id object = notification.object;
    if (!object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBTip showError:@"请求超时" toView:self.view];
        });
    }else{
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            
            [[NIMSysManager sharedInstance].remarkDict setObject:@YES forKey:@(self.groupList.groupId)];
            
            NSDictionary *dict = object;
            int64_t ct = [[dict objectForKey:@"ct"] longLongValue];
            int64_t userid = [[dict objectForKey:@"userid"] longLongValue];
            NSString *remark = [dict objectForKey:@"reamrk"];
            if (IsStrEmpty(remark)) {
                return;
            }
            int64_t groupid = self.groupList.groupId;
            RemarkEntity *remarkEntity = [RemarkEntity instancetypeFindgroupid:groupid];
            if (!remarkEntity) {
                remarkEntity = [RemarkEntity NIM_createEntity];
                remarkEntity.groupid = groupid;
            }
            remarkEntity.userid = userid;
            remarkEntity.content = remark;
            remarkEntity.ct = ct;
            self.groupList.remark = remark;
            _remarkLabel.text = self.groupList.remark;
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
        }
    }
}
@end
