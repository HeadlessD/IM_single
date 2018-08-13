//
//  NIMGroupCreateVC.m
//  QianbaoIM
//
//  Created by liunian on 14/8/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMGroupCreateVC.h"
#import "NIMSubSeleteTableViewCell.h"
#import "NIMSelfViewController.h"
#import "FDListEntity+CoreDataClass.h"
//#import "VcardEntity.h"
//#import "GroupList.h"
#import "GMember+CoreDataClass.h"
#import "NIMVcardCollectionViewCell.h"
#import "NIMGroupOperationBox.h"
#import "NIMChatUIViewController.h"
#import "NIMGroupVC.h"
//#import "NIMManager.h"
#import "NIMPChatTableViewController.h"
#import "SSIMThreadViewController.h"
#import "TextEntity+CoreDataClass.h"
// 

@interface NIMGroupCreateVC ()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, VcardCollectionViewCellDelegate, UITextFieldDelegate, GroupViewControllerDelegate, VcardTableViewCellDelegate,NIMSubSeleteTableViewCellDelegate>{
    BOOL    _searching;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedOtherResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray    *arrayOfCharacters;
@property (nonatomic, strong) NSMutableArray    *datasource;
@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, assign) BOOL          searching;
@property (nonatomic,strong)NSString *textContent;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int operate_max;
@property (nonatomic,assign)NSInteger collectOffset;
@property (nonatomic, strong) UIView    * collectBackView;

@end

@implementation NIMGroupCreateVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.showSelected = YES;
    [self qb_setTitleText:@"发起群聊"];
    [self initilizeConfig];
    [self reloadDataFromDB];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    VcardEntity* friendContact = [VcardEntity instancetypeFindUserid:OWNERID];
    if (friendContact) {
        [self.datasource addObject:friendContact];
    }
    if(self.friendUserId)
    {
        VcardEntity* friendContact = [VcardEntity instancetypeFindUserid:self.friendUserId];
        [self.datasource addObject:friendContact];
    }
    [self qb_showRightButton:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.datasource.count]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createGroupResponse:) name:NC_CREATE_GROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromDB) name:NC_GROUPMEMBERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupType:) name:NC_GROUP_TYPE_LIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvShipChange:) name:NC_FRIEND_SHIP_TIME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvC_CLIENT_FRIEND_ADD_RQ:) name:NC_CLIENT_FRIEND_ADD_RQ object:nil];

    [[NIMGroupOperationBox sharedInstance] sendGroupTypeList];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    [self setExtendedLayoutIncludesOpaqueBars:NO];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES; // 默认是YE
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadDataFromDB{
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)qb_back
{
    if(_delegate && [_delegate respondsToSelector:@selector(groupCreateViewController:didBackWithCompleteBlock:)]){
        [_delegate groupCreateViewController:self didBackWithCompleteBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (actionTyoe) {
                    case VcardSelectedActionTypeForward:
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    case VcardSelectedActionTypeChat:
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    default:
                        break;
                }
            });
            
        }];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    int rectW = CGRectGetWidth(self.view.frame);
    
    CGFloat yu = rectW % 55;
    
    CGFloat textW = 50 + yu;
    
    CGFloat maxWidth =rectW - textW;
    
    CGFloat width = self.datasource.count * 55;
    if (maxWidth - width >0 && maxWidth - width <55) {
        _collectOffset = self.datasource.count;
    }
    if (width >= maxWidth) {
        width = maxWidth;
        
    }
  
    if (KIsiPhoneX) {
        self.collectBackView.frame = CGRectMake(0, 86, self.view.bounds.size.width, 62);

        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([NSNumber numberWithFloat:88]);
            make.leading.equalTo(self.view.mas_leading).with.offset(15);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:width]);
            make.height.equalTo(@60);
        }];
    }else{
        self.collectBackView.frame = CGRectMake(0, 62, self.view.bounds.size.width, 62);
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([NSNumber numberWithFloat:64]);
            make.leading.equalTo(self.view.mas_leading).with.offset(15);
            make.width.lessThanOrEqualTo([NSNumber numberWithFloat:width]);
            make.height.equalTo(@60);
        }];
    }

//     [self.collectionView setContentSize:CGSizeMake(self.datasource.count * 70, 60)];
    [self.searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_top).with.offset(20);
        make.leading.equalTo(self.collectionView.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.collectionView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.view.mas_trailing);
        
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(1);
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
}

