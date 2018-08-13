//
//  NIMMemberVC.m
//  QianbaoIM
//
//  Created by liunian on 14/8/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMMemberVC.h"
#import "GMember+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMGroupOperationBox.h"
//#import "NIMManager.h"
#import "NIMSelfViewController.h"
#import "NIMDefaultTableViewCell.h"
//#import "NIMPChatTableViewController.h"
#import "ChatListEntity+CoreDataClass.h"
#import "NIMSContactTableViewCell.h"
#import "NIMBadgeTableViewCell.h"
#import "UIViewController+NIMQBaoUI.h"


@interface NIMMemberVC ()<NSFetchedResultsControllerDelegate, VcardTableViewCellDelegate>{
    BOOL    _isBulider;

}
@property (nonatomic, strong) NSString      *searchText;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray *arrayOfCharacters;
@end

@implementation NIMMemberVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.searchDisplayController.searchResultsTableView registerClass:[NIMSContactTableViewCell class]
                                                forCellReuseIdentifier:kSContactReuseIdentifier];
    self.searchDisplayController.searchResultsTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    [self initilizeConfig];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromDB) name:NC_GROUPMEMBERCHANGE object:nil];

    _isBulider = [self judgeBuilder];
    
    [self qb_setStatusBar_Light];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadDataFromDB];

}

