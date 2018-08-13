//
//  NIMPublicViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/8/23.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPublicViewController.h"
#import "NIMDefaultTableViewCell.h"
//#import "PublicEntity.h"
#import "NIMPublicOperationBox.h"
#import "NIMPublicInfoViewController.h"
#import "NIMSysPublicInfoViewController.h"
#import "NIMChatUIViewController.h"
#import "NIMPublicListsViewController.h"
#import "NIMUserOperationBox.h"
#import "NIMAllPublicInfoVC.h"
#import "NIMPublicSearchController.h"

@interface _LoaingPublicViewController : NIMTableViewController
@property (nonatomic,assign)double userId;
@end

@implementation _LoaingPublicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = UIView.new;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self qb_showLoading];
    [self performSelector:@selector(pushPublicVC:) withObject:@(self.userId) afterDelay:1];
}

- (void)pushPublicVC:(NSNumber *)userIdNumber
{
//    double userId = [userIdNumber doubleValue];
    [self qb_showLoading];
    /*
    [[NIMUserOperationBox sharedInstance] fetchUserid3:userId completeBlock:^(id object, NIMResultMeta *result) {
        DBLog(@"%@",object);
        void (^callBack)();
        callBack = ^(){
            [self qb_hideLoadingWithCompleteBlock:^{
                
            }];
            if (!object){
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该公众号停止服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alertV.tag =100;
                [alertV show];
                return ;
            }
            NSDictionary *dic1 = object;
            NSInteger subscribed = [dic1[@"subscribed"] integerValue];
            if (subscribed == PublicSubscribedTypeSys) {
                [self showSysPublicControllerWithPublic:userId animated:NO];
            }else{
                [self showPublicControllerWithPublic:userId animated:NO];
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


@interface NIMPublicViewController ()<NSFetchedResultsControllerDelegate, VcardTableViewCellDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray* tableDataSource;
@end

@implementation NIMPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    [self qb_showRightButton:@"添加公众号"];
    [self qb_setTitleText:@"公众号"];

    self.rightButton.titleLabel.font =[UIFont systemFontOfSize:16];
    [self.rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];

}
- (void)qb_rightButtonAction
{
//    NIMPublicListsViewController* publicType = (NIMPublicListsViewController*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:nil]instantiateViewControllerWithIdentifier:@"NIMPublicLists"];
//    [self.navigationController pushViewController:publicType animated:YES];
    NIMPublicSearchController *ctrl =[[NIMPublicSearchController alloc]initWithNibName:@"NIMPublicSearchController" bundle:[NSBundle mainBundle]];
    [self nim_pushToVC:ctrl animal:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark actions
- (void)refreshViewControlEventValueChanged{
    [self refresh];
}
#pragma mark fetch
- (void)refresh{
    [self.refreshControl beginRefreshing];
    [[NIMPublicOperationBox sharedInstance] fetchPublicsCompleteBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
//            NSArray* items = object;
            [self.tableDataSource removeAllObjects];
            NSArray *tmpArr = @[@{@"avatarPic":@"http://oitz0abuh.bkt.clouddn.com/20160512092315_547%E5%89%AF%E6%9C%AC.png",@"nickName":@"公众号假数据"}];
            
            [self.tableDataSource addObjectsFromArray:tmpArr];
            [self.tableView reloadData];
//            [self reloadDataFromDB];
        });
    }];
}
- (void)reloadDataFromDB{
    NSError *error = nil;
    if ([self.fetchedResultsController performFetch:&error]) {
        
    }
    [self.tableView reloadData];
}
#pragma mark actions
//- (void)showChatWithPublic:(PublicEntity *)publicEntity animated:(BOOL)animated{
//    NSString *thread = publicEntity.thread;
//    if(thread)
//    {
//        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
//        [chatVC setThread:thread];
//        chatVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:chatVC animated:YES];
//    }
//}

#pragma mark config
- (void)configureCell:(NIMDefaultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    NSString* strIcon = [dic objectForKey:@"avatarPic"];
    NSString* nickname = [dic objectForKey:@"nickName"];
    cell.titleLable.text = nickname;
    [cell.iconView setViewDataSourceFromUrlString:strIcon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == self.tableDataSource.count - 1) {
        cell.hasLineLeadingLeft = YES;
    }
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0);

    [cell makeConstraints];
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

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    PublicEntity *publicEntity = [self.tableDataSource objectAtIndex:indexPath.row];
//    if (publicEntity.publicid <= 0) {
//        return;
//    }
//    if (publicEntity.subscribed == PublicSubscribedTypeSys) {
//        [self showSysPublicControllerWithPublic:publicEntity.publicid animated:YES];
//    }else{
//        [self showPublicControllerWithPublic:publicEntity.publicid animated:YES];
//    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tableDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NIMDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 1) {
        return 0.1;
    }
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dic  = [self.tableDataSource objectAtIndex:indexPath.row];
    double userId = [dic[@"userId"] doubleValue];
    NIMAllPublicInfoVC *vc = [[NIMAllPublicInfoVC alloc]init];
    vc.publicid= userId;
    vc.publicSourceType = PubListSource;
    [self.navigationController pushViewController:vc animated:YES];

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




