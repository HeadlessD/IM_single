//
//  NIMFriendNoticeDetailViewController.m
//  QianbaoIM
//
//  Created by xuguochen on 15/12/21.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMFriendNoticeDetailViewController.h"
#import "NIMSelfViewController.h"
#import "Masonry.h"
#import "NIMChatUIViewController.h"

//#import "UIImageView+QBWebImage.h"
#import "NIMUserOperationBox.h"


//#import "TextEntity.h"

@interface NIMFriendNoticeDetailViewController ()

@property (nonatomic, strong) UIControl     *whiteBgView;
@property (nonatomic, strong) UIImageView   *headImageView;
@property (nonatomic, strong) UILabel       *nameLabel;
@property (nonatomic, strong) UILabel       *detailInfoLabel;
@property (nonatomic, strong) UILabel       *requestInfoLabel;

@property (nonatomic, strong) UIView        *whiteBarView;
@property (nonatomic, strong) UIButton      *agreeBtn;
//@property (nonatomic, strong) UIButton      *refuseBtn;
@property (nonatomic, strong) UILabel       *friendshipLabel;
@end

@implementation NIMFriendNoticeDetailViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    [self addConstraint];
    [self initUI];
    [self requestUserInfo:self.vcardEntity.userid];
    [self qb_setTitleText:@"好友申请"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_CLIENT_FRIEND_CONFIRM_RQ:) name:NC_CLIENT_FRIEND_CONFIRM_RQ object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}


- (void)requestUserInfo:(CGFloat)userID
{
    /*
     [[NIMUserOperationBox sharedInstance] fetchUserid3:userID completeBlock:^(id object, NIMResultMeta *result) {
     if (object) {
     VcardEntity *vcardEntity = [VcardEntity findFirstByAttribute:[NSPredicate predicateWithFormat:@"userid=%@",[NSNumber numberWithDouble:userID]]];
     if (vcardEntity) {
     [self.detailInfoLabel setText:[self detailInfoWith:vcardEntity]];
     }
     }
     }];
     */
}


- (void)showFeedProfile{
    if (self.vcardEntity.userid > 0) {
                NIMSelfViewController * feedProfileVC = [[NIMSelfViewController alloc]init];

        feedProfileVC.userid = self.vcardEntity.userid;
        feedProfileVC.feedSourceType = SearchSource;
        
        [feedProfileVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:feedProfileVC animated:YES];
    }
}

#pragma mark -UI

- (void)updateFriendShip:(NIMFriendshipType)friendship
{
    [self.whiteBarView setHidden:YES];
    [self.friendshipLabel setHidden:YES];
    switch (friendship) {
        case FriendShip_NotFriend:
        {
            break;
        }
        case FriendShip_IsMe:
        {
            break;
        }
        case FriendShip_Friended:
        {
            [self.friendshipLabel setHidden:NO];
            [self.friendshipLabel setText:@"已添加"];
            break;
        }
        case FriendShip_Ask_Me:
        {
            [self.whiteBarView setHidden:NO];
            break;
        }
        default:
            break;
    }
    
}
- (void)initUI{
    
    FDListEntity * fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld ",OWNERID,_vcardEntity.userid]];
    
    NIMFriendshipType friendshipType = fdlist.fdFriendShip;
    
    [self updateFriendShip:friendshipType];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:fdlist.fdAvatar] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    
    NSString * firstName= [NIMStringComponents finFristNameWithID:fdlist.fdPeerId];

    [self.nameLabel setText:firstName];
    
    [self.detailInfoLabel setText:[self detailInfoWith:self.vcardEntity]];
    
    NSMutableString *requestInfo = [NSMutableString stringWithFormat:@"附加信息: "];
    
    [requestInfo appendFormat:@"%@",fdlist.fdAddInfo];
    
    [self.requestInfoLabel setText:requestInfo];
}


