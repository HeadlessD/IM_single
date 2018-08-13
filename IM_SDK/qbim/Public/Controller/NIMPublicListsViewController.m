//
//  QBAddPublicTypeViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/9/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPublicListsViewController.h"
#import "NIMDefaultTableViewCell.h"
#import "NIMPublicOperationBox.h"
#import "NIMPublicInfoViewController.h"
//#import "PublicEntity.h"
#import "NIMUserOperationBox.h"
#import "NIMSysPublicInfoViewController.h"
#import "NIMAllPublicInfoVC.h"

@interface _LoaingPublicListViewController : NIMTableViewController
@property (nonatomic,assign)double pubId;
@end

@implementation _LoaingPublicListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = UIView.new;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self performSelector:@selector(pushPublicVC) withObject:nil afterDelay:1];
}

- (void)pushPublicVC
{
    [self pushPublicListVC:self.pubId];
}

- (void)pushPublicListVC:(double)pubId
{
    [self qb_showLoading];
    /*
    [[NIMUserOperationBox sharedInstance] fetchUserid3:pubId completeBlock:^(id object, NIMResultMeta *result) {
        
        void (^callBack)();
        callBack = ^(){
            NSDictionary *responseData = object;
            if (!responseData) {
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该公众号停止服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertV.tag =100;
                [alertV show];
                return ;
            }
            NSInteger subscribe = [[responseData objectForKey:@"subscribed"] integerValue];
            double publicid = [responseData[@"userId"] doubleValue];
            if (subscribe == PublicSubscribedTypeSys) {
                [self showSysPublicControllerWithPublic:publicid animated:NO];
                
            }else{
                [self showPublicControllerWithPublic:publicid animated:NO];
            }
            
        };
        if([NSThread isMainThread]){
            callBack();
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack();
            });
        }
    }];
*/
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPublicControllerWithPublic:(double)publicid animated:(BOOL)animated{
    UINavigationController *nav = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    NIMPublicInfoViewController *publicInfoVC = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMPublicInfoViewController"];
    publicInfoVC.publicid = publicid;
    [nav pushViewController:publicInfoVC animated:animated];
}

- (void)showSysPublicControllerWithPublic:(double)publicid animated:(BOOL)animated{
    UINavigationController *nav = self.navigationController;
    [self.navigationController popViewControllerAnimated:NO];
    NIMSysPublicInfoViewController *publicInfoVC = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMSysPublicInfoViewController"];
    publicInfoVC.publicid = publicid;
    [nav pushViewController:publicInfoVC animated:animated];
}

@end

@interface NIMPublicListsViewController ()
@property (nonatomic, strong) NSMutableArray* tableDataSource;
@property (nonatomic, assign) NSInteger count, offset;

@end

@implementation NIMPublicListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, -30, 0);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self qb_setTitleText:@"公众号"];
    _offset = 0;

//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore:)];
//    [self.tableView addFooterWithTarget:self action:@selector(loadMore:)];
    
    [self fetchData];
    // Do any additional setup after loading the view.
}

- (void)loadMore:(id)sender{
    _offset = self.tableDataSource.count;
    [self fetchData];
}

- (void)fetchData
{
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:[NSNumber numberWithInteger:_offset] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:20] forKey:@"limit"];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NIMPublicOperationBox sharedInstance] fetchPublicRecommendandParameters:params WithcompleteBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            if (result) {
                [MBTip showError:result.message toView:self.view];
                [self qb_showNoDataView:@"获取公众号失败"];
            }else{
                NSArray* items = [object objectForKey:@"items"];
                
                if (items.count > 0) {
                    [self qb_hideNoDataView];
                    
                    [self.tableDataSource addObjectsFromArray:items];
                    [self.tableView reloadData];
                }
                else
                {
                    if (self.tableDataSource.count == 0) {
                        [self qb_showNoDataView:@"没有服务数据"];
                    }
                    else
                    {
                        [MBTip showTipsView:@"没有服务数据"];
                        
                    }
                }

            }
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMDefaultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier];
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    NSString* strIcon = [dic objectForKey:@"avatarPic"];
    NSString* nickname = [dic objectForKey:@"nickName"];
    cell.titleLable.text = nickname;
    [cell.iconView setViewDataSourceFromUrlString:strIcon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == self.tableDataSource.count - 1) {
        cell.hasLineLeadingLeft = YES;
    }
    [cell makeConstraints];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    double userId = [dic[@"userId"] doubleValue];
    NIMAllPublicInfoVC *vc = [[NIMAllPublicInfoVC alloc]init];
    vc.publicid= userId;
    vc.publicSourceType = PubListSource;
    [self.navigationController pushViewController:vc animated:YES];

   
}
- (void)showPublicControllerWithPublic:(double)publicid animated:(BOOL)animated{
    NIMPublicInfoViewController *publicInfoVC = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMPublicInfoViewController"];
    publicInfoVC.publicid = publicid;
    [self.navigationController pushViewController:publicInfoVC animated:animated];
}

- (void)showSysPublicControllerWithPublic:(double)publicid animated:(BOOL)animated{
    NIMSysPublicInfoViewController *publicInfoVC = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMSysPublicInfoViewController"];
    publicInfoVC.publicid = publicid;
    [self.navigationController pushViewController:publicInfoVC animated:animated];
}

#pragma mark getter
- (NSMutableArray*)tableDataSource
{
    if(!_tableDataSource)
    {
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}
@end
