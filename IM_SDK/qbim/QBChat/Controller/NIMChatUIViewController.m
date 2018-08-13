//
//  NIMChatUIViewController.m
//  QianbaoIM
//
//  Created by qianwang on 14/11/25.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//


#import "NIMChatUIViewController.h"

#import "NIMRChatCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UIActionSheet+nimphoto.h"
#import "NIMRChatKeyboardView.h"
#import "NIMMapViewController.h"
//#import "QBImagePickerController.h"
#import "UIImage+NIMHBClass.h"
#import "NIMFriendNoticeDetailViewController.h"
#import "Location+CoreDataClass.h"
#import "NIMChatGroupSettingVC.h"
#import "NIMVcardViewController.h"
#import "NIMGroupAgreeVC.h"
#import "ImageEntity+CoreDataClass.h"

#import "NIMPChatTableViewController.h"
#import "NIMHtmlWebViewController.h"
//#import "MessageNIMOperationBox.h"
#import "TextEntity+CoreDataClass.h"
#import "NIMPhotoVC.h"
#import "NIMSampleQueueId.h"
#import "AudioEntity+CoreDataClass.h"
#import "NIMMessageSoundEffect.h"
//#import "NIMLatestVcardViewController.h"
//#import "NIMFeedProfileViewController.h"
#import "UIViewController+NIMPushVC.h"
//#import "PublicEntity.h"
//#import "CommodityDetailViewController.h"
//#import "OrderInfoViewController.h"
//#import "NIMPublicOperationBox.h"
//#import "ALAssetsLibrary+NIMCustomPhotoAlbum.h"
#import "JFImagePickerController.h"
#import "NIMBusinessViewController.h"
#import "NIMCameraViewController.h"
#import "NIMLLCameraViewController.h"
#import "NIMOrderListViewController.h"
#import "NIMBottomView.h"
#import "NIMPlaySound.h"
#import "NIMGroupCreateVC.h"
#import "NIMGroupVcardVC.h"
#import "NIMAddFriendAttributeCell.h"
#import "NIMAddDescViewController.h"
#import "NIMPublicBottomView.h"
#import "NIMMessageCenter.h"
#import "NIMPhotoObject.h"
#import "NIMManager.h"
#import "NIMMessageStruct.h"
#import "NIMSoundTipView.h"
#import "NIMBusinessOperationBox.h"
#import "NIMChatCountView.h"

#import "NIMSelfViewController.h"
#import "NIMLatestVcardViewController.h"


#import "SSIMThreadViewController.h"
#import "ZHSmallVideoController.h"
#import "UIImage+NIMEffects.h"
#import "DFVideoPlayController.h"
#import "ZHPlayVideoView.h"
#define  kMaxListItems  20
#define INPUT_HEIGHT 46.0f
#define kLimitFetch 5
#define kChatMediaViewW        320
#define kChatMediaViewH        216

#define threadCount [[self.thread componentsSeparatedByString:@":"] count]

typedef NS_ENUM(NSInteger, ChatThreadCount) {
    ChatWithFriendOrGroup    =3 ,           //IM或者群组聊天
    ChatWithBusiness         =4,            //个人商家或者认证商家之间聊天
    ChatWithWaiter           =5             //店小二之间聊天
};

@interface NIMChatUIViewController ()
<UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate,
ChatKeyboardDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate,
UIImagePickerControllerDelegate,
//QBImagePickerControllerDelegate,
NIMMapViewControllerDelegate,
VcardViewControllerDelegate,
ChatTableViewCellDelegate,NIMChatGroupSettingVCDelegate,NIMPChatTableViewControllerDelegate,NIMPlaySoundDelegate,UIAlertViewDelegate,NIMPublicBottomViewdelegate,NIMCameraViewControllerDelegate,NIMLLCameraViewControllerDelegate,UITextFieldDelegate,JFImagePickerDelegate,NIMChatCountViewDelegate,ZHSmallVideoControllerDelegate,VcardForwardDelegate>
{
    struct{
        unsigned int mediaPadShown:1;
        unsigned int scrollToBottomAnimated:1;
    }_chatVCFlag;
    BOOL                _isBottom;
    E_MSG_CHAT_TYPE        _packetType;
    double              _recipientid;
    double              _senderid;
    ChatKeyBoardSelectedType    _keyboardSelectedType;
    CGRect              _keyboardFrame;
    
    BOOL                _isLoading;
    BOOL                _hasMore;
    NSInteger           _offset;
    NSFetchedResultsChangeType  _fetchedResultsChangeType;
    
    UILabel *_titleLabel;
    UILabel *_statusLabel;
    UILabel *_miscLabel;
    
    UIButton *_buttonPlayPause;
    UIButton *_buttonNext;
    UIButton *_buttonStop;
    
    UISlider *_progressSlider;
    
    UILabel *_volumeLabel;
    UISlider *_volumeSlider;
    
    NSUInteger _currentTrackIndex;
    NSTimer *_timer;
    DOUAudioStreamer *_streamer;
    BOOL   isAbleContinuousPlay;
    NSInteger page;
    NSString *voiceStatus;
    NSTimer  *_waiterTimer;
}
@property (nonatomic, strong) UITableView                   * tableView;
@property (nonatomic, strong) NIMPublicBottomView *publicBottomView;

@property (nonatomic, strong) NSFetchedResultsController    * fetchedResultsController;
@property (nonatomic, strong) NIMRChatKeyboardView           * keyboardView;

@property (nonatomic, assign) CGFloat                         customKeyBoardHeight;
@property (nonatomic, strong) UIActivityIndicatorView       * indicatorView;
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (nonatomic, strong) NSMutableArray                * audioDatasource;
@property (nonatomic, readwrite, strong) ChatEntity      * currentRecordEntity;
@property (nonatomic) BOOL      preRecordEntityForSound;

@property (nonatomic, strong) NSMutableDictionary           * heightDatasource;
//@property (nonatomic, strong) NSMutableArray                * datasource;
@property (nonatomic, strong) NIMBottomView                  * bottomView;
@property (nonatomic, strong) NIMPlaySound                   * playSound;
@property (nonatomic) NSInteger                               playIndex;
@property (nonatomic) BOOL                                  proximityState;
@property (nonatomic) BOOL                                  isEarPhone;//是否听筒
@property (nonatomic, strong) UITapGestureRecognizer        * singleFingerOne;
//@property (nonatomic ,strong) NIMPublicInfoModel *publicModel;
@property (nonatomic, strong) UIImageView       *receImageView;
@property (strong, nonatomic) UIImagePickerController *pickerViewController;

//只有来自折叠群的群聊消息才更新首页的列表显示
@property (nonatomic ,assign) BOOL                          isUpdateGroupAssistant;
/** 商家id*/
@property (nonatomic, assign) int64_t bid;
/** 小二id*/
@property (nonatomic, assign) int64_t wid;

/*判断是否为个人商家*/
@property (nonatomic, assign) NIMChatUIType  chatUIType;

@property (nonatomic, assign) BOOL  keyboardIsShow;
@property (nonatomic, assign) BOOL  statusBarIsChange;
@property (nonatomic, assign) BOOL  isDisappear;

@property (nonatomic, strong) ChatListEntity      *chatList;

@property (nonatomic, strong) NIMSoundTipView      *soundTipView;
@property (nonatomic, strong) NIMLLCameraViewController      *camera;
@property (nonatomic, strong) NIMChatCountView      *chatCountView;
@property (nonatomic, strong) NSMutableArray      *ucountHeightArr;
@property (nonatomic, strong) NSMutableArray      *ucountMsgidArr;

@property (nonatomic, assign) CGFloat             iphoneXadd;
@property (nonatomic, strong) NSMutableArray      *messageArr;
@property (nonatomic, strong) ZHSmallVideoController *videoController;
//@property (nonatomic, strong) QBaoJSBridge *jsBridge;
@end

@implementation NIMChatUIViewController

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    return YES;
}

- (void)dealloc{
    [self removeObserver];
    self.keyboardView.delegate = self;
    self.keyboardView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    _currentRecordEntity = nil;
    _audioDatasource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NIMSysManager sharedInstance] setCurrentMbd:nil];
}

-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView{
    [super loadView];
    
}
- (void)handleInterruption:(NSNotification*)noti
{
    //    AVAudioSession *session=noti.object;
    //    NSDictionary *userinfo=noti.userInfo;
    
}
- (void)viewDidLoad {
    _iphoneXadd = IPX_BOTTOM_SAFE_H;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [super viewDidLoad];
    [[NIMSysManager sharedInstance] setCurrentMbd:self.thread];
    self.isUpdateGroupAssistant = NO;

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    _heightDatasource = @{}.mutableCopy;
    _ucountHeightArr = @[].mutableCopy;
    _ucountMsgidArr = @[].mutableCopy;
    _chatVCFlag.scrollToBottomAnimated = NO;
    _messageArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self tableViewRegisterClass];
    
    //刷新控件
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activity.frame = CGRectMake((headerView.frame.size.width - 20)/2, 0, 20, 20);;
    [headerView addSubview:self.activity];
    self.tableView.tableHeaderView = headerView;
    headerView.hidden = YES;
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
//    self.tableView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(scrollTableView)];
    _singleFingerOne.numberOfTouchesRequired = 1; //手指数
    _singleFingerOne.numberOfTapsRequired = 1; //tap次数
    _keyboardIsShow = NO;
    _statusBarIsChange = NO;
    _isBottom = YES;
  
    if (self.chatUIType == NIMChatUIType_NORMAL){//普通聊天
        [self.keyboardView.textView.internalTextView.keyboardInputView.chatMediaPad resetUIWithChatUIType:NIMChatUIType_NORMAL];
    }else if (self.chatUIType == NIMChatUIType_BUSINESS){//个人商家
        [self.keyboardView.textView.internalTextView.keyboardInputView.chatMediaPad resetUIWithChatUIType:NIMChatUIType_BUSINESS];
        [self showContactBusiness];
    }else if (self.chatUIType == NIMChatUIType_OFFCIAL){//企业商家，公众号
        [self.keyboardView.textView.internalTextView.keyboardInputView.chatMediaPad resetUIWithChatUIType:NIMChatUIType_OFFCIAL];
        [self showContactBusiness];
    }
    [self qb_setLeftButtonTitle:@"返回"];
    
    [self.labTitle addSubview:self.receImageView];
    



    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RecordBeginning) name:@"RecordBeginning" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(thisFuncCopyDesingFromWeChat:) name:kStopPlaySound object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReflashTableView) name:@"UPDATETABLE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvKicketGroup:) name:NC_KICKET_GROUP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvFreeWaiter:) name:NC_GET_FREE_WAITER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadImageStatus:) name:NC_CHAT_IMAGE_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUcount:) name:NC_SDK_UCOUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:NC_MESSAGE_OP_UI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selfUpdateUI:) name:NC_SELF_MESSAGE_OP_UI object:nil];
    
    //红包通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvRedbagSendNC:) name:NC_SSIM_SENDREDBAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvRedbagOpenNC:) name:NC_SSIM_OPENREDBAGE object:nil];

    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name: UIApplicationWillEnterForegroundNotification object:nil];

    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (statusBarDidChange) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
        

}

-(void)statusBarDidChange
{
    _statusBarIsChange = YES;
    if (!_keyboardIsShow) {
        self.keyboardView.frame = CGRectMake(0,
                                             CGRectGetHeight(self.view.bounds) - kHeightBoardHeader- _iphoneXadd,
                                             CGRectGetWidth(self.view.bounds),
                                             kHeightBoardHeader);
    }else{
        
        CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
        int shouldBeSubtractionHeight = 0;
        if (statusBarRect.size.height == 40) {
            shouldBeSubtractionHeight = 20;
        }else{
            shouldBeSubtractionHeight = -20;
        }
        CGRect boardFrame = self.keyboardView.frame;

        self.keyboardView.frame = CGRectMake(CGRectGetMinX(boardFrame),
                                             CGRectGetMinY(boardFrame)-shouldBeSubtractionHeight,
                                             CGRectGetWidth(boardFrame),
                                             CGRectGetHeight(boardFrame));
    }
}

-(void)setupVoiceMode
{
    self.receImageView.hidden = YES;
    
    _isEarPhone = [getObjectFromUserDefault(KEY_Earphone) boolValue];
    voiceStatus = [[AVAudioSession sharedInstance] category];
    NSError *error;
    if (_isEarPhone) {
        if (![voiceStatus isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
            [self.playSound setMode];
            if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
                DLog(@"%@",[error debugDescription]);
            }else{
                self.receImageView.hidden = NO;
                _proximityState = YES;
            }
            //            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
        self.receImageView.hidden = NO;
        [self.playSound setMode];

        
    }else{
        if (![voiceStatus isEqualToString:AVAudioSessionCategoryPlayback]) {
            //            [self.playSound setMode];
            if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
                DLog(@"%@",[error debugDescription]);
            }else{
                self.receImageView.hidden = YES;
                _proximityState = NO;
            }
        }
        
    }
}

-(void)ReflashTableView{
    [self.tableView reloadData];
}

-(void)initPublicMenu
{
    self.bottomView.hidden = YES;
    
}


- (void)thisFuncCopyDesingFromWeChat:(NSNotification*)noti
{
    ChatEntity* record = _currentRecordEntity;
    record.audioFile.state = QIMMessageStatuStopped;
    [self.playSound stopPlay];
    [self updatePlayState];
    
    [self changeProximityMonitorEnableState:NO];
    
}

-(void)RecordBeginning
{
    ChatEntity* record = _currentRecordEntity;
    record.audioFile.state = QIMMessageStatuStopped;
    [self.playSound stopPlay];
    [self updatePlayState];
}

-(void)recvKicketGroup:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        id object = noti.object;
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                self.rightButton.hidden = YES;
                self.rightButton.enabled = NO;
            }
            
        }
    });

}

