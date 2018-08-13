//
//  NIMGroupLeaderChangeVC.m
//  qbim
//
//  Created by 秦雨 on 17/3/8.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupLeaderChangeVC.h"
#import "GMember+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMGroupOperationBox.h"
#import "NIMDefaultTableViewCell.h"
#import "ChatListEntity+CoreDataClass.h"
#import "NIMSContactTableViewCell.h"
#import "NIMBadgeTableViewCell.h"
#import "UIViewController+NIMQBaoUI.h"
#import "NIMChatGroupSettingVC.h"
#import "UIAlertView+NIMBlocks.h"
@interface NIMGroupLeaderChangeVC ()<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray *arrayOfCharacters;
@property (nonatomic, assign) BOOL searching;

@end

@implementation NIMGroupLeaderChangeVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.searchDisplayController.searchResultsTableView registerClass:[NIMSContactTableViewCell class]
//                                                forCellReuseIdentifier:kSContactReuseIdentifier];
//    [self.searchDisplayController.searchResultsTableView registerClass:[NIMDefaultTableViewCell class]
//                                                forCellReuseIdentifier:kDefaultReuseIdentifier];
//    self.searchDisplayController.searchResultsTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
//
    [self initilizeConfig];
//    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
//    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
//    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromDB) name:NC_GROUPMEMBERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLeader:) name:NC_GROUPLEADERCHANGE object:nil];

    _searching = NO;
    [self reloadDataFromDB];
    
    [self qb_setStatusBar_Light];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([NSNumber numberWithFloat:self.topLayoutGuide.length]);
        make.leading.equalTo(self.view.mas_leading).with.offset(0);
        make.height.equalTo(@0);
        make.trailing.equalTo(self.view.mas_trailing);
        
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchField.mas_bottom).with.offset(0);
        make.leading.equalTo(self.searchField.mas_leading);
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




- (void)reloadDataFromDB{
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        
    }
    [self.tableView reloadData];
}

#pragma mark config
#pragma mark 优先备注
- (void)configureSearchCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GMember *memberEntity = [self.searchResults objectAtIndex:indexPath.row];
    
    [cell updateWithMemberEntity:memberEntity];
    
    [self updateViewConstraints];
    //UIFont *font = [UIFont boldSystemFontOfSize:16];
    
    //    [cell.titleLable setOriginalText:name
    //                        originaColor:cell.titleLable.textColor
    //                        originalFont:cell.titleLable.font
    //                       attributedStr:self.searchText
    //                     attributedColor:[UIColor redColor]
    //                      attributerFont:font];
    //[cell layoutSubviews];
}
#pragma mark 优先备注
- (void)configureCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GMember *memberEntity = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    VcardEntity *vcardEntity = [memberEntity vcard];
    
    vcardEntity = [VcardEntity instancetypeFindUserid:memberEntity.userid];
    
    [cell updateWithVcardEntity:vcardEntity];
    
    NSString *name = nil;
    
    FDListEntity *fd = [FDListEntity instancetypeFindFriendId:memberEntity.userid];
    
    if (!IsStrEmpty(fd.fdRemarkName)) {
        name = fd.fdRemarkName;
    }else if (!IsStrEmpty(memberEntity.groupmembernickname)){
        name = memberEntity.groupmembernickname;
    }else{
        name = vcardEntity.defaultName;
    }
    
    cell.titleLable.text = name;
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


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_searching){
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searching) {
        NIMDefaultTableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
        [self configureSearchCell:cell atIndexPath:indexPath];
        return cell;
    }
    
    NIMDefaultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
//    cell.delegate=self;
    //        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    //        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1]
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_searching){
        return 1;
    }
    
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    return numberOfRows;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(_searching){
        return @"搜索结果";
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

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GMember *member = nil;
    if(_searching){
        member = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
    }
    member = (GMember *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (member==nil) {
        return;
    }
    
    FDListEntity *fd = [FDListEntity instancetypeFindFriendId:member.userid];
    VcardEntity *vcard = [VcardEntity instancetypeFindUserid:member.userid];

    NSString *name = IsStrEmpty(fd.fdRemarkName)?member.groupmembernickname:fd.fdRemarkName;
    if (IsStrEmpty(name)) {
        name = [vcard defaultName];
    }
    
    NIMRIButtonItem *okItem = [NIMRIButtonItem itemWithLabel:@"确定" action:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        [[NIMGroupOperationBox sharedInstance] sendLeaderChangeUserid:member.userid groupid:self.groupEntity.groupId];
    }];
    NIMRIButtonItem *cancelItem = [NIMRIButtonItem itemWithLabel:@"取消"];
    
    NSString *ts = [NSString stringWithFormat:@"确定选择 %@ 为新群主，您将自动放弃群主身份。",name];
    UIAlertView *alter = [[UIAlertView alloc]initWithNimTitle:@"" message:ts cancelButtonItem:cancelItem otherButtonItems:okItem, nil];
    [alter show];
}

