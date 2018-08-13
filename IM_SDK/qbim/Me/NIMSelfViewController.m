//
//  NIMSelfViewController.m
//  qbnimclient
//
//  Created by 豆凯强 on 2017/12/8.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMSelfViewController.h"
#import "UIImage+NIMEllipse.h"

#import "NIMSelfTableViewCell.h"
#import "NIMAddDescViewController.h"
#import "NIMActionSheet.h"
#import "NIMChatUIViewController.h"

#import "NIMEditRemarkNameVC.h"

#import "SSIMThreadViewController.h"
#import "NIMContactsViewController.h"
#import "NIMMeViewController.h"

#import "UserViewController.h"
#define kHEIGHT (160 * ScreenScale)

@interface NIMSelfViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * userTableView;

@property (nonatomic,strong) UIImageView * botImgView;
@property(nonatomic,strong) UIImageView * userIconView;
@property(nonatomic,strong) UILabel *firstNameLabel;
@property(nonatomic,strong) UILabel *userNameLabel;
@property(nonatomic,strong) UILabel *nickNameLabel;

@property(nonatomic,strong) UIView * sexView;
@property(nonatomic,strong) UIImageView * sexImgView;
@property(nonatomic,strong) UILabel * ageLable;
@property(nonatomic,strong) UIButton * optionBtn;
@property(nonatomic,strong) NSArray * picArr;

@end

@implementation NIMSelfViewController
{
    BOOL delBack;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //_userid = 0;
    _searchContent = @"";
    [self qb_setNavBarTintColor:[UIColor blackColor]];
//    [self setNavigationBarTransparent:0];
    [self qb_setNavStyleTheme:THEME_COLOR_WHITHE];
//    [self qb_setStatusBar_Default];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    //导航栏透明
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:IMGGET(@"transparent") forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSArray* a = self.navigationController.navigationBar.subviews;
    UIView* v = (UIView*)[a firstObject];
    v.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USERINFO_RQ_ForPeedView:) name:NC_USERINFO_RQ_ForPeedView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_FRIEND_DEL_RQ:) name:NC_FRIEND_DEL_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvFEEDPROFILE:) name:@"FEEDPROFILE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_ADD_BLACK_RQ:) name:NC_ADD_BLACK_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvPic:) name:NC_PIC_QUERY object:nil];


    [self decideUser];
    NSLog(@"%@",_vcardEntity.nickName);
    _firstNameLabel.text = _vcardEntity.nickName;
//    [_userTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addView];
}

-(void)decideFriendShip{
    
}

-(void)decideUser
{
    
    NSLog(@"%lld",OWNERID);
    if (_feedSourceType == SystemRandomSource) {
        _userid = OWNERID;
    }
    //判断用户
    if (_userid) {
        _searchContent = [NSString stringWithFormat:@"%lld",_userid];
        VcardEntity * vcard = [VcardEntity instancetypeFindUserid:_userid];
        if (vcard) {
            _vcardEntity = vcard;
            [self setUserInfo];
        }
//        else{
//            [[NIMUserOperationBox sharedInstance] sendUserInfo:_searchContent type:_userid];
//        }
    }
//    else{
//        NSString * searchName;
//
//        if ([SSIMSpUtil isPhoneNum:_searchContent]) {
//            searchName = @"mobile";
//        }else if ([SSIMSpUtil isTypeNumber:_searchContent]){
//            searchName = @"userid";
//        }else{
//            searchName = @"userName";
//        }
//        VcardEntity * vcard = [VcardEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"%@ = %@",searchName,_searchContent]];
//
//        if (vcard) {
//            _vcardEntity = vcard;
//            [self setUserInfo];
//        }
//    }
    if (_userid == 0 && IsStrEmpty(_searchContent)) {
        _userid = OWNERID;
    }
    NSString * seatchCon =@"";
    if (_userid) {
        seatchCon = [NSString stringWithFormat:@"%lld",_userid];
        [[NIMMomentsManager sharedInstance] queryPicArticle:_userid];
        [[NIMUserOperationBox sharedInstance] sendUserInfo:seatchCon type:Search_PeedView];
    }else{
        seatchCon = _searchContent;
        if (IsStrEmpty(seatchCon)) {
            return;
        }
        [[NIMUserOperationBox sharedInstance] sendUserInfo:seatchCon type:Search_PeedView];
    }
    if (_userid == OWNERID || [_searchContent isEqualToString:[NSString stringWithFormat:@"%lld",OWNERID]]) {
        self.leftButton.hidden = NO;
    }
}

