//
//  NIMPublicInfoViewController.m
//  QianbaoIM
//
//  Created by liunian on 14/8/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMPublicInfoViewController.h"
#import "NIMPublicVcardTableViewCell.h"
//#import "QBSwitchTableViewCell.h"
#import "NIMVcardCollectionViewCell.h"
//#import "PublicEntity.h"
#import "VcardEntity+CoreDataClass.h"
#import "NIMPublicOperationBox.h"
//#import "NContactEntity.h"
#import "NIMPublicAttentionUserListVC.h"
#import "NIMChatUIViewController.h"
#import "NIMLatestVcardViewController.h"
#import "NIMUserOperationBox.h"
//#import "MessageNIMOperationBox.h"
//#import "NIMMessageContent.h"
//#import "NIMMessageCenter.h"

#import "NIMActionSheet.h"
@interface NIMPublicInfoViewController ()<NSFetchedResultsControllerDelegate,VcardForwardDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) IBOutlet UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *qbnameLabel;
@property (nonatomic, weak) IBOutlet UILabel *subcrebeLabel;
@property (nonatomic, weak) IBOutlet UILabel *introLabel;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, strong) UIButton *subcribeBtn;
@property (nonatomic, weak) IBOutlet UILabel *subcribeNumLabel;
@property (nonatomic, weak) IBOutlet UISwitch *apnSwitch;
@property (nonatomic, strong) NSMutableArray *datasource;
//@property (nonatomic, strong) PublicEntity  *publicEntity;
@property (nonatomic, strong) UIBarButtonItem* rightBar;
@end

@implementation NIMPublicInfoViewController

- (void)dealloc{
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    // Do any additional setup after loading the view.
    
    //    [self refreshFans];
//    self.apnSwitch.on = self.publicEntity.apn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.subcribeBtn.hidden = NO;
    [self reloadFromDB];
    [self setPublicStatus];
}


//-(void)updatePublicInfo{
//    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [privateContext performBlockAndWait:^{
//        PublicEntity *publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//
//        if (publicEntity == nil) {
//            publicEntity = [PublicEntity getEntity];
//        }
//        NSString *thread = [NIMStringComponents createMsgBodyIdWithType:PUBLIC  toId:self.publicid];
//        [publicEntity setThread:thread];
//        [publicEntity setSubscribed:0];
//
//        [privateContext MR_saveOnlySelfAndWait];
//    }];
//
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.subcribeBtn.hidden = YES;
}

- (void)qb_back{
//    if(self.apnSwitch.on == self.publicEntity.apn)
//    {
//        [super qb_back];
//        [self.subcribeBtn removeFromSuperview];
//    }
//    else
//    {
//        [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicEntity.publicid
//                                                          switchValue:self.apnSwitch.on
//                                                        completeBlock:^(id object, NIMResultMeta *result) {
//                                                            dispatch_sync(dispatch_get_main_queue(), ^{
//                                                                if(result)
//                                                                {
//                                                                    [MBTip showError:result.message toView:self.view];
//                                                                }
//                                                                else
//                                                                {
//                                                                    [self saveTo];
//                                                                    [self.subcribeBtn removeFromSuperview];
//                                                                    [self.navigationController popViewControllerAnimated:YES];
//
//                                                                }
//                                                            });
//                                                        }];
//    }
}

- (void)setPublicStatus
{
//    if(self.publicEntity.subscribed)
//    {
//        self.navigationItem.rightBarButtonItem = self.rightBar;
//    }
}

#pragma mark VcardForwardDelegate
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock
{
    if(thread.length==0)return;
    /*
     [[MessageNIMOperationBox sharedInstance] sendMessage:[NSNumber numberWithDouble:self.publicid] thread:thread packetContentType:PacketContentTypeJson packetSubtypeType:PacketSubtypeTypeVCard cardType:CardTypePublic completeBlock:^(id object, NIMResultMeta *result)
     {
     completeBlock(VcardSelectedActionTypeForward, object, result);
     }];
     */
}

