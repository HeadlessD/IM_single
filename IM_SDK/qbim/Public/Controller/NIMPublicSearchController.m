//
//  NIMPublicSearchController.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/6/25.
//  Copyright (c) 2015年 qianbao.com. All rights reserved.
//

#import "NIMPublicSearchController.h"
#import "NIMPublicMode.h"
#import "NIMPublicSearchResultCell.h"
#import "UIViewController+NIMQBaoUI.h"
#import "NIMAllPublicInfoVC.h"
#import "NIMPublicSearchingCell.h"
#import "NIMJXFeaturedResultCell.h"
#import "NIMPublicOperationBox.h"
#import "NIMMessageCenter.h"
@interface NIMPublicSearchController ()<NIMJXFeaturedResultCellDeleagate,NIMPublicSearchResultCellDeleagate>
@property(nonatomic,strong)UISearchDisplayController *m_searchDisPlayCtroller;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,strong)NSMutableArray *reCommendArray;
@property(nonatomic)       NSInteger       offset;
@property(nonatomic)       NSInteger       Reoffset;

@property(nonatomic,strong)publicMode    *publicObject;
@property(nonatomic)  BOOL         isSearching;
@property(nonatomic)  BOOL         isSearched;
@property(nonatomic,strong) UIView *m_headView;
@end

@implementation NIMPublicSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor =[SSIMSpUtil getColor:@"F1F1F1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self qb_setTitleText:@"添加公众号"];
    _offset=0;
    _Reoffset =0;
//    UIView * bottomHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
//    bottomHeaderView.backgroundColor = [UIColor redColor];
//    [bottomHeaderView addSubview:self.m_headView];
//    self.m_tableView.tableHeaderView =bottomHeaderView;
    self.m_tableView.tableHeaderView =self.m_headView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableCell:) name:@"RELOADCELL" object:nil];
    self.m_tableView.backgroundColor =[UIColor clearColor];
    self.m_tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
