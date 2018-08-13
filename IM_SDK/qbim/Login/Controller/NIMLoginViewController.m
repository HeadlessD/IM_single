			//
//  NIMLoginViewController.m
//  QianbaoIM
//
//  Created by xuqing on 16/2/19.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import "NIMLoginViewController.h"
#import "NIMLoginOperationBox.h"
#import "NIMManager.h"
#import "SSIMBusinessManager.h"

#define ANIMATION_DURATION 0.35f
#define headHight kHeigh/4
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeigh [UIScreen mainScreen].bounds.size.height
#define rectLeftArm CGRectMake(0, 100, 80, 80)
#define rectRightArm CGRectMake(_header.frame.size.width / 2 + 30, 100, 80, 80)
#define rectLeftHand CGRectMake(kWidth/ 2 - 85, headHight - 35, 60, 60)
#define rectRightHand CGRectMake(kWidth/ 2 + 30, headHight - 35, 60, 60)
#define KIdentifierIcon  @"iconCellIdentifier"//头像的cell


@implementation NIMLoginViewController

- (void)dealloc{
    _userNameTextField = nil;
    _PassWordTextField = nil;
    _arrowButton = nil;
    _headView = nil;
    _midView = nil;
    _forgetButton = nil;
    _kloginBtn = nil;
    _cloginBtn = nil;
    _yloginBtn = nil;

    _signBtn = nil;
    _qb_closeBarButton = nil;
    _closeButton = nil;
    _iconImage = nil;
    _userline = nil;
    _passline = nil;
    //宝儿的手
    _lefthand = nil;
    _righthand = nil;
    _header = nil;
    _accuntArr = nil;
    //宝儿的胳膊
    _lefthArm = nil;
    _rightArm = nil;
    _bottomView = nil;
    _dropDownView = nil;
    _moveDownView = nil;
    _delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headView = [[UIView alloc] init];
    /**
     *  读取沙盒中的登录账号记录
     */
    self.showDropView = NO;
    
    //    self.accuntArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.headView.backgroundColor = [SSIMSpUtil getColor:@"41415e"];
    [self.view addSubview:self.headView];
    
    self.midView = [[UIView alloc] init];
    self.midView.backgroundColor = [SSIMSpUtil getColor:@"ffffff"];
    [self.view addSubview:self.midView];
    
    [self.midView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.headView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
    
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(headHight));
    }];
    
    
    [self cuStomViewAutoLayOut];
    [self qb_setNavLeftButtonSpace];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.accuntArr = [NSMutableArray arrayWithArray:[[NIMAccountsManager shareIntance] getLocalAccounts]];
    if ([self getLastLoginAccount])
    {
        self.isshowBaoer = NO;
    }
    else
    {
        self.isshowBaoer = YES;
    }
    _iconImage.hidden = YES;
    self.PassWordTextField.text = @"";;
//    if(self.isshowBaoer == YES)
//    {
//        self.iconImage.hidden = YES;
//        self.arrowButton.hidden = YES;
//    }
//    else
//    {
    NSArray *users = getObjectFromUserDefault(@"users");
    if (users.count==0) {
        self.arrowButton.hidden = YES;
    } else {
        self.arrowButton.hidden = NO;
        NSString *name = [[NIMLoginManager sharedInstance] getLastAccount];
        if (!IsStrEmpty(name)) {
            self.userNameTextField.text = name;
        }
        //        if(self.accuntArr.count >0)
        //        {
        //            NIMAccountsInfo *model = [self.accuntArr objectAtIndex:self.accuntArr.count-1];
        //            [self hideBaoer];
        //            [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_point_head.png"]];
        //            self.userNameTextField.text = model.userName;
        //            self.PassWordTextField.text = model.passWord;
        //        }
        //        else
        //        {
        //
        //        }
        //    }
    }
    
    
    [self setNavigationBarTransparent:0];
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSMSloginRS:) name:NC_USER_REG_RQ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvSMSVaildRS:) name:NC_USER_SMS_VALID_RQ object:nil];
    
    //开始连接服务器
    [[SSIMClient sharedInstance] Connect:SERVER_DOMAIN_IM_SOCKET port:SERVER_DOMAIN_IM_PORT];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setNavigationBarTransparent:0];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _timeout = 0;
}