-(void)setUserInfo{
    _vcardEntity = [VcardEntity instancetypeFindUserid:_userid];
    if (_vcardEntity) {
        _fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld and fdPeerId = %lld",OWNERID,_vcardEntity.userid]];
    }
    
    if (self.groupid!=0) {
        GroupList *groupList = [GroupList instancetypeFindGroupId:self.groupid];
        if (groupList) {
            GMember *member = [GMember instancetypeFindUserid:self.userid group:groupList];
            
            BOOL isSet = !IsStrEmpty(_fdlist.fdRemarkName) && ![member.showName isEqualToString:_fdlist.fdRemarkName];
            if (isSet) {
                member.showName = _fdlist.fdRemarkName;
                member.fullLitter = [PinYinManager getFullPinyinString:_fdlist.fdRemarkName];
                if (![member.fLitter isEqualToString:[PinYinManager getFirstLetter:_fdlist.fdRemarkName]]) {
                    member.fLitter = [PinYinManager getFirstLetter:_fdlist.fdRemarkName];
                }
                [[NIMCoreDataManager currentCoreDataManager] saveDataToDisk];
            }
        }
    }
//    [_userIconView sd_setImageWithURL:[NSURL URLWithString:_vcardEntity.avatar] placeholderImage:[UIImage imageNamed:@"fclogo"]];
    [_userIconView sd_setImageWithURL:[NSURL URLWithString:_vcardEntity.avatar] placeholderImage:[UIImage imageNamed:@"fclogo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] removeImageForKey:USER_ICON_URL(_userid)];
        [[SDImageCache sharedImageCache] storeImage:image forKey:USER_ICON_URL(_userid)];
    }];
    _firstNameLabel.text = [NIMStringComponents finFristNameWithID:_vcardEntity.userid];
    
    NSString * showUserName = @"";
    if (_vcardEntity.userName) {
        showUserName = _vcardEntity.userName;
    }else{
        showUserName = @"暂未填写";
    }
    NSString * showNickName = @"";
    if (_vcardEntity.nickName) {
        showNickName = _vcardEntity.nickName;
    }else{
        showNickName = @"暂未填写";
    }
    _userNameLabel.text = [NSString stringWithFormat:@"帐号：%@",showUserName];
    _nickNameLabel.text = [NSString stringWithFormat:@"昵称：%@",showNickName];
    
    [self updateHeadViewData];
}

