//
//  NIMContactsViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/8/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  通讯录界面

#import "NIMContactsViewController.h"
//#import "PublicEntity.h"

//#import "NProfileEntity.h"

#import "NIMContactsCoverView.h"
#import "NIMAddFriendsViewController.h"
#import "NIMFriendNoticeViewController.h"
#import "NIMGroupVC.h"
#import "NIMPublicViewController.h"
#import "NIMSelfViewController.h"
#import "NIMSContactTableViewCell.h"
#import "NIMSPublicTableViewCell.h"
#import "UIlabel+NIMAttributed.h"
#import "NIMChatGroupSettingVC.h"
#import "NIMBadgeTableViewCell.h"

#import "NIMChatUIViewController.h"
#import "UIViewController+NIMQBaoUI.h"
#import "NIMGroupVcardVC.h"
//#import "MessageNIMOperationBox.h"
#import "NIMManager.h"
#import "NIMBlackListViewController.h"
#import "NIMBusinessViewController.h"
///////////////
#import "NIMMessageCenter.h"
#import "NIMActionSheet.h"

#import "NIMSelfViewController.h"
#import "SSIMBusinessManager.h"
@interface NIMContactsViewController ()<NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, NIMContactsCoverViewDelegate, VcardTableViewCellDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray                        *arrayOfCharacters;
@property (nonatomic, strong) NSFetchedResultsController            *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController            *unReadFetchedResultsController;
@property (nonatomic, strong) NIMContactsCoverView* coverView;
@property (nonatomic, strong) NSMutableDictionary   *datasource;
@property (nonatomic, strong) NSMutableArray   *searchKeys;
@property (nonatomic, strong) NSArray   *groupsource;

@property (nonatomic, strong) NSString      *searchText;

@end

#define kSearchContact  @"kSearchContact"
#define kSearchGroup  @"kSearchGroup"
#define kSearchPublic  @"kSearchPublic"

@implementation NIMContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    if (KIsiPhoneX) {
//        [self.tableView setFrame:CGRectMake(0, IPX_NAVI_H, SCREEN_WIDTH, SCREEN_HEIGHT-IPX_NAVI_H-IPX_BOTTOM_SAFE_H)];
//    }
    
    //    self.refreshControl = [[UIRefreshControl alloc]init];
    //    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[NIMBadgeTableViewCell class] forCellReuseIdentifier:kNIMBadgeTableViewCell];
    [self.tableView registerClass:[NIMBadgeTableViewCell class] forCellReuseIdentifier:kQBHeadBadgeTableViewCell];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[NIMSContactTableViewCell class]
                                                forCellReuseIdentifier:kSContactReuseIdentifier];
    [self.searchDisplayController.searchResultsTableView registerClass:[NIMSPublicTableViewCell class]
                                                forCellReuseIdentifier:kSPublicReuseIdentifier];
    self.searchDisplayController.searchResultsTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.searchDisplayController.searchBar.tintColor = [UIColor darkGrayColor];
    
    UITextField *searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];
    
    [self initilizeConfig];
    //    [self reloadFetchedResults:nil];
    [self reloadFetchedNewNoticeResults];
    //    [self.refreshControl beginRefreshing];
    //    [self.refreshControl endRefreshing];
    
    
    //    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    self.definesPresentationContext = YES;
    
    
    //    [UIViewController qb_setStatusBar_Light];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFetchedResults:) name:@"dele" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_FRIEND_DEL_RQ:) name:NC_FRIEND_DEL_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSomeOneAddMeNotification) name:NC_SERVER_FRIEND_ADD_RQ object:nil];
    //    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,self.searchDisplayController.searchBar.frame.size.height)];
    //    [searchBarView addSubview: self.searchDisplayController.searchBar];
    //    [self.view addSubview:searchBarView];
    
    //    self.tableView.tableHeaderView = searchBarView;
    NSLog(@"%f",SCREEN_WIDTH);
    [self qb_setTitleText:@"通讯录"];
    
    self.tableView.sectionIndexColor=[UIColor darkGrayColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadFetchedResults:nil];
        
    self.fetchedResultsController.delegate = self;
    self.unReadFetchedResultsController.delegate = nil;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    self.definesPresentationContext = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)reloadFetchedNewNoticeResults
{
    NSError *error = NULL;
    if (![self.unReadFetchedResultsController performFetch:&error]) {
    }
}

