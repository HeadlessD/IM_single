//
//  NIMBlackListViewController.m
//  QBNIMClient
//
//  Created by 豆凯强 on 17/7/31.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBlackListViewController.h"
#import "NIMSelfViewController.h"
#import "NIMBlackListCell.h"
#import "NIMNoneView.h"

@interface NIMBlackListViewController ()<NSFetchRequestResult,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController            *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController            *unReadFetchedResultsController;

@property(nonatomic,strong) UITableView * blackTableView;
@property (nonatomic, strong) UIView * noneView;

@end

@implementation NIMBlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self qb_setTitleText:@"黑名单"];
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

    self.view.backgroundColor = __COLOR_E6E6E6__;
    
    
    _blackTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _blackTableView.delegate = self;
    _blackTableView.dataSource = self;
    _blackTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_blackTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _blackTableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    _blackTableView.estimatedRowHeight =0;
    _blackTableView.estimatedSectionHeaderHeight =0;
    _blackTableView.estimatedSectionFooterHeight =0;

    [self.view addSubview:_blackTableView];
    
    _noneView = [[NIMNoneView alloc]initWithString:@"黑名单为空"];
    [_blackTableView addSubview:_noneView];
    
    if (self.fetchedResultsController.fetchedObjects.count ==0){
        _noneView.hidden =NO;
    }else{
        _noneView.hidden =YES;
    }
 }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.navigationController.navigationBar.translucent = NO; // 默认是YE
    self.fetchedResultsController = nil;
    [_blackTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        CGFloat heightTip = 0;
        if (indexPath.row == 0) {
            heightTip = 30;
        }
        return 58+heightTip;
    }
    return 58;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FDListEntity * fdlist = [self.fetchedResultsController objectAtIndexPath:indexPath];

            NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

    feedProfileVC.userid = fdlist.fdPeerId;
    NSString *source = [NSString stringWithFormat:@"%ld",ChatSource];
    feedProfileVC.feedSourceType =source;
    [feedProfileVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:feedProfileVC animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FDListEntity * fdlist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NIMBlackListCell * cell = [_blackTableView dequeueReusableCellWithIdentifier:@"NIMBlackListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (cell == nil) {
        cell = [[NIMBlackListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NIMBlackListCell"];
    }
//    [cell updateWithVcardEntity:vcard];

    [cell updateWithFDList:fdlist];
    return cell;
}



- (NSFetchedResultsController *)fetchedResultsController
{
    {
        if (nil != _fetchedResultsController) {
            return _fetchedResultsController;
        }

        _fetchedResultsController = [FDListEntity NIM_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and (fdFriendShip = 9 || fdFriendShip = 10)  and (fdBlackShip = 2 || fdBlackShip = 3)",OWNERID] sortedBy:@"firstLitter,fullLitter" ascending:YES delegate:self];
        
        [NSFetchedResultsController deleteCacheWithName:nil];
        
        NSError *error;
        
        if (![_fetchedResultsController performFetch:&error]) {
            DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
        }else{
            if (self.fetchedResultsController.fetchedObjects.count ==0)
            {
                _noneView.hidden  = NO;
            }
            else
            {
                _noneView.hidden  = YES;
            }
            
        }
        return _fetchedResultsController;
    }
}

- (NSFetchedResultsController *)unReadFetchedResultsController{
    if (nil != _unReadFetchedResultsController) {
        return _unReadFetchedResultsController;
    }
    return _unReadFetchedResultsController;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