// 更新名称年龄性别样式
- (void)updateHeadViewData{
    
    if ([_firstNameLabel.text isEqualToString: _nickNameLabel.text]) {
        _nickNameLabel.hidden = YES;
    }
    
    CGSize strSize=CGSizeMake(220 * ScreenScale, MAXFLOAT);
    
    NSDictionary *firAtt_firstName=@{NSFontAttributeName:_firstNameLabel.font};
    CGSize lableSize1=[self.firstNameLabel.text boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:firAtt_firstName context:nil].size;

    [self.firstNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconView.mas_top).mas_offset(@5);
        make.left.equalTo(_userIconView.mas_right).mas_offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@(lableSize1.width + 5));
    }];
    
    NSDictionary *firAtt_userName=@{NSFontAttributeName:self.userNameLabel.font};
    CGSize lableSize2=[self.userNameLabel.text boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:firAtt_userName context:nil].size;
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstNameLabel.mas_bottom).mas_offset(@5);
        make.left.equalTo(_firstNameLabel.mas_left);
        make.height.equalTo(@20);
        make.width.equalTo(@(lableSize2.width + 5));
    }];
    
    NSDictionary *firAtt_nickName=@{NSFontAttributeName:self.nickNameLabel.font};
    CGSize lableSize3=[self.nickNameLabel.text boundingRectWithSize:strSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:firAtt_nickName context:nil].size;

    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).mas_offset(@5);
        make.left.equalTo(_userNameLabel.mas_left);
        make.height.equalTo(@20);
        make.width.equalTo(@(lableSize3.width + 5));
    }];
    
    //更新性别
    if([_vcardEntity.sex isEqualToString:USER_SEX_FEMALE])
    {
        [_sexView setBackgroundColor:COLOR_RGBA(241, 46, 90, 1)];
        [_sexImgView setImage:IMGGET(@"icon_girl.png")];
    }else{
        [_sexView setBackgroundColor:COLOR_RGBA(19, 149, 255, 1)];
        [_sexImgView setImage:IMGGET(@"icon_boy.png")];
    }
    
    //更新年龄
    NSString * userAge = [NSString stringWithFormat:@"%d",_vcardEntity.age];
    if([userAge isEqualToString:@""] || userAge == nil || [userAge isEqualToString: @"0"] || IsStrEmpty(userAge) || userAge.length == 0)
    {
        _ageLable.hidden = YES;
        
        [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.firstNameLabel.mas_centerY);
            make.left.equalTo(self.firstNameLabel.mas_right).offset(5);
            make.width.equalTo(@(16));
            make.height.equalTo(@(12));
        }];
    }
    else
    {
        _ageLable.text = userAge;
        
        if (userAge.length == 1) {
            [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.firstNameLabel.mas_centerY);
                make.left.equalTo(self.firstNameLabel.mas_right).offset(5);
                make.width.equalTo(@(24));
                make.height.equalTo(@(12));
            }];
        }else if (userAge.length == 2){
            [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.firstNameLabel.mas_centerY);
                make.left.equalTo(self.firstNameLabel.mas_right).offset(5);
                make.width.equalTo(@(30));
                make.height.equalTo(@(12));
            }];
        }
    }
    
//    UIImage *image = [IMGGET(@"bg_cha_2.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    NSString *title = @"加为好友";
    
//    NIMFriendshipType friendships;
//    friendships ==_fdlist.fdFriendShip;

    
    switch (_fdlist.fdFriendShip){
        case FriendShip_NotFriend:
        case FriendShip_Ask_Peer:
        case FriendShip_Ask_Me:
        case FriendShip_Outlast:
        case FriendShip_MobileRecommend:{
            
            self.rightButton.hidden = YES;
            self.rightButton.userInteractionEnabled = NO;
            
            title = @"加为好友";
//            [_optionBtn setBackgroundImage:image forState:UIControlStateNormal];
            [_optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_optionBtn setBackgroundColor:[UIColor redColor]];
            
            [self.navigationItem setRightBarButtonItem:nil];
        }
            break;
        case FriendShip_Friended:
        case FriendShip_Consent_Peer:
        case FriendShip_UnilateralFriended:{
            
            self.rightButton.hidden = NO;
            self.rightButton.userInteractionEnabled = YES;
            
            title = @"发消息";
            [_optionBtn setTitleColor:[UIColor colorWithRed:19/255.0 green:86/255.0 blue:215/255.0 alpha:1] forState:UIControlStateNormal];
            [_optionBtn setBackgroundColor:[UIColor whiteColor]];
            [self qb_showRightButtonWithImg:IMGGET(@"icon_channel_more")];
        }
            break;
            
        case FriendShip_IsMe:{
            self.rightButton.hidden = NO;
            [self qb_showRightButtonWithImg:IMGGET(@"icon_SellerCentral_setting")];
            self.rightButton.userInteractionEnabled = YES;
            _optionBtn.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
        }
            break;
        default:{
            self.rightButton.hidden = YES;
            self.rightButton.userInteractionEnabled = NO;
            _optionBtn.userInteractionEnabled = NO;
            _optionBtn.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
            
            [_optionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.offset(0);
                make.trailing.offset(0);
                make.bottom.offset(0);
                make.height.offset(0);
            }];
        }
            break;
    }
    [_optionBtn setTitle:title forState:UIControlStateNormal];
    
    if (_vcardEntity.userid == OWNERID) {
        if (_feedSourceType == SystemRandomSource) {
            self.leftButton.hidden = YES;
            self.leftButton.userInteractionEnabled = NO;
        }
        self.rightButton.hidden = NO;
        [self qb_showRightButtonWithImg:IMGGET(@"icon_SellerCentral_setting")];
        self.rightButton.userInteractionEnabled = YES;

        _optionBtn.userInteractionEnabled = NO;
        _optionBtn.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];

        [_optionBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
            make.bottom.offset(0);
            make.height.offset(0);
        }];
    }
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    [_userTableView reloadData];
}