-(void)recvFreeWaiter:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    id object = notification.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            NSDictionary *dict = object;
            int64_t bid = [[dict objectForKey:@"bid"] longLongValue];
            int64_t wid = [[dict objectForKey:@"wid"] longLongValue];
            int32_t sid = [[dict objectForKey:@"sid"] intValue];
            self.bid = bid;
            self.wid = wid;
            NSDictionary *tdict = self.messageArr.lastObject;
            ChatEntity *chat = tdict.allValues.firstObject;
            int32_t preSid = 0;
            int64_t preWid = 0;

            if (chat) {
                preSid = chat.sid;
            }

            if (sid != preSid) {
                [[NIMSysManager sharedInstance].sidDict setObject:@(sid) forKey:@(bid)];
            }
            NSString *key = [NSString stringWithFormat:@"%lld_wid",bid];
            preWid = [[[NIMSysManager sharedInstance].sidDict objectForKey:key] longLongValue];

            if (preWid != wid) {
                [[NIMSysManager sharedInstance].sidDict setObject:@(wid) forKey:key];
                if (bid == wid) {
                    NSString *desc = nil;
                    NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:self.bid];
                    if (business) {
                        desc = business.name;
                    }else{
                        desc = [NSString stringWithFormat:@"商家_%lld",self.bid];
                        
                    }
                    [NIMStringComponents createProductTipsWithMbd:self.thread stype:TIP content:[NSString stringWithFormat:@"商家\"%@\"为您服务",desc]];
                }else{
                    NSString *desc = nil;
                    NWaiterEntity *waiterEntity = [NWaiterEntity findFirstWithBid:bid wid:wid];
                    if (waiterEntity) {
                        desc = waiterEntity.name;
                    }else{
                        desc = [NSString stringWithFormat:@"小二_%lld",self.bid];
                    }
                    
                    [NIMStringComponents createProductTipsWithMbd:self.thread stype:TIP content:[NSString stringWithFormat:@"小二\"%@\"为您服务",desc]];
                }
            }
            
            _actualThread = [NSString stringWithFormat:@"%@:%lld",self.thread,wid];
        }
        
    }
}

//- (void)leftButtonAction{
//    FinanceSummaryViewController *vc= _ALLOC_VC_CLASS_([FinanceSummaryViewController class]);
//    [self nim_pushToVC:vc animal:YES];
//}
//
//- (void)rightButtonAction{
//    NSMutableDictionary *dic =[NSMutableDictionary new];
//    [dic setObject:@"0" forKey:@"1"];
//
//    FinanceListViewController *listView = [[FinanceListViewController alloc] initWithType:FinanceListViewTypePerson andContentType:dic];
//    [self nim_pushToVC:listView animal:YES];
//}

- (void)qb_rightButtonAction{
    self.rightButton.enabled = NO;
    [self itemBtnClick:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	 [self setupVoiceMode];
   
    [super viewWillAppear:animated];

    [self refresh];
    self.navigationController.navigationBarHidden = NO;
    self.rightButton.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    [self.indicatorView startAnimating];
    //    [self scrollTableToFoot];//CLIENT-2934返回不会默认滚动到最下方
    [self updateTitle];
    [self viewWillAppearPlayer:NO];

    //清除所有未读红点
    [[NIMOperationBox sharedInstance] resetRecordListThread:self.thread isHomePageShow:NO];
    [self updateUcount:nil];
//    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (_statusBarIsChange) {
        [self statusBarDidChange];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _statusBarIsChange = NO;
    _isDisappear = YES;
    [[GroupManager sharedInstance] Clear];
    [[NIMOperationBox sharedInstance] resetRecordListThread:self.thread isHomePageShow:NO];
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self viewWillDisappearPlayer:NO];// audioPlay stop
    if (_currentRecordEntity) {
        _currentRecordEntity.audioFile.state = QIMMessageStatuStopped;
        [self updatePlayState];
        [[NIMOperationBox sharedInstance] flagReadRecordEntityMsgID:_currentRecordEntity.messageId];
    }
    /*
     if (_packetType == PUBLIC) {
     NRecordList *publicRecordList = [NRecordList getRecordListByThread:kPublicPacketThread];
     NRecordList *currentRecordList = [NRecordList getRecordListByThread:self.thread];
     if ([publicRecordList.actualThread isEqualToString:self.thread]) {
     if (publicRecordList.timestamp == currentRecordList.timestamp) {
     NSManagedObjectContext *privateContext = [NSManagedObjectContext MR_defaultContext];
     [privateContext performBlock:^{
     //TODO:save
     NRecordList *recordListEntity1 = [NRecordList getRecordListByThread:kPublicPacketThread];
     recordListEntity1.showRedPublic = NO;
     [[recordListEntity1 managedObjectContext] MR_saveOnlySelfAndWait];
     
     }];
     
     }
     }
     }
     */
    [self.playSound stopPlay];
    if (_isEarPhone) {
        NSError *error;
        
        if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
            DLog(@"%@",[error debugDescription]);
        }else{
            
        }
    }
}

//监测状态
-(void)applicationEnterBackground
{
    [self viewWillDisappearPlayer:NO];// audioPlay stop
    if (_currentRecordEntity) {
        _currentRecordEntity.audioFile.state = QIMMessageStatuStopped;
        [self updatePlayState];
        [[NIMOperationBox sharedInstance] flagReadRecordEntityMsgID:_currentRecordEntity.messageId];
    }
    [self.playSound stopPlay];
}

-(void)applicationEnterForeground
{
    [self viewWillAppearPlayer:NO];
    //清除当前未读数
    [[NIMOperationBox sharedInstance] resetRecordListThread:self.thread isHomePageShow:NO];
}

#pragma mark actions
- (void)qb_back
{
    [_waiterTimer invalidate];
    _waiterTimer = nil;
    [self.keyboardView.textView resignFirstResponder];
    
    _fetchedResultsController.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    BOOL isPop = NO;
    for (id obj in self.navigationController.viewControllers) {
        if ([obj isKindOfClass:[NIMGroupCreateVC class]]||
            [obj isKindOfClass:[NIMGroupVcardVC class]] ||
            [obj isKindOfClass:[NIMFriendNoticeDetailViewController class]] ||
            [obj isKindOfClass:[NIMPChatTableViewController class]]) {
            isPop = NO;
            break;
        }
        else
        {
            isPop = YES;
        }
    }
    if (self.backReadClean) {
        self.backReadClean();
    }
    if (isPop)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        BOOL isThread = NO;

        for (UIViewController *obj in self.navigationController.viewControllers) {
            if ([obj isKindOfClass:[SSIMThreadViewController class]]) {
                isThread = YES;
                [self.navigationController popToViewController:obj animated:YES];
                break;
            }
        }
        if (isThread) {
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
#pragma mark layout
- (void)updateViewConstraints{
    [super updateViewConstraints];
    [self makeConstraints];
}
- (void)makeConstraints{
    CGFloat heightKeyboard = kHeightBoardHeader;
//    if (_packetType == GROUP || _packetType == PRIVATE ||_recipientid == 10000 || _packetType == PUBLIC)
//    {
//        heightKeyboard = kHeightBoardHeader;
//    }
    CGFloat fgap = 0;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(fgap);
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-heightKeyboard - _iphoneXadd);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
    
//    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_bottom);
//        make.leading.equalTo(self.tableView.mas_leading);
////        make.width.equalTo(SCREEN_WIDTH);
//        make.trailing.equalTo(self.tableView.mas_trailing);
//        make.bottom.equalTo(@(0));
//    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo([NSNumber numberWithFloat:heightKeyboard  + _iphoneXadd]);
    }];
    
    [self.chatCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kHeightBoardHeader-10 - _iphoneXadd);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - 滑到最底部
- (void)scrollTableToFoot
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
}


#pragma mark fetch
- (NSInteger)getFethedResultsCount
{
    NSArray *arr = [ChatEntity NIM_findAllWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",self.thread]];
    NSInteger numberOfRows = arr.count;
    return numberOfRows;
}
#pragma mark actions
- (IBAction)itemBtnClick:(id)sender{
    if (_packetType == GROUP) {
        [self showGroupDetailController];
    }else  if (_packetType == PUBLIC) {//说明是公众号
        
    }else  if (_packetType == PRIVATE) {
        [self showProfileControllerWithUserid:_recipientid];
    }else if(_packetType == SHOP_BUSINESS || _packetType == CERTIFY_BUSINESS){//说明是企业商家
        NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:self.bid];
        NSString *url = @"";
        if (business.url) {
            url = business.url;
        }else{
            url = _IM_FormatStr(@"https://enterprise.qbao.com/merchant/shop/qry/toWapShopHome.html?interceptType=1&shopUserId=%lld",self.bid);
        }
        NSDictionary *tmpDict = @{@"url":url?:@"",
                                  @"push_type":@(SDK_PUSH_Item)};
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:tmpDict];
    }
}

- (void)showProfileControllerWithUserid:(int64_t)userid{
    NIMPChatTableViewController* chatSetting = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"NIMPChatTableViewController"];
    chatSetting.userid = userid;
    chatSetting.acMsgBodyID = self.actualThread;
    chatSetting.msgBodyID = self.thread;
    chatSetting.delegate = self;
    [self.navigationController pushViewController:chatSetting animated:YES];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.rightButton.enabled = YES;
}

//- (void)showPublicDetailWithPublicEntity:(PublicEntity *)publicEntity{
//
//}

- (void)showFeedProfileWithUserid:(int64_t)userid animated:(BOOL)animated{
    if (userid > 0) {
        
        NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];
        feedProfileVC.userid = userid;
        feedProfileVC.feedSourceType =ChatSource;
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:animated];
    }
}

- (void)showGroupDetailController{
    GroupList* group = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId=%@",self.thread]];
    if (group) {
        NIMChatGroupSettingVC* groupSetting = (NIMChatGroupSettingVC*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMChatGroupSettingIdentity"];
        
        groupSetting.groupList = group;
        groupSetting.delegate = self;
        [self.navigationController pushViewController:groupSetting animated:YES];
    }
}

//添加一个senderId参数，用于修改推文收藏传的userid不对的问题



- (void)showLatestVcardViewControllerWithRecordEntity:(ChatEntity *)recordEntity animated:(BOOL)animated{
    UINavigationController *latestVcardNavigation = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"latestVcardNavigation"];
    if ([latestVcardNavigation.topViewController isKindOfClass:[NIMLatestVcardViewController class]]) {
        NIMLatestVcardViewController *latestVVC = (NIMLatestVcardViewController *)latestVcardNavigation.topViewController;
        latestVVC.objectForward = recordEntity;
        latestVVC.delegate = self;
    }
    [self.navigationController presentViewController:latestVcardNavigation animated:YES completion:^{
        [self.keyboardView resetDefault];
    }];
}

#pragma mark private
- (void)sendMessage:(id)message packetContentType:(E_MSG_M_TYPE)mType subType:(E_MSG_S_TYPE)subType{
    
    E_MSG_E_TYPE cardType = DEFAULT;
    if (self.bid) {
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:message mType:mType sType:subType eType:cardType messageBodyId:(NSString *)self.actualThread msgid:[NIMStringComponents createMessageid:_packetType]];
    }else{
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:message mType:mType sType:subType eType:cardType messageBodyId:(NSString *)self.thread msgid:[NIMStringComponents createMessageid:_packetType]];
    }
}
#pragma mark - 发送红包
- (void)sendPlainText:(NSString *)text{
    [self sendMessage:text packetContentType:TEXT subType:CHAT];
}
- (void)sendSmily:(NSString *)text{
    [self sendMessage:text packetContentType:SMILEY subType:CHAT];
}

- (void)sendImage:(NSDictionary *)imageDic msgid:(int64_t)msgid{
    
    if (self.bid) {
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:imageDic mType:IMAGE sType:CHAT eType:DEFAULT messageBodyId:(NSString *)self.actualThread msgid:msgid];
    }else{
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:imageDic mType:IMAGE sType:CHAT eType:DEFAULT messageBodyId:(NSString *)self.thread msgid:msgid];
    }
}

-(void)sendHtml:(NSDictionary*)dic
{
    
}


- (void)sendVCard:(int64_t)cardid{
    [self sendMessage:[NSNumber numberWithLongLong:cardid] packetContentType:JSON subType:VCARD];
}

- (void)sendLocation:(NSDictionary *)location{
    
    
    [self sendMessage:location packetContentType:MAP subType:CHAT];
}

- (void)sendVoice:(NSString *)filePath{
    [self sendMessage:filePath packetContentType:VOICE subType:CHAT];
}

- (void)sendVideo:(NSDictionary *)videoDic msgid:(int64_t)msgid{
    
    if (self.bid) {
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:videoDic mType:VIDEO sType:CHAT eType:DEFAULT messageBodyId:(NSString *)self.actualThread msgid:msgid];
    }else{
        [[NIMMessageCenter sharedInstance] sendMessageWithObject:videoDic mType:VIDEO sType:CHAT eType:DEFAULT messageBodyId:(NSString *)self.thread msgid:msgid];
    }
}


#pragma mark private method
- (NSNumber*)getRecordTotalCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"thread = %@",self.thread];
    NSInteger number = [ChatEntity NIM_countOfEntitiesWithPredicate:predicate];
    NSNumber* numTotal = [NSNumber numberWithInteger:number];
    return numTotal;
    return 0;
}