#pragma mark fetch
- (void)reloadFetchedResults:(NSNotification*)note
{
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error])
    {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

-(void)recvSomeOneAddMeNotification
{
    [self.tableView reloadData];
}

- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark push
- (void)showProfileControllerWithUserid:(int64_t)userid{
    
    if (userid > 0) {
        //                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];
        
        //        feedProfileVC.userid = userid;
        //
        //        feedProfileVC.feedSourceType =ChatSource;
        //        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        //        [self.navigationController pushViewController:feedProfileVC animated:YES];
        
        NIMSelfViewController * selfVC = [[NIMSelfViewController alloc]init];
        selfVC.userid = userid;
        selfVC.feedSourceType =ChatSource;
        [selfVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:selfVC animated:YES];
        
    }
}


- (void)showChatControllerWithThread:(NSString *)thread{
    
    if (IsStrEmpty(thread)) return;
    
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    [chatVC setThread:thread];
    [chatVC setActualThread:thread];
    chatVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chatVC animated:YES];
    
    [self.searchDisplayController.searchBar  resignFirstResponder];
    self.searchDisplayController.active = NO;
    [self.searchDisplayController.searchBar endEditing:YES];
    
}

- (void)addFriend
{
    [self hiddenContactsView];
    UIStoryboard* testST = [UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]];
    NIMAddFriendsViewController* add = (NIMAddFriendsViewController*)[testST instantiateViewControllerWithIdentifier:@"addFriendsIdentity2"];
    [self.navigationController pushViewController:add animated:YES];
}
#pragma mark config
- (void)updateCell:(NIMBadgeTableViewCell *)cell withNContactEntity:(FDListEntity *)contactEntity{
    cell.delegate = self;
    [cell makeConstraints];
    VcardEntity *vcard = contactEntity.vcard;
    if (vcard==nil) {
        vcard = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
    }else{
        if (IsStrEmpty(vcard.avatar)) {
            vcard.avatar = USER_ICON_URL(contactEntity.fdPeerId);
            [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
        }
    }
    
    [cell updateWithVcardEntity:vcard];
}

- (void)configureCell:(NIMBadgeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
    FDListEntity *contactList = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    
    [self updateCell:cell withNContactEntity:contactList];
    
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section - 1];
        numberOfRows = [sectionInfo numberOfObjects];
        if (indexPath.row == numberOfRows - 1) {
            cell.hasLineLeadingLeft = YES;
        }
    }
}

- (void)configureSearchDefaultCell:(NIMSContactTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchKeys) {
        NSString *key = _searchKeys[indexPath.section];
        NSArray *result = self.datasource[key];
        if ([key isEqualToString:kSearchContact]) {
            FDListEntity *fdlist = result[indexPath.row];
            VcardEntity *card = fdlist.vcard;
            if (nil == card){
                card = [VcardEntity instancetypeFindUserid:fdlist.fdPeerId];
            }
            
            NSString *firstName = [NIMStringComponents finFristNameWithID:fdlist.fdPeerId];
            
            [cell updateWithVcardEntity:card];
            UIFont *font = [UIFont boldSystemFontOfSize:16];
            
            [cell.titleLable nim_setOriginalText:firstName
                                    originaColor:cell.titleLable.textColor
                                    originalFont:cell.titleLable.font
                                   attributedStr:nil
                                 attributedColor:[UIColor redColor]
                                  attributerFont:font];
            if (indexPath.row == 0) {
                cell.tipLablel.text = @"联系人";
            }
            [cell layoutSubviews];
        }else if ([key isEqualToString:kSearchGroup]){
            GroupList *groupEntity = result[indexPath.row];
            [cell updateWithGroupEntity:groupEntity];
            UIFont *font = [UIFont boldSystemFontOfSize:16];
            [cell.titleLable nim_setOriginalText:[groupEntity name]
                                    originaColor:cell.titleLable.textColor
                                    originalFont:cell.titleLable.font
                                   attributedStr:nil
                                 attributedColor:[UIColor redColor]
                                  attributerFont:font];
            if (indexPath.row == 0) {
                cell.tipLablel.text = @"群聊";
            }
            [cell layoutSubviews];
        }
        if (indexPath.row == 0) {
            cell.hasTip = YES;
            cell.lineView.hidden = YES;
        }else{
            cell.tipLablel.text = nil;
            cell.lineView.hidden = YES;
            cell.hasTip = NO;
            
        }
        if (indexPath.row == result.count - 1) {
            cell.hasLineLeadingLeft = YES;
        }else{
            cell.hasLineLeadingLeft = NO;
        }
        
        [cell makeConstraints];
        
    }
}