-(void)friendBtnClick{
    switch (_fdlist.fdFriendShip) {
        case FriendShip_NotFriend:
        case FriendShip_Ask_Peer:
        case FriendShip_Ask_Me:
        case FriendShip_Outlast:
        case FriendShip_MobileRecommend:{
            NIMAddDescViewController *descViewController = [[NIMAddDescViewController alloc] init];
            descViewController.userId = _userid;
            descViewController.addSourceType = _feedSourceType;
            UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: descViewController];
            
            descViewController.addBackRefesh = ^(){
                DBLog(@"返回刷新");
                [self setUserInfo];
            };
            [self presentViewController:presNavigation animated:YES completion:nil];
            
            break;
        }
        case FriendShip_IsMe:{
            
            
            break;
        }
        case FriendShip_Friended:
        case FriendShip_Consent_Peer:
        case FriendShip_UnilateralFriended:
        {
            [self checkChatUIVC];
            //            [QBClick event:kUMEventId_3021];
            NIMChatUIViewController *chatVC = [[NIMChatUIViewController alloc] init];
            [chatVC setThread:[NSString stringWithFormat:@"4:%lld:%lld",OWNERID,_vcardEntity.userid]];
            [chatVC setActualThread:[NSString stringWithFormat:@"4:%lld:%lld",OWNERID,_vcardEntity.userid]];
            chatVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatVC animated:YES];
            
            
            break;
        }
        default:
            break;
    }
}

-(void)checkChatUIVC
{
    for (int i=0; i<self.navigationController.viewControllers.count; i++) {
        id obj = self.navigationController.viewControllers[i];
        if ([obj isKindOfClass:[NIMChatUIViewController class]]) {
            NIMChatUIViewController *vc = obj;
            [vc removeObserver];
        }
    }
    
}


-(void)addView{
    [self.botImgView addSubview:self.userIconView];
    [self.botImgView addSubview:self.firstNameLabel];
    [self.botImgView addSubview:self.userNameLabel];
    [self.botImgView addSubview:self.nickNameLabel];
    [self.botImgView addSubview:self.sexView];
    [self.sexView addSubview:self.sexImgView];
    [self.sexView addSubview:self.ageLable];
    
    [self.userTableView addSubview:self.botImgView];
    [self.view addSubview:self.userTableView];
    [self.view addSubview:self.optionBtn];
    
    [self makeUIConstraints];
}