-(void)updateGroupAssistant:(NSString *)mbd
{
    E_MSG_CHAT_TYPE chatType = [NIMStringComponents chatTypeWithMsgBodyId:mbd];
    
    if (chatType == GROUP) {
        int64_t groupid = [NIMStringComponents getOpuseridWithMsgBodyId:mbd];
        GroupList *groupList = [GroupList instancetypeFindGroupId:groupid];
        if (groupList.switchnotify == GROUP_MESSAGE_IN_HELP_NO_HIT&&
            ![NIMSysManager sharedInstance].isInAssistant) {
            
            
            //把所有大于0的更新为0
            NSPredicate *pflag = [NSPredicate predicateWithFormat:@"groupAssistantRead > 0 and userId == %lld",OWNERID];
            
            NSArray *glist = [ChatListEntity NIM_findAllWithPredicate:pflag];
            
            if (glist.count==0) {
                return;
            }
            
            //查询已设置为收到群助手的所有群
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"switchnotify == %d and memberid=%lld",GROUP_MESSAGE_IN_HELP_NO_HIT,OWNERID];
            NSArray *list = [GroupList NIM_findAllWithPredicate:pre];
            
            NSMutableArray *source = [NSMutableArray array];
            for (GroupList *item in list)
            {
                [source addObject:item.messageBodyId];
            }
            
            //更新群助手为最后一条非通知类或通知类的消息内容（注意，通知是不管所在的群是否设置了提醒）
            NSPredicate *msg = [NSPredicate predicateWithFormat:@"chatType == 2 AND messageBodyId in %@",source,(long)OWNERID];
            
            NSArray *infos = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:msg];
            if (infos.count > 0)
            {
                NSMutableString *pre = [[NSMutableString alloc] init];
                ChatEntity *itemrecord = infos[0];
                GroupList *group = [GroupList instancetypeFindGroupId:itemrecord.groupId];
                NSString *s = [[NIMOperationBox sharedInstance]getPreviewForGroupAssistantBy:itemrecord];
                
                BOOL isMe = itemrecord.opUserId == OWNERID;
                if (!isMe) {
                    NSString *name = group.name;
                    if (name.length>12) {
                        name = [NSString stringWithFormat:@"%@...：",[name substringToIndex:12]];
                    }
                    [pre appendString:name];
                }
                [pre appendString:s];
                [[NIMOperationBox sharedInstance]updateGroupAssistant:pre];
            }
        }
    }
}

- (void)otherUidWithThread:(NSString *)thread{
    NSArray *nums = [thread componentsSeparatedByString:@":"];
    
    _packetType = [NIMStringComponents chatTypeWithMsgBodyId:thread];
    
    if(nums.count == ChatWithFriendOrGroup){//普通好友聊天,群聊
        self.chatUIType = NIMChatUIType_NORMAL;
        
        if (_packetType == GROUP) {
            _recipientid = [[nums objectAtIndex:1] doubleValue];
        }else if(_packetType == PRIVATE||_packetType == PUBLIC){
            double mid = [[nums objectAtIndex:1] doubleValue];
            double lastid = [[nums objectAtIndex:2] doubleValue];
            if (mid != OWNERID) {
                _senderid = lastid;
                _recipientid = mid;
            }else{
                _recipientid = lastid;
                _senderid = mid;
            }
            
            if (_packetType == PUBLIC) {
                self.chatUIType = NIMChatUIType_OFFCIAL;
            }
            
        }
    }
    else if( nums.count == ChatWithBusiness )//商家
    {
        if (_packetType == SHOP_BUSINESS) {
            self.chatUIType = NIMChatUIType_BUSINESS;
        }else{
            self.chatUIType = NIMChatUIType_OFFCIAL;
        }

        int64_t bid = [[nums objectAtIndex:2] longLongValue];
        int64_t wid = [[nums objectAtIndex:3] longLongValue];
        self.bid = bid;
        self.wid = wid;

    }
}

-(void)showContactBusiness
{
    NSDictionary *messageDic = [[NIMBusinessOperationBox sharedInstance] getJsonInfoByBusinessModel:self.content];
    if (self.isGoods) {
        [NIMStringComponents deleteProductTipsWithMbd:self.thread stype:PRODUCT_TIP];
        [NIMStringComponents createProductTipsWithMbd:self.thread stype:PRODUCT_TIP content:messageDic];
    }
    if (self.isOrder) {
        [NIMStringComponents deleteProductTipsWithMbd:self.thread stype:ORDER_TIP];
        [NIMStringComponents createProductTipsWithMbd:self.thread stype:ORDER_TIP content:messageDic];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSArray *arr = getObjectFromUserDefault(KEY_Wid_List(self.bid));
    if (arr.count>0) {
        [self getFreeWaiter];
        if (_waiterTimer) {
            [_waiterTimer invalidate];
            _waiterTimer = nil;
        }
        _waiterTimer = [NSTimer scheduledTimerWithTimeInterval:kWAITER_TIME target:self selector:@selector(getFreeWaiter) userInfo:nil repeats:YES];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}


-(void)getFreeWaiter
{
    NSArray *arr = getObjectFromUserDefault(KEY_Wid_List(self.bid));
    
    [[NIMBusinessOperationBox sharedInstance] getFreeWaiter:self.bid wid_list:arr];
}

-(UIImage *)compraseImage:(UIImage *)largeImage
{
    double compressionRatio = 1;
    int resizeAttempts = 5;
    UIImage *savedImage = nil;
    NSData * imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    while ([imgData length] > 400000 && resizeAttempts > 0) {
        resizeAttempts -= 1;
        compressionRatio = compressionRatio*0.5;
        imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    }
    savedImage = [UIImage imageWithData:imgData];
    return savedImage;
}
- (void)scrollTableView
{
    [self.keyboardView resetDefault];
}

- (void)scrollTableViewByContentOffSetAnimated
{
    CGFloat y = self.tableView.contentSize.height - CGRectGetMinY(self.keyboardView.frame) + 0;
    if(y < 0)
    {
        y = 0;
    }
    if([UIDevice currentDevice].systemVersion.doubleValue<8.0){
        y+=0;
    }
    [self.tableView setContentOffset:CGPointMake(0, y) animated:NO];
    [_ucountHeightArr removeAllObjects];
    [_ucountMsgidArr removeAllObjects];
    _chatCountView.UCount = self.ucountHeightArr.count;
}

- (void)scrollTableViewBottom{
    NSInteger lastCount = self.messageArr.count;
    if (lastCount > 1)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastCount - 1 inSection:0];
        NSUInteger rowCount=[self.tableView  numberOfRowsInSection:0];
        
        if (rowCount == self.messageArr.count) {
            if(_chatVCFlag.scrollToBottomAnimated && _isBottom)
            {
                
            }
            else
            {
                _chatVCFlag.scrollToBottomAnimated = YES;
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                [self performSelector:@selector(resetScrollToBottomAnimated) withObject:0 afterDelay:0.2];
            }
        }
        else
        {
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
            if(_chatVCFlag.scrollToBottomAnimated)
            {
                
            }
            else
            {
                _chatVCFlag.scrollToBottomAnimated = YES;
                [self.tableView scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionNone animated:YES];

                [self performSelector:@selector(resetScrollToBottomAnimated) withObject:0 afterDelay:0.2];
            }
        }
    }
}

- (void)resetScrollToBottomAnimated
{
    _chatVCFlag.scrollToBottomAnimated = NO;
}

- (void)defaultKeyboardView{
    //    NSTimeInterval animationDuration;
    
    CGRect boardFrame = self.keyboardView.frame;
    CGFloat heightBoardHeader = CGRectGetHeight(boardFrame);
    
    if ((_keyboardSelectedType == ChatKeyBoardSelectedTypeNone) || (_keyboardSelectedType == ChatKeyBoardSelectedTypeVoice)) {
        self.keyboardView.frame = CGRectMake(0,
                                             CGRectGetHeight(self.view.bounds) - heightBoardHeader - _iphoneXadd,
                                             CGRectGetWidth(boardFrame),
                                             heightBoardHeader);
    }else{
        self.keyboardView.frame = CGRectMake(CGRectGetMinX(boardFrame),
                                             CGRectGetHeight(self.view.bounds) - heightBoardHeader - _iphoneXadd,
                                             CGRectGetWidth(boardFrame),
                                             heightBoardHeader);
    }
    
    [self scrollTableViewByContentOffSetAnimated];
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, CGRectGetHeight(boardFrame) - kHeightBoardHeader, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)faceKeyboardView{
    //    NSTimeInterval animationDuration;
    
    CGRect boardFrame = self.keyboardView.frame;
    CGFloat heightBoardHeader = CGRectGetHeight(boardFrame);
    
    if ((_keyboardSelectedType == ChatKeyBoardSelectedTypeNone) || (_keyboardSelectedType == ChatKeyBoardSelectedTypeVoice)) {
        self.keyboardView.frame = CGRectMake(0,
                                             CGRectGetHeight(self.view.bounds) - heightBoardHeader,
                                             CGRectGetWidth(boardFrame),
                                             CGRectGetHeight(boardFrame));
    }else{
        self.keyboardView.frame = CGRectMake(CGRectGetMinX(boardFrame),
                                             CGRectGetHeight(self.view.bounds) - heightBoardHeader,
                                             CGRectGetWidth(boardFrame),
                                             CGRectGetHeight(boardFrame));
    }
    
    CGFloat offsetY = 0;
    CGFloat valueOffset = self.tableView.contentOffset.y - kHeightContainer;
    if (valueOffset >= 0) {
        offsetY = valueOffset;
    }
    //    [UIView animateWithDuration:0
    //                     animations:^{
    //                     }
    //                     completion:^(BOOL finished) {
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, heightBoardHeader - kHeightBoardHeader, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //                     }
    //     ];
}

- (void)autoLoadMoreData:(UIScrollView*)scrollView
{
    if(scrollView.contentOffset.y<50 &&  _hasMore && !_isLoading)
    {
        _isLoading = YES;
        self.tableView.tableHeaderView.hidden = NO;
        [self.activity startAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self moreData];
            [self.activity stopAnimating];
            self.tableView.tableHeaderView.hidden = YES;
        });
        
        
    }
}

- (void)moreData{
    NSInteger numberOfRows = 0;
    if (self.messageArr.count > 0){
        numberOfRows = self.messageArr.count;
    }
    _offset = numberOfRows;
    [self loadData];
}
- (void)refresh{
    
    _offset = 0;
    [_heightDatasource removeAllObjects];
    if (_isBottom) {
        [self loadData];
        [self scrollTableToFoot];
    }
}

/*
 fetch逻辑
 首先获取record的所有个数，然后按照时间正序排列（和在tableview里面从index为0开始展示的效果一致），取值的时候从最后面取20个，以依次往上取
 */
