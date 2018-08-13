//
//  NIMGroupAddVC.m
//  QianbaoIM
//
//  Created by liunian on 14/8/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMGroupAddVC.h"
#import "NIMVcardCollectionViewCell.h"
//#import "NIMSelfViewController.h"
#import "FDListEntity+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#import "GroupList+CoreDataClass.h"
#import "GMember+CoreDataClass.h"
#import "NIMSubSeleteTableViewCell.h"
#import "NIMGroupOperationBox.h"

@interface NIMGroupAddVC ()<NSFetchedResultsControllerDelegate, VcardCollectionViewCellDelegate,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,VcardTableViewCellDelegate,NIMSubSeleteTableViewCellDelegate>
{
    BOOL _searching;
}
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *rightItem;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedOtherResultsController;
@property (nonatomic, strong) NSArray                    *searchResults;
@property (nonatomic, strong) NSMutableArray    *arrayOfCharacters;
@property (nonatomic, strong) NSMutableArray    *datasource;
@property (nonatomic, strong) UITextField     *searchField;
@property (nonatomic,strong)NSString *textContent;
@property (nonatomic, assign) BOOL          searching;
@property (nonatomic,assign)NSInteger collectOffset;


@end

@implementation NIMGroupAddVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[NIMSubSeleteTableViewCell class] forCellReuseIdentifier:kSubSeleteReuseIdentifier];
    [self.collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:kvcardIdentifier];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initilizeConfig];
    [self reloadDataFromDB];
    [self qb_showRightButton:@"确定"];
    [self qb_setTitleText:@"添加新成员"];
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    if (numberOfRows <= 0)
    {
        [MBTip showTipsView:@"没有可以添加的新成员" atView:self.view];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupAdd:) name:NC_GROUP_ADD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataFromDB) name:NC_GROUPMEMBERCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvShipChange:) name:NC_FRIEND_SHIP_TIME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvC_CLIENT_FRIEND_ADD_RQ:) name:NC_CLIENT_FRIEND_ADD_RQ object:nil];


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
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

    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([NSNumber numberWithFloat:self.topLayoutGuide.length]);
        make.leading.equalTo(self.view.mas_leading).with.offset(0);
        make.width.lessThanOrEqualTo([NSNumber numberWithFloat:width]);
        make.height.equalTo(@60);
    }];
    //     [self.collectionView setContentSize:CGSizeMake(self.datasource.count * 70, 60)];
    [self.searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_top).with.offset(20);
        make.leading.equalTo(self.collectionView.mas_trailing).with.offset(0);
        make.bottom.equalTo(self.collectionView.mas_bottom).with.offset(-10);
        make.trailing.equalTo(self.view.mas_trailing);
        
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).with.offset(0);
        make.leading.equalTo(self.collectionView.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
    CGFloat set =self.datasource.count *60-60;
    if (width < 0) {
        set =0;
    }
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

#pragma mark config
- (void)initilizeConfig
{
    NSMutableArray *array = @[UITableViewIndexSearch,@"A", @"B", @"C", @"D", @"E", @"F", @"G",@"H", @"I", @"J", @"K", @"L", @"M", @"N",@"O", @"P", @"Q",@"R", @"S", @"T",@"U", @"V", @"W",@"X", @"Y", @"Z",@"#"].mutableCopy;
    self.arrayOfCharacters = [NSMutableArray arrayWithArray:array];
}

#pragma mark actions
- (void)qb_rightButtonAction{
   
    NSMutableArray *userInfos = @[].mutableCopy;

    [self.datasource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FDListEntity *contact = obj;
        VcardEntity *card = contact.vcard;
        if (card.userid) {
            QBUserBaseInfo *info = [[QBUserBaseInfo alloc] init];
            info.user_id = card.userid;
            info.user_nick_name = [card defaultName];
            [userInfos addObject:info];
        }
    }];
    
//    for (int i=0; i<4; i++) {
//        int64_t userid = 960000+i;
//        NSString *username = [NSString stringWithFormat:@"q_%lld",userid];
//        QBUserBaseInfo *info = [[QBUserBaseInfo alloc] init];
//        info.user_id = userid;
//        info.user_nick_name = username;
//        [userInfos addObject:info];
//    }

    if (userInfos.count == 0) {
        [MBTip showError:@"请至少选择一个好友进行添加" toView:self.view];
    }else{
        if (userInfos.count>self.groupEntity.addMax) {
            [MBTip showError:@"单次拉人达到上限" toView:self.view];
            return;
        }
        NSInteger memberCount = self.groupEntity.membercount + userInfos.count;
        if (memberCount>self.groupEntity.capacity) {
            [MBTip showError:@"群成员已达上限" toView:self.view];
            return;
        }
        if (self.groupEntity.relation && self.groupEntity.ownerid != OWNERID) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"群主已启用“群聊邀请确认”，邀请朋友进群可向群主描述原因。" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                
            }];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *reason = alertController.textFields.firstObject;
                NSLog(@"%@",reason.text);
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                //TODO:邀请
                [[NIMGroupOperationBox sharedInstance] sendGroupAddUserinfos:userInfos groupid:self.groupEntity.groupId opUserid:OWNERID oldMsgid:0 reason:reason.text];
            }];
            [alertController addAction:cancle];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //TODO:邀请
        [[NIMGroupOperationBox sharedInstance] sendGroupAddUserinfos:userInfos groupid:self.groupEntity.groupId opUserid:OWNERID oldMsgid:0 reason:nil];
    }

}