#pragma mark config
- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}

#pragma mark actions

-(void)groupType:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        id object = notification.object;
        
        if (object) {
            if ([object isKindOfClass:[NIMGroupTypeInfo class]]) {
                NIMGroupTypeInfo *info = object;
                self.type = info.group_type;
                self.operate_max = info.group_add_max_count;
            }else{
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }
        }else{
            //[MBTip showError:@"获取群类型失败" toView:nil];
            
            //        UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"获取群类型失败"];
            //        [self presentViewController:alertController animated:YES completion:nil];
            
        }
    });
    
    
}


-(void)createGroupResponse:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!object) {
            [MBTip showError:@"创建失败" toView:self.view];
        }else{
            if ([object isKindOfClass:[GroupList class]]) {
                [self.datasource removeAllObjects];
                GroupList *groupEntity = object;
                if(_delegate && [_delegate respondsToSelector:@selector(groupCreateViewController:didBackWithCompleteBlock:)]){
                    [_delegate groupCreateViewController:self didSelectedThread:groupEntity.messageBodyId completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            switch (actionTyoe) {
                                case VcardSelectedActionTypeForward:
                                {
                                    //                                    [MBTip showError:@"已发送" toView:self.view];
                                    //
                                    //                                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                    //                                    }];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                    if ([_delegate respondsToSelector:@selector(groupCreateViewController:didSelectRow:completeBlock:)]) {
                                        [_delegate groupCreateViewController:self didSelectRow:groupEntity.messageBodyId completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
                                            
                                        }];
                                    }
                                }
                                    break;
                                case VcardSelectedActionTypeChat:
                                {
                                    [MBTip showError:@"创建成功" toView:self.view];
                                    NIMPChatTableViewController *chatVC = nil;
                                    for (id obj in self.navigationController.viewControllers) {
                                        if ([obj isKindOfClass:[NIMPChatTableViewController class]]) {
                                            chatVC = obj;
                                            break;
                                        }
                                        
                                    }
                                    if (chatVC) {
                                        [self.navigationController popToViewController:chatVC animated:YES];
                                    }else{
                                        SSIMThreadViewController * threadVC = nil;
                                        for (id obj in self.navigationController.viewControllers) {
                                            if ([obj isKindOfClass:[SSIMThreadViewController class]]) {
                                                threadVC = obj;
                                                break;
                                            }
                                        }
                                        if (threadVC) {
                                            [self.navigationController popToViewController:threadVC animated:YES];
                                        }else{
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }
                                    }
                                    if ([_delegate respondsToSelector:@selector(groupCreateViewController:didCreatedGroup:)]) {
                                        
                                        [_delegate groupCreateViewController:self didCreatedGroup:groupEntity];
                                    }
                                }
                                    break;
                                default:
                                    break;
                            }
                            
                        });
                    }];
                }
            }
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }
        }
    });
}


-(void)recvShipChange:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        
        NSDictionary *dict = object;
        BOOL isRemove = [[dict objectForKey:@"isRemove"] boolValue];
        if (isRemove) {
            int64_t userid = [[dict objectForKey:@"userid"] longLongValue];
            for (int i=0; i<self.datasource.count; i++) {
                VcardEntity *vcard = self.datasource[i];
                if (vcard.userid == userid) {
                    [self.datasource removeObject:vcard];
                }
            }
            [self qb_showRightButton:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.datasource.count]];
        }
        _fetchedResultsController = nil;
        _fetchedOtherResultsController = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }
}

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    FDListEntity *contactEntity = nil;
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];
    if(_searching){
        contactEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
        if (contactEntity.fdFriendShip == FriendShip_UnilateralFriended || (contactEntity.fdFriendShip == FriendShip_Friended && contactEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK)) {
            [self showAlertWithFriend:contactEntity];
            return;
        }
        
    }else if (indexPath.section == sectionCnt){
        contactEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
        [self showAlertWithFriend:contactEntity];
        return;
        
    }else{
        contactEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    if(contactEntity.fdPeerId == self.friendUserId)
    {
        return;
    }
    if (contactEntity == nil) {
        return;
    }
    if (_searching)
    {
        //        self.searchField.text = @"";
        //        [self setSearching:NO];
    }
    [self handleContactEntity:contactEntity.vcard rowAtIndexPath:indexPath];
}