- (void)loadData{
    
    CGSize size = self.tableView.contentSize;
    NSInteger lastCount = self.messageArr.count;
//    if (lastCount%kMaxListItems == 0) {
//        _hasMore = YES;
//    }else{
//        _hasMore = NO;
//    }
    if (_offset==0) {
        _hasMore = YES;
        [self.tableView reloadData];
        return;
    }
    NSInteger len = kMaxListItems;
    if (lastCount%kMaxListItems > 0 && lastCount%kMaxListItems < len) {
        len = lastCount%kMaxListItems;
    }
    
    NSArray *arr = [[NIMMessageManager sharedInstance] getMessageWithSessionid:self.actualThread Offset:_offset limit:len];
    if (arr.count>0) {
        _hasMore = YES;
        [[NIMMessageManager sharedInstance] insertMessageList:arr messageBodyId:self.actualThread];
    }else{
        _hasMore = NO;
        [self.tableView reloadData];
        return;
    }
    
    if(self.messageArr.count>kMaxListItems){
        CGFloat f = 0;
        if([UIDevice currentDevice].systemVersion.doubleValue>=8.0)
        {
            f = 64;
        }
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentSize.height-size.height-f);
    }
    _isLoading = NO;
    
    [self.tableView reloadData];
    
    NSInteger row = 0;
    NSInteger conut = arr.count;
    if (_offset>=0&&_offset<kMaxListItems) {
        row = _offset%kMaxListItems;
        
    }else if (_offset>0 && _offset%kMaxListItems==0 &&conut%kMaxListItems==0) {
        row = conut-1;
    }else if (_offset-conut>kMaxListItems) {
        row = 0;
    }
    
    if (conut>=kMaxListItems) {
        if (IsStrEmpty([[NIMSysManager sharedInstance]currentMbd]) || row==0) {
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
#pragma mark config
- (void)tableViewRegisterClass
{
    [self.tableView registerClass:[NIMRLeftTextCell class] forCellReuseIdentifier:kLeftTextIdentifier];
    [self.tableView registerClass:[NIMRRightTextCell class] forCellReuseIdentifier:kRightTextIdentifier];
    
    [self.tableView registerClass:[NIMRLeftImageCell class] forCellReuseIdentifier:kLeftImageIdentifier];
    [self.tableView registerClass:[NIMRRightImageCell class] forCellReuseIdentifier:kRightImageIdentifier];
    [self.tableView registerClass:[NIMRLeftVoiceCell class] forCellReuseIdentifier:kLeftVoiceIdentifier];
    [self.tableView registerClass:[NIMRRightVoiceCell class] forCellReuseIdentifier:kRightVoiceIdentifier];
    
    [self.tableView registerClass:[NIMRLeftSmileyCell class] forCellReuseIdentifier:kLeftSmileyIdentifier];
    [self.tableView registerClass:[NIMRRightSmileyCell class] forCellReuseIdentifier:kRightSmileyIdentifier];
    
    [self.tableView registerClass:[NIMRLeftMapCell class] forCellReuseIdentifier:kLeftMapIdentifier];
    [self.tableView registerClass:[NIMRRightMapCell class] forCellReuseIdentifier:kRightMapIdentifier];
    [self.tableView registerClass:[NIMRLeftLBCell class] forCellReuseIdentifier:kLeftShareLBIdentifier];
    [self.tableView registerClass:[NIMRRightLBCell class] forCellReuseIdentifier:kRightShareLBIdentifier];
    
    
    [self.tableView registerClass:[NIMRLeftCardCell class] forCellReuseIdentifier:kLeftCardIdentifier];
    [self.tableView registerClass:[NIMRRightCardCell class] forCellReuseIdentifier:kRightCardIdentifier];
    
    [self.tableView registerClass:[NIMRLeftHtmlCell class] forCellReuseIdentifier:kLeftHtmlIdentifier];
    [self.tableView registerClass:[NIMRRightHtmlCell class] forCellReuseIdentifier:kRightHtmlIdentifier];
    
    [self.tableView registerClass:[NIMRLeftShareCell class] forCellReuseIdentifier:kLeftShareIdentifier];
    [self.tableView registerClass:[NIMRRightShareCell class] forCellReuseIdentifier:kRightShareIdentifier];
    
    [self.tableView registerClass:[NIMRLeftTaskCell class] forCellReuseIdentifier:kLeftTaskIdentifier];
    [self.tableView registerClass:[NIMRRightTaskCell class] forCellReuseIdentifier:kRightTaskIdentifier];
    
    [self.tableView registerClass:[NIMRSinglePicTextCell class] forCellReuseIdentifier:kSinglePicIdentifier];
    [self.tableView registerClass:[NIMRMutiPicTextCell class] forCellReuseIdentifier:kMutiPicTextIdentifier];
    
    [self.tableView registerClass:[NIMRTipTextCell class] forCellReuseIdentifier:kTipTextIdentifier];
    [self.tableView registerClass:[NIMRGroupTipTextCell class] forCellReuseIdentifier:kGroupTipTextIdentifier];
    [self.tableView registerClass:[NIMRGainCell class] forCellReuseIdentifier:kRGainCellIdentifier];
    
    [self.tableView registerClass:[NIMAddFriendAttributeCell class] forCellReuseIdentifier:kRNIMAddFriendAttributeCell];
    
    [self.tableView registerClass:[NIMRProductTipCell class] forCellReuseIdentifier:kProductTipIdentifier];
    [self.tableView registerClass:[NIMRBGProductTipCell class] forCellReuseIdentifier:kBGProductTipIdentifier];
    //    [self.tableView registerClass:[QBROrderTipCell class] forCellReuseIdentifier:kOrderTipIdentifier];
    
    [self.tableView registerClass:[NIMRLeftOrderCell class] forCellReuseIdentifier:kLeftOrderIdentifier];
    [self.tableView registerClass:[NIMRRightOrderCell class] forCellReuseIdentifier:kRightOrderIdentifier];
    
    [self.tableView registerClass:[NIMRLeftMerchandiseCell class] forCellReuseIdentifier:kLeftMerchandiseIdentifier];
    [self.tableView registerClass:[NIMRRightMerchandiseCell class] forCellReuseIdentifier:kRightMerchandiseIdentifier];
    
    [self.tableView registerClass:[NIMRLeftTransactionCell class] forCellReuseIdentifier:kTransactionIdentifier];
    
    //发红包(右边)
    [self.tableView registerClass:[NIMRightRedMoneyCell class] forCellReuseIdentifier:kRightRedmoneyIdentifier];
    //收红包(左边)
    [self.tableView registerClass:[NIMLeftRedMoneyCell class] forCellReuseIdentifier:kLeftRedmoneyIdentifier];
    
    [self.tableView registerClass:[NIMRLeftVideoCell class] forCellReuseIdentifier:kLeftVideoIdentifier];
    [self.tableView registerClass:[NIMRRightVideoCell class] forCellReuseIdentifier:kRightVideoIdentifier];
}

- (void)updateTitle
{
    UIImage *image = nil;
    NIM_INGROUP_STATUS status = NIM_INGROUP_STATUS_NORMAL;
    NSArray *nums = [self.actualThread componentsSeparatedByString:@":"];
    if (_packetType == PRIVATE)
    {
        NSArray*actualThreadArray=[self.thread componentsSeparatedByString:@":"];
        int64_t userid = [actualThreadArray.lastObject longLongValue];
        VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:userid];
        if (vcardEntity == nil) {
            
        }else{
            self.titleString = [NIMStringComponents finFristNameWithID:vcardEntity.userid];
            image =  IMGGET(@"icon_topbar_friend");
        }
        
    }
    else  if (_packetType == GROUP)
    {
        GroupList *groupEntity = [GroupList NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@",self.thread]];
        if (groupEntity == nil)
        {
            
        }
        else
        {
            status = groupEntity.type;
            self.isUpdateGroupAssistant =   (groupEntity.switchnotify == GROUP_MESSAGE_IN_HELP_NO_HIT);
            
//            if (groupEntity.name.length >6)
//            {
//                NSString *name = [groupEntity.name substringToIndex:6];
//                self.titleString = [NSString stringWithFormat:@"%@...",name];
//            }
//            else
//            {
                self.titleString = groupEntity.name;
//            }
            image = IMGGET(@"icon_topbar_group");
            
            [self qb_setTitleText:self.titleString];
            
        }
        
    }
    else if (_packetType == PUBLIC)
    {
        NOffcialEntity *offcialEntity = [NOffcialEntity findFirstWithMsgBodyId:self.thread];
        if (offcialEntity.offcialid == 1000) {
            self.titleString = @"系统消息";
        }else{
//            if (offcialEntity.name.length >6)
//            {
//                NSString *name = [offcialEntity.name substringToIndex:6];
//                self.titleString = [NSString stringWithFormat:@"%@...",name];
//            }
//            else
//            {
                self.titleString = offcialEntity.name;
//            }
        }

    }
    else
    {
        NBusinessEntity *business = [NBusinessEntity instancetypeFindBid:self.bid];
        if (business) {
            self.titleString = business.name;
        }else{
            self.titleString = [NSString stringWithFormat:@"商家_%lld",self.bid];
        }
        image = IMGGET(@"icon_topbar_shop");
    }

    if (self.titleString) {

        [self qb_setTitleText:self.titleString];
    }
    
    if (image)
    {
        [self.indicatorView stopAnimating];
        
        if (status == NIM_INGROUP_STATUS_BANNED) {
            self.rightButton.hidden = YES;
            self.rightButton.enabled = NO;
        }
        else
        {
            self.rightButton.enabled = YES;
            self.rightButton.hidden = NO;
            [self qb_showRightButton:@"" andBtnImg:image];
        }
    }
    else
    {
        [self.indicatorView stopAnimating];
    }
    
    
    CGFloat width = [self.labTitle.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil].size.width;
    
    CGFloat offset = width+10;

    [self.receImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.labTitle.mas_centerY);
        make.width.equalTo(@(19));
        make.height.equalTo(@(19));
        make.leading.equalTo(self.labTitle.mas_leading).with.offset(offset);
    }];
    
}
- (ChatEntity *)recordEntityAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numberOfRows = self.messageArr.count;
    if (indexPath.row >= numberOfRows || indexPath.row <0) {
        return nil;
    }
    NSDictionary *dict = self.messageArr[indexPath.row];
    ChatEntity * sChat = [dict allValues].firstObject;
    return sChat;
}

- (NIMRLeftTableViewCell *)tableView:(UITableView *)tableView  leftTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatEntity *recordEntity = [self recordEntityAtIndexPath:indexPath];
    
    E_MSG_M_TYPE contentType = recordEntity.mtype;
    E_MSG_S_TYPE contentSubType = recordEntity.stype;
    
    NIMRLeftTableViewCell *cell = nil;
    switch (contentType) {
        case TEXT:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftTextIdentifier forIndexPath:indexPath];
            break;
        case ITEM:
            //            cell = [tableView dequeueReusableCellWithIdentifier:kLeftHtmlIdentifier forIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftMerchandiseIdentifier forIndexPath:indexPath];
            
            break;
        case IMAGE:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftImageIdentifier forIndexPath:indexPath];
            break;
        case VOICE:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftVoiceIdentifier forIndexPath:indexPath];
            break;
        case SMILEY:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftSmileyIdentifier forIndexPath:indexPath];
            break;
        case MAP:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftMapIdentifier forIndexPath:indexPath];
            break;
        case VIDEO:
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftVideoIdentifier forIndexPath:indexPath];
            break;
        case JSON:
        {
            switch (contentSubType) {
                case TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kTipTextIdentifier forIndexPath:indexPath];
                    break;
                    
                case VCARD:
                    cell = [tableView dequeueReusableCellWithIdentifier:kLeftCardIdentifier forIndexPath:indexPath];
                    break;
                    
                case GROUP_ADD_AGREE:
                    //                    cell = [tableView dequeueReusableCellWithIdentifier:kLeftHtmlIdentifier forIndexPath:indexPath];
                    cell = [tableView dequeueReusableCellWithIdentifier:kRNIMAddFriendAttributeCell forIndexPath:indexPath];
                    break;
                    
                    
                    //                case ITEM:
                    //                    cell = [tableView dequeueReusableCellWithIdentifier:kLeftMerchandiseIdentifier forIndexPath:indexPath];
                    //                    break;
                    //
                case ORDER:
                    cell = [tableView dequeueReusableCellWithIdentifier:kLeftOrderIdentifier forIndexPath:indexPath];
                    break;
                    
                case RED_PACKET:
                    cell = [tableView dequeueReusableCellWithIdentifier:kLeftRedmoneyIdentifier forIndexPath:indexPath];
                    break;
                case PRODUCT_TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kBGProductTipIdentifier forIndexPath:indexPath];
                    break;
                case ORDER_TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kProductTipIdentifier forIndexPath:indexPath];
                    break;
                case ARTICLE:
                    cell = [tableView dequeueReusableCellWithIdentifier:kMutiPicTextIdentifier forIndexPath:indexPath];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    if (cell==nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dbIdentifier"];
    }
    
    return cell;
}

- (NIMRRightTableViewCell *)tableView:(UITableView *)tableView rightTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatEntity *recordEntity = [self recordEntityAtIndexPath:indexPath];
    E_MSG_M_TYPE contentType = recordEntity.mtype;
    E_MSG_S_TYPE contentSubType = recordEntity.stype;
    
    NIMRRightTableViewCell *cell = nil;
    switch (contentType) {
        case TEXT:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightTextIdentifier forIndexPath:indexPath];
            break;
        case ITEM:
            //            cell = [tableView dequeueReusableCellWithIdentifier:kRightHtmlIdentifier forIndexPath:indexPath];
            cell = [tableView dequeueReusableCellWithIdentifier:kRightMerchandiseIdentifier forIndexPath:indexPath];
            
            break;
        case IMAGE:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightImageIdentifier forIndexPath:indexPath];
            break;
        case VOICE:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightVoiceIdentifier forIndexPath:indexPath];
            break;
        case SMILEY:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightSmileyIdentifier forIndexPath:indexPath];
            break;
        case MAP:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightMapIdentifier forIndexPath:indexPath];
            break;
        case VIDEO:
            cell = [tableView dequeueReusableCellWithIdentifier:kRightVideoIdentifier forIndexPath:indexPath];
            break;
        case JSON:
        {
            switch (contentSubType) {
                case TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kTipTextIdentifier forIndexPath:indexPath];
                    break;
                case GROUP_NEED_AGREE:
                    cell = [tableView dequeueReusableCellWithIdentifier:kGroupTipTextIdentifier forIndexPath:indexPath];
                    break;
                case GROUP_ADD_AGREE:
                    //                    cell = [tableView dequeueReusableCellWithIdentifier:kGroupTipTextIdentifier forIndexPath:indexPath];
                    cell = [tableView dequeueReusableCellWithIdentifier:kRNIMAddFriendAttributeCell forIndexPath:indexPath];
                    
                    break;
                    
                case VCARD:
                    cell = [tableView dequeueReusableCellWithIdentifier:kRightCardIdentifier forIndexPath:indexPath];
                    break;
                    
                    //                case ITEM:
                    //                    cell = [tableView dequeueReusableCellWithIdentifier:kRightMerchandiseIdentifier forIndexPath:indexPath];
                    //                    break;
                case ORDER:
                    cell = [tableView dequeueReusableCellWithIdentifier:kRightOrderIdentifier forIndexPath:indexPath];
                    break;
                    
                case RED_PACKET:
                    cell = [tableView dequeueReusableCellWithIdentifier:kRightRedmoneyIdentifier forIndexPath:indexPath];
                    break;
                case PRODUCT_TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kBGProductTipIdentifier forIndexPath:indexPath];
                    break;
                case ORDER_TIP:
                    cell = [tableView dequeueReusableCellWithIdentifier:kProductTipIdentifier forIndexPath:indexPath];
                    break;
                case ARTICLE:
                    cell = [tableView dequeueReusableCellWithIdentifier:kMutiPicTextIdentifier forIndexPath:indexPath];
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    if (cell==nil) {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dbIdentifier"];
    }
    
    return cell;
}

- (void)configureCell:(NIMRChatTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    ChatEntity *recordEntity = [self recordEntityAtIndexPath:indexPath];
    ChatEntity *preRecordEntity = [self recordEntityAtIndexPath:preIndexPath];
    cell.isBuyer = self.isBuyer;
    [cell updateWithRecordEntity:recordEntity previousRecordEntity:preRecordEntity];
    cell.delegate = self;
    if (recordEntity.mtype == VOICE && !recordEntity.isSender) {
        AudioEntity *audioEntity = recordEntity.audioFile;
        if (!audioEntity.read) {
            if (![self.audioDatasource containsObject:recordEntity]) {
                [self.audioDatasource addObject:recordEntity];
            }
        }
    }
}

