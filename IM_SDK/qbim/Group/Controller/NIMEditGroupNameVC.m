//
//  NIMEditGroupNameVC.m
//  QianbaoIM
//
//  Created by Yun on 14/9/18.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMEditGroupNameVC.h"
#import "NIMGroupOperationBox.h"
#import "VcardEntity+CoreDataClass.h"
#import "GMember+CoreDataClass.h"

@interface NIMEditGroupNameVC ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField* txtGroupName;
@property (nonatomic, strong)  UILabel* descriptionLabel;
@end

@implementation NIMEditGroupNameVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvChange:) name:NC_GROUP_NAME_MODIFY object:nil];
    _txtGroupName.delegate =self;
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(_txtGroupName.frame) - 1,CGRectGetWidth(_txtGroupName.frame), 1)];
//    lineView.backgroundColor = [SSIMSpUtil getColor:@"DCDCDC"];
//    [_txtGroupName addSubview:lineView];

    [self qb_showRightButton:@"保存"];
    if (self.type == groupEditType)
    {
        [self qb_setTitleText:@"群聊名称"];
        _txtGroupName.placeholder  = @"群名称";
        _txtGroupName.text =  _groupEntity.name;

        if (_groupEntity.name.length >32)
        {
            _txtGroupName.text = [_groupEntity.name substringToIndex:32];
        }
        else
        {
            _txtGroupName.text =  _groupEntity.name;
        }
    }
    else if (self.type == groupCardEditType)
    {
        self.descriptionLabel.text = @" 设置你在群里的昵称，这个昵称只会在这个群内显示。";
        [self qb_setTitleText:@"我在本群的昵称"];
        _txtGroupName.placeholder  = @"群昵称";
        if (_groupEntity.selfcard.length >24)
        {
            _txtGroupName.text = [_groupEntity.selfcard substringToIndex:24];
        }
        else
        {
            if (IsStrEmpty(_groupEntity.selfcard) ) {
                VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:OWNERID];
                _txtGroupName.text =vcardEntity.defaultName;
            }
            else
            {
                _txtGroupName.text =  _groupEntity.selfcard;
            }
        }
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark actions
- (void)qb_rightButtonAction{
    [self saveAction:nil];
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (self.type == groupEditType)
//    {
//    if (string.length == 0) {
//        return YES;
//    }
//    
//    NSString *comcatstr = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    
//    if (comcatstr.length > 30) {
//        return NO;
//    }
//    }
//    
//    return YES;
//}


#pragma mark 11.4
- (void)saveAction:(id)sender
{
    
    NSString *text = self.txtGroupName.text;
    if (self.type == groupEditType) {
        
        if ([text length] > 0) {
            
            
            if ([text length] > 32) {
                [MBTip showError:@"群名称上限32字" toView:self.view];
                return;
            }
            
            if ([text isEqualToString: _groupEntity.name]) {
                [MBTip showError:@"请修改群名称再保存" toView:self.view];
                return;
            }
            else
            {
                text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                if (![SSIMSpUtil isValidateTag:text withLength:@"32"])
                    
                {
                    [MBTip showError:@"群名称格式不正确" toView:self.view];
                    return;
                }
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                if ([text isEqualToString:_groupEntity.name]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    return;
                }
                [[NIMGroupOperationBox sharedInstance] changeGroupInfo:self.groupEntity.groupId content:text type:GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME];
                
            }
            
        }else{
            [MBTip showError:@"群名称为空" toView:self.view];
        }
    }
    
    else if (self.type == groupCardEditType)
    {
        
        if ([text length] > 0) {
            
            NSString *name = nil;
            
            if (!IsStrEmpty(self.groupEntity.selfcard)) {
                name = self.groupEntity.selfcard;
            }
            else
            {
                VcardEntity *vcardEntity = [VcardEntity instancetypeFindUserid:OWNERID];
                name =vcardEntity.defaultName;
            }
            
            
            if ([text isEqualToString: name]) {
                [MBTip showError:@"请修改群昵称再保存" toView:self.view];
                return;
            }
            
            if ([text length]>24)
            {
                [MBTip showError:@"群昵称上限24字" toView:self.view];
                return;
            }
            text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            if (![SSIMSpUtil isNickValidateTag:text withLength:@"24"])
            {
                [MBTip showError:@"群昵称格式不正确" toView:self.view];
                return;
            }

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            if ([text isEqualToString:name]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                });
                return;
            }
            [[NIMGroupOperationBox sharedInstance] changeGroupInfo:self.groupEntity.groupId content:text type:GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME];
            
        }else{
            VcardEntity *vcard = [VcardEntity instancetypeFindUserid:OWNERID];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NIMGroupOperationBox sharedInstance] changeGroupInfo:self.groupEntity.groupId content:vcard.defaultName type:GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME];
        }
    }
    
    
    
}

-(UILabel *)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.textColor = [SSIMSpUtil getColor:@"888888"];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_descriptionLabel];
        [_descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@10);
            make.trailing.equalTo(@10);
            make.bottom.equalTo(self.txtGroupName.mas_bottom).offset(50);
            make.height.equalTo(@40);
        }];
    }
    return _descriptionLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)recvChange:(NSNotification *)noti
{
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    if (!object) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            GROUP_CHAT_OFFLINE_TYPE type = [[noti.userInfo objectForKey:@"type"] intValue];
            UIAlertController *alertController = nil;
            if (self.type == groupEditType) {
                if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_NAME) {
                    alertController = [NIMBaseUtil createAlertControllerWithOnlyTitle:@"无法修改群名称，可稍后再试"];
                    [self presentViewController:alertController animated:YES completion:nil];

                }
            }else{
                if (type == GROUP_OFFLINE_CHAT_MODIFY_GROUP_USER_NAME) {
                    alertController = [NIMBaseUtil createAlertControllerWithOnlyTitle:@"无法修改群昵称，可稍后再试"];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        });

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [MBTip showError:param.p_string toView:self.view];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
