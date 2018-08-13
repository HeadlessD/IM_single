//
//  NIMGroupVcardVC.m
//  QianbaoIM
//
//  Created by qianwang on 14/12/3.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMGroupVcardVC.h"
#import "NIMVcardCollectionViewCell.h"
#import "NIMGroupOperationBox.h"
#import "NIMChatUIViewController.h"
//#import "NIMMessageContent.h"
//#import "JoinGroupViewController.h"
#import "ChatEntity+CoreDataClass.h"
#import "TextEntity+CoreDataClass.h"
#import "ChatListEntity+CoreDataClass.h"
#import "VcardEntity+CoreDataClass.h"
#import "GMember+CoreDataClass.h"
#import "NIMGroupCardInfoVC.h"
#import "NIMSelfViewController.h"
#import "NIMScanNotifyView.h"
@interface NIMGroupVcardVC ()<VcardCollectionViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BOOL    _inGroup;
    NSString *groupName;
}
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UILabel *groupNameLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *button;

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIImageView *iconView;
@property (nonatomic, strong) NSArray *memberDatasource;
@end

@implementation NIMGroupVcardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//
    
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    self.tableView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES

    [self.collectionView registerClass:[NIMVcardCollectionViewCell class] forCellWithReuseIdentifier:kvcardIdentifier];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImage *image = [IMGGET(@"bg_cha_2") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    [self request];
//    self.tableView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupInfo:) name:NC_GROUP_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupMember:) name:NC_GROUP_DETAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvGroupAdd:) name:NC_GROUP_ADD object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.returnBlock=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)chatWithThread:(NSString *)thread{
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    [chatVC setThread:thread];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)joinCallbackWithObject:(id)object result:(NIMResultMeta *)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (result) {
        [MBTip showError:result.message toView:self.view];
    }else{
        NSString *thread = [NIMStringComponents createMsgBodyIdWithType:GROUP toId:self.groupid];
        [self chatWithThread:thread];
    }
}

#pragma mark fetch
- (IBAction)buttonClick:(id)sender{
    if (self.returnBlock) {//说明是来自群通知控制器
        if (_inGroup) {
            NSString *thread =  [NIMStringComponents createMsgBodyIdWithType:GROUP toId:self.groupid];
            [self chatWithThread:thread];
        }else{
            self.returnBlock();
        }
        
    }else{//说明来自扫描二维码
        if (_inGroup) {
            NSString *thread =  [NIMStringComponents createMsgBodyIdWithType:GROUP toId:self.groupid];
            [self chatWithThread:thread];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableArray *userInfos = @[].mutableCopy;
            QBUserBaseInfo *info = [[QBUserBaseInfo alloc] init];
            VcardEntity *card = [VcardEntity instancetypeFindUserid:OWNERID];
            info.user_id = OWNERID;
            info.user_nick_name = [card defaultName];
            [userInfos addObject:info];
            
            [[NIMGroupOperationBox sharedInstance] sendGroupAddUserinfos:userInfos groupid:self.groupid opUserid:self.inviteid oldMsgid:0 reason:@(self.groupid)];
        }

    }
}

#pragma mark
- (void)updateWithGroupName:(NSString *)name members:(NSInteger)memberCount inGroup:(BOOL)inGroup{
    _inGroup = inGroup;
    groupName = name;
    self.groupNameLabel.text = name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:GROUP_ICON_URL(self.groupid)] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    self.memberLabel.text = [NSString stringWithFormat:@"%ld人",(long)memberCount];
    [self.collectionView reloadData];
    if (inGroup) {
        [self.button setTitle:@"发消息" forState:UIControlStateNormal];
        self.button.userInteractionEnabled = YES;
    }else{
        [self.button setTitle:@"加入群组" forState:UIControlStateNormal];
        self.button.userInteractionEnabled = YES;
    }
    if (IsStrEmpty(name)) {
        [self.button setTitle:@"群组已解散" forState:UIControlStateNormal];
        self.button.userInteractionEnabled = NO;
    }
    [self.tableView reloadData];
    
}

- (void)request{
    
    [[NIMGroupOperationBox sharedInstance] sendGroupScan:self.groupid shareid:self.inviteid];
}