-(void)makeUIConstraints{
    [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];

    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.bottom.equalTo(self.optionBtn.mas_top).mas_offset(@-1);
    }];
    
    
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(75 * ScreenScale));
        make.width.equalTo(@(75 * ScreenScale));
        make.left.equalTo(_botImgView.mas_left).mas_offset(@(20 * ScreenScale));
        make.bottom.equalTo(_botImgView.mas_bottom).mas_offset(@(-(50 * ScreenScale)));
    }];
    
    [self.firstNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconView.mas_top).mas_offset(@(5 * ScreenScale));
        make.left.equalTo(_userIconView.mas_right).mas_offset(@(15 * ScreenScale));
        make.height.equalTo(@(20 * ScreenScale));
        make.width.equalTo(@(220 * ScreenScale));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstNameLabel.mas_bottom).mas_offset(@(5 * ScreenScale));
        make.left.equalTo(_firstNameLabel.mas_left);
        make.height.equalTo(@(20 * ScreenScale));
        make.width.equalTo(@(220));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).mas_offset(@(5 * ScreenScale));
        make.left.equalTo(_userNameLabel.mas_left);
        make.height.equalTo(@(20 * ScreenScale));
        make.width.equalTo(@(220));
    }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstNameLabel.mas_centerY);
        make.left.equalTo(self.firstNameLabel.mas_right);
        make.width.equalTo(@(40 * ScreenScale));
        make.height.equalTo(@(12 * ScreenScale));
    }];
    
    [self.sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexView.mas_top).offset(1);;
        make.bottom.equalTo(self.sexView.mas_bottom).offset(-1);
        make.left.equalTo(self.sexView.mas_left).offset(1);
        make.width.equalTo(@(14 * ScreenScale));
    }];
    
    [self.ageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sexImgView.mas_top);
        make.bottom.equalTo(self.sexImgView.mas_bottom);
        make.left.equalTo(self.sexImgView.mas_right).offset(-1);
        make.right.equalTo(self.sexView.mas_right).offset(-1);
    }];
}