#pragma mark
- (void)reloadFromDB
{
//    self.publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//    [self configurePublic];
//
//    [self.collectionView reloadData];
}

-(void)refreshSelf
{
    
    /*
     [[NIMUserOperationBox sharedInstance] fetchUserid3:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
     DBLog(@"%@",object);
     void (^callBack)();
     callBack = ^(){
     if (!object){
     UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该公众号停止服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     alertV.tag =100;
     [alertV show];
     return ;
     }
     [self reloadFromDB];
     };
     if([NSThread isMainThread]){
     callBack();
     }else{
     dispatch_async(dispatch_get_main_queue(), ^{
     callBack();
     });
     }
     }];
     */
    
}

- (void)refreshFans{
    [[NIMPublicOperationBox sharedInstance] fetchFansPublicid:self.publicid offset:0 completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (object) {
                [self reloadFromDB];
            }
        });
    }];
}
#pragma mark action
- (void)subcribePublic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [[NIMPublicOperationBox sharedInstance] subscribePublic:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //            if (result) {
    //                [MBProgressHUD showError:result.message toView:self.view];
    //            }else{
    //                self.publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
    //                self.navigationItem.rightBarButtonItem = self.rightBar;
    //                [self refreshSelf];
    //                [self.tableView reloadData];
    //            }
    //        });
    //    }];
}

- (void)unSubcribePublic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NIMPublicOperationBox sharedInstance] unsubscribePublic:self.publicid completeBlock:^(id object, NIMResultMeta *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (result) {
                [MBTip showError:result.message toView:self.view];
            }else{
//                self.publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
                [self refreshSelf];
                self.navigationItem.rightBarButtonItem = nil;
                [self.tableView reloadData];
            }
        });
    }];
}
-(void)saveTo
{
//    NSManagedObjectContext *managedObjectContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
//    [managedObjectContext performBlockAndWait:^{
//        PublicEntity  *publicEntity = [PublicEntity instancetypeWithPublic:self.publicid];
//        publicEntity.apn = self.apnSwitch.on;
//        //TODO:save
//        [managedObjectContext MR_saveOnlySelfAndWait];
//    }];
    
}
- (IBAction)subcribePublicButtonClick:(id)sender{
//    if (self.publicEntity.subscribed == PublicSubscribedTypeSys) {
//        [MBTip showError:@"系统服务号无法取消" toView:self.view];
//        return;
//    }
    //    _GET_APP_DELEGATE_(appDelegate);
    if(! [NIMSysManager sharedInstance].isQbaoLoginSuccess)
    {
        //        [appDelegate.window.rootViewController presentViewController:appDelegate.authNavigationC animated:YES completion:^{
        //
        //        }];
    }
    else
    {
//        if (self.publicEntity.subscribed) {
//
//
//            if(self.apnSwitch.on != self.publicEntity.apn){
//                [[NIMPublicOperationBox sharedInstance] switchPublicWithPubid:self.publicEntity.publicid
//                                                                  switchValue:self.apnSwitch.on
//                                                                completeBlock:^(id object, NIMResultMeta *result) {
//                                                                    dispatch_sync(dispatch_get_main_queue(), ^{
//                                                                        if(result){
//                                                                            [MBTip showError:result.message toView:self.view];
//                                                                        }
//                                                                        else{
//
//                                                                            [self saveTo];
//                                                                        }
//                                                                    });
//                                                                }];
//            }
//
//            NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
//            [chatVC setThread:self.publicEntity.thread];
//            chatVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:chatVC animated:YES];
//            [self.subcribeBtn removeFromSuperview];
//        }else{
//            [self subcribePublic];
//        }
    }
}