#pragma  mark textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.PassWordTextField)
    {
        if(_IM_IS_3_5_)
        {
            CGRect frame =  self.view.frame;
            frame.origin.y = - 44;
            self.view.frame = frame;
        }
        
    }
    else
    {
        
    }
    
    
    if(self.isshowBaoer==YES)
    {
        if ([textField isEqual:_userNameTextField]) {
            if (self.arrowButton.selected ==NO) {
                [self hideAccountBox];
            }
            else
            {
                
            }
            
            if (_clicktype != clicktypePass) {
                _clicktype =clicktypeUser;
                return;
            }
            _clicktype=clicktypeUser;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                
                self.rightArm.frame = CGRectMake(self.rightArm.frame.origin.x+45, self.rightArm.frame.origin.y + 70, self.rightArm.frame.size.width, self.rightArm.frame.size.height);
                self.lefthArm.frame = CGRectMake(self.lefthArm.frame.origin.x - 5, self.lefthArm.frame.origin.y + 70, self.lefthArm.frame.size.width, self.lefthArm.frame.size.height);
                self.lefthand.frame = CGRectMake(self.lefthand.frame.origin.x-60, self.lefthand.frame.origin.y-10, 60, 60);
                self.righthand.frame = CGRectMake(self.righthand.frame.origin.x +20, self.righthand.frame.origin.y-10, 60, 60);
            } completion:^(BOOL finished) {
                
            }];
        }else if ([textField isEqual:_PassWordTextField]){
            if (_clicktype == clicktypePass)
            {
                return;
            }
            _clicktype = clicktypePass;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                
                self.rightArm.frame = CGRectMake(self.rightArm.frame.origin.x - 45, self.rightArm.frame.origin.y - 70, self.rightArm.frame.size.width, self.rightArm.frame.size.height);
                self.lefthArm.frame = CGRectMake(self.lefthArm.frame.origin.x + 5, self.lefthArm.frame.origin.y - 70, self.lefthArm.frame.size.width, self.lefthArm.frame.size.height);
                self.lefthand.frame = CGRectMake(self.lefthand.frame.origin.x + 60, self.lefthand.frame.origin.y+10, 0, 0);
                self.righthand.frame = CGRectMake(self.righthand.frame.origin.x - 20, self.righthand.frame.origin.y+10, 0, 0);
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.PassWordTextField)
    {
        if(_IM_IS_3_5_)
        {
            CGRect frame =  self.view.frame;
            frame.origin.y = 0;
            self.view.frame = frame;
        }
        else
        {
            
        }
    }
    else
    {
        
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == _userNameTextField)
    {
        [self textFieldDidBeginEditing:textField];
    }
    if (textField ==self.userNameTextField) {
        [self showBaoer];
        self.PassWordTextField.text=@"";
    }
    return YES;
}


#pragma mark 页面autoLayOUT设置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameTextField resignFirstResponder];
    [self.PassWordTextField resignFirstResponder];
    if (self.showDropView==YES) {
        [self hideAccountBox];
    }
}

-(void)cuStomViewAutoLayOut{
    /**
     宝儿的头
     
     - returns: header
     */
    _header = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/ 2 - 150 / 2, 100, 150, 90)];
    
    _header.image= IMGGET(@"baoer");
    [self.headView addSubview:_header];
    
    [_header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(@(kWidth/ 2 - 150 / 2));
        make.width.equalTo(@150);
        make.height.equalTo(@90);
    }];
    
    
    _lefthand = [[UIImageView alloc]initWithFrame:rectLeftHand];
    _lefthand.image = IMGGET(@"hand");
    [self.view addSubview:_lefthand];
    
    _righthand = [[UIImageView alloc]initWithFrame:rectRightHand];
    _righthand.image = IMGGET(@"hand");
    [self.view addSubview:_righthand];
    
    
    _rightArm=[[UIImageView alloc]initWithFrame:rectRightArm];
    _rightArm.image=IMGGET(@"right");
    [_header addSubview:_rightArm];
    
    _lefthArm=[[UIImageView alloc]initWithFrame:rectLeftArm];
    _lefthArm.image=IMGGET(@"left");
    [_header addSubview:_lefthArm];
    
    _iconImage =[[UIImageView alloc]init];
    _iconImage.backgroundColor=[UIColor clearColor];
    _iconImage.contentMode =UIViewContentModeScaleToFill;
    [self.headView addSubview:_iconImage];
    
    
    