- (NSMutableString *)detailInfoWith:(VcardEntity*)card
{
    NSMutableString *detailInfo = [NSMutableString stringWithString:@""];
    if ([card.sex isEqualToString:@"M"]) {
        [detailInfo appendString:@"男"];
    }
    else if ([card.sex isEqualToString:@"F"])
    {
        [detailInfo appendString:@"女"];
    }
    
    if (card.age > 0) {
        [detailInfo appendFormat:@" %d岁",self.vcardEntity.age];
    }
    
    if (card.locationPro.length > 0) {
        [detailInfo appendFormat:@" %@",self.vcardEntity.locationPro];
    }
    
    if (card.localtionCity.length > 0) {
        [detailInfo appendFormat:@"%@",self.vcardEntity.localtionCity];
    }
    return detailInfo;
}





- (void)addConstraint
{
    [self.whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@0);
        make.trailing.mas_equalTo(@0);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(14);
        make.height.mas_equalTo(@130);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    [self.whiteBgView addSubview:line1];
    [line1 setBackgroundColor:__COLOR_D5D5D5__];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@0);
        make.trailing.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    [self.whiteBgView addSubview:line2];
    [line2 setBackgroundColor:__COLOR_D5D5D5__];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@15);
        make.trailing.mas_equalTo(@-15);
        make.top.mas_equalTo(@70);
        make.height.mas_equalTo(@1);
    }];
    
    UIView *line3 = [[UIView alloc] init];
    [self.whiteBgView addSubview:line3];
    [line3 setBackgroundColor:__COLOR_D5D5D5__];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@0);
        make.trailing.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.height.mas_equalTo(@1);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@15);
        make.top.mas_equalTo(@15.5);
        make.width.mas_equalTo(@39);
        make.height.mas_equalTo(@39);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headImageView.mas_trailing).offset(11);
        make.height.mas_equalTo(21);
        make.trailing.mas_equalTo(@-15);
        make.top.mas_equalTo(self.headImageView);
    }];
    
    [self.detailInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.headImageView.mas_trailing).offset(11);
        make.height.mas_equalTo(18);
        make.trailing.mas_equalTo(@-15);
        make.bottom.mas_equalTo(self.headImageView);
    }];
    
    [self.requestInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.whiteBgView).insets(UIEdgeInsetsMake(75, 15, 5, 15));
    }];
    
    
    [self.whiteBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@0);
        make.height.mas_equalTo(@50);
        make.trailing.mas_equalTo(@0);
        make.bottom.mas_equalTo(self.view);
    }];
    
    UIView *line4 = [[UIView alloc] init];
    [self.whiteBarView addSubview:line4];
    [line4 setBackgroundColor:__COLOR_D5D5D5__];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@0);
        make.trailing.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.height.mas_equalTo(@1);
    }];
    
    //    UIView *line5 = [[UIView alloc] init];
    //    [self.whiteBarView addSubview:line5];
    //    [line5 setBackgroundColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
    //
    //    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.mas_equalTo(self.whiteBarView);
    //        make.top.mas_equalTo(@0);
    //        make.width.mas_equalTo(@1);
    //        make.bottom.mas_equalTo(@0);
    //    }];
    
    //    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.equalTo(@0);
    //        make.top.equalTo(@0);
    //        make.bottom.equalTo(@0);
    //        make.width.equalTo(self.agreeBtn);
    //    }];
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        //        make.width.equalTo(self.refuseBtn);
    }];
    
    [self.friendshipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView.mas_bottom).offset(15);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@20);
    }];
}

#pragma mark WEB
- (void)agreeFriendReq:(UIButton*)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    });
    
    [[NIMFriendManager sharedInstance] sendFriendConRQ:self.vcardEntity.userid result:0];
    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
}

-(void)recvNC_CLIENT_FRIEND_CONFIRM_RQ:(NSNotification *)noti{
    
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
        }else{
            NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
            
            chatVC.thread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:self.vcardEntity.userid];
            chatVC.actualThread = [NIMStringComponents createMsgBodyIdWithType:PRIVATE toId:self.vcardEntity.userid];
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            QBNCParam *param = [[QBNCParam alloc]init];
//            param.p_string = @"请求超时";
//            [MBTip showError:param.p_string toView:self.view];
//        });

        UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [netAlert addAction:nAction];
        [self presentViewController:netAlert animated:YES completion:^{
        }];

    }
}


