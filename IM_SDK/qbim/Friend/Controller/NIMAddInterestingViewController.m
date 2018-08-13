//
//  NIMAddInterestingViewController.m
//  QianbaoIM
//
//  Created by Yun on 14/9/22.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMAddInterestingViewController.h"
#import "NIMSubAccessoryTableViewCell.h"
#import "NIMUserOperationBox.h"
#import "NIMSelfViewController.h"
#import "NIMAddDescViewController.h"

#import "NIMManager.h"

#import "NIMLoginOperationBox.h"

@interface NIMAddInterestingViewController ()<VcardTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray* tableDataSource;
@end

@implementation NIMAddInterestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"趣味相投的人"];
    [self.tableView registerClass:[NIMSubAccessoryTableViewCell class] forCellReuseIdentifier:kSubAccessoryReuseIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self fetchDataSource];
    [self qb_showRightButton:@"换一换"];
//    [self.rightButton setBackgroundImage:image forState:UIControlStateNormal];
//    [self.rightButton setTitle:@"换一换" forState:UIControlStateNormal];
}
-(void)qb_rightButtonAction
{
    NSLog(@"reghtbutton");
    [self fetchDataSource];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView setFrame:CGRectMake(0, IPX_NAVI_H, SCREEN_WIDTH, SCREEN_HEIGHT - IPX_NAVI_H - IPX_BOTTOM_SAFE_H)];
}

//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    [self.tableView setFrame:CGRectMake(0, IPX_NAVI_H, SCREEN_WIDTH, SCREEN_HEIGHT - IPX_NAVI_H - IPX_BOTTOM_SAFE_H)];
//}

- (void)fetchDataSource
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[NIMManager sharedImManager] fetchInterestListCompleteBlocknew:^(id object, NIMResultMeta *result) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if(result){
                [MBTip showError:result.message toView:self.view];
            }else{
                [self.tableDataSource removeAllObjects];
                NSArray* array = (NSArray*)object;
                [self.tableDataSource addObjectsFromArray:array];
                [self.tableView reloadData];
            }
//        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showProfileControllerWithuserid:(int64_t)userid{
    if (userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType = InterestSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
    }
}

#pragma mark VcardTableViewCellDelegate
- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    double userid = [PUGetObjFromDict(@"userId", dic, [NSNumber class]) doubleValue];
    if (userid) {
        [self showProfileControllerWithuserid:userid];
    }
}

- (void)tableViewCell:(NIMDefaultTableViewCell *)cell didSelectedWithType:(FriendActionType)type userid:(int64_t)userid{
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    
    if (userid) {
        if (type == FriendActionTypeTypeToAdd) {
            NIMAddDescViewController *descViewController = [[NIMAddDescViewController alloc] init];
            descViewController.userId = userid;
            descViewController.addSourceType = FD_ADD_TYPE_CONGENIAL;
            UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: descViewController];
            [self presentViewController:presNavigation animated:YES completion:nil];
            
            //[self.navigationController pushViewController:descViewController animated:YES];
        }
        else if (type == FriendActionTypeTypeToAgree)
        {
   //待同意好友
            
        }
    }
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
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    NIMSubAccessoryTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSubAccessoryReuseIdentifier forIndexPath:indexPath];
    [cell updateWithInterest:dic];
    cell.delegate = self;
    [cell makeConstraints];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = [self.tableDataSource objectAtIndex:indexPath.row];
    NSString* userId = dic[@"userId"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NIMFeedProfileViewController *feedProfileVC = [[UIStoryboard storyboardWithName:@"NIMSquare" bundle:nil] instantiateViewControllerWithIdentifier:@"NIMFeedProfileViewController"];
//    feedProfileVC.userid = userId.doubleValue;
//    feedProfileVC.feedSourceType =InterestSource;
//    [feedProfileVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:feedProfileVC animated:YES];
}


#pragma mark getter
- (NSMutableArray*)tableDataSource{
    if(!_tableDataSource){
        _tableDataSource = [[NSMutableArray alloc] init];
    }
    return _tableDataSource;
}

@end