#pragma mark config
//- (void)configurePublic{
//    //    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.publicEntity.avatar] placeholderImage:nil];
//    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.publicEntity.avatar] placeholderImage:nil options:SDWebImageRefreshCached];
//    self.nameLabel.text = self.publicEntity.name;
//    self.qbnameLabel.text = [NSString stringWithFormat:@"钱宝号:%.0f",self.publicEntity.publicid];
//    self.subcrebeLabel.text = [NSString stringWithFormat:@"关注人数:%lu",(unsigned long)self.publicEntity.fans.count];
//    NSString *introStr = self.publicEntity.desc;
//    self.introLabel.text =introStr;
//    self.introLabel.numberOfLines = 0;
//    self.apnSwitch.on = self.publicEntity.apn;
//    self.subcribeNumLabel.text = [NSString stringWithFormat:@"%lld人关注",self.publicEntity.fansnum];
//    NSString *subTips = @"关注";
//    if (self.publicEntity.subscribed) {
//        subTips = @"进入公众号";
//        [self.subcribeBtn setImage:nil forState:UIControlStateNormal];
//        [self.subcribeBtn setTitle:subTips forState:UIControlStateNormal];
//        [self.subcribeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    }else{
//        [self.subcribeBtn setImage:IMGGET(@"icon_bottom_add") forState:UIControlStateNormal];
//        [self.subcribeBtn setTitle:@"关注" forState:UIControlStateNormal];
//        [self.subcribeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.subcribeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self.subcribeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    }
//
//
//    if (self.publicEntity.subscribed == PublicSubscribedTypeSys) {
//        //        [self.subcribeBtn setEnabled:NO];
//    }else{
//        [self.subcribeBtn setEnabled:YES];
//    }
//
//    NSArray *allFans = [self.publicEntity.fans allObjects];
//
//    self.datasource = [NSMutableArray arrayWithArray:allFans];
//    NSArray* friends = self.publicEntity.fans.allObjects;
//    [self.datasource removeAllObjects];
//    [friends enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        NVcardEntity *vcardEntity = obj;
//        if (vcardEntity) {
//            [self.datasource addObject:vcardEntity];
//        }
//    }];
//    [self.tableView reloadData];
//}

- (void)showLatestVcardViewController:(BOOL)animated{
    
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.delegate = self;
    }
    [self.navigationController presentViewController:latestVcardNavigation animated:YES completion:^{
        
    }];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return 80;
//    }else if (indexPath.section == 0 && indexPath.row == 1){
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//        NSString *introStr = @"";
//        introStr = self.publicEntity.desc;
//        CGRect r = [introStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.frame) - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//
//
//        return CGRectGetHeight(r)+30;
//    }
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        if (self.datasource.count > 8) {
//            return 110;
//        }else{
//            return 60;
//        }
//    }
//    return 44;
//}
#pragma mark table view datasource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (self.publicEntity.subscribed == PublicSubscribedTypeNone) {
//        return 2;
//    }
//    return 3;
//}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            //            [QBClick event:kUMEventId_3020];
            NIMPublicAttentionUserListVC* attentionlist = (NIMPublicAttentionUserListVC*)[[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMPublicAttentionUserList"];
            attentionlist.publicid = self.publicid;
            [self.navigationController pushViewController:attentionlist animated:YES];
        }
    }
}
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numerOfItems = 0;
    numerOfItems = self.datasource.count;
    if (numerOfItems >= 16) {
        numerOfItems = 16;
    }
    return numerOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NIMVcardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kvcardIdentifier forIndexPath:indexPath];
    NSString *imageStr = nil;
    if (indexPath.row < self.datasource.count) {
        VcardEntity *vcardEntity = [self.datasource objectAtIndex:indexPath.row];
        imageStr = vcardEntity.avatar;
    }
    [cell updateConstraints];
    [cell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"fclogo"]];
    return cell;
}

float margin = 5;

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float length = floorf((self.collectionView.frame.size.width-margin*7)/8);
    return CGSizeMake(length, length);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(margin, 0, margin, 0);
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
//    self.publicEntity = anObject;
//    [self configurePublic];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
}
- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return [sectionName stringByReplacingOccurrencesOfString:@"Z#" withString:@"#"];;
}