-(void)recvGroupAdd:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showTipsView:param.p_string atView:self.view];
            }else{
                [MBTip showTipsView:@"邀请成功" atView:self.view];
                [self.navigationController popViewControllerAnimated:YES];            }
            
        }else{
            [MBTip showError:@"邀请失败" toView:self.view];
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
                FDListEntity *fdList = self.datasource[i];
                if (fdList.fdPeerId == userid) {
                    [self.datasource removeObject:fdList];
                }
            }
            [self qb_showRightButton:[NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.datasource.count]];
        }
        _fetchedResultsController = nil;
        _fetchedOtherResultsController = nil;
        [self.tableView reloadData];
        
    }
}

- (IBAction)okAction:(id)sender{

}
#pragma mark push
- (void)showFeedProfileWithuserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
//        NSString *source = [NSString stringWithFormat:@"%ld",ChatSource];
//        NIMFeedProfileViewController *feedProfileVC = [[UIStoryboard storyboardWithName:@"NIMSquare" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMFeedProfileViewController"];
//        feedProfileVC.userid = userid;
//        feedProfileVC.sourceType = source;
//        [feedProfileVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

- (void)showViewControllerWithEntity:(FDListEntity *)FDListEntity animated:(BOOL)animated{
    if (![self.datasource containsObject:FDListEntity]) {
        [self.datasource addObject:FDListEntity];
    }else{
        [self.datasource removeObject:FDListEntity];
    }
    [self.collectionView reloadData];
    
    if(self.datasource.count>0)
    {
        if (_collectOffset !=0 && self.datasource.count > _collectOffset) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.datasource.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
    
    NSString *titleStr = [NSString stringWithFormat:@"确定(%lu)",(unsigned long)self.datasource.count];
    [self qb_showRightButton:titleStr];
}

-(void)textFieldChanged
{
    if (![self.textContent isEqualToString:self.searchField.text])
    {
        NSString * searchKey = [self.searchField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (searchKey.length) {
            
            NSMutableSet *vcardEntitys = [NSMutableSet set];
            [self.groupEntity.members enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                GMember *memberEntity = obj;
                [vcardEntitys addObject:@(memberEntity.userid)];
            }];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((fullCNLitter CONTAINS[c] %@) OR (firstLitter CONTAINS[c] %@)  OR (fullLitter CONTAINS[c] %@) OR (fullAllLitter CONTAINS[c] %@)) and fdOwnId = %lld and (fdFriendShip = %d || fdFriendShip = %d) and (fdBlackShip = %d || fdBlackShip = %d) and NOT (fdPeerId in %@)",searchKey,searchKey,searchKey,searchKey,OWNERID,FriendShip_UnilateralFriended,FriendShip_Friended,FD_BLACK_NOT_BLACK,FD_BLACK_PASSIVE_BLACK,vcardEntitys];
            
            self.searchResults = [FDListEntity NIM_findAllSortedBy:@"fullAllLitter" ascending:YES withPredicate:predicate];
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


#pragma mark actions
- (void)refreshViewControlEventValueChanged{
}

#pragma mark config
- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *imageStr = nil;
    if (indexPath.row < self.datasource.count) {
        FDListEntity *FDListEntity = [self.datasource objectAtIndex:indexPath.row];
        VcardEntity *vcardEntity = [FDListEntity vcard];
        imageStr = [vcardEntity avatar];
    }
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr]
                              forState:UIControlStateNormal
                      placeholderImage:[UIImage imageNamed:@"fclogo"]];
    cell.vcardDelegate = self;
    [cell updateConstraints];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView ==  self.tableView) {
        [self.searchField resignFirstResponder];
    }
}

