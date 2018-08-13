//
//  EditNickNameViewController.m
//  qbnimclient
//
//  Created by shiyunjie on 2018/1/4.
//  Copyright © 2018年 秦雨. All rights reserved.
//

#import "EditNickNameViewController.h"

@interface EditNickNameViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UITextField * nameField;
@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvChangeUserInfo) name:NC_SDK_USER object:nil];

    [self qb_setTitleText:@"修改昵称"];
    [self qb_showRightButton:@"保存"];
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 40, 60)];
    _nameField.placeholder = _vcardEntity.nickName;
    _nameField.delegate = self;
    [backView addSubview:_nameField];
}

-(void)recvChangeUserInfo{
    [self.navigationController popViewControllerAnimated:YES];
    _vcardEntity.nickName = _nameField.text;
    [MBTip showError:@"修改成功" toView:self.view.window];
}

- (void)qb_rightButtonAction{
    [self saveAction:nil];
}
- (void)saveAction:(id)sender
{
    if ( IsStrEmpty(_nameField.text)) {
        [MBTip showError:@"昵称不能为空" toView:self.view];
    }else{
        NSMutableArray * userArr = [NSMutableArray array];
        NSString * sexStr = @"";
        if ([_vcardEntity.sex isEqualToString:@"F"]) {
            sexStr = @"女";
        }else{
            sexStr = @"男";
        }
        [userArr addObject:@{@(key_user_name):_nameField.text}];
        [userArr addObject:@{@(key_birthday):[NSString stringWithFormat:@"%@",_vcardEntity.birthday]}];
        [userArr addObject:@{@(key_mobile):IsStrEmpty(_vcardEntity.mobile)?@"":_vcardEntity.mobile}];
        [userArr addObject:@{@(key_mail):IsStrEmpty(_vcardEntity.mail)?@"":_vcardEntity.mail}];
        [userArr addObject:@{@(key_city):IsStrEmpty(_vcardEntity.localtionCity)?@"":_vcardEntity.localtionCity}];
        [userArr addObject:@{@(key_nick_name):_nameField.text}];
        [userArr addObject:@{@(key_sex):sexStr}];
        [userArr addObject:@{@(key_province):IsStrEmpty(_vcardEntity.locationPro)?@"":_vcardEntity.locationPro}];
        [userArr addObject:@{@(key_signature):IsStrEmpty(_vcardEntity.signature)?@"":_vcardEntity.signature}];
        [[NIMUserOperationBox sharedInstance]sendUpdateUserInfoRQ:userArr sessionID:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
