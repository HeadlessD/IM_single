//
//  NIMGroupRemoveVC.m
//  qbim
//
//  Created by 秦雨 on 17/4/20.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupRemoveVC.h"
#import "VcardEntity+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
#import "GMember+CoreDataClass.h"
#import "NIMSubSeleteTableViewCell.h"
#import "NIMGroupOperationBox.h"
@interface NIMGroupRemoveVC ()<NSFetchedResultsControllerDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate,VcardTableViewCellDelegate,NIMSubSeleteTableViewCellDelegate>


@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray    *arrayOfCharacters;
@property (nonatomic, strong) NSMutableArray    *datasource;
@property (nonatomic, strong) UITextField     *searchField;
@property (nonatomic,strong)NSString *textContent;
@property (nonatomic, assign) BOOL          searching;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@end

@implementation NIMGroupRemoveVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[NIMSubSeleteTableViewCell class] forCellReuseIdentifier:kSubSeleteReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initilizeConfig];
    [self reloadDataFromDB];
    [self qb_showRightButton:@"删除"];
    [self qb_setTitleText:@"删除群成员"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromDB) name:NC_GROUPMEMBERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupModify:) name:NC_GROUP_MODIFY object:nil];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    [self.searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([NSNumber numberWithFloat:self.topLayoutGuide.length]);
        make.leading.equalTo(self.view.mas_leading).with.offset(0);
        make.height.equalTo(@60);
        make.trailing.equalTo(self.view.mas_trailing);
        
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchField.mas_bottom).with.offset(0);
        make.leading.equalTo(self.searchField.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)okAction:(id)sender {
}


- (void)reloadDataFromDB{

    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        if ([self.fetchedResultsController performFetch:&error]) {
            
        }
        [self.tableView reloadData];
    });
}

#pragma mark config
- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}

#pragma mark actions
- (void)qb_rightButtonAction{
    
    //    NSMutableArray *userids = @[].mutableCopy;
    //    NSMutableArray *userNames = @[].mutableCopy;
    NSMutableArray *userInfos = @[].mutableCopy;
    
    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GMember *member = obj;
        [userInfos addObject:@(member.userid)];
    }];
    
    //    for (int i=0; i<1; i++) {
    //        int64_t userid = 100000400+i;
    //        NSString *username = [NSString stringWithFormat:@"q_%lld",userid];
    //        QBUserBaseInfo *info = [[QBUserBaseInfo alloc] init];
    //        info.user_id = userid;
    //        info.user_nick_name = username;
    //        [userInfos addObject:info];
    //    }
    
    if (userInfos.count == 0) {
        [MBTip showError:@"请至少选择一个成员进行删除" toView:self.view];
    }else{
        if (userInfos.count>self.groupEntity.addMax) {
            [MBTip showError:@"单次踢人达到上限" toView:self.view];
            return;
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定删除？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //TODO:邀请
            [[NIMGroupOperationBox sharedInstance] sendGroupKickUsers:userInfos groupid:self.groupEntity.groupId];
        }];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cancle];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


#pragma mark push
- (void)showFeedProfileWithuserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
        //        NSString *source = [NSString stringWithFormat:@"%ld",ChatSource];
        //        NIMFeedProfileViewController *feedProfileVC = [[UIStoryboard storyboardWithName:@"NIMSquare" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMFeedProfileViewController"];
        //        feedProfileVC.userid = userid;
        //        feedProfileVC.feedSourceType = source;
        //        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        //        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

- (void)showViewControllerWithEntity:(GMember *)FDListEntity animated:(BOOL)animated{
    if (![self.datasource containsObject:FDListEntity]) {
        [self.datasource addObject:FDListEntity];
    }else{
        [self.datasource removeObject:FDListEntity];
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"删除(%lu)",(unsigned long)self.datasource.count];
    [self qb_showRightButton:titleStr];
}