#pragma mark Fetch
- (void)fetchResultWithSearchText:(NSString *)text{
    self.searchText = text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((fullCNLitter CONTAINS[c] %@) OR(firstLitter CONTAINS[c] %@)  OR (fullLitter CONTAINS[c] %@) OR (fullAllLitter CONTAINS[c] %@)) and fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d)",text,text,text,text,OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK];
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"((allFullLitter CONTAINS[c] %@) OR (name CONTAINS[c] %@)) AND memberid=%lld AND type != %d",text,text,OWNERID,NIM_INGROUP_STATUS_BANNED];
    
    _datasource = @{}.mutableCopy;
    _searchKeys = @[].mutableCopy;
    NSArray *results_contact = [FDListEntity NIM_findAllSortedBy:@"fullAllLitter" ascending:YES withPredicate:predicate];
    if (results_contact.count) {
        _datasource[kSearchContact] = results_contact;
        [_searchKeys addObject:kSearchContact];
    }
    
    NSArray *results_group = [GroupList NIM_findAllSortedBy:@"allFullLitter" ascending:YES withPredicate:predicate1];
    if (results_group.count) {
        _datasource[kSearchGroup] = results_group;
        [_searchKeys addObject:kSearchGroup];
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
#else
    // For iOS 9+
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    
#endif
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    [UIViewController nim_setStatusBar_Default];
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [UIViewController nim_setStatusBar_Default];
    //    [self.searchDisplayController.searchBar  resignFirstResponder];
    //    self.searchDisplayController.active = NO;
    //    [self.searchDisplayController.searchBar endEditing:YES];  //结束编辑
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformIdentity;
        }];
    }
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    
    [self fetchResultWithSearchText:searchString];
    
    
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

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMBadgeTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        return;
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
    FDListEntity *contactEntity = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    [self showProfileControllerWithUserid:contactEntity.fdPeerId];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.searchKeys) {
            NSString *key = _searchKeys[section];
            NSArray *result = self.datasource[key];
            return result.count;
        }
        return 0;
    }
    if (section == 0) {
        return 4;
    }
    if (section == [[self.fetchedResultsController sections] count]+1) {
        return 1;
    }
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section - 1];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NIMBadgeTableViewCell *cell = nil;
        if (self.searchKeys) {
            cell = [tableView dequeueReusableCellWithIdentifier:kSContactReuseIdentifier forIndexPath:indexPath];
            [self configureSearchDefaultCell:(NIMSContactTableViewCell *)cell atIndexPath:indexPath];
        }
        cell.delegate = nil;
        return cell;
    }
    if (indexPath.section == [[self.fetchedResultsController sections] count] +1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactsCountID"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactsCountID"];
            cell.backgroundColor = tableView.backgroundColor;
            //            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
            //            //        label.contentMode = UIViewContentModeCenter;
            //            label.textAlignment =  NSTextAlignmentCenter;
            //            label.textColor = [SSIMSpUtil getColor:@"888888"];
            //            label.font = [UIFont systemFontOfSize:16];
            //            [cell.contentView addSubview:label];
        }
        cell.textLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"%lu位联系人",self.fetchedResultsController.fetchedObjects.count];
        return cell;
    }
    
    
    if(indexPath.section == 0)
    {
        NIMBadgeTableViewCell* cell = nil;
        cell = (NIMBadgeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kQBHeadBadgeTableViewCell
                                                                       forIndexPath:indexPath];
        cell.delegate=nil;
        //[cell setRightSSIMSpUtilityButtons:nil WithButtonWidth:0];
        cell.vLine.hidden = YES;
        cell.bottomLineView.hidden = YES;
        
        
        UIImage *image = nil;
        NSString *name = nil;
        switch (indexPath.row) {
            case 0:
            {
                cell.vLine.hidden = NO;
                name = @"新的朋友";
                image = IMGGET(@"icon_qb_addfriend");
                cell.bottomLineView.hidden = YES;
                
                
                //显示新的朋友小红点
                NSArray * unreadCounts = [FDListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and isInNewFriend == 1 and fdUnread == 1",OWNERID]];
                NSInteger unreadcount = unreadCounts.count;
                
                if(unreadcount == 0){
                    cell.badgeView.hidden = YES;
                }else if(unreadcount < 100){
                    cell.badgeView.hidden = NO;
                    cell.badgeLabel.text = [NSString stringWithFormat:@"%ld",(long)unreadcount];
                }else{
                    cell.badgeView.hidden = NO;
                    cell.badgeLabel.text = @"99+";
                }
            }
                break;
            case 1:
            {
                name = @"群聊";
                image = IMGGET(@"icon_qb_groupchat");
                cell.bottomLineView.hidden = YES;
                cell.badgeView.hidden = YES;
            }
                break;
            case 2:
            {
                name = @"公众号";
                image = IMGGET(@"icon_qb_service");
                cell.badgeView.hidden = YES;
            }
                break;
                //增加一行数据，用于测试 by yxh 5.27
            case 3:
            {
                name = @"黑名单";
                
                image = IMGGET(@"nim_icon_qb_black_list");
                cell.badgeView.hidden = YES;
            }
                break;
//            case 4:
//            {
//                name = @"商家测试";
//                image = IMGGET(@"icon_qb_business");
//                cell.badgeView.hidden = YES;
//            }
//                break;
            default:
                break;
        }
        [cell updateWithImage:image name:name];
        [cell makeConstraints];
        [cell.contentView bringSubviewToFront:cell.badgeView];
        
        if (indexPath.row == 2) {
            cell.hasLineLeadingLeft = YES;
        }
        
        return cell;
    }
    else
    {
        
        NIMBadgeTableViewCell* cell = nil;
        cell = (NIMBadgeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kNIMBadgeTableViewCell
                                                                       forIndexPath:indexPath];
        cell.vLine.hidden = YES;
        cell.bottomLineView.hidden = YES;
        //        [cell setRightSSIMSpUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
        cell.delegate =self;
        cell.hasLineLeadingLeft = YES;
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section - 1];
        NSInteger numbers = [sectionInfo numberOfObjects];
        if(numbers != indexPath.row+1){
            cell.bottomLineView.hidden = YES;
        }
        cell.badgeView.hidden = YES;
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }
}


