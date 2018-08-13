//
//  QBContactBookViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/8/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "NIMContactBookViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NIMUserOperationBox.h"
#import "NIMContactBookTableViewCell.h"
#import "NIMAddDescViewController.h"
#import "UIlabel+NIMAttributed.h"

#import "PhoneBookEntity+CoreDataProperties.h"

@interface NIMContactBookViewController ()<NSFetchedResultsControllerDelegate, ContactBookTableViewCellDelegate, MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray                    *dataSourcesArr;
@property (nonatomic, strong) NSMutableArray                        *arrayOfCharacters;
@property (nonatomic, strong) NSString      *searchText;
@end

@implementation NIMContactBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"通讯录好友"];

    [self initilizeConfig];
     [self.searchDisplayController.searchResultsTableView registerClass:[NIMContactBookTableViewCell class] forCellReuseIdentifier:@"ksearch"];

    [self.tableView  registerClass:[NIMContactBookTableViewCell class] forCellReuseIdentifier:kContactBookIdentifier];
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.sectionIndexColor=[UIColor darkGrayColor];

    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.searchDisplayController.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchBar.barStyle = UISearchBarStyleDefault;
    self.searchDisplayController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
    [self reloadDataFromDB];
    [[NIMFriendManager sharedInstance]searchContent];
    
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USERINFO_RQ_ForPeedView:) name:NC_USERINFO_RQ_ForPeedView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USERLST_INFO_RQ:) name:NC_USERLST_INFO_RQ object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)reloadDataFromDB{
    
    [self.dataSourcesArr removeAllObjects];
    
    _fetchedResultsController = [PhoneBookEntity  NIM_fetchAllGroupedBy:@"firstLitter" withPredicate:[NSPredicate predicateWithFormat:@"phoneNum != nil"] sortedBy:@"firstLitter,sorted,fullLitter" ascending:YES delegate:self];
    
    //    and userid != %lld
    //    NSFetchedResultsController *fetchedResultsController = [PhoneBookEntity NIM_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"phoneNum != nil"] sortedBy:@"sorted" ascending:YES delegate:self];
    
    [self.dataSourcesArr addObjectsFromArray:_fetchedResultsController.fetchedObjects];
    
    NSError * error;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
    }
    [self.tableView reloadData];
}


#pragma mark actions
- (void)refreshViewControlEventValueChanged{
    [[NIMFriendManager sharedInstance]searchContent];
}

#pragma mark config
- (void)configureSearchCell:(NIMContactBookTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    PhoneBookEntity *phoneBookEntity = [self.searchResults objectAtIndex:indexPath.row];
    [cell updateWithphoneBookEntity:phoneBookEntity];
}

- (void)configureCell:(NIMContactBookTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    PhoneBookEntity *phoneBookEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateWithphoneBookEntity:phoneBookEntity];
}
-(void)displaySMSComposerSheetWithPhoneNum:(NSString *)phonenum{
    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];

    messageVC.body =[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IM_DescSms_%lld",OWNERID]],[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"IM_InviteUrl_%lld",OWNERID]]];//@"钱宝客户端3.0";
    messageVC.recipients = @[phonenum];
    messageVC.messageComposeDelegate = self;
    UINavigationBar *navibar = [UINavigationBar appearanceWhenContainedIn:[NIMContactBookViewController  class], nil];
    navibar.barTintColor = UIColorOfHex(0x3cd66f);// RGBACOLOR(0x00, 0xbe, 0xbc, 0.7);//[UIColor colorWithHexString:@"#00abb8"];
    //[[UIBarButtonItem appearance] setTintColor:RGB(0x00, 0xab, 0xb8, 0.7)];
    [navibar setTintColor:[UIColor whiteColor]];//这个可以决定系统返回按钮的返回的箭头的颜色
    [navibar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self presentViewController:messageVC animated:NO completion:NULL];
}

-(void)showSMSPickerWithPhoneNum:(NSString *)phonenum {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"对方还未注册，邀请一起优活？" preferredStyle:UIAlertControllerStyleAlert];
        
        //        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        //            textField.delegate = self;
        //        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            UITextField *reason = alertController.textFields.firstObject;
            
            if ([messageClass canSendText]) {
                [self displaySMSComposerSheetWithPhoneNum:phonenum];
            }else {
                //设备没有短信功能
                [MBTip showError:@"设备没有短信功能" toView:[UIApplication sharedApplication].keyWindow];
            }
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:cancle];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else {
        // iOS版本过低,iOS4.0以上才支持程序内发送短信
        [MBTip showError:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" toView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    //Notifies users about errors associated with the interface
    switch (result) {
            
        case MessageComposeResultCancelled:
            //            if (DEBUG) NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //            if (DEBUG) NSLog(@"Result: Sent");
            //[MBProgressHUD showSuccess:@"信息已发出" toView:[UIApplication sharedApplication].keyWindow];
            break;
            
        case MessageComposeResultFailed:
            //            if (DEBUG) NSLog(@"Result: Failed");
            
            break;
            
        default:
            
            break;
            
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark ContactBookTableViewCellDelegate
- (void)contactBookTableViewCell:(NIMContactBookTableViewCell *)cell didSelectedWithphoneBookEntity:(PhoneBookEntity *)phoneBookEntity{
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    [[NIMUserOperationBox sharedInstance]sendUserInfo:phoneBookEntity.phoneNum type:Search_PeedView];
}


-(void)recvNC_USERINFO_RQ_ForPeedView:(NSNotification *)noti{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        
        if ([noti.userInfo[@"success"] intValue]) {
            //            [MBTip showTipsView:@"查找成功" atView:self.view];
            int userid = [noti.userInfo[@"userId"] intValue];
            VcardEntity * vcard = [VcardEntity instancetypeFindUserid:userid];
            
            if (vcard != nil) {
                NIMAddDescViewController *descViewController = [[NIMAddDescViewController alloc] init];
                descViewController.userId = vcard.userid;
                descViewController.addSourceType = FD_ADD_TYPE_CONTACTS;
                UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: descViewController];
                [self presentViewController:presNavigation animated:YES completion:nil];
                [self qb_showLoading];
                
            }else{
                [self showSMSPickerWithPhoneNum:noti.userInfo[@"searchCon"]];
            }
        }else{
            //            [MBTip showTipsView:noti.userInfo[@"error"]  atView:self.view];
            //            [self showSMSPickerWithPhoneNum:noti.userInfo[@"searchCon"]];
            if ([noti.userInfo[@"error"] isEqualToString:@"用户不存在"]){
                [self showSMSPickerWithPhoneNum:noti.userInfo[@"searchCon"]];
            }else{
                UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [netAlert addAction:nAction];
                [self presentViewController:netAlert animated:YES completion:^{
                }];
            }
        }
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.searchResults) {
            return self.searchResults.count;
        }
        return 0;
    }
    
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
    return self.fetchedResultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return @"搜索结果";
    }
    
    NSString *indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
    return indexTitle;
}

- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    return self.arrayOfCharacters;
    
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    DBLog(@"index : %ld title : %@", (long)index, title);
    NSInteger retPos = 0; /*无效的位置*/
    
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
                return 0;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NIMContactBookTableViewCell *cell = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ksearch"];
        [self configureSearchCell:cell atIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kContactBookIdentifier];
        [self configureCell:cell atIndexPath:indexPath];
    }
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else{
        
    }
    
    
    //    PhoneBookEntity *phoneBookEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 24)];
    v.backgroundColor = [UIColor whiteColor];
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
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
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


#pragma mark UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
#else
    // For iOS 9+
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
    
#endif
    
    self.searchResults = @[];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    self.searchText = searchString;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((fullCNLitter CONTAINS[c] %@) OR (firstLitter CONTAINS[c] %@)  OR (fullLitter CONTAINS[c] %@) OR (fullAllLitter CONTAINS[c] %@) OR (phoneNum CONTAINS[c] %@)) AND phoneNum != nil",searchString,searchString,searchString,searchString,searchString];
    
    NSArray *results = [PhoneBookEntity NIM_findAllSortedBy:@"sectionName" ascending:YES withPredicate:predicate];
    
    self.searchResults = results;
    
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
            {
                NIMContactBookTableViewCell *cell = (NIMContactBookTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                [self configureCell:cell atIndexPath:indexPath];
            }
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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


-(void)recvNC_USERLST_INFO_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view.window animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                //                QBNCParam *param = object;
                //                [MBTip showTipsView:@"请求超时" atView:self.view];
                UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [netAlert addAction:nAction];
                [self presentViewController:netAlert animated:YES completion:^{
                }];
                
            }else{
                NSArray * infoArr = object;
                [self changeStateWith:infoArr];
                //                [MBTip showTipsView:@"查找成功" atView:self.view];
            }
        }else{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
            
            
            //            [MBTip showError:@"查找失败" toView:self.view.window];
        }
    });
}


-(void)changeStateWith:(NSArray *)infoArr{
    
    NSManagedObjectContext *privateObjectContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    
    
    for (QBUserInfoPacket * pack in infoArr) {
        PhoneBookEntity * phoneentity = [PhoneBookEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"phoneNum = %@",pack.mobile]];
        VcardEntity * phVcard =  [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"mobile = %@",pack.mobile]];
        
        if (phoneentity != nil && phVcard != nil) {
            phoneentity.userid = phVcard.userid;
            phoneentity.vcard = phVcard;
            
            
            //            FDListEntity * fdListEntity = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,pack.searchUserid]];
            
            FDListEntity * phFdlist =  [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,phVcard.userid]];
            if (phFdlist) {
                phoneentity.fdList = phFdlist;
                
                if (phFdlist.fdRemarkName) {
                    phoneentity.fullCNLitter = [NSString stringWithFormat:@"%@(%@)",phoneentity.name,phFdlist.fdRemarkName];
                }
                
                if (phFdlist.fdFriendShip == FriendShip_Friended) {
                    phoneentity.sorted = @"3";
                }else{
                    phoneentity.sorted = @"1";
                }
                
                //                FriendShip_NotFriend                = 0,
                //                FriendShip_IsMe                     = 1,
                //                FriendShip_Ask_Me                   = 3,
                //                FriendShip_Consent_Peer             = 8,
                //                FriendShip_UnilateralFriended       = 9,
                //                FriendShip_Friended                 = 10,
                //                FriendShip_Outlast                  = 11,
                //                FriendShip_MobileRecommend          = 12
                
                if (phFdlist.fdFriendShip == FriendShip_NotFriend) {
                    phFdlist.fdFriendShip = FriendShip_MobileRecommend;
                    phFdlist.isInNewFriend = YES;
                }
            }
        }
        //过滤自己
        if (phoneentity.userid == OWNERID) {
            phoneentity.phoneNum = nil;
        }
        [privateObjectContext MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadDataFromDB];
        });
    }
}

#pragma mark fetch
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    //    NSError *error = NULL;
    //    if (![_fetchedResultsController performFetch:&error]) {
    //        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
    //        abort();
    //    }
    //
    return _fetchedResultsController;
}

-(NSMutableArray *)dataSourcesArr
{
    if (!_dataSourcesArr) {
        _dataSourcesArr = [NSMutableArray new];
    }
    return _dataSourcesArr;
}


-(void)dealloc{
    
}

@end