- (void)updateCellWithRecordEntity:(ChatEntity *)recordEntity{
    NSInteger index = [[NIMMessageManager sharedInstance] indexOfMessage:recordEntity];
    if(index == NSNotFound || index==-1){
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    ChatEntity *preRecordEntity = nil;
    if (index -1 >= 0) {
        NSDictionary *dict = [self.messageArr objectAtIndex:index -1];
        preRecordEntity = dict.allValues.firstObject;
    }
    
    NIMRChatTableViewCell *cell = (NIMRChatTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell updateWithRecordEntity:recordEntity previousRecordEntity:preRecordEntity];
    cell.delegate = self;
    
    if (recordEntity.mtype == VOICE && !recordEntity.isSender) {
        AudioEntity *audioEntity = recordEntity.audioFile;
        [[NIMMessageManager sharedInstance] updateMessage:recordEntity isPost:!_isDisappear isChange:NO];
        if (!audioEntity.read) {
            if (![self.audioDatasource containsObject:recordEntity]) {
                [self.audioDatasource addObject:recordEntity];
            }
        }
    }
}


#pragma mark STKAudioPlayerDelegate
- (void)updatePlayState{
    if (_currentRecordEntity == nil) {
        return;
    }
    _currentRecordEntity.audioFile.read = YES;
    
    [self updateCellWithRecordEntity:_currentRecordEntity];
    
}

//TODO:播放音频
- (void)playAudio:(ChatEntity *)recordEntity tableViewCell:(NIMRChatTableViewCell *)cell{
    
    //正在播放点击不提示
    if (recordEntity.audioFile.state != QIMMessageStatuPlaying) {
        if (_isEarPhone) {
            NSError *error;

            if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
                //[self.playSound setMode];
                if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
                    DLog(@"%@",[error debugDescription]);
                }else{
                }
            }
            [self.soundTipView showSoundAlert:@"当前为听筒播放模式" atView:self.view];
        }else{
//            if (![NIMBaseUtil usingHeadset]) {
//                [self.soundTipView showSoundAlert:@"当前为扬声器播放模式" atView:self.view];
//            }
        }
    }
    
    [self changeProximityMonitorEnableState:YES];
    if(_currentRecordEntity.audioFile.state == QIMMessageStatuPlaying && _currentRecordEntity!=recordEntity){//如果上一个没有播放就点击下一个，停止上一个播放
        [self.playSound stopPlay];
        _currentRecordEntity.audioFile.state = QIMMessageStatuStopped;
        [self updatePlayState];
    }
    if(recordEntity.audioFile.state == QIMMessageStatuPlaying){//如果点击正在播放的音频，停止播放
        [self.playSound stopPlay];
        recordEntity.audioFile.state = QIMMessageStatuStopped;
        [self updatePlayState];
        [self changeProximityMonitorEnableState:NO];
        return;
    }
    if(recordEntity.isSender){
        [self playWithEntity:recordEntity];
        return;
    }
    isAbleContinuousPlay = YES;
    [self playWithEntity:recordEntity];
    return;
    
}

- (void)playWithEntity:(ChatEntity *)recordEntity{
    [self.playSound stopPlay];
    if (_currentRecordEntity) {
        _currentRecordEntity.audioFile.state = QIMMessageStatuStopped;
        [self updatePlayState];
    }
    recordEntity.audioFile.state = QIMMessageStatuPlaying;
    _currentRecordEntity = recordEntity;
    self.preRecordEntityForSound = recordEntity.audioFile.read;
    
    
    if (isAbleContinuousPlay) {
        
        NSMutableArray *arr = @[].mutableCopy;
        
        for(NSInteger i=0;i<self.audioDatasource.count;i++){
            ChatEntity* r = (ChatEntity*)self.audioDatasource[i];
            if(!r.audioFile.read){
                [arr addObject:r];
            }
        }
        self.audioDatasource = arr;
        if (self.audioDatasource) {
            _playIndex = 0;
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ct" ascending:YES];
            [self.audioDatasource sortUsingDescriptors:@[sortDescriptor]];
            for(NSInteger i=0;i<self.audioDatasource.count;i++){
                ChatEntity* r = (ChatEntity*)self.audioDatasource[i];
                if(r == recordEntity){
                    _playIndex = i;
                    break;
                }
            }
        }
    }
    
    NSLog(@"%@_%@",recordEntity.audioFile,recordEntity.audioFile.file);
    if (recordEntity.audioFile.file) {
        NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
        NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath, recordEntity.audioFile.file];
        [self.playSound playSound:[NSURL fileURLWithPath:filePath]];
    }else{
        //NSLog(@"-----------------");
        if (recordEntity.audioFile.url){
            [[NIMOperationBox sharedInstance] downloadAudioRecordEntity:recordEntity success:^(BOOL success) {
                
            }];
            [self.playSound playSound:[NSURL URLWithString:recordEntity.audioFile.url.description]];
        }
    }
}

- (void)playStatusChanged:(DOUAudioStreamerStatus)status{
    ChatEntity* record = _currentRecordEntity;
    
    switch (status) {
        case DOUAudioStreamerPlaying:{
            record.audioFile.state = QIMMessageStatuPlaying;
        }
            break;
            
        case DOUAudioStreamerPaused:{
            [self.playSound pausePlay];
            [self.playSound playCon];
            //            record.audioFile.state = QIMMessageStatuPlaying;
            //            [self playWithEntity:record];
            //            record.audioFile.state = QIMMessageStatuStopped;
            //            [self changeProximityMonitorEnableState:NO];
            
        }
            break;
            
        case DOUAudioStreamerIdle:{
            
        }
            break;
            
        case DOUAudioStreamerFinished:
        {
            record.audioFile.state = QIMMessageStatuStopped;
            if(!record.isSender && !self.preRecordEntityForSound){
                _playIndex++;
                if(_playIndex<self.audioDatasource.count){
                    
                    [self changeProximityMonitorEnableState:YES];
                    [self updatePlayState];
                    [self playWithEntity:self.audioDatasource[_playIndex]];
                    return;
                }
                else{
                    [self.audioDatasource removeAllObjects];
                    [self changeProximityMonitorEnableState:NO];
                }
            }
            else
            {
                [self changeProximityMonitorEnableState:NO];
            }
        }
            break;
            
        case DOUAudioStreamerBuffering:{
            
        }
            break;
            
        case DOUAudioStreamerError:{
            record.audioFile.state = QIMMessageStatuNone;
        }
            break;
    }
    [self updatePlayState];
}

- (void)stopAudio:(ChatEntity *)recordEntity{
    [self.playSound stopPlay];
    [self changeProximityMonitorEnableState:NO];
}
- (void)changeProximityMonitorEnableState:(BOOL)enable {
    
    if ([NIMBaseUtil usingHeadset]) {
        //删除近距离事件监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        return;
    }else {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
            if (enable) {
                
                //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
                
            } else {
                
                if (!_isEarPhone) {
                    if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayback]) {
                        //[self.playSound setMode];
                        if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]){
                            
                        }
                    }
                }
                
                //删除近距离事件监听
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
                [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            }
        }
        
    }
    
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    NSError *error;
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        DBLog(@"Device is close to user");
        if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
            DLog(@"%@",[error debugDescription]);
        }else{
        }
    }
    else
    {
        DBLog(@"Device is not close to user");
        if (!_isEarPhone) {
            [self.soundTipView showSoundAlert:@"已从听筒切换回扬声器播放" atView:self.view];
            if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
                DLog(@"%@",[error debugDescription]);
            }else{
            }
        }
        
    }
}

#pragma mark VcardForwardDelegate
- (void)latestVcardViewController:(NIMLatestVcardViewController *)viewController didSendThread:(NSString *)thread completeBlock:(VcardCompleteBlock)completeBlock{
    if(thread.length==0)return;
    ChatEntity *recordEntity = viewController.objectForward;
    if ([recordEntity isKindOfClass:[ChatEntity class]]) {
        [[NIMMessageCenter sharedInstance] forwardRecordEntity:recordEntity toMsgBodyId:thread];
        completeBlock(VcardSelectedActionTypeForward,thread,nil);
    };
}

#pragma mark ChatKeyboardDelegate
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSelectedAction:(ChatKeyBoardSelectedType)actionType{
    _keyboardSelectedType = actionType;
    switch (actionType) {
        case ChatKeyBoardSelectedTypeNone:
            //            [self.keyboardView.textView resignFirstResponder];
            [self defaultKeyboardView];
            
            break;
        case ChatKeyBoardSelectedTypeKeyboard:
        {
            //            [self.keyboardView.textView becomeFirstResponder];
        }
            break;
        case ChatKeyBoardSelectedTypeVoice:
        {
            //            [self.keyboardView.textView resignFirstResponder];
            [self defaultKeyboardView];
        }
            break;
        case ChatKeyBoardSelectedTypeFace:
            //            [self.keyboardView.textView resignFirstResponder];
            //            [self faceKeyboardView];
            break;
        case ChatKeyBoardSelectedTypeOption:
            //            [self.keyboardView.textView resignFirstResponder];
            //            [self faceKeyboardView];
            
            break;
        case ChatKeyBoardSelectedTypeOthers:
            //            [self.keyboardView.textView resignFirstResponder];
            //            [self faceKeyboardView];
            //                        [self defaultKeyboardView];
            
            break;
        default:
            break;
    }
}


#pragma - mark 发送图片、地址、红包等

- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didOptionSelectedAction:(ChatKeyBoardOptionActionType)actionType{
    switch (actionType) {
        case ChatKeyBoardOptionActionTypeCamera:
        {
            [UIActionSheet  nim_canCameraWithYES:^{
                self.camera = [[NIMLLCameraViewController alloc] init];
                self.pickerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                
                self.camera.lldelegate = self;
                
                [self presentViewController:self.camera animated:YES completion:^{
                    [self.keyboardView resetDefault];
                    self.keyboardView.textView.editable = NO;
                }];
                //                self.pickerViewController = [[UIImagePickerController alloc] init];
                //                self.pickerViewController.delegate = self;
                //                self.pickerViewController.allowsEditing = NO;
                //                self.pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //                self.pickerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                //                [self presentViewController:self.pickerViewController animated:YES completion:^{
                //                    [self.keyboardView resetDefault];
                //                }];
            } withNO:^{
                
            }];
            
            
        }
            break;
        case ChatKeyBoardOptionActionTypePhoto:
            if([UIActionSheet  nim_checkPhotoLibrary])
            {
                //TODO:相册
                [UIActionSheet nim_canPhotoLibraryWithYES:^{
                    [JFImagePickerController setMaxCount:9];
                    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];
                    picker.pickerDelegate = self;
                    [self.navigationController presentViewController:picker animated:YES completion:^{
                        [self.keyboardView resetDefault];
                    }];
                } withNO:^{
                    
                }];
                
            }
            break;
        case ChatKeyBoardOptionActionTypeVideo:
            {
//                NSString *filePath = [DF_CACHEPATH stringByAppendingString:@"6aa46d073d1dcee3642833a4a18f33f6.mov"];
//                NSURL *url = [NSURL fileURLWithPath:filePath];
////                [[DFFileManager sharedInstance] writeVideoToPhotoLibrary:url];
//                int64_t msgid = [NIMStringComponents createMessageid:_packetType];
//                UIImage *image = [UIImage nim_getVideoPreViewImage:url];
//                if (image) {
//                    [NIMBaseUtil cacheVideoThumb:image msgId:msgid];
//                }
//                NSDictionary *videoDic = @{@"file":filePath};
//                [self sendVideo:videoDic msgid:msgid];
                _videoController = [[ZHSmallVideoController alloc] initWithDelegate:self];
                _videoController.chatType = _packetType;
                [self presentViewController:_videoController animated:YES completion:^{
                    [self.keyboardView resetDefault];
                }];
                __weak typeof(self)weakSelf = self;
                _videoController.finishBlock = ^(NSURL *url, int64_t msgid) {
                    UIImage *image = [UIImage nim_getVideoPreViewImage:url];
                    if (image) {
                        [NIMBaseUtil cacheVideoThumb:image msgId:msgid];
                    }
                    NSString *docPath = [NSString stringWithFormat:@"%@/",[[NIMCoreDataManager currentCoreDataManager] recordPathMov]];
                    NSString *file = [url.path stringByReplacingOccurrencesOfString:docPath withString:@""];
                    
                    NSDictionary *videoDic = @{@"file":file};
                    [weakSelf sendVideo:videoDic msgid:msgid];
                };
            }
            break;
        case ChatKeyBoardOptionActionTypeLocation:
        {
            //TODO:位置
            NIMMapViewController* m = (NIMMapViewController*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMMapViewControllerIdentity"];
            m.willSendLocation = YES;
            m.delegate = self;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:m];
            [self.navigationController presentViewController:nav animated:YES completion:^{
                [self.keyboardView resetDefault];
            }];
        }
            break;
        case ChatKeyBoardOptionActionTypeCard:
        {
            //TODO:名片
            [self showVcardViewControllerWithRecordEntity:nil vcardActionType:VcardActionTypeSelected];
            
        }
            break;
        case ChatKeyBoardOptionActionTypeRedMoney:
        {
//            NSLog(@"--------------->发红包了------------");
//
//            NSDictionary *messageDic = @{@"id":@"123",
//                                         @"desc":@"啦啦啦啦啦啦",
//                                         @"type":@"LUCK"};
//
//            [self sendMessage:messageDic packetContentType:JSON subType:RED_PACKET];
            
            int64_t targetID  = [NIMStringComponents getOpuseridWithMsgBodyId:_thread];
            int isGroup = 0;
            if (_packetType == GROUP) {
                isGroup = 1;
            }
            NSMutableDictionary * redDic = [NSMutableDictionary dictionary];
            [redDic setValue:@(targetID) forKey:@"target_id"];
            [redDic setValue:@(isGroup) forKey:@"isGroup"];
            [redDic setValue:@(SDK_PUSH_RedBag) forKey:@"push_type"];
            [redDic setValue:@1 forKey:@"isSend"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:redDic];
        }
            break;
        case ChatKeyBoardOptionActionTypeFavor:
        {
            NSDictionary *tmpDict = @{@"messageBodyId":_thread,
                                      @"push_type":@(SDK_PUSH_Favor)};
            [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:tmpDict];

        }
            break;
            
        case ChatKeyBoardOptionActionTypeOrder:
        {
            NIMOrderListViewController *order = [[NIMOrderListViewController alloc] init];
            order.messageBodyId = self.actualThread;
            
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:order];
            
            
            [self.navigationController presentViewController:nav animated:YES completion:^{
                [self.keyboardView resetDefault];
            }];            /*
                            NSDictionary *messageDic = @{@"img_url":@"https://facebook.github.io/react/img/logo_og.png",
                            @"title":@"订单详情",
                            @"desc":@"那才叫你参赛擦亮奥斯卡里面萨拉姆",
                            @"total":@"1234",
                            @"unit":@"0",
                            @"number":@"1",
                            @"id":@"1170000000027409",
                            @"state":@"未支付",
                            @"refund_amount":@"1111"};
                            [self sendOrder:messageDic];
                            */
        }
        default:
            break;
    }
}



