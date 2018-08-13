//
//  NIMPublicAttentionUserListVC.m
//  QianbaoIM
//
//  Created by Yun on 14/9/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPublicAttentionUserListVC.h"
//#import "PublicEntity.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMDefaultTableViewCell.h"
#import "NIMPublicOperationBox.h"
#import "NIMSelfViewController.h"
#import "NIMMessageCenter.h"
#import "NIMFansModle.h"
#import "NIMFansCell.h"
#import "NIMSelfViewController.h"

@interface NIMPublicAttentionUserListVC ()
@property (nonatomic, strong) NSMutableArray* tableDataSource;
@property (nonatomic, assign) NSInteger count, offset;

@end

@implementation NIMPublicAttentionUserListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self qb_setTitleText:@"关注的人"];
    _offset = 0;

    [self fetchData];
    [self.tableView registerClass:[NIMFansCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
//    [self.tableView addFooterWithTarget:self action:@selector(loadMore:)];

}


- (void)loadMore:(id)sender{
    _offset = self.tableDataSource.count;
    [self fetchData];
}

- (void)fetchData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NIMPublicOperationBox sharedInstance] fetchPublicFans:self.publicid
                                                  offset:_offset
                                                   limit:20
                                           completeBlock:^(id object, NIMResultMeta *result) {
                                               dispatch_async(dispatch_get_main_queue(), ^{

                                                   [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                       [object enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                           NSDictionary *dic = obj;
                                                           NIMFansModle *vcardEntity = [[NIMFansModle alloc ]initWithDic:dic];
                                                           [self.tableDataSource addObject:vcardEntity];                                               }];

                                               
                                                   [self.tableView reloadData];
                                               });
                                           }];
}
#pragma mark TableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMFansCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
    NIMFansModle* card = (NIMFansModle*)[self.tableDataSource objectAtIndex:indexPath.row];
    [cell updateWithVcardEntity:card];
    return cell;
}


#pragma mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _GET_APP_DELEGATE_(appDelegate);
//    if(! [NIMMessageCenter sharedInstance].isQbaoLoginSuccess)
//    {
//        [appDelegate.window.rootViewController presentViewController:appDelegate.authNavigationC animated:YES completion:^{
//            
//        }];
//    }
//    else
//    {
        NIMFansModle* card = (NIMFansModle*)[self.tableDataSource objectAtIndex:indexPath.row];
    
    NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];
        feedProfileVC.userid = card.userId;
        feedProfileVC.feedSourceType = PubAttentionSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)tableDataSource
{
    if (!_tableDataSource) {
        _tableDataSource = [NSMutableArray new];
    }
    return _tableDataSource;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
