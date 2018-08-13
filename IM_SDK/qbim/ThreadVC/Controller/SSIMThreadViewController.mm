
//
//  SSIMThreadViewController.m
//  QianbaoIM
//
//  Created by 秦雨 on 17/5/18.
//  Copyright © 2017年 秦雨. All rights reserved.
//  钱宝首页列表

#import "SSIMThreadViewController.h"
#import "NIMChatUIViewController.h"
#import "NIMContactsViewController.h"
#import "NIMSubTimeTableViewCell.h"
#import "NIMSelfViewController.h"
#import "NIMMaskWindow.h"
#import "NIMCCEaseRefresh.h"
#import "NetCenter.h"
#import "NIMAddFriendsViewController.h"
#import "NIMNirKxMenu.h"
#import "NIMFriendNoticeViewController.h"
#import "NIMGroupAssistantVC.h"
#import "NIMManager.h"
#import "NIMLoginViewController.h"
#import "NIMPublicChatListViewController.h"
#import "NIMGroupCreateVC.h"
#import "NIMBusinessTableVC.h"
#import "NIMBusinessViewController.h"
#import "NIMPhotoVC.h"
#import "DFMainViewController.h"
@interface SSIMThreadViewController ()<VcardTableViewCellDelegate,NSFetchedResultsControllerDelegate,NetCenterDelegate,GroupCreateViewControllerDelegate>
{
    BOOL isRedAnimating;
    NIMCCEaseRefresh *refreshView;
}
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController* fetchedPublic;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsControllerForNewFriends;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsControllerForShop;
@property (nonatomic, strong) UIBarButtonItem* leftButtonItem;
@property (nonatomic, strong) UIBarButtonItem* rightButtonItem;
@property (nonatomic, strong) UIBarButtonItem* backButtonItem;
@property (nonatomic, strong) UIButton* navRightButton;
@property (nonatomic, assign) BOOL redPointShow;
@property (nonatomic, strong) NIMLoginViewController *loginVC;

@property (nonatomic, strong) UIImageView * badgeView;
@property(nonatomic, strong)  UIButton *leftButton;
@property(nonatomic, strong)  UIButton *backButton;

@property(nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *receImageView;

@end

@implementation SSIMThreadViewController
-(void)dealloc
{
    [self nimDealloc];
}

-(void)nimDealloc
{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _fetchedResultsController.delegate =nil;
    _fetchedResultsController =nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reflashUI:) name:NC_REFRESH_UI object:nil];

    self.navigationController.navigationBarHidden = NO;
    [self qb_setNavLeftButtonSpace];
    [self setRightBarButtonItem];
    [self qb_showLeftButtonWithImg:IMGGET(@"icon_titlebar_address.png")];
    self.fetchedResultsControllerForShop.delegate = nil;
    self.fetchedResultsControllerForShop = nil;
    self.fetchedPublic.delegate = nil;
    self.fetchedPublic = nil;
    [self initLatestPublicInfo];

    
    [self initLatestShopInfo];
    
     [self reflashUI:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIImage *bgImage = [SSIMSpUtil scaleFromImage:IMGGET(@"bg_rich_topbar") toSize:_CGS(GetWidth([UIApplication sharedApplication].keyWindow), 64)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];

    [[NIMSysManager sharedInstance] setIsInAssistant:NO];
    [[NIMSysManager sharedInstance] setIsInBuiness:NO];
    [[NIMSysManager sharedInstance] setCurrentMbd:nil];
    BOOL isEarphone =  [getObjectFromUserDefault(KEY_Earphone) boolValue];
    //判断语音方式
    if (isEarphone) {
        self.receImageView.hidden = NO;
    }else{
        self.receImageView.hidden = YES;
    }
    [NIMSysManager sharedInstance].msgCount = [[NIMMsgCountManager sharedInstance] GetAllUnreadCount];
    [self recvSomeOneAddMeNotification];
}


-(void)recvSomeOneAddMeNotification{
    //有未读消息时显示小红点
    NSArray * unreadCounts = [FDListEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and isInNewFriend == 1 and fdUnread == 1",OWNERID]];
    NSInteger unreadcount = unreadCounts.count;
    if(unreadcount != 0){
        self.badgeView.hidden = NO;
        [self.leftButton addSubview:self.badgeView];
    }else{
        if (self.badgeView) {
            self.badgeView.hidden = YES;
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (![NIMSysManager sharedInstance].isQbaoLoginSuccess) {
//        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.loginVC] animated:YES completion:nil];
//    }
    self.receImageView.hidden = YES;
    [self.labTitle addSubview:self.receImageView];
    [self qb_setTitleText:@"消息"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSomeOneAddMeNotification) name:NC_SERVER_FRIEND_ADD_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickme:) name:NC_NET_BEKICK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchAccount:) name:NC_LOGINOUT object:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 0.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NIMSubTimeTableViewCell class] forCellReuseIdentifier:kSubTimeReuseIdentifier];
    [[NetCenter sharedInstance] addObserver:self];
    [self checkMessageStatus];
    // config refresh
    refreshView = [[NIMCCEaseRefresh alloc] initInScrollView:self.tableView];
    [refreshView addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    // auto refresh
    [refreshView beginRefreshing];
    UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick)];
    self.labTitle.userInteractionEnabled = YES;
    [self.labTitle addGestureRecognizer:titleTap];

}