-(void)changeLeader:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showTipsView:@"转让成功" atView:self.view afterDelay:kTipsDelay];
                NSArray *temArray = self.navigationController.viewControllers;
                
                for(UIViewController *temVC in temArray)
                    
                {
                    
                    if ([temVC isKindOfClass:[NIMChatGroupSettingVC class]])
                        
                    {
                        
                        [self.navigationController popToViewController:temVC animated:YES];
                        
                    }
                    
                }
            });
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUPMEMBERCHANGE object:object];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBTip showTipsView:@"转让失败" atView:self.view];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUPMEMBERCHANGE object:nil];
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
    self.searchResults = @[];
    _searching = YES;

    [self qb_setStatusBar_Default];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    _searching = NO;
    [self qb_setStatusBar_Light];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    self.searchText = searchString;
    
    
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(group = %@) and ((fLitter CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@)OR (card CONTAINS[c] %@)OR (groupmembernickname CONTAINS[c] %@) and userid != %lld)",self.groupEntity, searchString,searchString, searchString, searchString,searchString,searchString,OWNERID];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fullLitter CONTAINS[c] %@ OR showName CONTAINS[c] %@) AND group = %@ AND userid != %lld", searchString, searchString, self.groupEntity,OWNERID];

    
    self.searchResults = [GMember NIM_findAllWithPredicate:predicate];
//    [self.tableView reloadData];
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


-(void)textFieldChanged
{
    if (![self.searchText isEqualToString:self.searchField.text])
    {
        NSString * searchString = [self.searchField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (searchString.length) {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(group = %@) and ((vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@)OR (card CONTAINS[c] %@)OR (groupmembernickname CONTAINS[c] %@))",self.groupEntity, searchString, searchString, searchString,searchString,searchString];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fullLitter CONTAINS[c] %@ OR showName CONTAINS[c] %@) AND group = %@ AND userid != %lld", searchString, searchString, self.groupEntity,OWNERID];

            self.searchResults = [GMember NIM_findAllWithPredicate:predicate];
            _searching = YES;
            [self.tableView reloadData];
        }
        
    }
    if (IsStrEmpty(self.searchField.text))
    {
        _searching = NO;
        [self.tableView reloadData];
    }
    self.searchText = self.searchField.text;
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    //if(controller.fetchedObjects.count+1>0)
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
    });
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //if(controller.fetchedObjects.count+1>=0)
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
                //            NSIndexPath *nIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
                //            NIMDefaultTableViewCell *cell = (NIMDefaultTableViewCell *)[tableView cellForRowAtIndexPath:nIndexPath];
                //            [self configureCell:cell atIndexPath:nIndexPath];
                [self.tableView reloadData];
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
    _fetchedResultsController = [GMember NIM_fetchAllSortedBy:@"fullLitter"
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



- (UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectZero];
//        _searchField.backgroundColor = [UIColor whiteColor];
//        [_searchField setBorderStyle:UITextBorderStyleNone]; //外框类型
//        _searchField.placeholder = @"   搜索"; //默认显示的字
//        _searchField.autocorrectionType = UITextAutocorrectionTypeNo;
//        _searchField.font = [UIFont systemFontOfSize:14];
//        _searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        _searchField.returnKeyType = UIReturnKeyDone;
//        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
//        _searchField.delegate = self;
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(textFieldChanged)
//                                                     name:UITextFieldTextDidChangeNotification
//                                                   object:_searchField];
        [self.view addSubview:_searchField];
    }
    return _searchField;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
        _tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
        _tableView.sectionIndexColor = [UIColor darkGrayColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



@end