#pragma mark GroupViewControllerDelegate
- (void)groupViewController:(NIMGroupVC *)controller didSelectedWithGroupEntity:(GroupList *)groupEntity completeBlock:(VcardCompleteBlock)completeBlock{
    [_delegate groupCreateViewController:self didSelectedThread:groupEntity.messageBodyId completeBlock:completeBlock];
    
}

-(void)groupViewController:(NIMGroupVC *)viewController didSelectRow:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock
{
    if ([_delegate respondsToSelector:@selector(groupCreateViewController:didSelectRow:completeBlock:)]) {
        [_delegate groupCreateViewController:self didSelectRow:thread completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            
        }];
    }
}

#pragma mark VcardCollectionViewCellDelegate
- (void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIImageView *)avatar{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row < self.datasource.count) {
        VcardEntity *contactEntity = [self.datasource objectAtIndex:indexPath.row];
//        VcardEntity *card = contactEntity.nVcard;
        if (contactEntity.userid != self.friendUserId && contactEntity.userid != OWNERID)
        {
            FDListEntity *cEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdPeerId=%lld",contactEntity.userid]];
            NSIndexPath *indexP = [self.fetchedResultsController indexPathForObject:cEntity];
            [self handleContactEntity1:contactEntity rowAtIndexPath:indexP];
        }
    }
}
- (void)doSelectedGroup{
    NIMGroupVC *groupVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"groupInfoIdentifier"];
    groupVC.fromCreateGroup = YES;
    if(_delegate && [_delegate respondsToSelector:@selector(groupCreateViewController:didBackWithCompleteBlock:)]){
        [_delegate groupCreateViewController:self didBackWithCompleteBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            if (actionTyoe == VcardSelectedActionTypeForward) {
                groupVC.delegate = self;
            }
        }];
    }
    
    [self.navigationController pushViewController:groupVC animated:YES];
}

