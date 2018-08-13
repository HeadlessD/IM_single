//
//  NIMBusinessViewController.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/9/4.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMBusinessViewController.h"
#import "NIMBadgeTableViewCell.h"
#import "NIMChatUIViewController.h"
#import "NIMHtmlWebViewController.h"
#import "NIMManager.h"
@interface NIMBusinessViewController ()

@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation NIMBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NIMBadgeTableViewCell class] forCellReuseIdentifier:kQBHeadBadgeTableViewCell];
    self.tableView.rowHeight = 60;
    [self qb_setTitleText:@"店铺列表"];
    self.dataArr = @[@"140001775",@"140001776",@"115665806",@"5504152",@"109102784",@"5503455",@"27481318",@"120702563"];
    
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];

    
    for (int i=0; i<self.dataArr.count; i++) {
        int64_t bid = [self.dataArr[i] longLongValue];
        NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:bid];
        if (business == nil) {
            business = [NBusinessEntity NIM_createEntity];
            business.bid = bid;
            business.cid = OWNERID;
            NSString *name = nil;
            if (i<4) {
                name = [NSString stringWithFormat:@"商家_%lld",bid];
                business.isPersonal = YES;

            }else{
                name = [NSString stringWithFormat:@"企业商家_%lld",bid];
                business.isPersonal = NO;

            }
            business.name = name;
            business.avatar = USER_ICON_URL(bid);
        }
    }
    
//    NOffcialEntity *offcial = [NOffcialEntity findFirstWithOffcialid:109102784];
//    if (offcial == nil) {
//        offcial = [NOffcialEntity NIM_createEntity];
//        offcial.offcialid = 109102784;
//        offcial.fansid = OWNERID;
//        business.isPersonal = YES;
//        offcial.messageBodyId = [NSString stringWithFormat:@"%ld:%lld:%d",(long)PUBLIC,OWNERID,109102784];
//        offcial.name = [NSString stringWithFormat:@"商家_%d",109102784];
//    }
    
    [privateContext MR_saveToPersistentStoreAndWait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMBadgeTableViewCell* cell = nil;
    cell = (NIMBadgeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kQBHeadBadgeTableViewCell forIndexPath:indexPath];
    NSString *bid = [self.dataArr objectAtIndex:indexPath.row];
    NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:bid.longLongValue];
    NSString *name = business.name;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:business.avatar]];
    UIImage *image = [UIImage imageWithData:data];
    if (image == nil) {
        image = [UIImage imageNamed:@"fclogo"];
    }
    [cell updateWithImage:image name:name];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bidStr = [self.dataArr objectAtIndex:indexPath.row];
    int64_t bid = bidStr.longLongValue;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });

    [[NIMManager sharedImManager] fetchWidsWithBid:bid CompleteBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        if (object) {
            
            NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
            
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:10];

            NSArray *wids = [object objectForKey:@"data"];
            for (NSDictionary *dict in wids) {
                int64_t wid = [[dict objectForKey:@"wid"] longLongValue];
                NSString *name = [dict objectForKey:@"widname"];
                [list addObject:@(wid)];
                NWaiterEntity *waiterEntity = [NWaiterEntity findFirstWithBid:bid wid:wid];
                if (waiterEntity == nil) {
                    waiterEntity = [NWaiterEntity NIM_createEntity];
                    waiterEntity.bid = bid;
                    waiterEntity.wid = wid;
                }
                waiterEntity.name = name;
            }
            NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:bid];
            if (business) {
                business.wids = list;
            }
            
            [privateContext MR_saveToPersistentStoreAndWait];

            E_MSG_CHAT_TYPE type = SHOP_BUSINESS;
            if (!business.isPersonal) {
                type = CERTIFY_BUSINESS;
            }
            
            NSString *messageBodyId = [NIMStringComponents createMsgBodyIdWithType:type toId:bid];
            NSString *actualThread = [NSString stringWithFormat:@"%@:%lld",messageBodyId,bid];
            
            NSArray *arr = getObjectFromUserDefault(KEY_Wid_List(bid));
            
            if (list.count>0 &&
                ![list isEqualToArray:arr]) {
                setObjectToUserDefault(KEY_Wid_List(bid), list);
            }
            NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
            chatVC.isGoods = YES;
            chatVC.thread = messageBodyId;
            chatVC.actualThread = actualThread;
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }];
    
}

-(NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
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