-(void)viewWillDisappear:(BOOL)animated
{
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    if (!IsStrEmpty(self.searchText)) {
        [self.searchDisplayController.searchBar  resignFirstResponder];
        self.searchDisplayController.active = NO;
        [self.searchDisplayController.searchBar endEditing:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark config
- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}
- (BOOL )judgeBuilder{
    double ownerid = OWNERID;
    if (ownerid ==self.groupEntity.ownerid) {
        return YES;
    }
    return NO;
}

#pragma mark fetch

- (void)deleteMembser:(GMember *)member{
    NIMRIButtonItem *cancelItem = [NIMRIButtonItem itemWithLabel:@"取消"];
    
    NIMRIButtonItem *okItem = [NIMRIButtonItem itemWithLabel:@"确定" action:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[NIMGroupOperationBox sharedInstance] sendGroupKickUserid:member.userid groupid:self.groupEntity.groupId];
    }];
    UIAlertView *alter = [[UIAlertView alloc]initWithNimTitle:@"" message:@"确定移除该成员？" cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
    [alter show];
    
}



- (void)reloadDataFromDB{
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark push
- (void)showFeedProfileWithUserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.groupid = self.groupEntity.groupId;
        feedProfileVC.feedSourceType = ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

- (void)showViewControllerWithEntity:(GMember *)memberEntity animated:(BOOL)animated{
    [self showFeedProfileWithUserid:memberEntity.userid animated:animated];
}

#pragma mark actions
- (void)refreshViewControlEventValueChanged{

}

#pragma mark config
#pragma mark 优先备注
- (void)configureSearchCell:(NIMSContactTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
//    self.searchResults = [self.searchResults sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        GMember *m1 = obj1;
//        GMember *m2 = obj2;
//        return [m1.fullLitter compare:m2.fullLitter];
//    }];
    
    GMember *memberEntity = [self.searchResults objectAtIndex:indexPath.row];
    
    [cell updateWithMemberEntity:memberEntity];
//    UIFont *font = [UIFont boldSystemFontOfSize:16];
    
//    [cell.titleLable setOriginalText:name
//                        originaColor:cell.titleLable.textColor
//                        originalFont:cell.titleLable.font
//                       attributedStr:self.searchText
//                     attributedColor:[UIColor redColor]
//                      attributerFont:font];
    [cell layoutSubviews];
}
#pragma mark 优先备注
- (void)configureCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GMember *memberEntity = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
    
    [cell updateWithMemberEntity:memberEntity];
    
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section-1];
        numberOfRows = [sectionInfo numberOfObjects];
        if (indexPath.row == numberOfRows - 1) {
            cell.hasLineLeadingLeft = YES;
        }
    }
}
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath){
//        GMember *member = nil;
//        member = (GMember *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
//        [self deleteMembser:member];
//        
//        
//    }];
//    deleteRowAction.backgroundColor =[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
//    return @[deleteRowAction];
//}



//- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
//{
//    GMember *member = nil;
//    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//    member = (GMember *)[self.fetchedResultsController objectAtIndexPath:cellIndexPath];
//
//    switch (state) {
//        case 1:
//            // set to NO to disable all left utility buttons appearing
//            return NO;
//            break;
//        case 2:
//            if (OWNERID==self.groupEntity.ownerid) {
//                if (member.userid ==self.groupEntity.ownerid) {
//                    return NO;
//                }
//                else
//                {
//                    return YES;
//                }
//            }
//            else
//            {
//            return NO;
//            }
//            break;
//        default:
//            break;
//    }
//    
//    return NO;
//}

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GMember *memberEntity = nil;
    
    if (indexPath.section==0) {
        memberEntity = [GMember instancetypeFindUserid:self.groupEntity.ownerid group:self.groupEntity];
    }else{
        memberEntity = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
    }
 
    if (memberEntity.userid) {
        [self showFeedProfileWithUserid:memberEntity.userid animated:YES];
    }
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.searchResults) {
            return self.searchResults.count;
        }
        return 0;
    }
    
    if (section == 0) {
        return 1;
    }
    
    NSInteger numberOfRows = 0;
    if ([[self.fetchedResultsController sections] count] > 0){
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section-1];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    return numberOfRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NIMSContactTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:kSContactReuseIdentifier forIndexPath:indexPath];
        [self configureSearchCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 0) {
        NIMDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
        cell.delegate=self;
        
        GMember *memberEntity = [GMember instancetypeFindUserid:self.groupEntity.ownerid group:self.groupEntity];
        if (memberEntity != nil) {
            [cell updateWithMemberEntity:memberEntity];
        }
//        [self configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    
    else{
        NIMDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
        cell.delegate=self;
//        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
//        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
    
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    return numberOfRows+1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return @"搜索结果";
    }
    
    if (section == 0) {
        return @"群主";
    }
    
    NSString *indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section-1];
    return indexTitle;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
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
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    GMember *member = nil;
    
    if (indexPath.section == 0) {
        return NO;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
    member = (GMember *)[self.fetchedResultsController objectAtIndexPath:newIndexPath];

    if (OWNERID==self.groupEntity.ownerid) {
        if (member.userid ==self.groupEntity.ownerid) {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return NO;
    }

//    if (!_isBulider) {
//        return NO;
//    }
//    GMember *member = nil;
//    if(tableView == self.searchDisplayController.searchResultsTableView){
//        member = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
//    }else{
//        member = (GMember *)[self.fetchedResultsController objectAtIndexPath:indexPath];
//    }
//    if (member) {
//        if (member.role == IMGroupRoleTypeBuilder || member.userid == OWNERID) {
//            return NO;
//        }
//        return YES;
//    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GMember *member = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        member = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            member = (GMember *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
            [self deleteMembser:member];
        }
    }
}
*/
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 40;
    }
    else
    {
        return 25;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GMember *member = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        member = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        if (indexPath.section == 0) {
            member = [GMember instancetypeFindUserid:self.groupEntity.ownerid group:self.groupEntity];
        }else{
            member = (GMember *)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]];
        }

    }
    
    if (member == nil) {
        return;
    }
    [self showViewControllerWithEntity:member animated:YES];
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
    [self qb_setStatusBar_Default];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    self.searchText = nil;
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self qb_setStatusBar_Light];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    self.searchText = searchString;
    
    
    
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(group = %@) and ((vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@)OR (card CONTAINS[c] %@)OR (groupmembernickname CONTAINS[c] %@))",self.groupEntity, searchString, searchString, searchString,searchString,searchString];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group = %@ and (fullLitter CONTAINS[c] %@ OR showName CONTAINS[c] %@ OR allFullLitter CONTAINS[c] %@)",self.groupEntity, searchString, searchString,searchString];
    
    self.searchResults = [GMember NIM_findAllWithPredicate:predicate];
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
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:newIndexPath.section+1]]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1]] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
            {
                NSIndexPath *nIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
                NIMDefaultTableViewCell *cell = (NIMDefaultTableViewCell *)[tableView cellForRowAtIndexPath:nIndexPath];
                [self configureCell:cell atIndexPath:nIndexPath];
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
                
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex+1] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:newSectionIndex+1] withRowAnimation:UITableViewRowAnimationFade];
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
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    if(!self.groupEntity)
    {
        return nil;
    }
    _fetchedResultsController = [GMember NIM_fetchAllSortedBy:@"fLitter,fullLitter"
                                                   ascending:YES
                                               withPredicate:[NSPredicate predicateWithFormat:@"group = %@ and userid != %lld",self.groupEntity,self.groupEntity.ownerid]
                                                     groupBy:@"fLitter"
                                                    delegate:self];
    
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


@end