-(void)kickme:(NSNotification*)noti{
    
    id object = noti.object;
    if (object) {
        QBNCParam *param = object;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SHEET_MISS object:nil];
            UIViewController *topRootViewController = [[UIApplication  sharedApplication] keyWindow].rootViewController;
            BOOL isPresent = NO;
            while (topRootViewController.presentedViewController)
            {
                isPresent = YES;
                topRootViewController = topRootViewController.presentedViewController;
            }
            [topRootViewController dismissViewControllerAnimated:YES completion:nil];
            [[NIMSysManager sharedInstance] clearLoginInfo];
            [[NIMMomentsManager sharedInstance] clear];

            // 然后再进行present操作
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.loginVC] animated:YES completion:^{
                BOOL isPop = YES;
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[SSIMThreadViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        isPop = NO;
                        break;
                    }
                }
                if (isPop) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                [self nimDealloc];
                [self.navigationController.tabBarController setSelectedIndex:0];
                [MBTip showTipsView:param.p_string atView:self.loginVC.view afterDelay:2.0];
            }];
        });
    }else{
        
    }
    
}

-(void)loadView
{
    [super loadView];
    
    //重新监听 防止在切换用户之后数据库变更
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        //        [kAddressBookManager initData];
    });
    
    isRedAnimating = NO; // 小红点没有动画效果
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NC_REFRESH_UI object:nil];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)dropViewDidBeginRefreshing:(NIMCCEaseRefresh *)refreshControl
{
    double delayInSeconds = 1.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [refreshControl endRefreshing];
                       
                       // iOS，离线好友会话消息，一键下拉清除后，未读提醒依然显示
                       [self closeRefreshing];
                   });
    
}

- (void)closeRefreshing
{
    [[NIMMsgCountManager sharedInstance] Clear:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        for (NIMSubTimeTableViewCell * cell in self.tableView.visibleCells)
        {
            if (![cell.badgeLabel isHidden]) {
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    [cell disAppearRedPointWtihCompletion:^(BOOL finished) {
                        dispatch_semaphore_signal(semaphore);
                    }];
                });
                dispatch_time_t timeoutTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
                if (dispatch_semaphore_wait(semaphore, timeoutTime)) {
                    NSLog(@"11111111111111111");
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadFetchedResults:nil];
            isRedAnimating = NO;
        });
        
    });

}

-(void)newNotification
{
    
}

- (void)onLoadFinish
{
    int num = 0;
    for (int i = 1 ; i < self.fetchedResultsController.fetchedObjects.count; i++)
    {
        ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:i];
        
        num +=  recordList.badge;
        
        if (num > 9) {
            // 首页小红点的引导页面:当小红点数为10时或者以上都需要展示小红点帮助页面
            [self performSelector:@selector(showMark) withObject:nil afterDelay:0.5];
            return;
        }
    }
}

- (void)connectSocket{
    
}

- (void)setRightBarButtonItem{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    item.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[item,self.rightButtonItem,self.leftButtonItem];
}