//    UIImageView *image1 =[[UIImageView alloc]initWithImage:IMGGET(@"icon_account")];
//    image1.contentMode =UIViewContentModeScaleAspectFit;
//    UIImageView *image2 =[[UIImageView alloc]initWithImage:IMGGET(@"icon_password")];
//    image2.contentMode =UIViewContentModeScaleAspectFit;
    self.userNameTextField =[[NIMCustomTextField alloc]init];
    [self.userNameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.userNameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.userNameTextField.backgroundColor = [UIColor clearColor];
    self.userNameTextField.placeholder =@"请输入手机号";
    self.userNameTextField.delegate=self;
    self.userNameTextField.tag=1001;
    self.userNameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.userNameTextField];
    
    _userline =[[UIImageView alloc]init];
    _userline.backgroundColor =[SSIMSpUtil getColor:@"e6e6e6"];
    [self.view addSubview:_userline];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //cell间距
    layout.minimumInteritemSpacing = 0.7;
    //cell的行距
    layout.minimumLineSpacing=10;
    _dropDownView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _dropDownView.delegate = self;
    _dropDownView.dataSource = self;
    _dropDownView.alwaysBounceHorizontal=YES;
    _dropDownView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dropDownView];
    
    
    // 注册cell,否则会报错
    [self.dropDownView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HSHeader"];
    [self.dropDownView registerClass:[NIMLoginHistoryCell class]  forCellWithReuseIdentifier:KIdentifierIcon];
    
    
    _moveDownView =[[UIView alloc]init];
    _moveDownView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_moveDownView];
    _passline = [[UIImageView alloc]init];
    _passline.backgroundColor=[SSIMSpUtil getColor:@"e6e6e6"];
    [self.moveDownView addSubview:_passline];
    
    self.PassWordTextField =[[NIMCustomTextField alloc]init];
    self.PassWordTextField.placeholder = @"请输入验证码";
    self.PassWordTextField.delegate=self;
    self.PassWordTextField.backgroundColor =[UIColor clearColor];
    self.PassWordTextField.secureTextEntry=YES;
    self.PassWordTextField.tag=1002;
    self.PassWordTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_moveDownView addSubview:self.PassWordTextField];
    
    self.arrowButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.arrowButton setImage:IMGGET(@"icon_drop-down-arrow") forState:UIControlStateNormal];
    self.arrowButton.backgroundColor=[UIColor redColor];
    [self.arrowButton addTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    self.arrowButton.backgroundColor =[UIColor clearColor];
    self.arrowButton.selected=NO;
    [self.view addSubview:self.arrowButton];
    
    self.forgetButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
    self.forgetButton.layer.cornerRadius=10;
    [self.forgetButton addTarget:self action:@selector(forgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.forgetButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.forgetButton setBackgroundColor:[SSIMSpUtil getColor:@"fd472b"]];
    [self.moveDownView addSubview:self.forgetButton];

    
    _kloginBtn =[[UIButton alloc]init];
    _kloginBtn.backgroundColor=[UIColor redColor];
    [_kloginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_kloginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_kloginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_kloginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [_kloginBtn setBackgroundColor:[SSIMSpUtil getColor:@"fd472b"]];
    _kloginBtn.layer.cornerRadius=20;
    _kloginBtn.tag = 10;
    [self.moveDownView addSubview:_kloginBtn];
    
//    _cloginBtn =[[UIButton alloc]init];
//    _cloginBtn.backgroundColor=[UIColor redColor];
//    [_cloginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_cloginBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [_cloginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_cloginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [_cloginBtn setBackgroundColor:[SSIMSpUtil getColor:@"fd472b"]];
//    _cloginBtn.layer.cornerRadius=20;
//    _cloginBtn.tag = 11;
//    [self.moveDownView addSubview:_cloginBtn];
    
//    _yloginBtn =[[UIButton alloc]init];
//    _yloginBtn.backgroundColor=[UIColor redColor];
//    [_yloginBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_yloginBtn setTitle:@"预发布登录" forState:UIControlStateNormal];
//    [_yloginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_yloginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    [_yloginBtn setBackgroundColor:[SSIMSpUtil getColor:@"fd472b"]];
//    _yloginBtn.layer.cornerRadius=20;
//    _yloginBtn.tag = 12;
//    [self.moveDownView addSubview:_yloginBtn];
    
    NSInteger padding = 10;
    
//    _signBtn =[[UIButton alloc]init];
//    _signBtn.backgroundColor=[UIColor redColor];
//    [_signBtn addTarget:self action:@selector(loginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_signBtn setTitle:@"线网登录" forState:UIControlStateNormal];
//    [_signBtn setTitleColor:[SSIMSpUtil getColor:@"fd472b"] forState:UIControlStateNormal];
//    [_signBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    _signBtn.layer.borderWidth=_LINE_HEIGHT_1_PPI;
//    _signBtn.layer.borderColor =[SSIMSpUtil getColor:@"e6e6e6"].CGColor;
//    _signBtn.layer.cornerRadius=20;
//    _signBtn.backgroundColor =[UIColor whiteColor];
//    _signBtn.tag = 13;
//    [self.moveDownView addSubview:_signBtn];
    
    _bottomView = [[NIMBottomView alloc] initView];
    _bottomView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_bottomView];
    [self updateQQAndWB];
//    self.userNameTextField.leftView =image1;
    self.userNameTextField.leftViewMode=UITextFieldViewModeAlways;
//    self.PassWordTextField.leftView=image2;
    self.PassWordTextField.leftViewMode=UITextFieldViewModeAlways;
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.trailing.leading.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    [self.iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.centerY.equalTo(self.headView.mas_centerY);
        make.width.height.equalTo(@60);
    }];
    
    [self.userNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).with.offset(50);
        make.leading.equalTo(@30);
        make.trailing.equalTo(self.arrowButton.mas_leading);
        make.height.equalTo(@45);
    }];
    
    [self.userline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).with.offset(4);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@(-30));
        make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
    }];
    
    [self.arrowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-15));
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.userNameTextField.mas_centerY);
    }];
    
    [self.moveDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).with.offset(5);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@250);
    }];
    
    [self.PassWordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moveDownView.mas_top).with.offset(5);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@(-150));
        make.height.equalTo(@45);
    }];
    
    [self.forgetButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-30));
        make.height.equalTo(@30);
        make.width.equalTo(@90);
        make.centerY.equalTo(self.PassWordTextField.mas_centerY);
    }];
    
    [self.dropDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).with.offset(5);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@80);
    }];
    