- (void)showVcardViewControllerWithRecordEntity:(ChatEntity *)recordEntity vcardActionType:(VcardActionType)vcardType{
    UINavigationController *vcardNav = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"VcardNavigation"];
    
    if ([vcardNav.topViewController isKindOfClass:[NIMVcardViewController class]]) {
        NIMVcardViewController *vcardVC = (NIMVcardViewController *)vcardNav.topViewController;
        vcardVC.vcardType = vcardType;
        vcardVC.delegate = self;
        switch (vcardType) {
            case VcardActionTypeNone:
                return;
                break;
            case VcardActionTypeSelected:
                
                break;
            case VcardActionTypeForward:
                vcardVC.recordEntity = recordEntity;
                break;
            default:
                break;
        }
    }
    [self.navigationController presentViewController:vcardNav animated:YES completion:^{
        [self.keyboardView resetDefault];
    }];
}

- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didChangedHeight:(CGFloat)height{
    
    CGRect boardFrame = self.keyboardView.frame;
    CGFloat heightBoardHeader = CGRectGetHeight(boardFrame);
    CGFloat y = 0;
    if (keyboardView.keboardSelectedType == ChatKeyBoardSelectedTypeKeyboard||keyboardView.keboardSelectedType == ChatKeyBoardSelectedTypeOthers) {
        y = CGRectGetMinY(_keyboardFrame) - heightBoardHeader;
    }else{
        y = CGRectGetHeight(self.view.frame) - heightBoardHeader - CGRectGetHeight(_keyboardFrame);
    }
    if(heightBoardHeader == 54){
        boardFrame = CGRectMake(boardFrame.origin.x, boardFrame.origin.y, boardFrame.size.width, kHeightBoardHeader);
        heightBoardHeader = kHeightBoardHeader;
        y=y+7;
    }
    self.keyboardView.frame = CGRectMake(CGRectGetMinX(boardFrame), y, CGRectGetWidth(boardFrame), heightBoardHeader);
    UIEdgeInsets inset = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, heightBoardHeader + CGRectGetHeight(_keyboardFrame) - kHeightBoardHeader , 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    if(_customKeyBoardHeight!=heightBoardHeader)
    {
        _customKeyBoardHeight = heightBoardHeader;
        [UIView animateWithDuration:.25
                         animations:^{
                             [self scrollTableViewByContentOffSetAnimated];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
    
    
}

- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSendText:(NSString *)text{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (text.length) {
        [self sendPlainText:text];
    }
    
}

- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didSendSmiley:(NSString *)text{
    [self sendSmily:text];
}
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didShowError:(NSString *)text{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法录音" message:@"请在iphone的“设置-隐私-麦克风”选项中，允许钱宝访问你的手机麦克风。"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
}
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView willBeginRecordingAtFilePath:(NSString *)filePath{
    
}
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didCancelRecordAtFilePath:(NSString *)filePath{
    
}
- (void)chatKeyboardView:(NIMRChatKeyboardView *)keyboardView didFinishRecordAtFilePath:(NSString *)filePath{
    [self sendVoice:filePath];
}

#pragma mark ChatTableViewCellDelegate

- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity{
    E_MSG_M_TYPE contentType = recordEntity.mtype;
    E_MSG_S_TYPE contentSubType = recordEntity.stype;
    if (contentType == ITEM) {
        NSString* sbody = recordEntity.msgContent;
        NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
        NSString *url = @"";
        if (htmDic) {
            url = [htmDic objectForKey:@"url"];
        }
        NSDictionary *tmpDict = @{@"url":url?:@"",
                                  @"push_type":@(SDK_PUSH_Item)};
        [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:tmpDict];
    }
    else if(contentType == IMAGE)
    {
        NSMutableArray *image_forPrepare = @[].mutableCopy;
        NSInteger numberOfRows = self.messageArr.count;
        NSInteger index = 0;
        for (int i = 0; i< numberOfRows; i++) {
            NSDictionary *dict = [self.messageArr objectAtIndex:i];

            ChatEntity *theRecordEntity = (ChatEntity *)dict.allValues.firstObject;
            
            E_MSG_M_TYPE contentType = theRecordEntity.mtype;
            if(contentType == IMAGE){
                NSIndexPath *ewIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                UIImageView* currentImageView = nil;
                if(!recordEntity.isSender)
                {
                    NIMRLeftImageCell* cellc = (NIMRLeftImageCell*)[self.tableView cellForRowAtIndexPath:ewIndexPath];
                    currentImageView = cellc.iconView;
                }
                else
                {
                    NIMRRightImageCell* cellc = (NIMRRightImageCell*)[self.tableView cellForRowAtIndexPath:ewIndexPath];
                    currentImageView = cellc.iconView;
                }
                NSString* surl = theRecordEntity.imageFile.img;
                
                NIMPhotoObject* obj = [[NIMPhotoObject alloc] init];
                if(theRecordEntity.imageFile.bigFile)
                {
                    NSString *fullPath = [[[NIMCoreDataManager currentCoreDataManager] applicationDocumentsDirectory] path];
                    NSString *filePath = [NSString stringWithFormat:@"%@%@",fullPath,theRecordEntity.imageFile.bigFile];
                    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                    obj.originlImage = img;
                }
                
                obj.imageUrl = surl;
                
                obj.currentImageView = currentImageView;
                
                obj.messageId = theRecordEntity.messageId;
                
                [image_forPrepare addObject:obj];
                if (theRecordEntity == recordEntity) {
                    index = [image_forPrepare indexOfObject:obj];
                }
            }
        }
        //        NSArray *reversedArray = [[image_forPrepare reverseObjectEnumerator] allObjects];
        //        index = reversedArray.count - index -1;
        NIMPhotoVC* vc = [[NIMPhotoVC alloc] init];
        [vc setPhotoDataSource:image_forPrepare atIndex:index showDelete:NO];
        
        [[NSUserDefaults standardUserDefaults]setObject:recordEntity.messageBodyId forKey:@"selectedImageUuid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.keyboardView.textView resignFirstResponder];
        _isBottom = NO;
    }
    else if(contentType == VOICE)
    {
        [self playAudio:recordEntity tableViewCell:cell];
    }else if(contentType == VIDEO)
    {
        VideoEntity* videoEntity = recordEntity.videoFile;
        [self.keyboardView.textView resignFirstResponder];

        NSURL *videoUrl;
        if (videoEntity.file.length>0) {
            NSString *docPath = [NSString stringWithFormat:@"%@",[[NIMCoreDataManager currentCoreDataManager] recordPathMov]];
            videoUrl = [NSURL fileURLWithPath:[docPath stringByAppendingPathComponent:videoEntity.file]];
        } else {
            videoUrl = [NSURL URLWithString:[SSIMSpUtil holderImgURL:videoEntity.url]];
        }
        [ZHPlayVideoView zh_playVideoWithUrl:videoUrl isShow:NO completion:^(ZHActionButtonType btnType) {
            
        }];
    }
    else if (contentSubType == GROUP_NEED_AGREE||
              contentSubType == GROUP_ADD_AGREE){
        
        
    }else if (contentType == JSON)
    {
        if (contentSubType == ORDER)
        {
            NSString* sbody = recordEntity.msgContent;
            NSDictionary *htmDic = [NIMUtility jsonWithJsonString:sbody];
            if (htmDic) {
                
                NSDictionary *tmpDict = @{@"order_id":[htmDic objectForKey:@"order_id"]?:@"",
                                          @"buyer_id":[htmDic objectForKey:@"buyer_id"]?:@"",
                                          @"push_type":@(SDK_PUSH_Order)};
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:tmpDict];
            }else{
                
            }
            
        }
        else if (contentSubType == VCARD)
        {
            NSData *m_Data        = [recordEntity.msgContent dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *m_Dict  = [NSJSONSerialization JSONObjectWithData:m_Data
                                                                    options:NSJSONReadingMutableLeaves
                                                                      error:nil];
            int type = [[m_Dict objectForKey:@"type"] intValue];
            if (type == 0) {
                int64_t userid;
                VcardEntity *vcardEntity = recordEntity.vcard;
                if (vcardEntity==nil) {
                    userid = [[m_Dict objectForKey:@"id"] longLongValue];
                }else{
                    userid = vcardEntity.userid;
                }
                [self showFeedProfileWithUserid:userid animated:YES];
            }else if (type == 1){
                [MBTip showError:@"外接功能" toView:self.view];
            }
        }else if (contentSubType == RED_PACKET){
            [[NIMRedBagManage sharedInstance] sendRedBagWithChat:recordEntity];
        }
    }else if(contentType == MAP){
        Location* loc = recordEntity.location;
        //这个地方可能要判断，android 发上来的数据可能为空
        //http://jira.qbao.com/browse/CLIENT-2861
        if (loc.lat == 0 || loc.lng == 0) {
            [MBTip showTipsView:@"无法定位"];
            return;
        }
        NSDictionary* dic = @{@"address":loc.address?:@"",@"lat":[NSString stringWithFormat:@"%f",loc.lat],@"lng":[NSString stringWithFormat:@"%f",loc.lng]};
        NIMMapViewController* map = (NIMMapViewController*)[[UIStoryboard storyboardWithName:@"NIMChatSub" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMMapViewControllerIdentity"];
        map.willSendLocation = NO;
        map.record = dic;
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:map];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            [self.keyboardView resetDefault];
        }];
        
        
    }
}

-(void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity atIndex:(NSInteger)index
{
    NSString* sbody = recordEntity.msgContent;;
    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
    NSArray *items = [jsonDic objectForKey:@"items"];
    NSDictionary *dic = items[index];
    NSString *url = [dic objectForKey:@"url"];
    NSDictionary *tmpDict = @{@"url":url?:@"",
                              @"push_type":@(SDK_PUSH_Item)};
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_SDK_PUSHTOVC object:tmpDict];
}

-(void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectUser:(int64_t)userid
{
    
    FDListEntity * fdlist = [FDListEntity instancetypeFindMUTUALFriendId:userid];

    if (!fdlist) {
        NIMAddDescViewController *descViewController = [[NIMAddDescViewController alloc] init];
        descViewController.userId = userid;
        descViewController.addSourceType = ChatSource;
        UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: descViewController];
        [self presentViewController:presNavigation animated:YES completion:nil];
    }else{
        [MBTip showError:@"对方已经是您的好友了" toView:self.view.window];
    }
    
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"发送好友请求" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
//            textField.delegate = self;
//        }];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UITextField *reason = alertController.textFields.firstObject;
//            
//            FDListEntity * fdlist = [FDListEntity instancetypeFindMUTUALFriendId:userid];
//            if (!fdlist) {
//                    [[NIMFriendManager sharedInstance] sendFriendAddRQ:userid opMsg:reason.text sourceType:ChatSource];
//            }else{
//                [MBTip showError:@"对方已经是您的好友了" toView:self.view.window];
//            }
//        }];
//        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        
//        [alertController addAction:cancle];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (comcatstr.length > 32) {
        return NO;
    }
    return YES;
}

#pragma mark - 交易提醒跳转界面

- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell infoButtonDidSelectedWithRecordEntity:(ChatEntity *)recordEntity{
    [[NIMMessageCenter sharedInstance] reSendRecordEntity:recordEntity];
}

- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectStr:(NSString*)str withType:(MLEmojiLabelLinkType)type{
    switch (type) {
        case MLEmojiLabelLinkTypeURL:
        {
            
            
            NSMutableDictionary* mudic = [[NSMutableDictionary alloc] init];
            [mudic setValue:str forKey:@"url"];
            [mudic setValue:str forKey:@"title"];
            
            NIMHtmlWebViewController *htmlWebVC = [[UIStoryboard storyboardWithName:@"NIMChatUI" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NIMHtmlWebViewController"];
            [htmlWebVC setHidesBottomBarWhenPushed:YES];
            htmlWebVC.linkDict = mudic;
            htmlWebVC.isNotReport = YES;
            htmlWebVC.sourceChannel = @"1";
            htmlWebVC.userId =[NSString stringWithFormat:@"%.f",_senderid];
            htmlWebVC.senderId =[NSString stringWithFormat:@"%.f",_recipientid];
            [self.navigationController pushViewController:htmlWebVC animated:YES];
            
            
        }
            break;
        case MLEmojiLabelLinkTypeEmail:{
            
        }
            break;
        case MLEmojiLabelLinkTypePhoneNumber:{
            NSMutableString * strPhone=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",str];
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strPhone]]){
                NIMRIButtonItem* call = [NIMRIButtonItem itemWithLabel:@"确定" action:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
                }];
                NIMRIButtonItem* cancel = [NIMRIButtonItem itemWithLabel:@"取消" action:^{
                    
                }];
                UIAlertView * alert = [[UIAlertView alloc] initWithNimTitle:@"提醒" message:[NSString stringWithFormat:@"你确定要拨打该电话：%@",str] cancelButtonItem:cancel otherButtonItems:call, nil];
                                       
                [alert show];
            }
        }
            break;
        case MLEmojiLabelLinkTypeAt:{
            
        }
            break;
        case MLEmojiLabelLinkTypePoundSign:{
            
        }
            break;
            
        default:
            break;
    }
}

- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSendBGProductWithRecordEntity:(ChatEntity *)recordEntity
{
    NSString* sbody = recordEntity.msgContent;
    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
    [self sendItem:jsonDic];
}

-(void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSendProductWithRecordEntity:(ChatEntity *)recordEntity
{
    NSString* sbody = recordEntity.msgContent;
    NSDictionary *jsonDic = [NIMUtility jsonWithJsonString:sbody];
    [self sendOrder:jsonDic];
}

/*
 
 - (void)showVcardViewControllerWithRecordEntity:(ChatEntity *)recordEntity vcardActionType:(VcardActionType)vcardType{
 UINavigationController *vcardNav = [[UIStoryboard storyboardWithName:@"NIMFriendShip" bundle:nil] instantiateViewControllerWithIdentifier:@"VcardNavigation"];
 
 if ([vcardNav.topViewController isKindOfClass:[NIMVcardViewController class]]) {
 NIMVcardViewController *vcardVC = (NIMVcardViewController *)vcardNav.topViewController;
 vcardVC.vcardType = vcardType;
 vcardVC.delegate = self;
 switch (vcardType) {
 case VcardActionTypeNone:
 return;
 break;
 case VcardActionTypeSelected:
 
 break;
 case VcardActionTypeForward:
 vcardVC.recordEntity = recordEntity;
 break;
 default:
 break;
 }
 }
 [self.navigationController presentViewController:vcardNav animated:YES completion:^{
 [self.keyboardView resetDefault];
 }];
 }
 */
- (void)chatTableViewCell:(NIMRChatTableViewCell *)cell didSelectedWithRecordEntity:(ChatEntity *)recordEntity action:(ChatMenuActionType )actionType{
    
    if (actionType == ChatMenuActionTypeForward) {
        [self showLatestVcardViewControllerWithRecordEntity:recordEntity animated:YES];
    }else if (actionType == ChatMenuActionTypeAvatar){
        if (_packetType == PUBLIC) {
            if(!recordEntity.isSender){
                int64_t offcialid = [NIMStringComponents getOpuseridWithMsgBodyId:recordEntity.messageBodyId];
                [self showFeedProfileWithUserid:offcialid animated:YES];
            }else{
                [self showFeedProfileWithUserid:recordEntity.userId animated:YES];
            }
        }else{
            if(recordEntity.isSender){
                [self showFeedProfileWithUserid:recordEntity.userId animated:YES];
            }else{
                [self showFeedProfileWithUserid:recordEntity.opUserId animated:YES];
            }
        }
    }else if (actionType == ChatMenuActionTypeVoice){
        _isEarPhone = !_isEarPhone;
        NSError *error;
        
        setObjectToUserDefault(KEY_Earphone, @(_isEarPhone));
        if (_isEarPhone) {
            
            if (![[[AVAudioSession sharedInstance] category] isEqualToString:AVAudioSessionCategoryPlayAndRecord]) {
                if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]){
                    DLog(@"%@",[error debugDescription]);
                }else{
                    self.receImageView.hidden = NO;
                    [self.soundTipView showSoundAlert:@"当前为听筒播放模式" atView:self.view];
                    
                }
            }
            //删除近距离事件监听
            //            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            //            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            
        }else{
            
            if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error]){
                DLog(@"%@",[error debugDescription]);
            }else{
                self.receImageView.hidden = YES;
                [self.soundTipView showSoundAlert:@"当前为扬声器播放模式" atView:self.view];
            }
        }
        
    }
}

#pragma mark VcardViewControllerDelegate
- (void)VcardViewController:(NIMVcardViewController *)viewController didSelectedWithCardInfos:(NSArray *)entitys{
    if (entitys.count) {
        
        NSString *content = entitys.firstObject;
        [self sendMessage:content packetContentType:JSON subType:VCARD];
    }
}

-(void)cameraViewController:(NIMLLCameraViewController *)picker didFinishPickingImage:(NSDictionary *)imageDict
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    UIImage *oriImage = [imageDict objectForKey:@"original"];
    int64_t msgid = [NIMStringComponents createMessageid:_packetType];
    [NIMBaseUtil cacheImage:oriImage mid:msgid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendImage:imageDict msgid:msgid];
    });
}


#pragma UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    if(image)
    {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            [SSIMSpUtil saveImageToAlbum:image withAlert:NO];
        }
    }
    else
    {
        [MBTip showError:@"图片无效" toView:self.view];
        return;
    }
    
    
    UIImage *photo = [self compraseImage:image];
    //UIImage *thumbNail = [photo nim_getLimitImage:CGSizeMake(200, 200)];
    
    NSDictionary *imageDic = @{@"thumbnail": photo,@"original":photo};
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendMessage:imageDic packetContentType:IMAGE subType:CHAT];
        
    }];
    
    
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark NIMChooseImageViewControllerDelegate

-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(00, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}


-(void)imagePickerDidFinished:(JFImagePickerController *)picker
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *oriImage = [UIImage imageWithCGImage:imageRef];
            
            int64_t msgid = [NIMStringComponents createMessageid:_packetType];
            [NIMBaseUtil cacheImage:oriImage mid:msgid];
            NSDictionary *imageDic = @{@"original":oriImage,@"id":@(msgid)};
            [arr addObject:imageDic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sendImage:imageDic msgid:msgid];
            });
            if (arr.count == picker.assets.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self imagePickerDidCancel:picker];
                });
            }
        }];

    }
}

-(void)imagePickerDidCancel:(JFImagePickerController *)picker
{
    [picker hidden];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}


#pragma mark - ZHSmallVideoControllerDelegate

-(void)zh_delegateVideoInLocationUrl:(NSURL *)url
{
    [_videoController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"视频存在本地的路径：%@", url);
    [[DFFileManager sharedInstance] writeVideoToPhotoLibrary:url];
//    int64_t msgid = [NIMStringComponents createMessageid:_packetType];
//    UIImage *image = [UIImage nim_getVideoPreViewImage:url];
//    [NIMBaseUtil cacheVideoThumb:image msgId:msgid];
//    NSDictionary *videoDic = @{@"thumb":image,@"file":url.path};
//    [self sendVideo:videoDic msgid:msgid];
}


#pragma mark NIMMapViewControllerDelegate
- (void)NIMMapViewController:(NIMMapViewController *)viewController didSendLocation:(NSDictionary*)location{
    [self sendLocation:location];
}


#pragma ChatGroupSettingControllerDelegate
-(void)reloadTableIfNameShow
{
    [self.tableView reloadData];
}

-(void)reloadTableIfClearDataSource
{
    [self.tableView reloadData];
}

#pragma mark - Keyboard notifications
- (void)keyboardDidShow:(NSNotification *)notification
{
    _keyboardIsShow = YES;
    NSValue* keyboardFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [self.view convertRect:[keyboardFrameValue CGRectValue] fromView:nil];
    _keyboardFrame = keyboardFrame;
    NSValue* animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGRect boardFrame = self.keyboardView.frame;
    CGFloat heightBoardHeader = CGRectGetHeight(boardFrame);
    UIEdgeInsets inset = self.tableView.contentInset;
    
    //    [UIView animateWithDuration:0
    //                     animations:^{
    self.keyboardView.frame = CGRectMake(CGRectGetMinX(boardFrame),
                                         CGRectGetMinY(keyboardFrame) - heightBoardHeader,
                                         CGRectGetWidth(boardFrame),
                                         CGRectGetHeight(boardFrame));
    [self scrollTableViewByContentOffSetAnimated];
    //                     }
    //                     completion:^(BOOL finished) {
    //                         if (finished) {
    int bottom = CGRectGetHeight(keyboardFrame) + heightBoardHeader - kHeightBoardHeader;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0,bottom , 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [_tableView addGestureRecognizer:_singleFingerOne];
    //                         }
    //                     }];
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, heightBoardHeader + CGRectGetHeight(_keyboardFrame) - kHeightBoardHeader , 0);

    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    [self.keyboardView layoutIfNeeded];
    if (_keyboardSelectedType == ChatKeyBoardSelectedTypeKeyboard || _keyboardSelectedType == ChatKeyBoardSelectedTypeNone ||_keyboardSelectedType ==ChatKeyBoardSelectedTypeOthers) {
        [self.keyboardView showTextKeyboard:_keyboardSelectedType];
    }
    [self.chatCountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-bottom-kHeightBoardHeader-10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    _keyboardIsShow = NO;
    if (UIEdgeInsetsEqualToEdgeInsets(self.tableView.contentInset,UIEdgeInsetsZero))
    {
        /* Our table view's content inset is intact so no need to reset it */
        return;
    }
    //    if(self.keyboardView.keboardSelectedType == ChatKeyBoardSelectedTypeNone)
    //    {
    //        return;
    //    }
    _customKeyBoardHeight = 0;
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue* keyboardFrameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [self.view convertRect:[keyboardFrameValue CGRectValue] fromView:nil];
    _keyboardFrame = CGRectMake(CGRectGetMinX(keyboardFrame), CGRectGetMinY(keyboardFrame), CGRectGetWidth(keyboardFrame), 0);
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat downBoardHeader = CGRectGetHeight(self.keyboardView.frame);
    UIEdgeInsets inset = self.tableView.contentInset;
    _isBottom = YES;
    //    [UIView animateWithDuration:0
    //                     animations:^{
    self.keyboardView.frame = CGRectMake(0,
                                         CGRectGetHeight(self.view.bounds) -  CGRectGetHeight(self.keyboardView.frame) - _iphoneXadd,
                                         CGRectGetWidth(self.keyboardView.frame),
                                         CGRectGetHeight(self.keyboardView.frame));
                             [self scrollTableViewByContentOffSetAnimated];
    //                     }
    //                     completion:^(BOOL finished) {
    //                         if (finished) {
    int bottom = downBoardHeader - kHeightBoardHeader;
    self.tableView.contentInset = UIEdgeInsetsMake(inset.top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //                         }
    [_tableView removeGestureRecognizer:_singleFingerOne];
    //                     }
    //     ];
    [self.chatCountView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-bottom-kHeightBoardHeader-10);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom + inset.top;
    float h = size.height;
    if(y >= h - SCREEN_HEIGHT/4.0) {
        _isBottom = YES;
        
    }else{
        _isBottom = NO;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom + inset.top;
    float h = size.height;
    if(y >= h - SCREEN_HEIGHT/4.0) {
        _isBottom = YES;
        
    }else{
        _isBottom = NO;
    }
    int ucountHeight  = 0;
    for (int i=0; i<self.ucountHeightArr.count; i++) {
        int c = [[self.ucountHeightArr objectAtIndex:i] intValue];
        ucountHeight+=c;
    }
    
    if (ucountHeight>0 &&
        y+ucountHeight>=h+64) {
        [self.ucountHeightArr removeObjectAtIndex:0];
        [_ucountMsgidArr removeObjectAtIndex:0];
        self.chatCountView.UCount = self.ucountHeightArr.count;
    }
//    NSLog(@"高度：%f,y----%f,h----%f,height:%f",_ucountHeight,y,h,SCREEN_HEIGHT);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self autoLoadMoreData:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self autoLoadMoreData:scrollView];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatEntity *recordEntity = [self recordEntityAtIndexPath:indexPath];
    BOOL inComing = recordEntity.isSender;
    NIMRChatTableViewCell *cell = nil;
    if (inComing) {
        cell = [self tableView:tableView rightTableViewCellForRowAtIndexPath:indexPath];
    }else{
        cell = [self tableView:tableView leftTableViewCellForRowAtIndexPath:indexPath];
    }

    cell.contentView.backgroundColor = [SSIMSpUtil getColor:@"F4F4F4"];
    cell.backgroundColor = [SSIMSpUtil getColor:@"F4F4F4"];
    cell.backgroundView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    
    ChatEntity *recordEntity = [self recordEntityAtIndexPath:indexPath];
    ChatEntity *preRecordEntity = [self recordEntityAtIndexPath:preIndexPath];
    
    CGFloat height = 0;
    if (recordEntity.mtype == IMAGE) {
        height = [NIMRChatTableViewCell heightWithNRecordEntity:recordEntity previousRecordEntity:preRecordEntity];
        return height;
    }
    if (self.heightDatasource[@(recordEntity.messageId)]) {
        NSNumber *hD = self.heightDatasource[@(recordEntity.messageId)];
        height = [hD floatValue];
    }else{
        height = [NIMRChatTableViewCell heightWithNRecordEntity:recordEntity previousRecordEntity:preRecordEntity];
        if (recordEntity.messageId) {
            self.heightDatasource[@(recordEntity.messageId)] = [NSNumber numberWithFloat:height];
        }
    }
    return height;
}
// 解决不能转发问题
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView endEditing:NO];
//}

- (void)onTickoutAlter:(NSString *)msg
{
    
}

-(void)updateUcount:(NSNotification *)noti
{
    if (_packetType == SHOP_BUSINESS || _packetType == CERTIFY_BUSINESS) {
        return;
    }
    NSInteger ucount = 0;
    if (noti.object == nil) {
        ucount = [[NIMMsgCountManager sharedInstance] GetShowUnreadCount];
    }else{
        ucount = [noti.object intValue];
    }
    int64_t session_id = [NIMStringComponents getOpuseridWithMsgBodyId:self.thread];
    E_MSG_CHAT_TYPE chat_type = [NIMStringComponents chatTypeWithMsgBodyId:self.thread];
    ucount -= [[NIMMsgCountManager sharedInstance] GetUnreadCount:session_id chat_type:chat_type];
    if (ucount == 0) {
        self.uCountL.hidden = YES;
    }else{
        self.uCountL.hidden = NO;
        if (ucount<100) {
            self.uCountL.text = _IM_FormatStr(@"(%ld)",(long)ucount);
        }else{
            self.uCountL.text = @"(99+)";
        }
    }
}

-(void)selfUpdateUI:(NSNotification *)noti
{
    id object = noti.object;
    if (object == nil ||
        IsStrEmpty([[NIMSysManager sharedInstance]currentMbd])) {
        return;
    }
    NSDictionary *dict = object;
    NSString *messageBodyId = [dict objectForKey:@"messageBodyId"];
    if (![messageBodyId isEqualToString:self.thread]) {
        return;
    }
    
    NIMMessage_OP_Type type = [[dict objectForKey:@"type"] intValue];
    NSInteger row = self.messageArr.count - 1;
    if (type == NIMMessage_OP_Type_ADD) {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self performSelector:@selector(scrollTableToFoot) withObject:nil afterDelay:0];

    }else if (type == NIMMessage_OP_Type_UPDATE)
    {
        if (IsStrEmpty([[NIMSysManager sharedInstance] currentMbd])) {
            return;
        }
        NSInteger index = [[dict objectForKey:@"index"] integerValue];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [self.tableView reloadData];
    }
}