- (void)refuseFriendReq:(UIButton*)sender{
    //    [[NIMFriendManager sharedInstance] sendFriendConRQ:self.vcardEntity.userid result:1];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:NC_REFRESH_UI object:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
    
    
    //    ChatListEntity * chatList = [ChatListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageBodyId = %@ and userId = %lld",kNewFriendThread,OWNERID]];
    //    if (!chatList) {
    //        chatList = [ChatListEntity NIM_createEntity];
    //    }
    //    chatList.messageBodyId  = kNewFriendThread;
    //    chatList.chatType = SYS;
    //    chatList.actualThread = kNewFriendThread;
    //    chatList.isPublic = 0;
    //    chatList.isflod=0;
    //    [chatList setShowRedPublic:0];
    //    chatList.userId = OWNERID;
    //    chatList.ct = msg_time/1000;
    //    chatList.preview = @"已发送好友请求";
}


#pragma mark GET

- (UIControl*)whiteBgView
{
    if (!_whiteBgView) {
        _whiteBgView = [[UIControl alloc] init];
        [_whiteBgView setBackgroundColor:[UIColor whiteColor]];
        [_whiteBgView addTarget:self action:@selector(showFeedProfile) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_whiteBgView];
    }
    return _whiteBgView;
}


- (UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [self.whiteBgView addSubview:_headImageView];
        
    }
    
    return _headImageView;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.whiteBgView addSubview:_nameLabel];
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_nameLabel setTextColor:[SSIMSpUtil getColor:@"262626"]];
    }
    
    return _nameLabel;
}

- (UILabel*)detailInfoLabel
{
    if (!_detailInfoLabel) {
        _detailInfoLabel = [[UILabel alloc] init];
        [_detailInfoLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.whiteBgView addSubview:_detailInfoLabel];
        [_detailInfoLabel setTextColor:[SSIMSpUtil getColor:@"888888"]];
    }
    
    return _detailInfoLabel;
}

- (UILabel*)requestInfoLabel
{
    if (!_requestInfoLabel) {
        _requestInfoLabel = [[UILabel alloc] init];
        [_requestInfoLabel setFont:[UIFont systemFontOfSize:16.0]];
        [self.whiteBgView addSubview:_requestInfoLabel];
        [_requestInfoLabel setNumberOfLines:0];
        [_requestInfoLabel setTextColor:[SSIMSpUtil getColor:@"262626"]];
        
        NSMutableString *requestInfo = [NSMutableString stringWithFormat:@"附加信息: "];
        
        if (self.vcardEntity.fdExtrInfo.length > 0) {
            [requestInfo appendString:self.vcardEntity.fdExtrInfo];
        }
        
        [_requestInfoLabel setText:requestInfo];
    }
    return _requestInfoLabel;
}

- (UIView*)whiteBarView
{
    if (!_whiteBarView) {
        _whiteBarView = [[UIView alloc] init];
        [_whiteBarView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_whiteBarView];
    }
    return _whiteBarView;
}

- (UIButton*)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc] init];
        [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_agreeBtn setTitleColor:[SSIMSpUtil getColor:@"fd472b"] forState:UIControlStateNormal];
        [_agreeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_agreeBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_agreeBtn addTarget:self action:@selector(agreeFriendReq:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteBarView addSubview:_agreeBtn];
    }
    return _agreeBtn;
}

//- (UIButton*)refuseBtn
//{
//    if (!_refuseBtn) {
//        _refuseBtn = [[UIButton alloc] init];
//        [_refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
//        [_refuseBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//        [_refuseBtn setTitleColor:[SSIMSpUtil getColor:@"262626"] forState:UIControlStateNormal];
//        [_refuseBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        [_refuseBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//        [_refuseBtn addTarget:self action:@selector(refuseFriendReq:) forControlEvents:UIControlEventTouchUpInside];
//        [self.whiteBarView addSubview:_refuseBtn];
//    }
//    return _refuseBtn;
//}


- (UILabel*)friendshipLabel
{
    if (!_friendshipLabel) {
        _friendshipLabel = [[UILabel alloc] init];
        [_friendshipLabel setTextColor:__COLOR_888888__];
        [_friendshipLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_friendshipLabel setText:@"已拒绝"];
        [_friendshipLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:_friendshipLabel];
    }
    
    return  _friendshipLabel;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