- (void)configureSearchCell:(NIMSubSeleteTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    FDListEntity *fdListEntity = [self.searchResults objectAtIndex:indexPath.row];
    VcardEntity *vcardEntity = [fdListEntity vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:fdListEntity.fdPeerId];
        fdListEntity.vcard = vcardEntity;
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
    if ([self.datasource containsObject:fdListEntity]) {
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
    
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];
    FDListEntity *FDListEntity = nil;
    if (indexPath.section == sectionCnt) {
        FDListEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
    }else{
        FDListEntity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    VcardEntity *vcardEntity = [FDListEntity vcard];
    if (vcardEntity == nil) {
        vcardEntity = [VcardEntity instancetypeFindUserid:FDListEntity.fdPeerId];
        FDListEntity.vcard = vcardEntity;
    }
    [cell updateWithVcardEntity:vcardEntity];
    [cell updateConstraints];
    for (GMember *member in _groupEntity.members) {
        if(vcardEntity.userid == self.groupEntity.ownerid ||member.userid ==self.groupEntity.ownerid )
        {
            //cell.userInteractionEnabled=NO;
            //            [cell.seleteBtn setImage:IMGGET(@"phontLib_select.png") forState:UIControlStateSelected];
        }else if (vcardEntity.userid == member.userid){
            cell.userInteractionEnabled=NO;
            [cell.seleteBtn setImage:IMGGET(@"phontLib_select.png") forState:UIControlStateNormal];
        }
        else
        {
            [cell.seleteBtn setImage:IMGGET(@"select_on.png") forState:UIControlStateSelected];
        }
    }
//    if(vcardEntity.userid == self.groupEntity.ownerid)
//    {
//        [cell.seleteBtn setImage:IMGGET(@"phontLib_select.png") forState:UIControlStateSelected];
//    }
//    else
//    {
//        [cell.seleteBtn setImage:IMGGET(@"select_on.png") forState:UIControlStateSelected];
//    }
    if ([self.datasource containsObject:FDListEntity]) {
        cell.have = YES;
    }else{
        cell.have = NO;
    }
    [cell makeConstraints];
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 90, 0, 0);
//    NSInteger numberOfRows = 0;
//    if ([[self.fetchedResultsController sections] count] > 0){
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
//        numberOfRows = [sectionInfo numberOfObjects];
//        if (indexPath.row == numberOfRows - 1) {
//            cell.hasLineLeadingLeft = YES;
//        }
//    }
    [self updateViewConstraints];
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

- (void)handleFDListEntity1:(FDListEntity *)FDListEntity rowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showViewControllerWithEntity:FDListEntity animated:YES];
        if (IsStrEmpty(self.searchField.text) && self.datasource.count == 0) {
        self.searching = NO;
    }
    [self.tableView reloadData];
    
}

- (void)handleFDListEntity:(FDListEntity *)FDListEntity rowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showViewControllerWithEntity:FDListEntity animated:YES];
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
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark VcardCollectionViewCellDelegate

- (void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIButton *)avatar
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row < self.datasource.count) {
        FDListEntity *FDListEntity = [self.datasource objectAtIndex:indexPath.row];
        VcardEntity *card = FDListEntity.vcard;
        if (card.userid != self.groupEntity.ownerid)
        {
            NSIndexPath *indexP = [self.fetchedResultsController indexPathForObject:FDListEntity];
            [self handleFDListEntity1:FDListEntity rowAtIndexPath:indexP];
        }
    }
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