- (void)show
{
    if(! [[self.navigationController.viewControllers lastObject] isKindOfClass:[self class]])
    {
        DBLog(@"----已经推到通讯录页面！！");
        return;
    }
    //    NIMContactsViewController* contact = (NIMContactsViewController*)[[UIStoryboard storyboardWithName:@"NIMChat" bundle:nil]instantiateViewControllerWithIdentifier:@"NIMContactsViewController"];
    //    [contact setHidesBottomBarWhenPushed:YES];
    //    [self.navigationController pushViewController:contact animated:YES];
}
#pragma mark 右键点击出现更多
- (void)showPopView:(id)sender
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[KxMenuOverlay class]]) {
            [KxMenu dismissMenu];
        }
        else
        {
            UIButton *button =(UIButton *)sender;
            KxMenuItem *itemCreate =[KxMenuItem menuItem:@"发起群聊" image:IMGGET(@"icon_group") target:self action:@selector(createGroup)];

            KxMenuItem *itemAdd =[KxMenuItem menuItem:@"添加好友" image:IMGGET(@"icon_add") target:self action:@selector(addFriend)];
            KxMenuItem *itemScan =[KxMenuItem menuItem:@"扫一扫" image:IMGGET(@"icon_scan") target:self action:@selector(showScanCodeView:)];
//            KxMenuItem *itemSwitch =[KxMenuItem menuItem:@"切换账号" image:IMGGET(@"icon_add") target:self action:@selector(switchAccount:)];
            
            NSArray *menuArray =@[itemCreate,itemAdd,itemScan];
            OptionalConfiguration dic ={9.0,  //指示箭头大小
                12.0,  //MenuItem左右边距
                13,  //MenuItem上下边距
                30,  //MenuItemImage与MenuItemTitle的间距
                2,  //菜单圆角半径
                true,  //是否添加覆盖在原View上的半透明遮罩
                NO,  //是否添加菜单阴影
                YES,  //是否设置分割线
                YES,  //是否在分割线两侧留下Insets
                {1,1,1},  //menuItem字体颜色
                {53/255.0,53/255.0,63/255.0}//菜单的底色
            };
            [KxMenu showMenuInView:self.view
                          fromRect:CGRectMake(SCREEN_WIDTH - button.frame.size.width-10, button.frame.origin.y-button.frame.size.height, button.frame.size.width, button.frame.size.height) menuItems:menuArray withOptions: dic];
        }
    }
    
    
}

-(void)createGroup
{
    NIMGroupCreateVC *groupCVC = (NIMGroupCreateVC*)[[UIStoryboard storyboardWithName:@"NIMGroup" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMGroupCreateVC"];
    groupCVC.delegate = self;
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:groupCVC];
    [self.navigationController pushViewController:groupCVC animated:YES];
}

-(void)addFriend
{
    UIStoryboard* testST = [UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]];
    NIMAddFriendsViewController* add = (NIMAddFriendsViewController*)[testST instantiateViewControllerWithIdentifier:@"addFriendsIdentity2"];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)showScanCodeView:(id)sender
{
    [self nim_showScanCodeView];
}

- (void)switchAccount:(id)sender
{
    [[NetCenter sharedInstance] DisConnect];
    [[NIMSysManager sharedInstance] removeAll];
    [[NIMSysManager sharedInstance] clearLoginInfo];
    [[NIMMomentsManager sharedInstance] clear];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:self.loginVC] animated:YES completion:^{
        removeObjectFromUserDefault(@"imuserInfo");
        BOOL isPop = YES;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[SSIMThreadViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                isPop = NO;
                break;
            }
        }
        if (isPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        [self.navigationController.tabBarController setSelectedIndex:0];
    }];
}