//滑动动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y < -kHEIGHT) {
        _botImgView.frame =CGRectMake(0,point.y, [UIScreen mainScreen].bounds.size.width,-point.y);
    }
    float alpha = 1 - (-point.y - kHEIGHT)/100;
    if (alpha < 0 ) {
        alpha = 0;
    }
    //jpg
    [_botImgView setImage:[IMGGET(@"feedHome") nim_uie_boxblurImageWithBlur:alpha]];
    
    if(scrollView.contentOffset.y<64)
    {
        [self setNavigationBarTransparent:1];
    }else{
        [self setNavigationBarTransparent:2];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_fdlist.fdFriendShip == FriendShip_IsMe || !_fdlist) {
        if (section == 1) {
            return 1;
        }
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 70;
    }
    
    if (_fdlist.fdFriendShip == FriendShip_IsMe || !_fdlist) {
        if (indexPath.section == 1) {
            return 0;
        }
    }
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMSelfTableViewCell *cell = (NIMSelfTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NIMSelfTableViewCell" forIndexPath:indexPath];
    
    //取消点击背景色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置箭头
    if (indexPath.section == 2 || indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (cell == nil) {
        cell = [[NIMSelfTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NIMSelfTableViewCell"];
    }
    cell.pics = self.picArr;
    [cell getViewModelWithIndex:indexPath withVcard:_vcardEntity];
    
    NSArray * sourceArr = @[@"通讯录匹配",@"趣味相投的人",@"附近的人",@"扫描二维码",@"搜索添加",@"名片分享",@"相同任务领取人",@"公众号关注者添加",@"任务评论者添加",@"动态发布者添加",@"动态评论者添加",@"动态点赞者添加",@"聊天会话页添加",@"公众号文章评论者添加",@"商品评论者添加",@"服务号列表页添加",@"图文页点击服务号名称添加",@"推荐人自动加好友",@"系统随机推荐"];

    if (indexPath.section == 0) {
        if (!IsStrEmpty(_vcardEntity.locationPro) && !IsStrEmpty(_vcardEntity.localtionCity)) {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@",_vcardEntity.locationPro,_vcardEntity.localtionCity];
        }
    }else if (indexPath.section == 1) {
//        if (_fdlist.fdFriendShip == FriendShip_IsMe || !_fdlist) {
//            cell.contentView.frame =CGRectMake(0, 0, 0, 0);
//        }else{
            if (0 <= self.feedSourceType &&  self.feedSourceType < 18) {
                cell.contentLabel.text = sourceArr[self.feedSourceType];
            }
//        }
    }else if (indexPath.section == 4){
        if (!IsStrEmpty(_vcardEntity.signature)) {
            cell.contentLabel.text = _vcardEntity.signature;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (_userid>0) {
            UserViewController *controller = [[UserViewController alloc] init];
            controller.userid = _userid;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [MBTip showError:@"该用户不存在" toView:self.view];
        }
    }
}

- (void)qb_rightButtonAction{
    if (_userid == OWNERID || [_searchContent isEqualToString:[NSString stringWithFormat:@"%lld",OWNERID]]) {
        NSLog(@"编辑个人资料");
        
        NIMMeViewController * editView = [[NIMMeViewController alloc]init];
        editView.vcardEntity = _vcardEntity;
        editView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editView animated:YES];
        
    }else{
        FDListEntity * fdlist = [FDListEntity NIM_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"fdOwnId = %lld  and fdPeerId = %lld and (fdFriendShip = %d || fdFriendShip = %d)",OWNERID,_vcardEntity.userid,FriendShip_Friended,FriendShip_UnilateralFriended]];
        
        NSString *firstName = [NIMStringComponents finFristNameWithID:_vcardEntity.userid];
        
        NSString * blackStr = @"";
        NSString * blackSure = @"";
        NSString * notCall = @"";
        NIMFDBlackShipType blacktype;
        
        if (fdlist.fdBlackShip == FD_BLACK_NOT_BLACK || fdlist.fdBlackShip == FD_BLACK_PASSIVE_BLACK) {
            blackStr = @"加入黑名单";
            blackSure = @"确认加入";
            blacktype = 1;
            notCall = @"你将不再收到对方的消息";
        }else if (fdlist.fdBlackShip == FD_BLACK_MUTUAL_BLACK || fdlist.fdBlackShip == FD_BLACK_ACTIVE_BLACK){
            blackStr = @"移出黑名单";
            blackSure = @"确认移出";
            notCall = @"";
            blacktype = 0;
        }
        
        NIMActionSheet * actionSheet = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"修改备注",@"删除好友",blackStr] AttachTitle:@""];
        
        //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
        
        [actionSheet ButtonIndex:^(NSInteger Buttonindex) {
            
            
            if (Buttonindex == 1) {
                
                NIMEditRemarkNameVC* remark = [[NIMEditRemarkNameVC alloc] initWithNibName:@"NIMEditRemarkNameVC" bundle:[NSBundle mainBundle]];
                remark.userId = self.userid;
                if (_fdlist) {
                    if (_fdlist.fdRemarkName) {
                        remark.remarkName = _fdlist.fdRemarkName;
                    }
                }
                remark.backRefesh = ^(){
                    DBLog(@"返回刷新");
                    [self setUserInfo];
                };
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATETABLE" object:nil];
                [self.navigationController pushViewController:remark animated:YES];
                
            }else if (Buttonindex == 2) {
                
                NSString *str =[NSString stringWithFormat:@"将联系人“%@”删除\n同时删除与他的聊天记录",firstName];
                
                NIMActionSheet * actionSheet = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[@"确认删除"] AttachTitle:str];
                
                //            [action ChangeTitleColor:[UIColor redColor] AndIndex:1];
                
                [actionSheet ButtonIndex:^(NSInteger Buttonindex) {
                    
                    if (Buttonindex == 1) {
                        
                        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
                            [self showAlertWithNetFail];
                            return;
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                            });
                            
                            [[NIMFriendManager sharedInstance] sendFriendDelRQ:_vcardEntity.userid];
                        }
                    }
                }];
                
            }else if (Buttonindex == 3){
                NSString *str =[NSString stringWithFormat:@"将联系人“%@”%@。%@",firstName,blackStr,notCall];
                NIMActionSheet * actionSheet = [[NIMActionSheet alloc] initWithCancelStr:@"取消" otherButtonTitles:@[blackSure] AttachTitle:str];
                [actionSheet ButtonIndex:^(NSInteger Buttonindex) {
                    
                    if (Buttonindex == 1) {
                        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
                            [self showAlertWithNetFail];
                            return;
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
                            });
                            [[NIMFriendManager sharedInstance] addBlackListRQ:_vcardEntity.userid blackType:blacktype];
                        }
                    }
                }];
            }
        }];
    }
}