//    [self.m_tableView addHeaderWithTarget:self action:@selector(refreshData)];
//    [self.m_tableView addFooterWithTarget:self action:@selector(loadMore)];
    

    self.isSearching=NO;
    [self getRecommentData];
    if (IsStrEmpty(self.m_searchString)) {
        return;
    }
    else
    {
        self.isSearching =YES;
        self.isSearched=YES;
        self.m_searchBar.text =self.m_searchString;
        [self searchPublicByString:self.m_searchString];
    }

   
    
}
-(void)reloadTableCell:(NSNotification*)notification
{
    
    NSIndexPath *indexpath=[notification.object objectForKey:@"index"];
    NSString    *statue =[notification.object objectForKey:@"statue"];

    UITableViewCell *cell =[self.m_tableView cellForRowAtIndexPath:indexpath];
    if ([cell isKindOfClass:[NIMPublicSearchResultCell class]]) {
        NIMPublicSearchResultCell *jxcell =(NIMPublicSearchResultCell*)cell;

        if ([statue isEqualToString:@"1"]) {
            
            [jxcell updateButnState];
        }
        else
        {
            [jxcell changeButnState];
        }
        
    }
    else if ([cell isKindOfClass:[NIMJXFeaturedResultCell class]]) {
        NIMJXFeaturedResultCell *jxcell =(NIMJXFeaturedResultCell*)cell;
        
        //公众号详情改变关注状态，在不重新请求的情况下，执行修改数组里面的publicMode-by,yanhao
        publicMode *tmppublic = [self.reCommendArray objectAtIndex:indexpath.row];
        tmppublic.subscribed = statue;
        [self.reCommendArray replaceObjectAtIndex:indexpath.row withObject:tmppublic];

        
        if ([statue isEqualToString:@"1"]) {
        [jxcell updateButnState];
        }
        else
        {
            [jxcell changeButnState];
        }

    }

//        [self.m_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)reloadRequest
{
    
}
-(void)getRecommentData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    /*
    [[NIMManager sharedImManager]featuredPublicSearchKeyWord:@"" offset:_Reoffset limit:20 completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!result) {
            [self.m_tableView footerEndRefreshing];
            [self.m_tableView headerEndRefreshing];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            NSDictionary *dic =(NSDictionary*)object;
            NSArray *publicArray = PUGetObjFromDict(@"items", dic, [NSArray class]);
            [publicArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary* dic = (NSDictionary*)obj;
                publicMode *public =[[publicMode alloc]initWithDic:dic];
                [self.reCommendArray addObject:public];
                
            }];
            [self.m_tableView reloadData];
            }
            else
            {
                [self.m_tableView footerEndRefreshing];
                [self.m_tableView headerEndRefreshing];
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

                [self.view showTipsView:result.message];
            }
        });
        
    }];
     */

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self qb_setTitleText:@"添加公众号"];
}
- (void)refreshData
{
    if (self.isSearching==NO) {
        [self.reCommendArray removeAllObjects];
        _Reoffset =0;
        [self getRecommentData];
    }
    else
    {
    [self.searchArray removeAllObjects];
    _offset=0;
     [self searchPublicByString:self.m_searchBar.text];
    }
}
-(void)loadMore
{
    if (self.isSearching == NO) {
        _Reoffset =self.reCommendArray.count;
        [self getRecommentData];
    }
    else
    {
    _offset = self.searchArray.count;
    [self searchPublicByString:self.m_searchBar.text];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    if (self.isSearching==YES){
        if(self.isSearched ==YES)
        {
            if (self.searchArray.count==0) {
                return 1;
            }
            else
            {
                rows = [self.searchArray count];
            }
        }
        else
        {
            return 1;
        }
    }else{
        rows = [self.reCommendArray count];
    }
    return rows;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isSearching==YES) {
        
        if (self.isSearched==YES) {
            if (self.searchArray.count==0) {
                return nil;
            }
            else
            {
                UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self
                                                                          .view.frame.size.width, 40)];
                headView.backgroundColor=[UIColor whiteColor];
                UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
                title.text =@"相关公众号";
                title.textColor =[SSIMSpUtil getColor:@"888888"];
                title.font =[UIFont systemFontOfSize:14];
                [headView addSubview:title];
                
                UIView * line =[[UIView alloc]initWithFrame:CGRectMake(10, 39,  self
                                                                       .view.frame.size.width-10,_LINE_HEIGHT_1_PPI )];
                line.backgroundColor =[SSIMSpUtil getColor:@"e6e6e6"];
                [headView addSubview:line];
                return headView;
            }
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isSearching==YES) {
        if(self.isSearched==YES)
        {
            if (self.searchArray.count==0) {
                return 1;
            }
            else
            {
                return 40;
            }
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"publicCell";
    NIMJXFeaturedResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[NIMJXFeaturedResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.delegate=self;
    }
    
    if (self.isSearching==NO) {
        
        if (self.reCommendArray.count>0) {
            [cell setCellDataSource:[self.reCommendArray objectAtIndex:indexPath.row]];
        }
        else
        {
            return cell;
        }
        
    }
    else
    {
        
        if(self.isSearched==NO)
        {
            static NSString *cellId1 = @"searchingCell";
            NIMPublicSearchingCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellId1];
            
            if (cell1 == nil) {
                cell1 = [[NIMPublicSearchingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
            }
            [cell1 setCellDataSource:self.m_searchBar.text type:0];
            return cell1;
            
        }
        else
        {
            if (self.searchArray.count==0) {
                static NSString *cellId1 = @"searchingCell";
                NIMPublicSearchingCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellId1];
                cell1.selectionStyle =UITableViewCellSelectionStyleNone;
                if (cell1 == nil) {
                    cell1 = [[NIMPublicSearchingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId1];
                }
                [cell1 setCellDataSource:self.m_searchBar.text type:1];
                return cell1;
            }
            else
            {
                static NSString *cellId2 = @"JXpublicCell";
                NIMPublicSearchResultCell *JXcell = [tableView dequeueReusableCellWithIdentifier:cellId2];
                
                if (JXcell == nil) {
                    JXcell = [[NIMPublicSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
                    JXcell.delegate=self;
                }
                
                [JXcell setCellDataSource:[self.searchArray objectAtIndex:indexPath.row] searchString:self.m_searchBar.text];
                return JXcell;
            }
        }
    }
    return cell;
}
-(void)JXPublicfollowBtnPressed:(UITableViewCell *)cell publicMode:(publicMode *)publicModes
{
    if(/*! [NIMMessageCenter sharedInstance].isQbaoLoginSuccess*//* DISABLES CODE */ (1))
    {
//        [[NIMLoginOperationBox sharedInstance]showloginView];
    }
    else
    {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NIMPublicOperationBox sharedInstance] subscribePublic:publicModes.publicid.doubleValue andSource:SearchSource completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (result) {
                [MBTip showError:result.message toView:self.view];
            }else{
                
                if ([cell isKindOfClass:[NIMPublicSearchResultCell class]]) {
                    NIMPublicSearchResultCell *jxcell1 =(NIMPublicSearchResultCell*)cell;
                    [jxcell1 updateButnState];
                }
                else if ([cell isKindOfClass:[NIMJXFeaturedResultCell class]]) {
                    NIMJXFeaturedResultCell *jxcell2 =(NIMJXFeaturedResultCell*)cell;
                    
                    //增加在不重新请求的情况下,修改关注的状态改变，防止tableviewcell重绘后又恢复最初的关注状态-by,yanhao
                    NSIndexPath *indexpath = [self.m_tableView indexPathForCell:cell];
                    publicMode *tmppublic = [self.reCommendArray objectAtIndex:indexpath.row];
                    tmppublic.subscribed = @"1";//已关注
                    [self.reCommendArray replaceObjectAtIndex:indexpath.row withObject:tmppublic];
                    
                    [jxcell2 updateButnState];
                }
                
            }
        });
    }];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearching==YES) {
        if (self.isSearched==YES) {
            if (self.searchArray.count==0) {
                //                NIMPublicSearchController *ctrl =[[NIMPublicSearchController alloc]initWithNibName:@"NIMPublicSearchController" bundle:nil];
                //                ctrl.m_searchString = self.m_searchBar.text;
                //                [self nim_pushToVC:ctrl animal:YES];
                
            }
            else{
                publicMode *public =(publicMode*)[self.searchArray objectAtIndex:indexPath.row];
                NIMAllPublicInfoVC *vc = [[NIMAllPublicInfoVC alloc]init];
                vc.publicid= public.publicid.doubleValue;
                vc.m_indexPath = indexPath;
                vc.publicSourceType = SearchSource;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            self.isSearched=YES;
            [self.searchArray removeAllObjects];
            [self.m_searchBar resignFirstResponder];
            NSString *keyWord = self.m_searchBar.text;
            
            keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([keyWord length] <= 0) {
                return;
            }
            else
            {
//                [self.m_tableView.mj_header setHidden:NO];
//                [self.m_tableView.mj_footer setHidden:NO];
                [self searchPublicByString:self.m_searchBar.text];
            }
            
        }
    }
    else
    {
        publicMode *public =(publicMode*)[self.reCommendArray objectAtIndex:indexPath.row];
        NIMAllPublicInfoVC *vc = [[NIMAllPublicInfoVC alloc]init];
        vc.publicid= public.publicid.doubleValue;
        vc.m_indexPath = indexPath;
        vc.publicSourceType = SearchSource;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.m_searchBar resignFirstResponder];
}