- (IBAction)cancelBack:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)forwardFromThread:(NSString *)thread{
    if(_delegate && [_delegate respondsToSelector:@selector(groupCreateViewController:didBackWithCompleteBlock:)]){
        [_delegate groupCreateViewController:self didSelectedThread:thread completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                switch (actionTyoe) {
                    case VcardSelectedActionTypeForward:
                    {
//                        if (result) {
//                            [MBTip showError:result.message toView:nil];
//                        }else{
//                            [MBTip showError:@"已发送" toView:nil];
//
//                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        if ([_delegate respondsToSelector:@selector(groupCreateViewController:didSelectRow:completeBlock:)]) {
                            [_delegate groupCreateViewController:self didSelectRow:thread completeBlock:^(VcardSelectedActionType actionTyoe, id object, NIMResultMeta *result) {
                                
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
    }
    
}

- (IBAction)okAction:(id)sender{
    
    if(self.datasource.count<=2)
    {
        if (_groupCreateType == GroupCreateTypeForward) {
            if (self.datasource.count <= 1) {
                [MBTip showError:@"请至少选择1个好友进行分享" toView:nil];
                return;
            }
            VcardEntity *vcard = [self.datasource lastObject];
            if (vcard) {
                [self forwardFromThread:[NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:vcard.userid]];
            }
            
        }else{
            if (self.type == 0) {
                UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"获取群类型失败"];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            if (self.datasource.count == 2) {
                VcardEntity *vcard = [self.datasource lastObject];
                
                NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
                chatVC.thread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:vcard.userid];
                chatVC.actualThread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:vcard.userid];
                chatVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatVC animated:YES];
                
            }else{
                [MBTip showError:@"请至少选择一个好友建群" toView:nil];
                return;
            }
        };
        
        return;
    }
    
    if (self.type == 0) {
        UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"获取群类型失败"];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    if(self.datasource.count>self.operate_max)
    {
        NSString *tip = [NSString stringWithFormat:@"单次建群最多选择%d人",self.operate_max];
        [MBTip showError:tip toView:nil];
        return;
    }
    
    NSMutableArray *userids = @[].mutableCopy;
    NSMutableArray *userNames = @[].mutableCopy;
    
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        VcardEntity *card = obj;
        int64_t userid = card.userid;
        
        if (userid != 0) {
            [userids addObject:@(userid)];
            [userNames addObject:[card defaultName]];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    [[NIMGroupOperationBox sharedInstance] createGroupWithContacts:userids withNames:userNames];
    /*
    NSInteger inviteCnt = self.datasource.count - 1;//去掉自己
    NSInteger canInviteCnt = inviteCnt - (deleteFds.count+blackFds.count);
    
    if (canInviteCnt == 0) {
        //全为黑名单提示和部分黑名单或不包含黑名单提示不同
        if (blackFds.count == inviteCnt) {
            [self showAlert:blackFds balcks:nil type:NIM_GROUP_TIP_MODE_BLACK];
        }else if(deleteFds.count == inviteCnt){
            [self showAlert:deleteFds balcks:nil type:NIM_GROUP_TIP_MODE_DELETE];
        }else{
            [self showAlert:deleteFds balcks:blackFds type:NIM_GROUP_TIP_MODE_BOTH];
        }
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        if (deleteFds.count>0) {
            setObjectToUserDefault(KEY_Group_Create_Del, deleteFds);
        }
        if (blackFds.count>0) {
            setObjectToUserDefault(KEY_Group_Create_Bla, blackFds);
        }
        [self.datasource removeAllObjects];

        [[NIMGroupOperationBox sharedInstance] createGroupWithContacts:userids withNames:userNames];
    }
     */
}

/*
-(void)showAlert:(NSArray *)fds balcks:(NSArray *)balcks type:(NIM_GROUP_TIP_MODE)type
{
    NSString *tips = nil;
    NSMutableString * nameStr = [[NSMutableString alloc] init];
    NSMutableString * bnameStr = [[NSMutableString alloc] init];

    for (int i=0; i<fds.count; i++) {
        
        int64_t userid = [[fds objectAtIndex:i] longLongValue];
        
        FDListEntity *fdListEntity = nil;
        if (type == NIM_GROUP_TIP_MODE_BLACK) {
            fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and fdBlackShip = %d",OWNERID,userid,FD_BLACK_PASSIVE_BLACK]];
        }else{
            fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and fdFriendShip = %d",OWNERID,userid,FriendShip_UnilateralFriended]];
        }
        NSString *name = firstName;
        [nameStr appendString:name];
        if (i<fds.count-1) {
            [nameStr appendString:@"、"];
        }
    }
    if (type == NIM_GROUP_TIP_MODE_BOTH) {
        for (int i=0; i<balcks.count; i++) {
            
            int64_t userid = [[balcks objectAtIndex:i] longLongValue];
            
            FDListEntity *fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld and fdBlackShip = %d",OWNERID,userid,FD_BLACK_PASSIVE_BLACK]];
            NSString *name = firstName;
            
            [bnameStr appendString:name];
            if (i<fds.count-1) {
                [bnameStr appendString:@"、"];
            }
        }
    }
    if (type == NIM_GROUP_TIP_MODE_BLACK) {
        tips = [NSString stringWithFormat:@"%@拒绝加入群聊。",nameStr];
    }else if(type == NIM_GROUP_TIP_MODE_DELETE){
        tips = [NSString stringWithFormat:@"%@未把你添加到通讯录，需要发送好友申请，等对方通过。",nameStr];
    }else{
        tips = [NSString stringWithFormat:@"%@拒绝加入群聊。%@未把你添加到通讯录，需要发送好友申请，等对方通过。",bnameStr,nameStr];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建群聊失败" message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
*/
-(void)showAlertWithFriend:(FDListEntity *)fdListEntity
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (fdListEntity ==nil) {
            return;
        }
        NSString *tips = nil;
        UIAlertAction *okAction = nil;
        UIAlertAction *cancle = nil;
        NSString *firstName = [NIMStringComponents finFristNameWithID:fdListEntity.fdPeerId];

        if (fdListEntity.fdFriendShip == FriendShip_UnilateralFriended) {
            tips = [NSString stringWithFormat:@"%@未把你添加到通讯录，需要发送好友申请，等对方通过。是否发送？",firstName];
            okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([[NIMSysManager sharedInstance]GetNetStatus] != LOGINED) {
                    UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"提示"];
                    [self presentViewController:alertController animated:YES completion:nil];
                    return ;
                }
                
                FDListEntity * fdlist = [FDListEntity instancetypeFindMUTUALFriendId:fdListEntity.fdPeerId];
                if (!fdlist) {
                    [[NIMFriendManager sharedInstance] sendFriendAddRQ:fdListEntity.fdPeerId opMsg:nil sourceType:ChatSource];
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
    });
    
}



-(void)recvC_CLIENT_FRIEND_ADD_RQ:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        id object = noti.object;
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary * addDic = object;
                [MBTip showError:@"添加好友成功" toView:self.view.window];
                NSDictionary * dicts = @{@"userId":[addDic objectForKey:@"userId"],@"fdResult":@0};
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
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


#pragma mark push
- (void)showFeedProfileWithuserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType = ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];

    }
}