#pragma mark- gzq:右滑删除时调用
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){
        
        NSString *thread = nil;
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1 ];
        FDListEntity *contactEntity = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
        
        thread = contactEntity.messageBodyId;
        
//        FDListEntity * fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and fdPeerId = %lld",OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,contactEntity.fdPeerId]];

        NSString *firstName = [NIMStringComponents finFristNameWithID:contactEntity.fdPeerId];

        NSString *str =[NSString stringWithFormat:@"将联系人“%@”删除\n同时删除与他的聊天记录",firstName];
        
        NIMActionSheet * actionSheet = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"确认删除"] AttachTitle:str];
        
        //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
        
        [actionSheet ButtonIndex:^(NSInteger Buttonindex) {
            
            if (Buttonindex == 1) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NIMFriendManager sharedInstance] sendFriendDelRQ:contactEntity.fdPeerId];
            }
        }];
    }];
    deleteRowAction.backgroundColor =[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    return @[deleteRowAction];
}

-(void)dele:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        [self.tableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section==0||indexPath.section==[[self.fetchedResultsController sections] count] +1){
        return NO;
    }else{
        return YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.searchKeys) {
            return self.searchKeys.count;
        }
        return 0;
    }
    return self.fetchedResultsController.sections.count+2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return @"搜索结果";
    }
    
    NSString *indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section-1];
    return indexTitle;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 24)];
    v.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    UIView* vline = [[UIView alloc] init];
    vline.backgroundColor = __COLOR_D5D5D5__;
    [v addSubview:vline];
    [vline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.with.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(_LINE_HEIGHT_1_PPI);
    }];
    vline = [[UIView alloc] init];
    vline.backgroundColor = __COLOR_D5D5D5__;
    [v addSubview:vline];
    [vline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.with.offset(0);
        make.leading.offset(0);
        make.trailing.offset(0);
        make.height.offset(_LINE_HEIGHT_1_PPI);
    }];
    
    UILabel* labTitle = [[UILabel alloc] init];
    labTitle.font = [UIFont boldSystemFontOfSize:14];
    labTitle.textColor = __COLOR_888888__;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        labTitle.text = @"搜索结果";
    }
    else{
        if ([[self.fetchedResultsController sections] count] > 0 && section <= [[self.fetchedResultsController sections] count]){
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section -1];
            labTitle.text = [sectionInfo.name stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];;
        }
    }
    [v addSubview:labTitle];
    [labTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.leading.offset(10);
        make.trailing.offset(0);
    }];
    return v;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    return self.arrayOfCharacters;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
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
            return sectionCount;
        }
        for (NSInteger i = 0; i < sectionCount; i++){
            NSString * str = [keys objectAtIndex:i];
            NSComparisonResult result = [str compare:title options:NSCaseInsensitiveSearch];
            /*如果小于当前滑动到的位置值，继续向下查找*/
            if (result == NSOrderedDescending){
                if (retPos < 0){
                    retPos = 0;
                    continue;
                }
                else
                {
                    break;
                }
            }
            /*如果大于或相等 当前滑动到的位置值，停止查找，并付给新的位置并返回*/
            else if (result == NSOrderedAscending){
                retPos =  i+1;
            }
            else{
                retPos = i+1;
                break;
            }
        }
    }
    
    return retPos;
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        CGFloat heightTip = 0;
        if (indexPath.row == 0) {
            heightTip = 30;
        }
        return 58+heightTip;
    }
    return 58;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView || section == [[self.fetchedResultsController sections] count]+1){
        return 0;
    }
    if (section < 1) {
        return 0;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *thread = nil;
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                NIMFriendNoticeViewController *friendNVC = [NIMFriendNoticeViewController new];
                [self.navigationController pushViewController:friendNVC animated:YES];
            }else if (indexPath.row == 1){
                
                NIMGroupVC *groupVC = [[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"groupInfoIdentifier"];
                [self.navigationController pushViewController:groupVC animated:YES];
            }else if (indexPath.row == 2){
//                [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_OfficialList)];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [MBTip showError:@"该功能暂未对接新IM" toView:self.view];
//                });
                SSIMOrderModel *model = [SSIMOrderModel new];
                model.order_id = @"12321321321";
                model.order_img = @"12321321321";
                model.order_num = @"12321321321";
                model.order_pay = @"12321321321";
                model.order_price = @"12321321321";
                model.order_title = @"1232132132112321321321123213213211232132132112321321321";
                model.buyer_id = @"12321321321";
                model.order_status = @"12321321321";
                model.stateVale = @"12321321321";
                model.order_list_desc = @"12321321321";
                model.order_url = _IM_FormatStr(@"https://m.qbao.com//wswap/productShare.htm?spuId=1&sourceType=1");
                
                SSIMBusinessModel *bmodel = [SSIMBusinessModel new];
                bmodel.bid = OWNERID;
                bmodel.cid = 0;
                bmodel.name = @"12321321321";
                bmodel.avatar = @"";
                bmodel.url = _IM_FormatStr(@"https://enterprise.qbao.com/merchant/shop/qry/toWapShopHome.html?interceptType=1&shopUserId=%lld",bmodel.bid);
                bmodel.bType = 0;
                [[SSIMBusinessManager sharedInstance] nimPushToChatWithOrderInfo:model businessInfo:bmodel];
            }else if (indexPath.row == 3){
                NIMBlackListViewController * blView = [[NIMBlackListViewController alloc]init];
                [self.navigationController pushViewController:blView animated:YES];
            }else{
                NIMBusinessViewController * blView = [[NIMBusinessViewController alloc]init];
                [self.navigationController pushViewController:blView animated:YES];
            }
            return;
        }
        if (indexPath.section == [[self.fetchedResultsController sections]count]+1) {
            return;
        }
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
        FDListEntity *contactEntity = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
        
        thread = contactEntity.messageBodyId;
        
        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
        
        NSString *messageBodyId = nil;
        
        if (self.fetchedResultsController.fetchedObjects.count == 0) {
            messageBodyId = [NIMStringComponents createMsgBodyIdWithType:PRIVATE  toId:0];
        }else{
            messageBodyId = [self.fetchedResultsController.fetchedObjects[indexPath.row] messageBodyId];
        }
        
        chatVC.thread = thread;
        chatVC.actualThread = thread;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        return;
        
    }else{
        
        if (self.searchKeys) {
            NSString *key = _searchKeys[indexPath.section];
            NSArray *result = self.datasource[key];
            if ([key isEqualToString:kSearchGroup]) {
                GroupList *groupEntity = result[indexPath.row];
                thread = groupEntity.messageBodyId;
            }else if ([key isEqualToString:kSearchContact]) {
                FDListEntity *contactEntity = result[indexPath.row];
                thread = contactEntity.messageBodyId;
            }
        }
        
        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
        
        chatVC.thread = thread;
        chatVC.actualThread = thread;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        
        [self.searchDisplayController.searchBar  resignFirstResponder];
        self.searchDisplayController.active = NO;
        [self.searchDisplayController.searchBar endEditing:YES];
    }
    
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    //    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];
}