-(void)click:(UIButton *)btn
{
    NIMSubSeleteTableViewCell *cell = (NIMSubSeleteTableViewCell *)[[btn superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    FDListEntity *fdListEntity = nil;
    if(_searching){
        fdListEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
    }else{
        fdListEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if (fdListEntity == nil) {
        return;
    }
    if (_searching)
    {
        //        self.searchField.text = @"";
        //        [self setSearching:NO];
        //        [self.tableView reloadData];
        
    }
    [self handleFDListEntity:fdListEntity rowAtIndexPath:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_searching){
        return 1;
    }
    
    NSInteger numberOfRows = [[self.fetchedResultsController sections] count];
    
    if (self.fetchedOtherResultsController.fetchedObjects.count>0) {
        numberOfRows += 1;
    }
    
    if (numberOfRows <= 0)
    {
        _tableView.hidden = YES;
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
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    FDListEntity *fdListEntity = nil;
    NSInteger sectionCnt = [[self.fetchedResultsController sections] count];

    if(_searching){
        fdListEntity = (FDListEntity *)[self.searchResults objectAtIndex:indexPath.row];
        if (fdListEntity.fdFriendShip == FriendShip_UnilateralFriended || (fdListEntity.fdFriendShip == FriendShip_Friended && fdListEntity.fdBlackShip == FD_BLACK_PASSIVE_BLACK)) {
            [self showAlertWithFriend:fdListEntity];
            return;
        }
    }else if (indexPath.section == sectionCnt){
        fdListEntity = [self.fetchedOtherResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - sectionCnt]];
        [self showAlertWithFriend:fdListEntity];
        return;
    }
    else{
        fdListEntity = (FDListEntity *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }

    if (fdListEntity == nil) {
        return;
    }
    if (_searching)
    {
//        self.searchField.text = @"";
        //        [self setSearching:NO];
//        [self.tableView reloadData];
        
    }
    [self handleFDListEntity:fdListEntity rowAtIndexPath:indexPath];
}

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
                if ([addDic objectForKey:@"isComeBack"]) {
                    [MBTip showError:@"添加好友成功" toView:self.view.window];
                    NSDictionary * dicts = @{@"userId":[addDic objectForKey:@"userId"],@"fdResult":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
                }
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
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fdOwnId = %lld and (fdFriendShip = 9 || fdFriendShip = 10) and (fdBlackShip = 0 || fdBlackShip = 1) and ((firstLitter CONTAINS[c] %@)  OR (fullLitter CONTAINS[c] %@) OR (fullAllLitter CONTAINS[c] %@))",OWNERID,searchString,searchString,searchString];
//    
//    self.searchResults = [FDListEntity NIM_findAllWithPredicate:predicate];
//    [self.searchDisplayController.searchResultsTableView reloadData];
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
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];;
}

#pragma mark fetch
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSMutableSet *vcardEntitys = [NSMutableSet set];
    [self.groupEntity.members enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        GMember *memberEntity = obj;
        [vcardEntitys addObject:@(memberEntity.userid)];
    }];

//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (fdPeerId in %@) and fdOwnId = %lld and (fdFriendShip = 9 || fdFriendShip = 10) and (fdBlackShip = 0 || fdBlackShip = 1)",vcardEntitys,OWNERID];
    
    //显示可加
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (fdPeerId in %@) and fdOwnId = %lld and fdFriendShip = %d  and fdBlackShip = 0",vcardEntitys,OWNERID,FriendShip_Friended];
    _fetchedResultsController = [FDListEntity NIM_fetchAllGroupedBy:@"firstLitter"
                                                      withPredicate:predicate
                                                           sortedBy:@"firstLitter,fullLitter,fullAllLitter"
                                                          ascending:YES
                                                           delegate:self];
    
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
    NSMutableSet *vcardEntitys = [NSMutableSet set];
    [self.groupEntity.members enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        GMember *memberEntity = obj;
        [vcardEntitys addObject:@(memberEntity.userid)];
    }];
    //显示不可加
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"NOT (fdPeerId in %@) and fdOwnId = %lld and ((fdFriendShip = %d and fdBlackShip = %d) || fdFriendShip = %d ) and (fdBlackShip != %d && fdBlackShip != %d)",vcardEntitys,OWNERID,FriendShip_Friended,FD_BLACK_PASSIVE_BLACK,FriendShip_UnilateralFriended,FD_BLACK_ACTIVE_BLACK,FD_BLACK_MUTUAL_BLACK];
    
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
        UIView* vbg = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.view.bounds.size.width, 62)];
        vbg.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:vbg];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[NIMSubSeleteTableViewCell class] forCellReuseIdentifier:kSubSeleteReuseIdentifier];
        _tableView.estimatedRowHeight =0;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;

        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