//    [self.kloginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(@(-50));
//        make.leading.equalTo(@50);
//        make.height.equalTo(@40);
//        make.top.equalTo(self.PassWordTextField.mas_bottom).with.offset(20);
//    }];
//    [@[self.kloginBtn, self.cloginBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
//    
//    [@[self.kloginBtn, self.cloginBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.PassWordTextField.mas_bottom).with.offset(30);
//        make.height.equalTo(@40);
//    }];
    

    [self.kloginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@100);
        make.trailing.equalTo(@-100);
        make.height.equalTo(@50);
        make.top.equalTo(self.forgetButton.mas_bottom).offset(20);
    }];
    
//    [self.signBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(@(-100));
//        make.leading.equalTo(@100);
//        make.height.equalTo(@40);
//        make.top.equalTo(self.kloginBtn.mas_bottom).with.offset(20);
//    }];
    
    [self.passline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PassWordTextField.mas_bottom).with.offset(5);
        make.leading.equalTo(@30);
        make.trailing.equalTo(@(-30));
        make.height.equalTo(@(_LINE_HEIGHT_1_PPI));
    }];
    
    self.iconImage.layer.cornerRadius =30;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [SSIMSpUtil getColor:@"67677e"].CGColor;
    self.iconImage.layer.borderWidth =2;
    
}

# pragma mark 打开还是关闭下拉界面
-(void)hideAccountBox
{
    if(!_showDropView)
        return;
    self.showDropView = NO;
    [self.view bringSubviewToFront:self.PassWordTextField];
    [self.arrowButton setSelected:NO];
    [self.arrowButton setImage:IMGGET(@"icon_drop-down-arrow") forState:UIControlStateNormal];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.moveDownView.center.x, self.moveDownView.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(self.moveDownView.center.x, self.moveDownView.center.y-self.dropDownView.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    
    [self.moveDownView.layer addAnimation:move forKey:nil];
    
    [self.moveDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).with.offset(5);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@250);
    }];
    
    [self.iconImage setAlpha:1.0f];
    [self.userNameTextField setAlpha:1.0];
    [self.PassWordTextField setAlpha:1.0];
    
}