-(void)recvGroupInfo:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            
            NSString *tips = nil;
            
            if (param.p_uint64 == RET_GROUP_USER_NOT_JOIN) {
                tips = @"该二维码分享者已离开群聊，无法加入";
            }else{
                tips = param.p_string;
            }
            NIMScanNotifyView *tView = [[NIMScanNotifyView alloc] initWithTips:tips];
            [self.view addSubview:tView];

            return;
        }
        NSDictionary *dict = noti.object;
        QBGroupInfoPacket *info = [dict objectForKey:@"content"];
        BOOL isMember = [[dict objectForKey:@"isMember"] boolValue];

        if (info.group_add_is_agree&&!isMember) {
            
            NIMScanNotifyView *tView = [[NIMScanNotifyView alloc] initWithTips:@"群主已开启进群验证，只可通过邀请进群"];
            [self.view addSubview:tView];
            return;
            
        }
        self.tableView.hidden = NO;

//        [[NIMGroupOperationBox sharedInstance] sendGroupMemberRQ:self.groupid];
        if ([NSThread isMainThread]) {
            [self updateWithGroupName:info.group_name members:info.group_count inGroup:isMember];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateWithGroupName:info.group_name members:info.group_count inGroup:isMember];
            });
        }
    }else{
        NIMScanNotifyView *tView = [[NIMScanNotifyView alloc] initWithTips:@"请求超时"];
        [self.view addSubview:tView];
        return;
    }
    
}

-(void)recvGroupMember:(NSNotification *)noti
{
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
//            [MBTip showTipsView:param.p_string atView:self.view.window];
            [MBTip showError:param.p_string toView:self.view.window];

            return;
        }
        GroupList *groupList = [GroupList instancetypeFindGroupId:self.groupid];
        [self updateMembers:groupList.members];
    }else{
//        [MBTip showTipsView:@"请求超时" atView:self.view.window];
         UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];


    }
    
}

-(void)recvGroupAdd:(NSNotification *)noti
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        id object = noti.object;
        if (object) {
            
            if ([object isKindOfClass:[QBNCParam class]]) {
                
                QBNCParam *param = object;
                [MBTip showTipsView:param.p_string atView:self.view];
                
            }else{
                NSString*thread= [NIMStringComponents createMsgBodyIdWithType:GROUP toId:self.groupid];
                [self chatWithThread:thread];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBTip showError:@"已加入" toView:self.view];
                    
                });
                
            }
            
        }else{
            
        }
    });
    
    
}


- (void)configCollectionViewCell:(NIMVcardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSString *imageStr = nil;
    if (indexPath.row < self.memberDatasource.count) {
        GMember *member = [self.memberDatasource objectAtIndex:indexPath.row];
        
        VcardEntity *vcard = [VcardEntity instancetypeFindUserid:member.userid];
        
        imageStr = vcard.avatar;
    }
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    [cell updateConstraints];
    cell.vcardDelegate = self;
}
#pragma mark VcardCollectionViewCellDelegate

-(void)vcardCollectionViewCell:(NIMVcardCollectionViewCell *)cell didSelectedWithAvatar:(UIButton *)avatar
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    GMember *member = self.memberDatasource[indexPath.row];
            NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

    feedProfileVC.userid = member.userid;
    feedProfileVC.feedSourceType =ChatSource;
    [feedProfileVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:feedProfileVC animated:YES];
}



#pragma mark UICollectionViewDelegate
- (void)updateMembers:(NSSet *)members{
    NSArray *allObjs = members.allObjects;
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ct" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    self.memberDatasource = [allObjs sortedArrayUsingDescriptors:sortDescriptors];
    [self.collectionView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section==1) {
        if(indexPath.row == 1)
        {
            NIMGroupCardInfoVC* card = [[NIMGroupCardInfoVC alloc] initWithGroupName:groupName groupIp:self.groupid];
            [self.navigationController pushViewController:card animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.memberDatasource.count > 8) {
            return 150;
        }else{
            return 105;
        }
    }
    return 60;
}
#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"imgCell"];
        UIImageView *imgView = [cell viewWithTag:100];
        self.iconView = imgView;
        
    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"nameCell"];
        UILabel *nL = [cell viewWithTag:101];
        self.groupNameLabel = nL;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cntCell"];
        UILabel *nL = [cell viewWithTag:102];
        self.memberLabel = nL;
    }
    
    return cell;
}
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numerOfItems = 0;
    numerOfItems = self.memberDatasource.count;
    if (numerOfItems >= 16) {
        numerOfItems = 16;
    }
    return numerOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kvcardIdentifier forIndexPath:indexPath];
    [self configCollectionViewCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row < self.memberDatasource.count) {
//        GMember *memberEntity = [self.memberDatasource objectAtIndex:indexPath.row];
//        [self showFeedProfileWithUserid:memberEntity.userid animated:YES];
//    }
}


@end