/*
- (void)scrollUnRead
{
    
    if (self.fetchedResultsController.fetchedObjects.count <= 1)
    {
        return;
    }
    
    NSArray * cells = [self.tableView visibleCells];
    NSIndexPath *first = [self.tableView indexPathForCell:cells[0]];
    
    NSInteger firstRow = first.row;
    NSInteger firstSection = first.section;
    BOOL taskUndo = NO;
    if (firstSection == 0)
    {
        ChatListEntity *rec = self.fetchedResultsController.fetchedObjects.firstObject;
        if (rec.badge > 0)
        {
            if (self.tableView.contentOffset.y < 100)
            {
                taskUndo = YES;
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    
    if (! taskUndo)
    {
        
        BOOL find;
        
        NSIndexPath *jumpIndex;
        int offset = firstSection == 1 ? 2: 1;
        for (NSInteger i = firstRow+offset;i< self.fetchedResultsController.fetchedObjects.count ;i++)
        {
            ChatListEntity *rec = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
            if (rec.badge > 0)
            {
                if (self.tableView.contentSize.height - self.tableView.contentOffset.y -20 <= self.tableView.frame.size.height)
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    return;
                }
                
                find = YES;
                jumpIndex = [NSIndexPath indexPathForRow:i-1 inSection:1];
                
                //                NSInteger jumpIndexRow = jumpIndex.row;
                [self.tableView scrollToRowAtIndexPath:jumpIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        
        if (! find)
        {
            ChatListEntity *rec = self.fetchedResultsController.fetchedObjects.firstObject;
            if (rec.badge > 0)
            {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                return;
            }
            
            for (NSInteger i = 0 ;i< firstRow+offset+1;i++)
            {
                ChatListEntity *rec = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
                if (rec.badge > 0)
                {
                    NSIndexPath *jumpIndex = [NSIndexPath indexPathForRow:i-1 inSection:1];
                    
                    [self.tableView scrollToRowAtIndexPath:jumpIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    break;
                }
            }
        }
    }
    
}
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[KxMenuOverlay class]]) {
            [KxMenu dismissMenu];
        }
    }
    
}

#pragma mark NIMViewController
- (void)requestNewModel{
    [self connectSocket];
}
- (void)updateUIbyModel{
    
}
- (void)updateUIByDeviceOrientation{
    
}
#pragma mark NetMsgMgrDelegate

-(void)imWithConnectStatus:(NSNumber *)iMConnectStatus result:(NIMResultMeta *)result
{
    E_NET_STATUS imConnectStatus = (E_NET_STATUS)[iMConnectStatus integerValue];
    
    NSString *titleString = @"消息(未连接)";
    switch (imConnectStatus) {
        case CLOSED:case BEKICKED:
        {
            titleString = @"消息(未连接)";
        }
            break;
        case CONNECTING:
        {
            titleString = @"消息(连接中...)";
        }
            break;
        case CONNECTED:
        {
            titleString = @"连接中...";
        }
            break;
        case DISCONNECT:
        {
            titleString = @"消息(未连接)";
        }
            break;
        case CLOSING:
        {
            titleString = @"消息(未连接)";
        }
            break;
        case LOGINING:
        {
            titleString = @"消息(登录中...)";
        }
            break;
        case LOGINED:
        {
            titleString = @"消息";
        }
            break;
        default:
            break;
    }
    //    self.imConnectStatus=imConnectStatus;
    //
    //    [[NSUserDefaults standardUserDefaults]setInteger:imConnectStatus forKey:@"imConnectStatus"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if([NSThread isMainThread]){
        [self qb_setTitleText:titleString];
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self qb_setTitleText:titleString];
        });
    }
    
}

-(void)nim_back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_BackHome)];
}

-(void)pushToContacts
{
    NIMContactsViewController* contact = (NIMContactsViewController*)[[UIStoryboard storyboardWithName:@"NIMChat" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMContactsViewController"];
    [self.navigationController pushViewController:contact animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    [QBControllerMediator mediator].redPointView.hidden = self.redPointShow;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    [[NIMOperationBox sharedInstance] arrangeTheneworder];
    
    NSArray* a = self.navigationController.navigationBar.subviews;
    UIView* v = (UIView*)[a firstObject];
    v.hidden = NO;
    [self onLoadFinish];
    self.tableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (KIsiPhoneX) {
        [self.tableView setFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-118)];
    }
}

// 小红点的引导页面
- (void)showMark
{
    NSNumber *nb = [[NSUserDefaults standardUserDefaults]valueForKey:@"mask_help_flag"];
    if (!nb)
    {
        NIMMaskWindow *help = [[NIMMaskWindow alloc]init];
        UIImageView *v = [[UIImageView alloc]init];
        v.backgroundColor = [UIColor clearColor];
        v.image = IMGGET(@"redhelp");
        [help addSubview:v];
        [v mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        help.touchDismiss = YES;
        [help show];
        
        [[NSUserDefaults standardUserDefaults]setValue:@(1) forKey:@"mask_help_flag"];
    }
}


//-(void)targetMethod
//{
//    timeIndex ++;
//    if (timeIndex<3)
//    {
//        [self reloadFetchedResults:nil];
//    }
//    else
//    {
//        [reflashTimer setFireDate:[NSDate distantFuture]];
//        isTimerClosed = YES;
//        timeIndex = 0;
//    }
//
//}

-(void)reflashUI:(NSNotification *)noti
{

    dispatch_async(dispatch_get_main_queue(), ^{
        id object = noti.object;
        if (object) {
            ChatListEntity *chatList = [ChatListEntity findFirstWithMessageBodyId:object];
            NSInteger index = [self.fetchedResultsController.fetchedObjects indexOfObject:chatList];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [self reloadFetchedResults:nil];
        }
    });
}

-(UIImageView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIImageView alloc]initWithImage:IMGGET(@"05")];
        [_badgeView setFrame:CGRectMake(self.leftButton.imageView.frame.size.width - 5, 0, 10, 10)];
    }
    return _badgeView;
}

-(void)titleClick
{
    if ( [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return;
    }
    E_NET_STATUS status = [NetCenter sharedInstance].GetNetStatus;
    if (status == CLOSED ||
        status == CLOSING ||
        status == DISCONNECT ||
        status == BEKICKED)
    {
        [[NetCenter sharedInstance] CacheConnect];
    }
}

-(void)checkMessageStatus
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isChange = [user boolForKey:@"msg_status"];
    if (!isChange) {
        return;
    }
    [user setBool:NO forKey:@"msg_status"];
    [user synchronize];
    if (self.fetchedResultsController.fetchedObjects.count>0) {
        for (ChatListEntity *chatList in self.fetchedResultsController.fetchedObjects) {
            
            if (chatList.chatType==SYS||
                chatList.chatType==INVALID) {
                continue;
            }
            
            NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
            [privateContext performBlock:^{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@ AND status = %d",chatList.messageBodyId,QIMMessageStatuIsUpLoading];
                
                NSArray *chatArr = [ChatEntity NIM_findAllWithPredicate:predicate];
                if (chatArr.count>0) {
                    for (ChatEntity* chatEntity in chatArr) {
                        if (chatEntity == nil) {
                            return ;
                        }
                        chatEntity.status = QIMMessageStatuUpLoadFailed;
                        
                    }
                    [privateContext MR_saveToPersistentStoreAndWait];
                }
                
                
                //                ChatEntity* chatEntity = nil;
                //                chatEntity = [ChatEntity NIM_findFirstWithPredicate:predicate sortedBy:@"ct" ascending:NO];
                //                if (chatEntity == nil) {
                //                    return ;
                //                }
                //                NSUserDefaults *msg = [NSUserDefaults standardUserDefaults];
                //                [msg setBool:YES forKey:chatList.messageBodyId];
                //                [msg synchronize];
                //                if (chatEntity.status == QIMMessageStatuIsUpLoading) {
                //                    chatEntity.status = QIMMessageStatuUpLoadFailed;
                //                }
                //                [privateContext NIM_saveToPersistentStoreAndWait];
            }];
        }
    }
    
}

- (void)reloadFetchedResults:(NSNotification*)note
{
    self.fetchedResultsController = nil;
    self.fetchedResultsController.delegate = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark push
- (void)showProfileControllerWithThread:(NSString *)thread{
    int64_t recipientid = [NIMStringComponents getOpuseridWithMsgBodyId:thread];
    if (recipientid > 0) {
        NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];
        
        feedProfileVC.userid = recipientid;
        feedProfileVC.feedSourceType = ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
    }
}

- (void)showGroupDetailControllerWithThread:(NSString *)thread{
    
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    chatVC.thread = thread;
    chatVC.actualThread = thread;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
    /*
    GroupList* group = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",thread]];
    if (group) {
        NIMChatGroupSettingVC* groupSetting = (NIMChatGroupSettingVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMChatGroupSettingIdentity"];
        groupSetting.groupList = group;
        groupSetting.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:groupSetting animated:YES];
    }
     */
}