- (IBAction)showCoverView:(id)sender {
    
    [self addFriend];
    return;
    
    UIWindow *kWindow = [UIApplication sharedApplication].keyWindow;
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }else{
        [kWindow addSubview:self.coverView];
        self.tableView.scrollEnabled = NO;
    }
}
#pragma NIMContactsCoverViewDelegate
- (void)hiddenContactsView{
    if (self.coverView.superview) {
        [self.coverView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }
}

#pragma mark getter
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [FDListEntity NIM_fetchAllGroupedBy:@"firstLitter" withPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d)",OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK] sortedBy:@"firstLitter,fullLitter" ascending:YES delegate:self];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSError *error;
    
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
    }
    NSLog(@"%lld存在%u个好友",OWNERID,_fetchedResultsController.fetchedObjects.count);
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)unReadFetchedResultsController{
    if (nil != _unReadFetchedResultsController) {
        return _unReadFetchedResultsController;
    }
    return _unReadFetchedResultsController;
    
}

- (NIMContactsCoverView *)coverView{
    if (!_coverView) {
        _coverView = (NIMContactsCoverView*)[[[NSBundle mainBundle] loadNibNamed:@"NIMContactsCoverView" owner:nil options:nil]lastObject];
        
        CGRect frame = self.navigationController.navigationBar.frame;
        CGRect cRect = _coverView.frame;
        _coverView.frame = CGRectMake(0, CGRectGetMaxY(frame), CGRectGetWidth(cRect), CGRectGetHeight(cRect));
        _coverView.delegate = self;
        _coverView.backgroundColor = [UIColor clearColor];
    }
    return _coverView;
}

-(void)recvNC_FRIEND_DEL_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                //                [MBTip showTipsView:param.p_string atView:self.view.window];
                [MBTip showError:param.p_string toView:self.view.window];
                
            }else{
                [MBTip showError:@"删除成功" toView:self.view.window];
                //                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
            
            //            [MBTip showError:@"删除失败" toView:self.view.window];
        }
        [self.tableView reloadData];
    });
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
