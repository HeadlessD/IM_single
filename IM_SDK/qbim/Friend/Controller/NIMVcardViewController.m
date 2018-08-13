//
//  NIMVcardViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/8/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMVcardViewController.h"
#import "VcardEntity+CoreDataClass.h"
#import "FDListEntity+CoreDataClass.h"
#import "NIMSelfViewController.h"
//#import "MBProgressHUD+Add.h"
#import "NIMVcardTableViewCell.h"
//#import "MessageNIMOperationBox.h"
#import "NIMDefaultTableViewCell.h"

@interface NIMVcardViewController ()<NSFetchedResultsControllerDelegate, UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray *arrayOfCharacters;
@property (nonatomic, strong) NSMutableArray  *datasource;
@property (nonatomic, strong) NSArray  *publicEntitys;
@property (nonatomic, strong) NSArray  *publicSearchEntitys;
@end

@implementation NIMVcardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeConfig];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"offcialid > 0 and fansid=%lld",OWNERID];
    
    _publicEntitys = [NOffcialEntity NIM_findAllWithPredicate:predicate];
    [self.searchDisplayController.searchResultsTableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.searchDisplayController.searchResultsTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
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

- (void)qb_back{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark config
- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}

#pragma mark actions
- (void)forwardToContactEntity:(FDListEntity *)contactEntity{
    if (contactEntity == nil) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)selectedToSendVcard:(NSString *)cardInfo{
    
    if ([_delegate respondsToSelector:@selector(VcardViewController:didSelectedWithCardInfos:)]) {
        [_delegate VcardViewController:self didSelectedWithCardInfos:@[cardInfo]];
        [self toBack:nil];
    }
    
}

#pragma mark push
- (void)showFeedProfileWithuserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType  =ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

- (void)showViewControllerWithEntity:(FDListEntity *)contactEntity animated:(BOOL)animated{

    VcardEntity *card = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
    NSDictionary*bodyDic=@{@"showName":[card defaultName],@"avatar":@"",@"id":@(card.userid),@"type":@0};
    NSData*bodyData=[NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyString = [[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    switch (_vcardType) {
        case VcardActionTypeSelected:
            [self selectedToSendVcard:bodyString];
            break;
        case VcardActionTypeForward:
            [self forwardToContactEntity:contactEntity];
            break;
        case VcardActionTypeShare:
        {
            if (![self.datasource containsObject:contactEntity]) {
                [self.datasource addObject:contactEntity];
            }else{
                [self.datasource removeObject:contactEntity];
            }

        }
            break;
        default:
            break;
    }
    
}


- (void)showViewControllerWithPublicEntity:(NOffcialEntity *)publicEntity animated:(BOOL)animated{
    
    NSDictionary*bodyDic=@{@"showName":publicEntity.name,@"avatar":publicEntity.avatar,@"id":@(publicEntity.offcialid),@"type":@1};
    NSData*bodyData=[NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyString = [[NSString alloc]initWithData:bodyData encoding:NSUTF8StringEncoding];
    
    switch (_vcardType) {
        case VcardActionTypeSelected:
        {
            [_delegate VcardViewController:self didSelectedWithCardInfos:@[bodyString]];
            [self toBack:nil];
        }
            break;
        case VcardActionTypeForward:

            break;
        case VcardActionTypeShare:
        {

            
        }
            break;
        default:
            break;
    }
    
}



#pragma mark actions
- (void)refreshViewControlEventValueChanged{


}

- (IBAction)toBack:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark config
- (void)updateVcardCell:(NIMVcardTableViewCell *)cell withVcardEntity:(VcardEntity *)vcardEntity{
    
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:USER_ICON_URL(vcardEntity.userid)] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];

    NSString *firstName = [NIMStringComponents finFristNameWithID:vcardEntity.userid];
    cell.nameLabel.text = firstName;
}

- (void)configureSearchCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{

    if (self.publicSearchEntitys.count>0)
    {
        if (indexPath.section ==0)
        {
//            NOffcialEntity *contactEntity  = [self.publicSearchEntitys objectAtIndex:indexPath.row];
//            [cell updateWithPublicEntity:contactEntity];
        }
        else
        {
            NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section -1];
            FDListEntity *contactEntity  = [self.searchResults objectAtIndex:theNewIndexPath.row];
            VcardEntity *vcardEntity = [contactEntity vcard];
            if (vcardEntity == nil) {
                vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
                contactEntity.vcard = vcardEntity;
            }
            [cell updateWithVcardEntity:vcardEntity];
        }
    }
    else
    {
        FDListEntity *contactEntity  = [self.searchResults objectAtIndex:indexPath.row];
        VcardEntity *vcardEntity = [contactEntity vcard];
        if (vcardEntity == nil) {
            vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
            contactEntity.vcard= vcardEntity;
        }
        [cell updateWithVcardEntity:vcardEntity];
    }

}

- (void)configureCell:(NIMVcardTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    if (_publicEntitys.count > 0) {
        if (indexPath.section == 0) {
            NOffcialEntity *publicEntity = _publicEntitys[indexPath.row];
            
            [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:publicEntity.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
            cell.nameLabel.text = publicEntity.name;
            
        }else{
            NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section -1];
            FDListEntity *contactEntity = [self.fetchedResultsController objectAtIndexPath:theNewIndexPath];
            VcardEntity *vcardEntity = [contactEntity vcard];
            if (vcardEntity == nil) {
                vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
                contactEntity.vcard = vcardEntity;
            }
            [self updateVcardCell:cell withVcardEntity:vcardEntity];
        }
    }else{
        FDListEntity *contactEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
        VcardEntity *vcardEntity = [contactEntity vcard];
        if (vcardEntity == nil) {
            vcardEntity = [VcardEntity instancetypeFindUserid:contactEntity.fdPeerId];
//            contactEntity.vcard = vcardEntity;
        }
        [self updateVcardCell:cell withVcardEntity:vcardEntity];
    }
    

}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.publicSearchEntitys.count >0) {
            if (section == 0) {
                return self.publicSearchEntitys.count;
            }
            else
            {
                if (self.searchResults) {
                    return self.searchResults.count;
                }
            }
        }
        else
        {
            if (self.searchResults) {
                return self.searchResults.count;
            }
        }
        return 0;
    }
    
    if (_publicEntitys.count >0) {
        if (section == 0) {
            return _publicEntitys.count;
        }else{
            NSInteger numberOfRows = 0;
            if ([[self.fetchedResultsController sections] count] > 0){
                id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section - 1];
                numberOfRows = [sectionInfo numberOfObjects];
            }
            
            return numberOfRows;
        }
        
    }else{
        NSInteger numberOfRows = 0;
        if ([[self.fetchedResultsController sections] count] > 0){
            id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
            numberOfRows = [sectionInfo numberOfObjects];
        }
        
        return numberOfRows;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NIMDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier];
        [self configureSearchCell:cell atIndexPath:indexPath];
        return cell;
    }else{
        
//        NIMVcardTableViewCell * cell = (NIMVcardTableViewCell*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMVcardTableViewCell"];
//        [self configureCell:cell atIndexPath:indexPath];
//        return cell;
        
        NIMVcardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResuIdentifier forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
         return cell;
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.publicSearchEntitys.count>0) {
            return 2;
        }
        return 1;
    }
    
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    
    if (_publicEntitys.count >0) {
        numberOfRows+= 1;
    }
    return numberOfRows;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.publicSearchEntitys.count>0) {
            if (section == 0) {
                return @"公众号";
            }
        }
        if (self.searchResults.count >0) {
            if (section == 1) {
                return @"联系人";
            }
        }
        return @"搜索结果";
    }
    NSString *indexTitle = @"";
    if (_publicEntitys.count >0) {
        if (section == 0) {
            indexTitle = @"公众号";
        }else{
            indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section - 1];
        }
    }else{
        indexTitle =  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
    }
    
    return indexTitle;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    else
    {
        return self.arrayOfCharacters;
    }
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
        int sectionCount = [keys count];
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
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        if (self.publicSearchEntitys.count >0)
        {
            if (indexPath.section == 0)
            {
                NOffcialEntity *contactEntity  = [self.publicSearchEntitys objectAtIndex:indexPath.row];
                [self showViewControllerWithPublicEntity:contactEntity animated:YES];
            }
            else
            {
                NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section -1];
                FDListEntity *contactEntity  = [self.searchResults objectAtIndex:theNewIndexPath.row];
                [self showViewControllerWithEntity:contactEntity animated:YES];
            }
        }
        else
        {
            FDListEntity *contactEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
            [self showViewControllerWithEntity:contactEntity animated:YES];
        }
    }else{
        if (_publicEntitys.count > 0) {
            if (indexPath.section == 0) {
                NOffcialEntity *publicEntity = _publicEntitys[indexPath.row];
                
                [self showViewControllerWithPublicEntity:publicEntity animated:YES];
            }else{
                
                NSIndexPath *theNewIndexPaht = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
                FDListEntity *contactEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:theNewIndexPaht];
                if (contactEntity == nil) {
                    return;
                }
                [self showViewControllerWithEntity:contactEntity animated:YES];
                
            }
            
        }else{
            FDListEntity *contactEntity = nil;
            if(tableView == self.searchDisplayController.searchResultsTableView){
                contactEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
            }else{
                contactEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
            }
            
            if (contactEntity == nil) {
                return;
            }
            [self showViewControllerWithEntity:contactEntity animated:YES];
        }
    
    }
    

    

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((fdRemarkName CONTAINS[c] %@) OR (fdNickName CONTAINS[c] %@) OR (fullLitter CONTAINS[c] %@) OR (firstLitter CONTAINS[c] %@) OR (vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@)) AND fdOwnId = %lld AND (fdFriendShip = %d || fdFriendShip = %d)",searchString ,searchString, searchString, searchString,searchString ,searchString, searchString,OWNERID,FriendShip_Friended,FriendShip_UnilateralFriended];
    
    self.searchResults = [FDListEntity NIM_findAllWithPredicate:predicate];
    
    NSArray *results_public = [NOffcialEntity NIM_findAllSortedBy:@"name" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"name contains[cd] %@",searchString]];
    
    self.publicSearchEntitys =results_public;
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
                NIMVcardTableViewCell *cell = (NIMVcardTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                [self configureCell:cell atIndexPath:indexPath];
            }
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }    });
    
    
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
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d)",OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK];

    _fetchedResultsController = [FDListEntity NIM_fetchAllGroupedBy:@"firstLitter"
                                                     withPredicate:pre sortedBy:@"firstLitter,fullLitter" ascending:YES delegate:self];
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = @[].mutableCopy;
    }
    return _datasource;
}

@end