#pragma mark UISearchDisplayDelegate
//- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        //CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformMakeTranslation(0, 0);
//        }];
//    }
//    [UIViewController qb_setStatusBar_Default];
//}
//- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
//{
//    [UIViewController qb_setStatusBar_Light];
//}
//- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [UIView animateWithDuration:0.25 animations:^{
//            for (UIView *subview in self.view.subviews)
//                subview.transform = CGAffineTransformIdentity;
//        }];
//    }
//    
//}
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
//    
//    if (!controller.searchResultsDataSource)
//    {
//        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//    else
//    {
//        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
//        return YES;
//}
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
//

//去除 No Results 标签
//dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
//dispatch_after(popTime, dispatch_get_main_queue(), ^{
//    for (UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
//        if ([subview isKindOfClass:[UILabel class]] && [[(UILabel *)subview text] isEqualToString:@"No Results"]) {
//            UILabel *label = (UILabel *)subview;
//            label.text = @"无结果";
//            break;
//        }
//    }
//});

//    return YES;
//}
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.m_searchBar setShowsCancelButton:YES];
    NSArray *searchBarSubViews = [[_m_searchBar.subviews objectAtIndex:0] subviews];
    
    for (UIView* v in searchBarSubViews)
    {
        if ( [v isKindOfClass: [UIButton class]] )
        {
            UIButton *btn = (UIButton *)v;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}
-(void)cancleBtnPressed
{
    [self.m_searchBar resignFirstResponder];
    self.isSearched =NO;
    self.isSearching =NO;
    self.m_searchBar.text=@"";
     [self qb_hideNoDataView];
    [self.m_tableView reloadData];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.m_searchBar setShowsCancelButton:NO];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    DBLog(@"searching");
    self.isSearched =YES;
    [self.searchArray removeAllObjects];
    [self.m_searchBar resignFirstResponder];
    NSString *keyWord = searchBar.text;
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([keyWord length] <= 0) {
        return;
    }
    else
    {
        [self searchPublicByString:searchBar.text];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (IsStrEmpty(searchBar.text)) {
        self.isSearching =NO;
        [self qb_hideNoDataView];
        [self.m_tableView reloadData];
    }
   else
   {
       self.isSearching =YES;
       self.isSearched =NO;
       [self.m_tableView reloadData];
   }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.m_searchBar.text=@"";
    self.isSearching=YES;
    self.isSearched=NO;
    [self.searchArray removeAllObjects];
     [self qb_hideNoDataView];
    [self.m_tableView reloadData];
}
-(void)searchPublicByString:(NSString*)searchString
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];

    /*
    [[NIMManager sharedImManager]SearchPublic:searchString offset:_offset limit:20 completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_tableView footerEndRefreshing];
        [self.m_tableView headerEndRefreshing];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        NSDictionary *dic =(NSDictionary*)object;
        NSArray *publicArray = PUGetObjFromDict(@"items", dic, [NSArray class]);
        [publicArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary* dic = (NSDictionary*)obj;
            publicMode *public =[[publicMode alloc]initWithDic:dic];
            [self.searchArray addObject:public];
            
        }];
            [self.m_tableView reloadData];
        });

    }];
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(UISearchBar*)m_searchBar
{
    if (!_m_searchBar) {
        _m_searchBar =[[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
        _m_searchBar.placeholder = @"公众号账号/公众号名称";
        _m_searchBar.barTintColor =[UIColor whiteColor];
        _m_searchBar.backgroundColor =[UIColor whiteColor];
        [[[[ _m_searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
        _m_searchBar.layer.borderColor =[UIColor clearColor].CGColor;
        _m_searchBar.layer.borderWidth =0.5;
        _m_searchBar.delegate =self;
        _m_searchBar.returnKeyType =UIReturnKeySearch;
       
    }
    return _m_searchBar;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}
-(NSMutableArray*)searchArray
{
    if (!_searchArray) {
        _searchArray =[[NSMutableArray alloc]init];
    }
    return _searchArray;
}
-(NSMutableArray*)reCommendArray
{
    if (!_reCommendArray) {
        _reCommendArray =[[NSMutableArray alloc]init];
    }
    return _reCommendArray;
}
-(UIView*)m_headView
{
    if (!_m_headView) {
        _m_headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
        _m_headView.backgroundColor =[UIColor clearColor];
        [_m_headView addSubview:self.m_searchBar];

    }
    return _m_headView;
}
@end
