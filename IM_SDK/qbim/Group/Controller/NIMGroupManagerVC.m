//
//  NIMGroupManagerVC.m
//  qbim
//
//  Created by 秦雨 on 17/3/8.
//  Copyright © 2017年 shiyunjie. All rights reserved.
//

#import "NIMGroupManagerVC.h"
#import "NIMGroupLeaderChangeVC.h"
@interface NIMGroupManagerVC ()

@property (weak, nonatomic) IBOutlet UISwitch *isNeed;


@end

@implementation NIMGroupManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeed.on = self.groupEntity.relation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        
        NIMGroupLeaderChangeVC *leader = (NIMGroupLeaderChangeVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"leaderIdentifier"];
        leader.groupEntity = self.groupEntity;
        [self.navigationController pushViewController:leader animated:YES];
    }
}



- (IBAction)changeValue:(UISwitch *)sender {
    int32_t type = GROUP_OFFLINE_CHAT_ENTER_DEFAULT;
    if (sender.on) {
        type = GROUP_OFFLINE_CHAT_ENTER_AGREE;
    }
    [[NIMGroupOperationBox sharedInstance] sendInviteAgreeWithType:type groupid:self.groupEntity.groupId];
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