- (void)showViewControllerWithEntity:(VcardEntity *)contactEntity animated:(BOOL)animated{
    if (![self.datasource containsObject:contactEntity]) {
        [self.datasource addObject:contactEntity];
    }else{
        [self.datasource removeObject:contactEntity];
    }
    
    [self.collectionView reloadData];
    if(self.datasource.count>0)
    {
        if (_collectOffset !=0 && self.datasource.count > _collectOffset) {
              [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.datasource.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
    
    [self qb_showRightButton:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.datasource.count]];
    [self updateViewConstraints];
}

- (void)qb_rightButtonAction{
    [self okAction:nil];
}

#pragma mark config

- (void)handleContactEntity1:(VcardEntity *)contactEntity rowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showViewControllerWithEntity:contactEntity animated:YES];
    if (IsStrEmpty(self.searchField.text) && self.datasource.count == 0) {
        self.searching = NO;
    }
    [self.tableView reloadData];
    
}

- (void)handleContactEntity:(VcardEntity *)contactEntity rowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showViewControllerWithEntity:contactEntity animated:YES];
    NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (_searching)
    {
        [self configureSearchCell:cell atIndexPath:indexPath];
    }
    else
    {
        [self configureCell:cell atIndexPath:indexPath];
    }
    if (IsStrEmpty(self.searchField.text) && self.datasource.count == 0) {
        self.searching = NO;
    }
    [self.tableView reloadData];
    
}
- (void)updateContactEntity:(FDListEntity *)contactEntity withCell:(NIMVcardCollectionViewCell *)cell{
    VcardEntity *vcardEntity = [contactEntity vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdOwnId];
        contactEntity.vcard = vcardEntity;
    }
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:vcardEntity.avatar]
                              forState:UIControlStateNormal placeholderImage:IMGGET(@"handcode_logo.png")];
}
- (void)configureSearchCell:(NIMSubSeleteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    FDListEntity *contactEntity = [self.searchResults objectAtIndex:indexPath.row];
    VcardEntity *vcardEntity = [contactEntity vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
        contactEntity.vcard = vcardEntity;
    }
    [cell updateWithVcardEntity:vcardEntity];
    if(vcardEntity.userid == self.friendUserId)
    {
        [cell.seleteBtn setImage:IMGGET(@"phontLib_select.png") forState:UIControlStateSelected];
    }
    else
    {
        [cell.seleteBtn setImage:IMGGET(@"select_on.png") forState:UIControlStateSelected];
    }
    if ([self.datasource containsObject:contactEntity.vcard]) {
        cell.have = YES;
    }else{
        cell.have = NO;
    }
    cell.delegate = self;
    [cell makeConstraints];
    cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0);
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
        numberOfRows = [sectionInfo numberOfObjects];
        if (indexPath.row == numberOfRows - 1) {
            cell.hasLineLeadingLeft = YES;
        }
    }
    [self updateViewConstraints];
}

- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    VcardEntity *contactEntity = nil;
    if (indexPath.row < self.datasource.count) {
        contactEntity = [self.datasource objectAtIndex:indexPath.row];
    }
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:USER_ICON_URL(contactEntity.userid)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    [cell updateConstraints];
    cell.vcardDelegate = self;
}