//- (void)moreAction:(id)Sender{
//
//    if(self.publicEntity.subscribed == PublicSubscribedTypeSys){
//        NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"推荐给好友"] AttachTitle:@"退出后将不再接收此群消息，同时删除该群的聊天记录"];
//
//        //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
//
//        [action ButtonIndex:^(NSInteger Buttonindex) {
//
//            if (Buttonindex == 1) {
//                [self showLatestVcardViewController:YES];
//
//            }
//            NSLog(@"index--%ld",Buttonindex);
//
//        }];
//    }
//    else{
//        NIMActionSheet *action = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"取消关注",@"推荐给好友"] AttachTitle:@"退出后将不再接收此群消息，同时删除该群的聊天记录"];
//
//        //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
//
//        [action ButtonIndex:^(NSInteger Buttonindex) {
//
//            if (Buttonindex == 2) {
//                [self showLatestVcardViewController:YES];
//
//            }else if (Buttonindex == 1){
//                UIAlertAction* can = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                }];
//                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self unSubcribePublic];
//                }];
//
//
//
//                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消关注么" preferredStyle:UIAlertControllerStyleActionSheet];
//                [alertC addAction:can];
//                [alertC addAction:ok];
//
//                [self presentViewController:alertC animated:YES completion:nil];
//
//            }
//            NSLog(@"index--%ld",Buttonindex);
//
//        }];
//    }
//
//
//    //    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //
//    //    }];
//    //    UIAlertAction* friend = [UIAlertAction actionWithTitle:@"推荐给好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //        [self showLatestVcardViewController:YES];
//    //    }];
//    //
//    //    UIAlertAction* exit = [UIAlertAction actionWithTitle:@"取消关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //
//    //        UIAlertAction* can = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //
//    //        }];
//    //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //            [self unSubcribePublic];
//    //        }];
//    //
//    //
//    //
//    //        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消关注么" preferredStyle:UIAlertControllerStyleActionSheet];
//    //        [alertC addAction:can];
//    //        [alertC addAction:ok];
//    //
//    //        [self presentViewController:alertC animated:YES completion:nil];
//    //
//    //
//    //    }];
//    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    //
//    //
//    //    if(self.publicEntity.subscribed == PublicSubscribedTypeSys){
//    //        [alertController addAction:cancel];
//    //        [alertController addAction:friend];
//    //
//    //    }
//    //    else{
//    //        [alertController addAction:cancel];
//    //        [alertController addAction:exit];
//    //        [alertController addAction:friend];
//    //
//    //    }
//    //
//    //    [self presentViewController:alertController animated:YES completion:nil];
//
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else if (buttonIndex == 1)
    {
        [self unSubcribePublic];
    }
}
#pragma mark getter
- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSError *error = NULL;
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}


- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = @[].mutableCopy;
    }
    return _datasource;
}

- (UIBarButtonItem*)rightBar{
    if(!_rightBar){
        _rightBar = [[UIBarButtonItem alloc] initWithImage:IMGGET(@"icon_public_more") style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    }
    return _rightBar;
}

- (UIButton*)subcribeBtn{
    if(!_subcribeBtn){
        _subcribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        _subcribeBtn.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50);
        [_subcribeBtn setBackgroundColor:[UIColor whiteColor]];
        [_subcribeBtn setTitleColor:[SSIMSpUtil getColor:@"43A81D"] forState:UIControlStateNormal];
        [_subcribeBtn addTarget:self action:@selector(subcribePublicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_subcribeBtn];
        [_subcribeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo([UIApplication sharedApplication].keyWindow.mas_leading);
            make.trailing.equalTo([UIApplication sharedApplication].keyWindow.mas_trailing);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
            make.width.equalTo([UIApplication sharedApplication].keyWindow.mas_width);
            make.height.equalTo(@50);
        }];
    }
    return _subcribeBtn;
}
@end