-(void)showAccountBox
{
    if(_showDropView)
        return;
    self.showDropView =YES;
    
    _accuntArr= [NSMutableArray arrayWithArray:[[NIMAccountsManager shareIntance] getLocalAccounts]];
    
    [self.dropDownView reloadData];
    [self.userNameTextField resignFirstResponder];
    [self.PassWordTextField resignFirstResponder];
    [self.arrowButton setSelected:YES];
    [self.arrowButton setImage:IMGGET(@"icon_arrow_up") forState:UIControlStateNormal];
    CABasicAnimation *move=[CABasicAnimation animationWithKeyPath:@"position"];
    [move setFromValue:[NSValue valueWithCGPoint:CGPointMake(self.moveDownView.center.x, self.moveDownView.center.y)]];
    [move setToValue:[NSValue valueWithCGPoint:CGPointMake(self.moveDownView.center.x, self.moveDownView.center.y+self.dropDownView.frame.size.height)]];
    [move setDuration:ANIMATION_DURATION];
    [self.moveDownView.layer addAnimation:move forKey:nil];
    
    [self.moveDownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dropDownView.mas_bottom).with.offset(5);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@250);
    }];
    //模糊处理
    [self.iconImage setAlpha:0.5f];
    [self.userNameTextField setAlpha:0.5];
    [self.PassWordTextField setAlpha:0.5];
    
}

#pragma mark collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 80);
}

//optional
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NIMLoginHistoryCell *headCell =[collectionView dequeueReusableCellWithReuseIdentifier:KIdentifierIcon forIndexPath:indexPath];
    headCell.backgroundColor=[UIColor whiteColor];
    headCell.delegate=self;
    [headCell setAutoLayOut:self.accuntArr];
    return headCell;
}

- (void)qb_setNavLeftButtonSpace
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, self.qb_closeBarButton,nil]];
}

#pragma mark Actions
-(void)qb_close
{
    /*
    [self.userNameTextField resignFirstResponder];
    [self.PassWordTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
     */
}

- (void)qb_qqLogin
{

}
- (void)qb_weiboLogin
{
    
}


-(void)loginBtnPressed:(id)sender
{

    [self hideAccountBox];
    if ([[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <= 0) {
        [MBTip showTipsView:@"请输入登录账号"];
        return;
    }
    if (self.userNameTextField.text.length == 0)
    {
        [MBTip showTipsView:@"请输入登录账号"];
        return;
    }
    if (self.PassWordTextField.text.length ==0 ) {
        [MBTip showTipsView:@"请输入验证码"];
        return;
    }
    E_NET_STATUS net_ststus = [[NIMSysManager sharedInstance] GetNetStatus];
    if (net_ststus == CONNECTED) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loginWithName:_userNameTextField.text passwd:_PassWordTextField.text fromRegister:NO];
    } else {
        [MBTip showError:@"请检查网络状况" toView:self.view];
    }
    
}


-(void)forgetButtonPressed:(id)sender
{
    if (IsStrEmpty(self.userNameTextField.text)) {
        [MBTip showTipsView:@"请输入手机号"];
        return;
    }
    E_NET_STATUS net_ststus = [[NIMSysManager sharedInstance] GetNetStatus];
    if (net_ststus == CONNECTED) {
        [[NIMSysManager sharedInstance] sendSMSVaildRQ:[_userNameTextField.text integerValue]];
        _timeout=60;
        [self timePadding];
    } else {
        [MBTip showError:@"请检查网络状况" toView:self.view];
    }
    
    //    QBAuthFindPassWordViewController *fsv = [[QBAuthFindPassWordViewController alloc]initWithRootVC:self];
    //    [self nim_pushToVC:fsv animal:YES];
}

- (void)timePadding{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeout<=0){
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.forgetButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.forgetButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = _timeout ;//% 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.forgetButton setTitle:[NSString stringWithFormat:@"重新发送(%@s)",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.forgetButton.userInteractionEnabled = NO;
            });
            _timeout--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark -- http
- (void)loginWithName:(NSString*)username passwd:(NSString*)password fromRegister:(BOOL)fromRegister
{
    [self.view endEditing:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"userMobile"];
    
    [[NIMSysManager sharedInstance] sendSMSloginRQ:[username integerValue] userToken:password type:0];
      //开始连接服务器
//    [[SSIMClient sharedInstance] Connect:@"39.104.84.2" port:8001];
}

-(void)recvSMSVaildRS:(NSNotification *)noti{
    if (noti.object == nil) {
        _timeout=0;
        [self timePadding];
        [MBTip showError:@"验证码请求超时" toView:self.view.window];
    }else if ([noti.object isKindOfClass:[QBNCParam class]]){
        QBNCParam * par = noti.object;
        [MBTip showTipsView:par.p_string];
        _timeout=0;
        [self timePadding];
    }else{
        [MBTip showError:@"验证码发送成功" toView:self.view.window];
    }
}

