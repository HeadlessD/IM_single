//
//  NIMMeViewController.m
//  IM_single
//
//  Created by Zhang jiyong on 2018/2/25.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import "NIMMeViewController.h"
#import "EditViewController.h"
#import "NIMMessageNotifyVC.h"
#import "NIMPrivacyViewController.h"
#import "NetCenter.h"

@interface NIMMeViewController ()

@property(nonatomic,strong)NSArray *contentArr;

@end

@implementation NIMMeViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentArr = @[@[@"个人资料"],@[@"新消息通知",@"隐私"],@[@"退出"]];
    [self qb_setTitleText:@"设置"];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSetting:) name:NC_SET_MODIFY object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _contentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rows = _contentArr[section];
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditTableViewCell"];
    }
    NSArray *rows = _contentArr[indexPath.section];
    cell.textLabel.text = rows[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        EditViewController * editView = [[EditViewController alloc]init];
        editView.vcardEntity = _vcardEntity;
        [self.navigationController pushViewController:editView animated:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NIMMessageNotifyVC *manager = (NIMMessageNotifyVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMMessageNotifyVC"];
            [self.navigationController pushViewController:manager animated:YES];
        }else if (indexPath.row == 1){
            NIMPrivacyViewController *manager = (NIMPrivacyViewController*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMPrivacyIdentity"];
            manager.settingBlock = ^(DFSettingItem *item) {
                [[NIMMomentsManager sharedInstance] settingModifyRQ:item];
            };
            [self.navigationController pushViewController:manager animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_LOGINOUT object:nil];
            }];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [netAlert addAction:cancle];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
        }
    }
}

-(void)recvSetting:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if([object isKindOfClass:[QBNCParam class]]){
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            
        }
    }else{
        [MBTip showError:__FAILDMESSAGE__ toView:self.view];
    }
}

@end