- (void)configureCell:(NIMSubSeleteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];
    FDListEntity *contactEntity = nil;
    if (indexPath.section == sectionCnt) {
        contactEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
    }else{
        contactEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    VcardEntity *vcardEntity = [contactEntity vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
        contactEntity.vcard = vcardEntity;
    }
    
    if(vcardEntity.userid == self.friendUserId)
    {
        [cell.seleteBtn setImage:IMGGET(@"mart_favorites_cancel_select") forState:UIControlStateSelected];
    }
    else
    {
        [cell.seleteBtn setImage:IMGGET(@"mart_favorites_cancel_select_on") forState:UIControlStateSelected];
    }
    if ([self.datasource containsObject:contactEntity.vcard]) {
        cell.have = YES;
    }else{
        cell.have = NO;
    }
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0);
//    NSInteger numberOfRows = 0;
//    if ([[self.fetchedResultsController sections] count] > 0){
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
//        numberOfRows = [sectionInfo numberOfObjects];
//        if (indexPath.row == numberOfRows -1) {
//            cell.hasLineLeadingLeft = YES;
//        }
//        else
//        {
//            cell.hasLineLeadingLeft = NO;
//        }
//    }
    [cell updateWithVcardEntity:vcardEntity];
    [cell makeConstraints];
    [self updateViewConstraints];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)textFieldChanged
{
    if (![self.textContent isEqualToString:self.searchField.text])
    {
       NSString * searchKey = [self.searchField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (searchKey.length) {
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((fullCNLitter CONTAINS[c] %@) OR (firstLitter CONTAINS[c] %@)  OR (fullLitter CONTAINS[c] %@) OR (fullAllLitter CONTAINS[c] %@)) and fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d)",searchKey,searchKey,searchKey,searchKey,OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK];
            
            self.searchResults =  [FDListEntity NIM_findAllSortedBy:@"fullAllLitter" ascending:YES withPredicate:predicate];
            [self setSearching:YES];
            [self.tableView reloadData];
        }

    }
    if (IsStrEmpty(self.searchField.text))
    {
        [self setSearching:NO];
        [self.tableView reloadData];
    }
    self.textContent = self.searchField.text;
}



#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numerOfItems = 0;
    numerOfItems = self.datasource.count;
    return numerOfItems;
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
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {5,0,5,0};
    return top;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_searching){
        if (self.searchResults) {
            return self.searchResults.count;
        }
        return 0;
    }
    
    if (section == [[self.fetchedResultsController sections] count]) {
        return self.fetchedOtherResultsController.fetchedObjects.count;
    }
    
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    
    
    return numberOfRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NIMSubSeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubSeleteReuseIdentifier forIndexPath:indexPath];
    cell.selDeleagte = self;
    if (_searching) {
        [self configureSearchCell:cell atIndexPath:indexPath];
    }
    else
    {
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

#pragma mark 11.17
-(void)click:(UIButton*)btn
{
    NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[[btn superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];
    FDListEntity *contactEntity = nil;
    if(_searching){
        contactEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        if (indexPath.section == sectionCnt){
            contactEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
            [self showAlertWithFriend:contactEntity];
            return;
        }
        contactEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if (contactEntity == nil ||
        contactEntity.fdPeerId == _friendUserId) {
        return;
    }
    if (_searching)
    {
        //        self.searchField.text = @"";
        //        [self setSearching:NO];
        //        [self.tableView reloadData];
        
    }
    [self handleContactEntity:contactEntity.vcard rowAtIndexPath:indexPath];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_searching){
        return 1;
    }
    
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    
    if (self.fetchedOtherResultsController.fetchedObjects.count>0) {
        numberOfRows += 1;
    }
    return numberOfRows;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_searching){
        return @"搜索结果";
    }
    
    if (section == [[self.fetchedResultsController sections] count]) {
        return @"*";
    }
    
    NSString *indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
    
    return indexTitle;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(_searching){
        return nil;
    }
    return self.arrayOfCharacters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    DBLog(@"index : %ld title : %@", (long)index, title);
    NSInteger retPos = -1; /*无效的位置*/
    
    if (title == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else
    {
        NSArray *keys = [self.fetchedResultsController sectionIndexTitles];
        NSUInteger sectionCount = [keys count];
        if ([title isEqualToString:@"#"]) {
            if (sectionCount == 0) {
                return -1;
            }
            return sectionCount-1;
        }
        for (NSInteger i = 0; i < sectionCount; i++){
            NSString * str = [keys objectAtIndex:i];
            NSComparisonResult result = [str compare:title options:NSCaseInsensitiveSearch];
            /*如果小于当前滑动到的位置值，继续向下查找*/
            if (result == NSOrderedDescending){
                if (retPos < 0){
                    retPos = 0;
                }
                continue;
            }
            /*如果大于或相等 当前滑动到的位置值，停止查找，并付给新的位置并返回*/
            else if (result == NSOrderedAscending){
                retPos =  i;;
            }
            else{
                retPos = i;
                break;
            }
        }
    }
    
    return retPos;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FDListEntity *contactEntity = nil;
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];
    if(_searching){
        contactEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
        if (contactEntity.fdFriendShip == FriendShip_UnilateralFriended || (contactEntity.fdFriendShip == FriendShip_Friended && contactEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK)) {
            [self showAlertWithFriend:contactEntity];
            return;
        }

    }else if (indexPath.section == sectionCnt){
        contactEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
        [self showAlertWithFriend:contactEntity];
        return;
        
    }else{
        contactEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    if(contactEntity.fdPeerId == self.friendUserId)
    {
        return;
    }
    if (contactEntity == nil) {
        return;
    }
    if (_searching)
    {
//        self.searchField.text = @"";
//        [self setSearching:NO];
    }
    [self handleContactEntity:contactEntity.vcard rowAtIndexPath:indexPath];
}


#pragma mark UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
#else
    // For iOS 9+
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    
#endif
    
    DBLog(@"searching");
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@))", searchString, searchString, searchString];
    
    self.searchResults = [FDListEntity NIM_findAllWithPredicate:predicate];
    [self.searchDisplayController.searchResultsTableView reloadData];
    //去除 No Results 标签
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        for (UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
                UILabel *label = (UILabel *)subview;
                label.text = @"无结果";
                break;
            }
        }
    });

    return YES;
}
#pragma mark NSFetchedResultsControllerDelegate