-(void)recvSMSloginRS:(NSNotification *)noti{
    NSDictionary * dic = [NSDictionary dictionary];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([noti.object isKindOfClass:[NSDictionary class]]) {
        dic = noti.object;
        int64_t userid = [[dic objectForKey:@"userid"] integerValue];
        NSString * userToken = [dic objectForKey:@"usertoken"];
        NSDictionary *dict = @{@"id":@(userid),@"token":userToken};
        setObjectToUserDefault(@"imuserInfo", dict);
        //登录信息设置TCP登陆
        SSIMLogin *ns_login = [[SSIMLogin alloc]init];
        ns_login.user_id = userid;
        ns_login.ap_id = APP_ID_TYPE_QB;
        ns_login.token = userToken;
        
        //SDK传入登陆信息
        [[SSIMClient sharedInstance] setLoginInfo:ns_login];
        
        [[NIMSysManager sharedInstance]sendTCPlogin:ns_login];
        if (self.loginOk) {
            self.loginOk();
        }
        [self dismissViewControllerAnimated:YES completion:^{
            [MBTip showTipsView:@"登录成功"];
        }];

    }else if ([noti.object isKindOfClass:[QBNCParam class]]){
        QBNCParam * par = noti.object;
        [MBTip showError:par.p_string toView:self.view];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    //if (_delegate && [_delegate respondsToSelector:@selector(authLoginViewDismissed)])
   // {
     //   [_delegate authLoginViewDismissed];
    //}
}

-(void)_qb_afterLogin:(BOOL)exchangeAccount fromRegister:(BOOL)fromRegister
{
    [self dismissViewControllerAnimated:YES completion:^{
        [MBTip showTipsView:@"登录成功"];
    }];
    
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UITabBarController * newTabbar = [[SSIMBusinessManager sharedInstance] loadTabbar];

    delegate.window.rootViewController = newTabbar;

    
     /*
    //重置datasoruce
    switch (self.loginType) {
        case LOGIN_DEFAULT:
        {
            _GET_APP_DELEGATE_(appDelegate);
            [appDelegate NIMMessageCenterLoginDidSuccess:exchangeAccount fromRegister:fromRegister];
        }
            break;
        case LOGIN_GETHANDCODE:
        {
            if(exchangeAccount)
            {
                _GET_APP_DELEGATE_(appDelegate);
                [appDelegate NIMMessageCenterLoginDidSuccess:exchangeAccount  fromRegister:fromRegister];
            }
            else
            {
                if([_delegate respondsToSelector:@selector(authLoginViewController:loginSuccess:)])
                {
                    [_delegate authLoginViewController:self loginSuccess:self.loginType];
                }
            }
        }
            break;
        case LOGIN_THIRD:
        {
            
        }
            break;
            
        case LOGIN_TOUCHID:
        {
            [self updateTouchInfo];
            
            _GET_APP_DELEGATE_(appDelegate);
            [appDelegate NIMMessageCenterLoginDidSuccess:exchangeAccount fromRegister:fromRegister fromTouchId:YES];
            
            self.loginType = LOGIN_DEFAULT;
            [self updateBottom];
        }
            break;
        default:
            break;
    }
      */
    
}

//-(void)signBtnPressed:(id)sender
//{
//    [self hideAccountBox];
//    //    QBAuthRegisterPart1ViewController *registerVC = _ALLOC_VC_CLASS_([QBAuthRegisterPart1ViewController class]);
//    //    [self nim_pushToVC:registerVC animal:YES];
//
//}


-(void)dropDown:(id)sender
{
    __weak typeof(self) weakSelf = self;
    CGRect rect = self.userNameTextField.frame;
    rect = CGRectMake(rect.origin.x+40, rect.origin.y+CGRectGetHeight(self.userNameTextField.frame), rect.size.width-50, rect.size.height);
    [[NIMLoginManager sharedInstance] showAccountsRect:rect];
    [NIMLoginManager sharedInstance].selectBlock = ^(NSString *userName) {
        weakSelf.userNameTextField.text = userName;
    };
    [NIMLoginManager sharedInstance].clearBlock = ^{
        weakSelf.arrowButton.hidden = YES;
    };
//    UIButton *btn =(UIButton *)sender;
//    if ([btn isSelected])
//    {
//        [self hideAccountBox];
//        btn.selected =NO;
//
//    }
//    else
//    {
//        [self showAccountBox];
//        btn.selected =YES;
//    }
}

#pragma mark public
- (void)updateBottom
{
    if(self.loginType == LOGIN_TOUCHID)
    {
        [self.bottomView setCenterTitle:@"指纹登录" img:IMGGET(@"icon_fingerprint.png") action:@selector(reShowTouchID) target:self];
    }
    else
    {
        [self updateQQAndWB];
    }
}


- (void)showTouchID
{
    self.PassWordTextField.text = @"";
    [self qb_showLoading];
    [self performSelector:@selector(showTouchIDAction:) withObject:@NO afterDelay:3];
}

- (void)reShowTouchID
{
    self.PassWordTextField.text = @"";
    [self qb_showLoading];
    [self performSelector:@selector(showTouchIDAction:) withObject:@YES afterDelay:0];
}

- (void)qb_firstAuthVC
{
    
}

#pragma mark 本地账户操作
- (NIMAccountsInfo *)getLastLoginAccount
{
    return [[NIMAccountsManager shareIntance] getLastLocalAccout];
}


- (void)selectAccount:(NIMAccountsInfo *)model
{
    self.userNameTextField.text =model.userName;
    self.PassWordTextField.text =model.passWord;
    [self hideBaoer];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"icon_point_head.png"]];
}