-(void)showAlertWithNetFail{
    UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [netAlert addAction:nAction];
    [self presentViewController:netAlert animated:YES completion:^{
    }];
}

-(void)recvNC_USERINFO_RQ_ForPeedView:(NSNotification *)noti{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        
        if ([noti.userInfo[@"success"] intValue]) {
            //            [MBTip showTipsView:@"查找成功" atView:self.view];
            BOOL isRequest = NO;
            if (_userid == 0) {
                isRequest = YES;
            }else{
                isRequest = NO;
            }
            _userid = [noti.userInfo[@"userId"] intValue];
            if (isRequest) {
                [[NIMMomentsManager sharedInstance] queryPicArticle:_userid];
            }
            VcardEntity * vcard = [VcardEntity instancetypeFindUserid:_userid];
            _vcardEntity = vcard;
            [self setUserInfo];
        }else{
            
        }
    });
}

-(void)recvNC_FRIEND_DEL_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showTipsView:param.p_string atView:self.view];
            }else{
                [MBTip showTipsView:@"删除成功" atView:self.view];
                [self setUserInfo];
                delBack = YES;
            }
        }else{
            [self showAlertWithNetFail];
            
        }
        [_userTableView reloadData];
    });
}

-(void)qb_back{
    UIViewController *target=nil;
    if (delBack) {
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[NIMChatUIViewController class]]) {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if([vc isKindOfClass:[NIMContactsViewController class]]){
                        target=vc;
                    }else{
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            if([vc isKindOfClass:[SSIMThreadViewController class]]){
                                target=vc;
                            }
                        }
                    }
                }
            }
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(void)recvNC_ADD_BLACK_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    NSString * type = object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view.window];
                
            }else{
                //                [self.navigationController popViewControllerAnimated:YES];
                
                if ([type isEqualToString:@"0"]) {
                    [MBTip showError:@"移出黑名单成功" toView:self.view.window];
                }else if ([type isEqualToString:@"1"]){
                    [MBTip showError:@"添加黑名单成功" toView:self.view.window];
                }
            }
        }else{
            [self showAlertWithNetFail];
        }
        [_userTableView reloadData];
    });
}

-(void)recvFEEDPROFILE:(NSNotification *)noti{
    [self setUserInfo];
}

-(void)recvPic:(NSNotification *)noti
{
    id object = noti.object;
    if(object){
        if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [MBTip showError:param.p_string toView:self.view];
            return;
        }else{
            self.picArr = noti.object;
            [self.userTableView reloadData];
        }
    }else{
        [MBTip showError:FAILDMESSAGE toView:nil];
    }
}

