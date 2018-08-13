//
//  NIMAddFriendsViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/8/15.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMAddFriendsViewController.h"
#import "NIMUserOperationBox.h"

//#import "NIMSelfViewController.h"
#import "NIMContactBookViewController.h"
//#import "NIMPublicListsViewController.h"
#import "NIMAddInterestingViewController.h"
#import "NIMScanCodeViewController.h"
#import "UIActionSheet+nimphoto.h"
//#import "NIMSysPublicInfoViewController.h"
//#import "PublicEntity.h"
//#import "NIMAllPublicInfoVC.h"
//#import "NIMPublicSearchController.h"
#import "UIViewController+NIMQBaoUI.h"
#import "NIMPublicListsViewController.h"

#import "NIMPublicSearchController.h"
#import "NIMSelfViewController.h"
//#import "NIMFriendManager.h"
#import "NIMAddDescViewController.h"
#import "NIMSelfViewController.h"

#import "NIMManager.h"
#import "NIMSearchUserManager.h"


@interface NIMAddFriendsViewController ()<UITextFieldDelegate, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, copy) NSString * searchCon;
@end

@implementation NIMAddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self qb_setTitleText:@"添加好友"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USERINFO_RQ_ForAddView:) name:NC_USERINFO_RQ_ForAddView object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.hidesBottomBarWhenPushed =YES;
    
    
    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
    [self.searchDisplayController setActive:NO animated:NO];

    self.searchBar.tintColor = [UIColor darkGrayColor];
    UITextField *searchField = [self.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];

    self.tableView.contentOffset = CGPointMake(0, 0);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //这句话不加在6.0以上版本还是会有线的
//    [self.tableView setSeparatorColor:[UIColor clearColor]];

    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    [self qb_setStatusBar_Default];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchWithKeyword:(NSString *)keyword{
    
//    _searchCon = [keyword lowercaseString];
//    NSString *searchName;
//
//    if ([SSIMSpUtil isPhoneNum:_searchCon]) {
//        searchName = @"mobile";
//    }else if ([SSIMSpUtil isTypeNumber:_searchCon]){
//        searchName = @"userid";
//    }else if ([SSIMSpUtil isEmail:_searchCon]){
//        searchName = @"mail";
//    }else{
//        searchName = @"userName";
//    }
//
//    VcardEntity * vcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%@ = %@",searchName,_searchCon]];
//
//    if (vcard) {
//        NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];
//        feedProfileVC.searchContent = _searchCon;
//        feedProfileVC.vcardEntity = vcard;
//        feedProfileVC.feedSourceType = SearchSource;
//        [feedProfileVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:feedProfileVC animated:YES];
//    }else{
//    _searchCon = keyword;
    _searchCon = [keyword lowercaseString];

        [[NIMUserOperationBox sharedInstance] sendUserInfo:keyword type:Search_AddView];    
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
//    }
}

-(void)recvNC_USERINFO_RQ_ForAddView:(NSNotification *)noti{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([noti.userInfo[@"success"] intValue]) {
//            [MBTip showTipsView:@"查找成功" atView:self.view];
            NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

            feedProfileVC.searchContent = _searchCon;
            feedProfileVC.feedSourceType = SearchSource;
            [feedProfileVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:feedProfileVC animated:YES];
        }else{
            [MBTip showTipsView:noti.userInfo[@"error"]  atView:self.view];
        }
    });
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *keyWord = searchBar.text;
    keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([keyWord length] <= 0) {
        return;
    }
#pragma mark- gzq:使用用户名添加
    [self searchWithKeyword:keyWord];
}
#pragma mark UISearchDisplayDelegate
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
#else
    // For iOS 9+
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";

#endif
    //    [self.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];

    
//    for(UIView *view in  [[[self.searchBar subviews] objectAtIndex:0] subviews]) {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"取消" forState:UIControlStateNormal];
//        }
//    }
    [UIViewController nim_setStatusBar_Default];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    [UIViewController nim_setStatusBar_Default];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    if (!controller.searchResultsDataSource)
    {
        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        controller.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    
    //去除 No Results 标签
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        for (UIView *subview in self.searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]] && ([[(UILabel *)subview text] isEqualToString:@"No Results"] ||[[(UILabel *)subview text] isEqualToString:@"无结果"])) {
                UILabel *label = (UILabel *)subview;
                label.text = @" ";
                break;
            }
        }
    });
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    
    return YES;
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            
            NIMContactBookViewController *feedProfileVC = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMContactBookViewController"];
            [self.navigationController pushViewController:feedProfileVC animated:YES];
            return;
        }
        if(indexPath.row == 1)
        {
            NIMAddInterestingViewController* interesting = (NIMAddInterestingViewController*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QBAddInteresting"];
            [self.navigationController pushViewController:interesting animated:YES];
        }
        if(indexPath.row == 2)
        {
//            NIMPublicListsViewController* publicType = (NIMPublicListsViewController*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMPublicLists"];
//            [self.navigationController pushViewController:publicType animated:YES];
//            
//            NIMPublicSearchController *ctrl =[[NIMPublicSearchController alloc]initWithNibName:@"NIMPublicSearchController" bundle:nil];
//            [self nim_pushToVC:ctrl animal:YES];
            
        }
        if(indexPath.row == 3)
        {
            NIMScanCodeViewController* scan = [[NIMScanCodeViewController alloc] init];
            [self nim_pushToVC:scan animal:YES];
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