- (void)deleteLocalAccounts:(NSMutableArray *)array
{
    self.accuntArr = [NSMutableArray arrayWithArray:[[NIMAccountsManager shareIntance] getLocalAccounts]];
    self.userNameTextField.text=@"";
    self.PassWordTextField.text=@"";
    [self showBaoer];
    
    [self.dropDownView reloadData];
    if(self.accuntArr.count<=0)
    {
        self.arrowButton.hidden =YES;
        [self hideAccountBox];
    }
    else
    {
        self.arrowButton.hidden =NO;
    }
}

#pragma mark private
- (void)cleanCoreDataConnect{
    if([NIMCoreDataManager currentCoreDataManager].managedObjectContext){
        [NIMCoreDataManager currentCoreDataManager].managedObjectContext = nil;
        [NIMCoreDataManager currentCoreDataManager].managedObjectModel = nil;
        [NIMCoreDataManager currentCoreDataManager].persistentStoreCoordinator = nil;
        [NIMCoreDataManager clearcurrentCoreDataManager];
        [MagicalRecord cleanUp];
    }
    else
    {
        [NIMCoreDataManager clearcurrentCoreDataManager];
    }
}

- (void)updateTouchInfo
{
     /*
    NIMAccountsInfo *user = [[NIMAccountsManager shareIntance] getLastLocalAccout];
    NIMBaseUserInfo *info  = [NIMBaseUserInfo baseDataWithDecode:user.userid];
    
    if (AUTH_VALID)
    {
        _MYINFO_(info);
        info.local_lastTouchIDTime = [[NSDate date] timeIntervalSince1970];
    }
    info.local_lastTouchIDTime = [[NSDate date] timeIntervalSince1970];
    [info saveToLocal];
      */
}

- (void)showTouchIDAction:(NSNumber *)state
{
    /*
     if([state boolValue])
     {
     [self qb_hideLoadingWithCompleteBlock:^{
     [[TouchIDManager shareManager] showTouchIDWithSuccess:^{
     
     BOOL ishavePWD = NO;
     NIMAccountsInfo  *old = [[NIMAccountsManager shareIntance] getLastLocalAccout];
     
     //判断是否有用户名密码，有则自动登录。
     if ([old.userName length] > 0 && [old.passWord length] >0)
     {
     ishavePWD = YES;
     }
     
     if(ishavePWD)
     {
     NIMAccountsInfo *userInfo = [[NIMAccountsManager shareIntance] getLastLocalAccout];
     [self loginWithName:userInfo.userName passwd:userInfo.passWord fromRegister:NO];
     [self updateTouchInfo];
     }
     
     
     } faile:^(TouchIDError code) {
     switch (code) {
     case TIErrorPasscodeNotSet:
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未开启系统Touch ID" message:@"请先在系统设置-TouchID与密码中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
     [alert show];
     }
     break;
     case TIErrorTouchIDNotEnrolled:
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未开启系统Touch ID" message:@"请先在系统设置-TouchID与密码中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
     [alert show];
     }
     break;
     
     default:
     break;
     }
     }];
     }];
     }
     else
     {
     [self updateBottom];
     [self qb_hideLoadingWithCompleteBlock:^{
     [[TouchIDManager shareManager] showTouchIDWithSuccess:^{
     self.loginType = LOGIN_DEFAULT;
     [self updateBottom];
     NIMAccountsInfo *userInfo = [[NIMAccountsManager shareIntance] getLastLocalAccout];
     [self loginWithName:userInfo.userName passwd:userInfo.passWord fromRegister:NO];
     [self updateTouchInfo];
     
     } faile:^(TouchIDError code) {
     switch (code)
     {
     case TIErrorPasscodeNotSet:
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未开启系统Touch ID" message:@"请先在系统设置-TouchID与密码中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
     [alert show];
     }
     break;
     case TIErrorTouchIDNotEnrolled:
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未开启系统Touch ID" message:@"请先在系统设置-TouchID与密码中开启" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
     [alert show];
     }
     break;
     
     default:
     break;
     }
     
     }];
     }];
     }
     */
}

