//
//  GroupSettingViewController.h
//  QianbaoIM
//
//  Created by Yun on 14/8/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "GroupList+CoreDataClass.h"

@protocol NIMChatGroupSettingVCDelegate <NSObject>

-(void)reloadTableIfNameShow;
-(void)reloadTableIfClearDataSource;
@end

@interface NIMChatGroupSettingVC : NIMTableViewController
@property (weak, nonatomic) IBOutlet UIView *viewRedpoint;
@property (weak, nonatomic) IBOutlet UILabel *labNotify;
@property (nonatomic, strong) GroupList* groupList;
@property (weak, nonatomic) IBOutlet UILabel *labGroupNumber;
@property (weak, nonatomic) IBOutlet UILabel *labGroupName;
@property (weak, nonatomic) IBOutlet UILabel *labUserNickName;
@property (weak, nonatomic) IBOutlet UITableViewCell *swShowUserNickName;
@property (weak, nonatomic) IBOutlet UITableViewCell *swTopInfo;
@property (weak, nonatomic) IBOutlet UISwitch *swNewsNotfication;
@property (weak, nonatomic) IBOutlet UISwitch *swSaveBook;
@property (weak, nonatomic) IBOutlet UISwitch *swShowNickName;
@property (weak, nonatomic) IBOutlet UISwitch *swSetTop;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *myNickNameLabel;

@property (nonatomic ,weak) id<NIMChatGroupSettingVCDelegate>delegate;
- (IBAction)exitGroup:(UIButton *)sender;


@end