- (void)deleteChatLogFormNotification:(NSNotification*)notification
{
    //    NSString* thred = [notification object];
    //    [self deleteChatLog:thred];
}
- (void)showPublicControllerWithThread:(NSString *)thread{
    
    
}

#pragma mark VcardTableViewCellDelegate
#pragma mark 头像点击

- (void)iconDidSlectedWithtableViewCell:(NIMDefaultTableViewCell *)cell
{
    NIMSubTimeTableViewCell *subCell = (NIMSubTimeTableViewCell *)cell;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:subCell];
    ChatListEntity*recordList=nil;
    recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    NSString *messageBodyId = recordList.messageBodyId;
    E_MSG_CHAT_TYPE chatType = (E_MSG_CHAT_TYPE)recordList.chatType;
    switch (chatType) {
        case GROUP:{
            [self showGroupDetailControllerWithThread:messageBodyId];
        }
            break;
        case PRIVATE:{
            [self showProfileControllerWithThread:messageBodyId];
        }
            break;
        case PUBLIC:{
            [self showPublicControllerWithThread:messageBodyId];
        }
            break;
        case SYS:{
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark configure
- (void)configureCell:(NIMSubTimeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(ChatListEntity*)recordList
{
    cell.delegate = self;
    [cell updateWithRecordList:recordList isRedAnimating:isRedAnimating];
}
#pragma mark SWTableViewCellDelegate


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = self.fetchedResultsController.fetchedObjects.count;
//    if (section == 0)
//    {
//        if (numberOfRows>0) {
//            return 1;
//        }
//    }
//    else
//    {
//        return numberOfRows-1;
//    }
    //    NSInteger numberOfRows = 0;
    //    if (section == 0)
    //    {
    //        return 1;
    //    }
    //    else
    //    {
    //        return self.fetchedResultsController.fetchedObjects.count-1;
    //    }
    //
    return numberOfRows;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 设置显示多个按钮
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewRowAction 通过此类创建按钮
    
    ChatListEntity *recordList=nil;
    recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];

    BOOL topAlen = recordList.topAlign;
    int64_t session_id = [NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId];
    int unread_count = [[NIMMsgCountManager sharedInstance] GetUnreadCount:session_id chat_type:recordList.chatType];
    
    NSInteger badge = unread_count;
    
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        
        if (recordList.isPublic == YES){
            NSMutableArray *arr = [self.fetchedPublic.fetchedObjects mutableCopy];
            for (ChatListEntity *list in arr){
                [self deleteChatLog:list.messageBodyId];
            }
            self.fetchedPublic.delegate = nil;
            self.fetchedPublic = nil;
        }
        if ([recordList.messageBodyId isEqualToString:kShopThread]) {
            NSMutableArray *arr = [self.fetchedPublic.fetchedObjects mutableCopy];
            for (ChatListEntity *list in arr){
                
                [self deleteChatLog:list.messageBodyId];
            }
            self.fetchedResultsControllerForShop.delegate = nil;
            self.fetchedResultsControllerForShop = nil;
            
            
            NSPredicate *delePre = [NSPredicate predicateWithFormat:@"userId = %lld and (chatType == %d or chatType ==%d)",OWNERID,5,6];
            [ChatListEntity NIM_deleteAllMatchingPredicate:delePre];
            
        }
        [self deleteChatLog:recordList.messageBodyId];
        [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    }];
    deleteRowAction.backgroundColor =  [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    
    UITableViewRowAction * topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        if (recordList.topAlign==YES) {
            [[NIMGroupOperationBox sharedInstance] swithTop:NO withGroupMsgBodyId:recordList.messageBodyId];
        }else{
            [[NIMGroupOperationBox sharedInstance] swithTop:YES withGroupMsgBodyId:recordList.messageBodyId];
        }
        [self reloadFetchedResults:nil];
        
    }];
    topRowAction.backgroundColor =  [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0];
    
    UITableViewRowAction * moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标为 已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (recordList.isPublic ==YES) {
            
        }else{
            int64_t session_id = [NIMStringComponents getOpuseridWithMsgBodyId:recordList.messageBodyId];
            E_MSG_CHAT_TYPE chat_type = [NIMStringComponents chatTypeWithMsgBodyId:recordList.messageBodyId];
            
            int unread_count = [[NIMMsgCountManager sharedInstance] GetUnreadCount:session_id chat_type:chat_type];
            
            if(unread_count!=0){
                [[NIMMsgCountManager sharedInstance] RemoveUnreadCount:session_id chat_type:chat_type];
            }else{
                [[NIMMsgCountManager sharedInstance] UpsertUnreadCount:session_id chat_type:chat_type unread_count:1];
            }
            [self reloadFetchedResults:nil];
            //            [[NIMOperationBox sharedInstance] arrangeTheneworder];
        }
    }];
    moreRowAction.backgroundColor =  [UIColor orangeColor];
    if (![recordList.messageBodyId isEqualToString:kNewFriendThread]) {
        if(topAlen==YES)
        {
            topRowAction.title =@"取消\r置顶";
        }
        else{
            topRowAction.title = @"置顶";
            
        }
    }
    if ([recordList.messageBodyId isEqualToString:kNewFriendThread]){ //新的朋友没有置顶
        if(badge!=0){
            moreRowAction.title =@"标为\r已读";
            
        }else{
            moreRowAction.title =@"标为\r未读";
        }
        
        return @[deleteRowAction,moreRowAction];
    }
    
    if (recordList.isPublic==YES ||
        [recordList.messageBodyId isEqualToString:kGroupAssistantThread] ||
        [recordList.messageBodyId isEqualToString:kShopThread]) {
        return @[deleteRowAction,topRowAction];
    }else{
        if(badge!=0){
            moreRowAction.title =@"标为\r已读";
        }else{
            moreRowAction.title =@"标为\r未读";
        }
    }
    return @[deleteRowAction,moreRowAction,topRowAction];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NIMSubTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSubTimeReuseIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    ChatListEntity *recordList = nil;

    recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];

    [cell updateWithRecordList:recordList isRedAnimating:isRedAnimating];
    return cell;
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *messageBodyId = nil;
    NSString *actualThread = nil;
    
    ChatListEntity *chatList = nil;
    chatList = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    messageBodyId = chatList.messageBodyId;
    actualThread = chatList.actualThread;
    
    E_MSG_CHAT_TYPE chatType = [NIMStringComponents chatTypeWithMsgBodyId:messageBodyId];
    if (chatType==PUBLIC) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_OfficialChat)];

    }
    if ([messageBodyId isEqualToString:kNewFriendThread]) {
        NIMFriendNoticeViewController *friendNVC = [NIMFriendNoticeViewController new];
        [friendNVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:friendNVC animated:YES];
        return;
    }
    if ([messageBodyId isEqualToString:kGroupAssistantThread]) {
        NIMGroupAssistantVC *vc = [[NIMGroupAssistantVC alloc]init];
        [self nim_pushToVC:vc animal:YES];
        return;
    }
    if ([messageBodyId isEqualToString:kPublicPacketThread]) {
        NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
        [privateContext performBlock:^{
            //TODO:save
            ChatListEntity *recordListEntity = [ChatListEntity findFirstWithMessageBodyId:kPublicPacketThread];
            recordListEntity.showRedPublic = NO;
            [privateContext MR_saveOnlySelfAndWait];
        }];
        NIMPublicChatListViewController *vc = [[NIMPublicChatListViewController alloc]init];
        [self nim_pushToVC:vc animal:YES];
        return;
    }
    if ([messageBodyId isEqualToString:kTaskHelperThread]) {
        NSLog(@"任务助手");
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_Task)];
        return;
    }
    
    if ([messageBodyId isEqualToString:kSubscribeThread]) {
        NSLog(@"订阅助手");
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:@(SDK_PUSH_Subscribe)];
        return;
    }
    
    if ([messageBodyId isEqualToString:kShopThread]) {
        NSLog(@"我的店铺");

        NIMBusinessTableVC * businVC = [[NIMBusinessTableVC alloc]init];
        
        [self.navigationController pushViewController:businVC animated:YES];

        return;
    }
    NSLog(@"聊天ID:%@",messageBodyId);
    NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
    chatVC.thread = messageBodyId;
    chatVC.actualThread = actualThread;
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatListEntity *recordList = (ChatListEntity *)[self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    if (recordList.isPublic == YES){
        
        NSMutableArray *arr = [self.fetchedPublic.fetchedObjects mutableCopy];
        for (ChatListEntity *list in arr)
        {
            [self deleteChatLog:list.messageBodyId];
        }
        self.fetchedPublic.delegate = nil;
        self.fetchedPublic = nil;
    }
    
    [self deleteChatLog:recordList.messageBodyId];
    [self reloadFetchedResults:nil];
    //    [[NIMOperationBox sharedInstance] arrangeTheneworder];
}

