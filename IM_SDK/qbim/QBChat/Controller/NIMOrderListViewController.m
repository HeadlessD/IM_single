//
//  NIMOrderListViewController.m
//  qbnimclient
//
//  Created by 秦雨 on 17/10/26.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMOrderListViewController.h"
#import "NIMBadgeTableViewCell.h"
#import "NIMChatUIViewController.h"
#import "NIMManager.h"
#import "NIMMessageCenter.h"
@interface NIMOrderListViewController ()
@property(nonatomic,strong)NSArray *dataArr;

@end

@implementation NIMOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NIMBadgeTableViewCell class] forCellReuseIdentifier:kQBHeadBadgeTableViewCell];
    self.tableView.rowHeight = 60;
    [[NIMManager sharedImManager] fetchOrdersWithSellerId:5504152 buyId:OWNERID CompleteBlock:^(id object, NIMResultMeta *result) {
        if (object) {
            NSArray *arr = [object objectForKey:@"data"];
            self.dataArr = [NSArray arrayWithArray:arr];
            [self.tableView reloadData];
        }
    }];

    // Do any additional setup after loading the view.
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
    NSDictionary *dict = [self.dataArr objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"订单_%@",[dict objectForKey:@"orderId"]];
    UIImage *image = [UIImage imageNamed:@"fclogo"];
    [cell updateWithImage:image name:name];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self translate:[self.dataArr objectAtIndex:indexPath.row]];
    [[NIMMessageCenter sharedInstance] sendMessageWithObject:dict mType:JSON sType:ORDER eType:DEFAULT messageBodyId:(NSString *)self.messageBodyId msgid:[NIMBaseUtil GetServerTime]];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(NSDictionary *)translate:(NSDictionary *)dict{
    NSDictionary *goodsDict = [[dict objectForKey:@"goodsInfoDto4IMs"] firstObject];
    NSString *orderId = [dict objectForKey:@"orderId"];
    NSString *orderStateStr = [dict objectForKey:@"orderStateStr"];
    NSString *totalAmount = [dict objectForKey:@"totalAmount"];
    NSString *buyerId = [dict objectForKey:@"buyerId"];
    NSString *sellerId = [dict objectForKey:@"sellerId"];
    
    
    NSString *goodsNum = [goodsDict objectForKey:@"goodsNum"];
    NSString *imgUrl = [goodsDict objectForKey:@"imgUrl"];
    NSString *unitPrice = [goodsDict objectForKey:@"unitPrice"];
    NSDictionary *tmpDict = @{@"img_url":imgUrl,
                              @"sellerId":sellerId,
                              @"buyerId":buyerId,
                              @"total":totalAmount,
                              @"unitPrice":unitPrice,
                              @"number":goodsNum,
                              @"id":orderId,
                              @"state":orderStateStr};

    return tmpDict;
}

-(void)qb_back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
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