-(void)updateUI:(NSNotification *)noti
{
    id object = noti.object;
    if (object == nil ||
        IsStrEmpty([[NIMSysManager sharedInstance]currentMbd])) {
        return;
    }
    NSDictionary *dict = object;
    NSString *messageBodyId = [dict objectForKey:@"messageBodyId"];
    if (![messageBodyId isEqualToString:self.thread]) {
        return;
    }
    NIMMessage_OP_Type type = [[dict objectForKey:@"type"] intValue];
    NSIndexPath *theIndex = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
    if (type == NIMMessage_OP_Type_ADD) {
        [self.tableView insertRowsAtIndexPaths:@[theIndex] withRowAnimation:UITableViewRowAnimationNone];
        if (_isBottom) {
            [self performSelector:@selector(scrollTableToFoot) withObject:nil afterDelay:0];
        }else{
            /*
            NSInteger count = self.messageArr.count;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)];
            NSArray *temArray = [[[self.messageArr reverseObjectEnumerator] allObjects] objectsAtIndexes:indexSet];
            NSDictionary *dict = temArray.firstObject;
            ChatEntity *recordEntity = dict.allValues.firstObject;
            if (recordEntity.isSender) {
                _isBottom = YES;
                return ;
            }
            NSLog(@"消息ID：%lld",recordEntity.messageId);
            ChatEntity *preRecordEntity = nil;
            if (temArray.count>1) {
                NSDictionary *tmpDict = temArray[1];
                preRecordEntity = tmpDict.allValues.firstObject;;
            }
            CGFloat height = 0;
            height = [NIMRChatTableViewCell heightWithNRecordEntity:recordEntity previousRecordEntity:preRecordEntity];
            NSNumber *hD = @(height);
            if ([_ucountMsgidArr containsObject:@(recordEntity.messageId)]) {
                NSUInteger index = [_ucountMsgidArr indexOfObject:@(recordEntity.messageId)];
                [_ucountHeightArr replaceObjectAtIndex:index withObject:hD];
            }else{
                [_ucountHeightArr addObject:hD];
                [_ucountMsgidArr addObject:@(recordEntity.messageId)];
            }
            _chatCountView.UCount = self.ucountHeightArr.count;
             */
        }
    }else if (type == NIMMessage_OP_Type_UPDATE)
    {
        NSInteger index = [[dict objectForKey:@"index"] integerValue];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

#pragma mark NIMChatCountViewDelegate
-(void)clickAtChatCountView
{
    [_ucountHeightArr removeAllObjects];
    [_ucountMsgidArr removeAllObjects];
    _chatCountView.UCount = self.ucountHeightArr.count;
    [self performSelector:@selector(scrollTableToFoot) withObject:nil afterDelay:0];
}



-(void)reloadImageStatus:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    
    int64_t msgid = [[dict objectForKey:@"msgid"] longLongValue];
    
    ChatEntity *chatEntity = [ChatEntity findFirstWithMessageId:msgid];
    
    NSInteger row = [self.messageArr indexOfObject:chatEntity];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    
}


#pragma mark getter
- (NSString *)cacheChatName{
    return [NSString stringWithFormat:@"Cache-%llu-%@",OWNERID,self.thread];
}


-(void)checkRecordStatus{
    
    NSManagedObjectContext *privateContext = [[NIMCoreDataManager currentCoreDataManager] privateObjectContext];
    [privateContext performBlock:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageBodyId = %@ and status = %d",self.thread,QIMMessageStatuIsUpLoading];
        NSArray * all = [ChatEntity NIM_findAllSortedBy:@"ct" ascending:NO withPredicate:predicate];
        if(all.count!=0){
            
            for (ChatEntity *chatEntity in all) {
                if (chatEntity == nil) {
                    return ;
                }
                chatEntity.status = QIMMessageStatuUpLoadFailed;
            }
            [privateContext MR_saveToPersistentStoreAndWait];
        }
    }];
    
    
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [SSIMSpUtil getColor:@"F4F4F4"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if([UIDevice currentDevice].systemVersion.doubleValue>=8.0)
            _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.translatesAutoresizingMaskIntoConstraints = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NIMPublicBottomView *)publicBottomView
{
    if(!_publicBottomView) {
        _publicBottomView = [[NIMPublicBottomView alloc] initWithFrame:CGRectMake(0,
                                                                                 CGRectGetHeight(self.view.bounds),
                                                                                 CGRectGetWidth(self.view.bounds),
                                                                                 kHeightBoardHeader)];
        _publicBottomView.backgroundColor = [SSIMSpUtil getColor:@"f1f1f1"];
        _publicBottomView.delegate = self;
        _publicBottomView.hidden = YES;
        [self.view addSubview:_publicBottomView];
    }
    return _publicBottomView;
}
- (NIMRChatKeyboardView *)keyboardView{
    if (!_keyboardView) {
        _keyboardView = [[NIMRChatKeyboardView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.bounds) - kHeightBoardHeader - _iphoneXadd - IPX_NAVI_H,CGRectGetWidth(self.view.bounds),kHeightBoardHeader)];
        _keyboardView.backgroundColor = [SSIMSpUtil getColor:@"f1f1f1"];
        _keyboardView.delegate = self;
        [self.view addSubview:_keyboardView];
    }
    return _keyboardView;
}

- (NIMPlaySound*)playSound{
    if(!_playSound){
        _playSound = [[NIMPlaySound alloc] init];
        _playSound.delegate = self;
    }
    return _playSound;
}

- (NIMBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NIMBottomView alloc] init];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        [_bottomView awakeFromNib];
        [_bottomView setBackgroundColor:_COLOR_WHITE];
        _bottomView.leftBtn.titleLabel.font = BOLDFONT_TITLE(17);
        _bottomView.rightBtn.titleLabel.font = _bottomView.leftBtn.titleLabel.font;
        _bottomView.hidden = YES;
        //        [_bottomView setLeftTitle:@"我的资产" action:@selector(leftButtonAction) target:self];
        //        [_bottomView setRightTitle:@"收益明细" action:@selector(rightButtonAction) target:self];
        [self.view addSubview:_bottomView];
        
    }
    return _bottomView;
}
- (NSMutableArray *)audioDatasource{
    if (!_audioDatasource) {
        _audioDatasource = @[].mutableCopy;
    }
    return _audioDatasource;
}

- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.frame = CGRectMake(0, 0, 36, 36);
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}
#pragma mark setter
- (void)setThread:(NSString *)thread
{
    _thread =  thread;
    _actualThread =thread;
    [self otherUidWithThread:thread];
    [self updateGroupAssistant:thread];
    
}

-(void)setActualThread:(NSString *)actualThread{
    _actualThread = actualThread;
    NSArray*threadArray=[actualThread componentsSeparatedByString:@":"];
    if(threadArray.count == 3) return;
    [self otherUidWithThread:actualThread];
}

_GETTER_BEGIN(UIImageView, receImageView)
{
    UIImage *image = IMGGET(@"听");
    _receImageView = [[UIImageView alloc]initWithImage:image];
    
}
_GETTER_END(receImageView)

-(NSMutableArray *)messageArr
{
    _messageArr = [[NIMMessageManager sharedInstance].chatDict objectForKey:self.thread];
//    _messageArr = arr;
    return _messageArr;
}

#pragma mark doubanplaycontrol




static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;



- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    
}


- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        //[_progressSlider setValue:0.0f animated:NO];
    }
    else {
        //[_progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}


- (void)_updateBufferingStatus
{
    
    if ([_streamer bufferingRatio] >= 1.0) {
        DLog(@"sha256: %@", [_streamer sha256]);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewWillAppearPlayer:(BOOL)animated
{
    //[super viewWillAppear:animated];
    
    [self _resetStreamer];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    //    [_volumeSlider setValue:[DOUAudioStreamer volume]];
    /*注此代码缘由：1、_volumeSlider为nil 2、问题单如下
     客户端 CLIENT-2545
     【钱宝3.0-第二阶段】【iOS】首次启动应用，进入一个聊天页，会自动暂停正在播放的音乐*/
}

- (void)viewWillDisappearPlayer:(BOOL)animated
{
    [_timer invalidate];
    _timer = nil;
    [_streamer stop];
    [self _cancelStreamer];
    [self changeProximityMonitorEnableState:NO];
    

}

- (void)_actionPlayPause:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }
    else {
        [_streamer pause];
    }
}

- (void)_actionNext:(id)sender
{
    
}

- (void)_actionStop:(id)sender
{
    [_streamer stop];
}

- (void)_actionSliderProgress:(id)sender
{
    [_streamer setCurrentTime:[_streamer duration] * [_progressSlider value]];
}

- (void)_actionSliderVolume:(id)sender
{
    //[DOUAudioStreamer setVolume:[_volumeSlider value]];
}

-(ChatListEntity *)chatList
{
    if (!_chatList) {
        _chatList = [ChatListEntity findFirstWithMessageBodyId:self.thread];
        
    }
    
    return _chatList;
}

-(NIMSoundTipView *)soundTipView
{
    if (!_soundTipView) {
        _soundTipView = [[NIMSoundTipView alloc] initWithFrame:CGRectMake(0, CGRectGetMinX(self.view.frame), SCREEN_WIDTH, 50)];
    }
    
    return _soundTipView;
}

-(NIMChatCountView *)chatCountView
{
    if (!_chatCountView) {
        _chatCountView = [[NIMChatCountView alloc] initBottomViewWithFrame:CGRectZero];
        _chatCountView.UCount = 0;
        _chatCountView.delegate = self;
        [self.view addSubview:_chatCountView];
    }
    return _chatCountView;
}

//发红包回包
-(void)recvRedbagSendNC:(NSNotification * )noti{
    
    
    SSIMRedbagModel * redBagModel = noti.object;
    if ([redBagModel.redbag_type isEqualToString:@"WORD"]) {
        [MBTip showError:@"暂不支持该红包类型" toView:self.view.window];
    }else{
        NSDictionary *messageDic = @{@"target_id":redBagModel.target_id,
                                     @"group_id":redBagModel.target_id,
                                     @"opt_user_id":redBagModel.target_id,
                                     @"id":redBagModel.redbag_id,
                                     //                                 @"status":redBagModel.redbag_status,
                                     @"desc":redBagModel.redbag_desc,
                                     @"type":redBagModel.redbag_type,
                                     @"isGroup":@(redBagModel.isGroup),
                                     //                                 @"user_name":redBagModel.open_user_name,
                                     //                                 @"reSend":redBagModel.reSend,
                                     @"send_user_id":@(OWNERID)
                                     };
        
        [self sendMessage:messageDic packetContentType:JSON subType:RED_PACKET];
        
//        [NIMRedBagManage sharedInstance]saveWordRedBagWith:redBagModel msgID:<#(int64_t)#> msgBdID:<#(NSString *)#>
     }
}

//拆红包回包
-(void)recvRedbagOpenNC:(NSNotification * )noti{
    SSIMRedbagModel * redBagModel = noti.object;

    if (!redBagModel.isGroup) {
        VcardEntity * sendVcard = [VcardEntity instancetypeFindUserid:[redBagModel.send_user_id integerValue]];
        
        if ([redBagModel.send_user_id integerValue] != OWNERID) {
            //自己显示拆包暗文
            int64_t targetID  = [NIMStringComponents getOpuseridWithMsgBodyId:_thread];
            int64_t packID = [redBagModel.redbag_id integerValue];
            ChatEntity * chatEnt = [ChatEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId = %lld and opUserId = %lld and packId = %lld",OWNERID,targetID,packID]];
            if (!chatEnt) {
                [[NIMFriendManager sharedInstance]createHBTipsWithOpID:targetID redID:[redBagModel.redbag_id integerValue] strType:[NSString stringWithFormat:@"你领取了%@的红包",[sendVcard defaultName]]];
            }
        }
    }
    //暂时不给对方发消息
    //    [self sendMessage:@"IMHB" packetContentType:TEXT subType:CHAT];
}


#pragma mark 发红包

-(void)sendRedEnvelop:(SSIMRedbagModel *)redBagModel
{
  }

#pragma mark 发商品

-(void)sendItem:(id)jsonDic
{
    [self sendMessage:jsonDic packetContentType:ITEM subType:CHAT];

}
#pragma mark 发订单

-(void)sendOrder:(id)jsonDic
{
    [self sendMessage:jsonDic packetContentType:JSON subType:ORDER];

}


@end