- (void)deleteChatLog:(NSString*)messageBodyId{
    ChatListEntity *recordList = [ChatListEntity findFirstWithMessageBodyId:messageBodyId];
    
    [ChatEntity NIM_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",messageBodyId]];
    [recordList NIM_deleteEntity];
    [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
    [[NIMMessageManager sharedInstance] removeAllMessageBy:messageBodyId];

}

//TODO:显示系统消息
- (void)showSystemInfoVC{
    
}
- (void)showTaskHelper{
    
}

- (void)qb_showLeftButtonWithImg:(UIImage *)image
{
    self.leftButtonItem = nil;
    [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    [self.leftButton setImage:image forState:UIControlStateHighlighted];
    [self.leftButton setTitle:nil forState:UIControlStateNormal];
}

- (void)qb_setNavLeftButtonSpace
{
    // Do any additional setup after loading the view.
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -6;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:self.backButtonItem];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, self.backButtonItem, nil]];
}



- (void)qb_setTitleText:(NSString*)titleText
{
    self.labTitle.text = titleText;
    
    CGFloat width = [titleText boundingRectWithSize:CGSizeMake(100, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.width;
    
    CGFloat offset = 80+width/2.0;
    
    [self.receImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle.mas_centerY);
        make.width.equalTo(@(19));
        make.height.equalTo(@(19));
        make.leading.equalTo(self.labTitle.mas_leading).with.offset(offset);
    }];
    
}