/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(controller.fetchedObjects.count>0)
        [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(controller.fetchedObjects.count>0)
        [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView beginUpdates];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];

            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView beginUpdates];

            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];

            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            break;
    }
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
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
}
 */
- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];
}

#pragma mark fetch
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    //显示可加
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdFriendShip = %d  and fdBlackShip = 0",OWNERID,FriendShip_Friended];

    _fetchedResultsController = [FDListEntity NIM_fetchAllGroupedBy:@"firstLitter" withPredicate:pre sortedBy:@"firstLitter,fullLitter,fullAllLitter" ascending:YES delegate:self];
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}


-(NSFetchedResultsController *)fetchedOtherResultsController
{
    if (nil != _fetchedOtherResultsController) {
        return _fetchedOtherResultsController;
    }
    
    //显示不可加
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and ((fdFriendShip = %d and fdBlackShip = %d) || fdFriendShip = %d) and (fdBlackShip != %d && fdBlackShip != %d)",OWNERID,FriendShip_Friended,FD_BLACK_PASSIVE_BLACK,FriendShip_UnilateralFriended,FD_BLACK_ACTIVE_BLACK,FD_BLACK_MUTUAL_BLACK];
    
    _fetchedOtherResultsController = [FDListEntity NIM_fetchAllGroupedBy:nil withPredicate:pre sortedBy:@"fdFriendShip,firstLitter,fullLitter,fullAllLitter" ascending:YES delegate:self];
    NSError *error = NULL;
    if (![_fetchedOtherResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedOtherResultsController;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = @[].mutableCopy;
    }
    return _datasource;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:_headerView.frame];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitle:@"选择一个群组" forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(doSelectedGroup) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:button];
    }
    return _headerView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.itemSize = CGSizeMake(50, 50);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
//        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:kvcardIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        

        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(UIView *)collectBackView{
    
    if (!_collectBackView) {
        _collectBackView = [[UIView alloc]init];
        _collectBackView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectBackView];
    }
    return _collectBackView;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[NIMSubSeleteTableViewCell class] forCellReuseIdentifier:kSubSeleteReuseIdentifier];
        _tableView.tableHeaderView = self.headerView;
        _tableView.estimatedRowHeight =0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;

        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectZero];
        _searchField.backgroundColor = [UIColor whiteColor];
        [_searchField setBorderStyle:UITextBorderStyleNone]; //外框类型
        _searchField.placeholder = @" 搜索"; //默认显示的字
        _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchField.returnKeyType = UIReturnKeyDone;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        _searchField.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:_searchField];
        [self.view addSubview:_searchField];
    }
    return _searchField;
}

- (void)setSearching:(BOOL)searching{
    if (_searching != searching) {
        _searching = searching;
    }
    
    if (searching) {
        if (self.showSelected) {
            self.tableView.tableHeaderView = nil;
        }
    }else{
        if (self.showSelected) {
            self.tableView.tableHeaderView = self.headerView;
        }
    }

}

- (void)setShowSelected:(BOOL)showSelected{
    if (_showSelected != showSelected) {
        _showSelected = showSelected;
    }
    
    if (!showSelected) {
        self.tableView.tableHeaderView = nil;
    }else{
        self.tableView.tableHeaderView = self.headerView;
    }
}
@end