//状态栏调整
- (void)setNavigationBarTransparent:(NSInteger)isTransparent
{
    self.title = @"个人中心";
    UIImage * img = nil;
    switch (isTransparent) {
        case 0:
        {
            img = IMGGET(@"bg_whitecell1");
        }
            break;
        case 1:
        {
            img = IMGGET(@"transparent");
            [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        }
            break;
        case 2:
        {
            img = IMGGET(@"bg_qb_topbar01");
            [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
            self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            //            [self qb_setTitleText:@"个人中心"];
        }
            break;
        default:
            break;
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationController.navigationBar setBackgroundImage:img forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSArray* a = self.navigationController.navigationBar.subviews;
    UIView* v = (UIView*)[a firstObject];
    if(isTransparent == 1)
        v.hidden = YES;
    else
        v.hidden = NO;
}

-(UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.estimatedRowHeight = 0;
        _userTableView.estimatedSectionHeaderHeight = 0;
        _userTableView.estimatedSectionFooterHeight = 0;
        _userTableView.showsVerticalScrollIndicator = NO;
        _userTableView.contentInset = UIEdgeInsetsMake(kHEIGHT, 0, 0, 0);
        
        //CELL边框边线
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
        [_userTableView registerClass:[NIMSelfTableViewCell class] forCellReuseIdentifier:@"NIMSelfTableViewCell"];
    }
    return _userTableView;
}


-(UIImageView * )botImgView{
    if (!_botImgView) {
        _botImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHEIGHT, [UIScreen mainScreen].bounds.size.width, kHEIGHT)];
        _botImgView.backgroundColor = [UIColor whiteColor];
        _botImgView.contentMode = UIViewContentModeScaleAspectFill;
        _botImgView.clipsToBounds = YES;
    }
    return _botImgView;
}

-(UIImageView * )userIconView{
    if (!_userIconView) {
        _userIconView = [[UIImageView alloc]init];
        [_userIconView sd_setImageWithURL:[NSURL URLWithString:_vcardEntity.avatar] placeholderImage:[UIImage imageNamed:@"fclogo"]];
        _userIconView.layer.cornerRadius = 10;
        _userIconView.clipsToBounds = YES;
    }
    return _userIconView;
}
-(UILabel *)firstNameLabel{
    if (!_firstNameLabel) {
        _firstNameLabel = [[UILabel alloc]init];
//            _firstNameLabel.backgroundColor = [UIColor blueColor];
        _firstNameLabel.text = @"";
        _firstNameLabel.textColor = [UIColor whiteColor];
        _firstNameLabel.font = [UIFont boldSystemFontOfSize:16 * ScreenScale];
    }
    return _firstNameLabel;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
//        _userNameLabel.backgroundColor = [UIColor blueColor];
        _userNameLabel.text = @"";
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15 * ScreenScale];
    }
    return _userNameLabel;
}

-(UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc]init];
//                        _nickNameLabel.backgroundColor = [UIColor blueColor];
        _nickNameLabel.text = @"";
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:15 * ScreenScale];
    }
    return _nickNameLabel;
}

-(UIView *)sexView{
    if (!_sexView) {
        _sexView = [[UIView alloc]init];
        _sexView.backgroundColor = [UIColor clearColor];
        _sexView.layer.cornerRadius = 3;
        _sexView.layer.masksToBounds = YES;
    }
    return _sexView;
}

-(UIImageView *)sexImgView{
    if (!_sexImgView) {
        
        _sexImgView = [[UIImageView alloc]init];
        _sexImgView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _sexImgView;
}

-(UILabel *)ageLable{
    if (!_ageLable) {
        _ageLable = [[UILabel alloc]init];
        _ageLable.textColor = [UIColor whiteColor];
        _ageLable.textAlignment = NSTextAlignmentCenter;
        _ageLable.font = [UIFont systemFontOfSize:11 * ScreenScale];
    }
    return _ageLable;
}

- (UIButton*)optionBtn{
    if(!_optionBtn){
        _optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _optionBtn.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
        [_optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_optionBtn addTarget:self action:@selector(friendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _optionBtn;
}

-(NSArray *)picArr
{
    if (!_picArr) {
        _picArr = [[NSArray alloc] init];
    }
    return _picArr;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