#pragma mark GroupCreateViewControllerDelegate


- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didCreatedGroup:(GroupList *)groupEntity{
    if (groupEntity == nil) {
        return;
    }
    if(groupEntity.messageBodyId)
    {
        NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
        [chatVC setThread:groupEntity.messageBodyId];
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    
}
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didSelectedThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    completeBlock(VcardSelectedActionTypeChat,nil,nil);
}
- (void)groupCreateViewController:(NIMGroupCreateVC *)viewController didBackWithCompleteBlock:(VcardCompleteBlock)completeBlock{
    completeBlock(VcardSelectedActionTypeChat,nil,nil);
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (controller == self.fetchedPublic) {
        [self initLatestPublicInfo];
    }

}

////此方法执行时，说明数据已经发生了变化，通知tableview开始更新UI
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView beginUpdates];
//    });
//}

////结束更新
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView endUpdates];
//    });
//}



#pragma mark NSFetchedResultsController
- (NSFetchedResultsController *)fetchedResultsController{
    
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSPredicate *pregroup = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid == %lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
    NSArray *list = [GroupList NIM_findAllWithPredicate:pregroup];
    
    NSMutableArray *source = [NSMutableArray array];
    for (GroupList *item in list)
    {
        [source addObject:item.messageBodyId];
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"NOT (messageBodyId in %@) and userId = %lld and isflod == %d and (chatType!=%d and chatType!=%d)",source,OWNERID,NO,SHOP_BUSINESS,CERTIFY_BUSINESS];
    _fetchedResultsController =  [ChatListEntity NIM_fetchAllGroupedBy:@"messageBodyIdType" withPredicate:pre sortedBy:@"messageBodyIdType,topAlign,ct" ascending:NO delegate:nil];
    _fetchedResultsController.delegate = self;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSError *error;
    
    if (![_fetchedResultsController performFetch:&error]) {
        DBLog(@"[fetchSinaFriend] Unresolved error %@, %@", error, [error userInfo]);
    }
    return _fetchedResultsController;
}