-(void)textFieldChanged
{
    if (![self.textContent isEqualToString:self.searchField.text])
    {
        NSString * searchKey = [self.searchField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (searchKey.length) {
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(((vcard.nickName CONTAINS[c] %@ ) OR (vcard.nickName CONTAINS[c] %@)  OR (vcard.fullLitter CONTAINS[c] %@)) AND group = %@ AND userid != %lld)", searchKey, searchKey, searchKey, self.groupEntity,OWNERID];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fullLitter CONTAINS[c] %@ OR showName CONTAINS[c] %@ OR allFullLitter CONTAINS[c] %@) AND group = %@ AND userid != %lld", searchKey, searchKey,searchKey, self.groupEntity,OWNERID];

            
            self.searchResults = [GMember NIM_findAllSortedBy:@"ct" ascending:YES withPredicate:predicate];
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView ==  self.tableView) {
        [self.searchField resignFirstResponder];
    }
}

- (void)configureSearchCell:(NIMSubSeleteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GMember *member = [self.searchResults objectAtIndex:indexPath.row];
    VcardEntity *vcardEntity = [member vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:member.userid];
        member.vcard = vcardEntity;
    }
    [cell updateWithVcardEntity:vcardEntity];
    if(vcardEntity.userid == self.groupEntity.ownerid)
    {
        [cell.seleteBtn setImage:IMGGET(@"phontLib_select.png") forState:UIControlStateSelected];
    }
    else
    {
        [cell.seleteBtn setImage:IMGGET(@"select_on.png") forState:UIControlStateSelected];
    }
    if ([self.datasource containsObject:member]) {
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

- (void)configureCell:(NIMSubSeleteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    GMember *memberEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    VcardEntity *vcardEntity = [memberEntity vcard];
//    if (vcardEntity == nil) {
//        vcardEntity = [VcardEntity instancetypeFindUserid:memberEntity.userid];
//        memberEntity.vcard = vcardEntity;
//    }
    [cell updateWithMemberEntity:memberEntity];
    [cell updateConstraints];

    if ([self.datasource containsObject:memberEntity]) {
        cell.have = YES;
    }else{
        cell.have = NO;
    }
    [cell makeConstraints];
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0);
    [self updateViewConstraints];
}


- (void)handleMemberEntity:(GMember *)memberEntity rowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showViewControllerWithEntity:memberEntity animated:YES];
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

-(void)click:(UIButton *)btn
{
    NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[[btn superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    GMember *memberEntity = nil;
    if(_searching){
        memberEntity = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        memberEntity = (GMember *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if (memberEntity == nil) {
        return;
    }
    if (_searching)
    {
        //        self.searchField.text = @"";
        //        [self setSearching:NO];
        //        [self.tableView reloadData];
        
    }
    [self handleMemberEntity:memberEntity rowAtIndexPath:indexPath];
}


-(void)recvGroupModify:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object)
        {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBTip showError:param.p_string toView:self.view];
                });
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            UIAlertController *alertController = [NIMBaseUtil createAlertControllerWithTitle:@"删除群成员失败"];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    });
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_searching){
        return 1;
    }
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    if (numberOfRows <= 0)
    {
        _tableView.hidden = YES;
        [MBTip showTipsView:@"没有可以移除的群成员" atView:self.view];
    }
    else
    {
        _tableView.hidden = NO;
    }
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
    
    
    GMember *memberEntity = nil;
    if(_searching){
        memberEntity = (GMember *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        memberEntity = (GMember *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if (memberEntity == nil) {
        return;
    }
    if (_searching)
    {
        //        self.searchField.text = @"";
        //        [self setSearching:NO];
        //        [self.tableView reloadData];
        
    }
    [self handleMemberEntity:memberEntity rowAtIndexPath:indexPath];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(fullLitter CONTAINS[c] %@)OR (showName CONTAINS[c] %@ OR allFullLitter CONTAINS[c] %@) AND group = %@ AND userid != %lld)", searchString, searchString,searchString, self.groupEntity,OWNERID];
    
    self.searchResults = [GMember NIM_findAllSortedBy:@"ct" ascending:YES withPredicate:predicate];
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
        if(controller.fetchedObjects.count>1){
            [self.tableView endUpdates];
        }
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
                NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"group = %@ and userid != %lld",self.groupEntity,self.groupEntity.ownerid];
    _fetchedResultsController = [GMember NIM_fetchAllSortedBy:@"fLitter,fullLitter,allFullLitter"
                                                   ascending:YES
                                               withPredicate:pre
                                                     groupBy:@"fLitter"
                                                    delegate:self];
    
    
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
- (void)setSearching:(BOOL)searching{
    if (_searching != searching) {
        _searching = searching;
    }
    
}

- (UITextField *)searchField{
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectZero];
        _searchField.backgroundColor = [UIColor whiteColor];
        [_searchField setBorderStyle:UITextBorderStyleNone]; //外框类型
        _searchField.placeholder = @"   搜索"; //默认显示的字
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[NIMSubSeleteTableViewCell class] forCellReuseIdentifier:kSubSeleteReuseIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