/**
 *  设置NAV颜色
 *
   isTransparent 0：透明 1：白色
 */
- (void)setNavigationBarTransparent:(NSInteger)isTransparent
{
    [self qb_setTitleText:@""];
    UIImage * img = nil;
    switch (isTransparent) {
        case 0:
        {
            img = [[UIImage alloc] init];
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
        }
            break;
        default:
            break;
    }
    [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
    NSArray* a = self.navigationController.navigationBar.subviews;
    UIView* v = (UIView*)[a firstObject];
    if(isTransparent == 1)
        v.hidden = YES;
    else
        v.hidden = NO;
}




//这个不能乱掉，因为还有指纹登录 掺杂在里面，只有你确认要显示第三方的时候才能调用这里
- (void)updateQQAndWB
{
    //    if([QQApiInterface isQQInstalled] && [WeiboSDK isWeiboAppInstalled])
    //    {
    [self.bottomView setLeftTitle:@"QQ登录"    img:IMGGET(@"qb_login_qq_icon.png")   action:@selector(qb_qqLogin) target:self];
    [self.bottomView setRightTitle:@"微博登录" img:IMGGET(@"qb_login_weibo_icon.png") action:@selector(qb_weiboLogin) target:self];
    //    }
    //    else if([QQApiInterface isQQInstalled] == NO && [WeiboSDK isWeiboAppInstalled])
    //    {
    //        [self.BottomView setCenterTitle:@"微博登录" img:IMGGET(@"qb_login_weibo_icon.png") action:@selector(qb_weiboLogin) target:self];
    //    }
    //    else if([QQApiInterface isQQInstalled] && [WeiboSDK isWeiboAppInstalled] == NO)
    //    {
    //        [self.BottomView setCenterTitle:@"QQ登录" img:IMGGET(@"qb_login_qq_icon.png") action:@selector(qb_qqLogin) target:self];
    //    }
    //    else
    //    {
    //        [self.BottomView setCenterTitle:@"" img:nil action:nil target:self];
    //    }
}

/**
 *  隐藏卡通人物
 */
-(void)hideBaoer
{
    self.isshowBaoer=NO;
    self.header.hidden =YES;
    self.rightArm.hidden=YES;
    self.lefthArm.hidden =YES;
    self.lefthand.hidden =YES;
    self.righthand.hidden =YES;
    self.iconImage.hidden=NO;
}

/**
 *  显示卡通人物
 */
-(void)showBaoer
{
    self.isshowBaoer=YES;
    self.header.hidden =NO;
    self.rightArm.hidden=NO;
    self.lefthArm.hidden =NO;
    self.lefthand.hidden =NO;
    self.righthand.hidden =NO;
    self.iconImage.hidden=YES;
}



#pragma mark -- getter
_GETTER_BEGIN(UIBarButtonItem, qb_closeBarButton)
{
    _qb_closeBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.closeButton];
}
_GETTER_END(qb_closeBarButton)

_GETTER_BEGIN(UIButton, closeButton)
{
    _closeButton     = [UIButton buttonWithType:UIButtonTypeCustom];
    _CLEAR_BACKGROUND_COLOR_(_closeButton);
    _closeButton.exclusiveTouch  = YES;
    _closeButton.frame           = _CGR(5, 0, 20, 20);
    [_closeButton setBackgroundImage:IMGGET(@"icon_x_circle") forState:UIControlStateNormal];
    
    [_closeButton addTarget:self action:@selector(qb_close) forControlEvents:UIControlEventTouchUpInside];
}
_GETTER_END(closeButton)
@end
