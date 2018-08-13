//
//  NIMSysPublicInfoViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/10/14.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMSysPublicInfoViewController.h"
#import "NIMDefaultTableViewCell.h"
#import "NIMSysPublicTextCell.h"
//#import "PublicEntity.h"
#import "NIMChatUIViewController.h"
#import "NIMPublicOperationBox.h"

@interface NIMSysPublicInfoViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) PublicEntity  *publicEntity;
@property (nonatomic, strong) UISwitch* swShop;

@end
@implementation NIMSysPublicInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NIMDefaultTableViewCell class] forCellReuseIdentifier:kDefaultReuseIdentifier];
    [self.tableView registerClass:[NIMSysPublicTextCell class] forCellReuseIdentifier:kPublicTextCellReuseIdentifier];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self qb_setTitleText:@"详细资料"];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self reloadFromDB];
//    self.swShop.on = self.publicEntity.apn;
}

#pragma mark

//-(void)qb_back{
//    if(self.swShop.on == self.publicEntity.apn){
//        [super qb_back];
//    }
//    else{
//        [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicEntity.publicid
//                                                       switchValue:self.swShop.on
//                                                     completeBlock:^(id object, NIMResultMeta *result) {
//                                                         dispatch_sync(dispatch_get_main_queue(), ^{
//                                                             if(result){
//                                                                 [MBTip showError:result.message toView:self.view];
//                                                             }
//                                                             else{
//                                                                 [self saveTo];
//                                                                 [self.navigationController popViewControllerAnimated:YES];
//
//                                                             }
//                                                         });
//                                                     }];
//    }
//
//}



//-(void)saveTo{
//    NSManagedObjectContext *managedObjectContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [managedObjectContext performBlockAndWait:^{
//        PublicEntity  *publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//        publicEntity.apn = self.swShop.on;
//        //TODO:save
//        [managedObjectContext MR_saveOnlySelfAndWait];
//    }];
//
//}
//- (void)reloadFromDB{
//    self.publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//    [self.tableView reloadData];
//}
//- (IBAction)doGoPublicThread:(id)sender{
//
//    if(self.swShop.on != self.publicEntity.apn){
//        [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicEntity.publicid
//                                                       switchValue:self.swShop.on
//                                                     completeBlock:^(id object, NIMResultMeta *result) {
//                                                         dispatch_sync(dispatch_get_main_queue(), ^{
//                                                             if(result){
//                                                                 [MBTip showError:result.message toView:self.view];
//                                                             }
//                                                             else{
//                                                                 [self saveTo];
//                                                             }
//                                                         });
//                                                     }];
//    }
//    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
//    [chatVC setThread:self.publicEntity.thread];
//    chatVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatVC animated:YES];
//}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NIMDefaultTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kDefaultReuseIdentifier forIndexPath:indexPath];
            
//            NSString* strIcon = self.publicEntity.avatar;
//            NSString* nickname = self.publicEntity.name;
//            cell.titleLable.text = nickname;
//            [cell.iconView setViewDataSourceFromUrlString:strIcon];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [cell makeConstraints];
            return cell;
        }
        
        NIMSysPublicTextCell* cell = [tableView dequeueReusableCellWithIdentifier:kPublicTextCellReuseIdentifier forIndexPath:indexPath];
        NSString *desc = @"暂无描述";
//        if (self.publicEntity.desc) {
//            desc = self.publicEntity.desc;
//        }
        
        [cell updateWithPublicText:desc];
        return cell;
    }
    else
    {
        static NSString* newInfoCell = @"newInfoCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:newInfoCell];
        if(nil == cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newInfoCell];
            [cell addSubview:self.swShop];
        }
//        self.swShop.on = self.publicEntity.apn;
        cell.textLabel.text = @"接收消息";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            return 80;
        }
        NSString *desc = @"暂无描述";
//        if (self.publicEntity.desc) {
//            desc = self.publicEntity.desc;
//        }
        return [NIMSysPublicTextCell heightSysPublicTextCellWithText:desc];
    }
    else
    {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (UISwitch*)swShop{
    if(!_swShop){
        _swShop = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-65, 7, 60, 30)];
        _swShop.on = YES;
    }
    return _swShop;
}

@end