- (void)initLatestPublicInfo
{
    if (!_fetchedPublic) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"isflod == %d AND userId = %lld",YES,OWNERID];
        
        _fetchedPublic = [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:pre sortedBy:@"topAlign,ct" ascending:NO delegate:self];
        
        NSError *error = nil;
        if (![_fetchedPublic performFetch:&error])
        {
            DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    if (self.fetchedPublic.fetchedObjects.count > 0)
    {
        ChatListEntity *list = [self.fetchedPublic.fetchedObjects firstObject];
        [[NIMOperationBox sharedInstance] makePublicPacketShow:list];
    }
    else
    {
        [ChatListEntity clearRecordWithMessageBodyId:kPublicPacketThread];
    }
    
    return;
    
}


- (void)initLatestShopInfo
{
    if (!_fetchedResultsControllerForShop) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"(chatType = %d || chatType = %d) AND userId = %lld",SHOP_BUSINESS,CERTIFY_BUSINESS,OWNERID];
        
        _fetchedResultsControllerForShop = [ChatListEntity NIM_fetchAllGroupedBy:@"topAlign" withPredicate:pre sortedBy:@"topAlign,ct" ascending:NO delegate:self];
        
        NSError *error = nil;
        if (![_fetchedResultsControllerForShop performFetch:&error])
        {
            DBLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
  
    return;
}

- (UIBarButtonItem*)rightButtonItem{
    if(!_rightButtonItem){
        _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
    }
    return _rightButtonItem;
}

- (UIButton*)navRightButton{
    if(!_navRightButton){
        _navRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navRightButton.frame = CGRectMake(0, 0, 30, 30);
        [_navRightButton setImage:IMGGET(@"icon_titlebar_more") forState:UIControlStateNormal];
        [_navRightButton setImage:IMGGET(@"icon_titlebar_more") forState:UIControlStateHighlighted];
        [_navRightButton addTarget:self action:@selector(showPopView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _navRightButton;
}

_GETTER_BEGIN(UIBarButtonItem, leftButtonItem)
{
//    UIView *t_leftView = _ALLOC_OBJ_WITHFRAME_(UIView, _CGR(0, 0, 44, 44));
//    [t_leftView addSubview:self.leftButton];
    _leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
}
_GETTER_END(leftButtonItem)

_GETTER_BEGIN(UIBarButtonItem, backButtonItem)
{
    //    UIView *t_leftView = _ALLOC_OBJ_WITHFRAME_(UIView, _CGR(0, 0, 44, 44));
    //    [t_leftView addSubview:self.leftButton];
    _backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.backButton];
}
_GETTER_END(backButtonItem)

_GETTER_BEGIN(UIButton, leftButton)
{
    _leftButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _CLEAR_BACKGROUND_COLOR_(_leftButton);
    _leftButton.exclusiveTouch  = YES;
    _leftButton.frame           = _CGR(0, 0, 30, 30);
    [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [_leftButton.titleLabel setFont:FONT_TITLE(16)];
    [_leftButton addTarget:self action:@selector(pushToContacts) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(leftButton)

_GETTER_BEGIN(UIButton, backButton)
{
    _backButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _CLEAR_BACKGROUND_COLOR_(_backButton);
    _backButton.exclusiveTouch  = YES;
    _backButton.frame           = _CGR(0, 0, 60, 28);
//    [_backButton setImage:IMGGET(@"icon_titlebar_back") forState:UIControlStateNormal];
    [_backButton setTitleColor:[SSIMSpUtil getColor:@"66666e"]  forState:UIControlStateNormal];
//    [_backButton setTitle:@"返回" forState:UIControlStateNormal];
    [_backButton.titleLabel setFont:FONT_TITLE(16)];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 27)];
    [_backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 0)];
//    [_backButton addTarget:self action:@selector(nim_back) forControlEvents:UIControlEventTouchUpInside];
}

_GETTER_END(backButton)

_GETTER_BEGIN(UILabel, labTitle)
{
    _CREATE_LABEL_ALIGN_BOLDFONT(_labTitle, _CGR(0, 0, 100, 35), ALIGN_CENTER, 19);
    self.navigationItem.titleView = _labTitle;
}
_GETTER_END(labTitle)

_GETTER_BEGIN(UIImageView, receImageView)
{
    UIImage *image =  IMGGET(@"听");
    _receImageView = [[UIImageView alloc]initWithImage:image];
    
}
_GETTER_END(receImageView)



-(NIMLoginViewController *)loginVC
{
    if (!_loginVC) {
        _loginVC = [[NIMLoginViewController alloc] init];
    }
    return _loginVC;
}
@end
