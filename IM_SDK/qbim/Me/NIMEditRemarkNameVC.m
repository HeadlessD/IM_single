//
//  NIMEditRemarkNameVC.m
//  QianbaoIM
//
//  Created by Yun on 14/10/21.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMEditRemarkNameVC.h"
#import "NIMUserOperationBox.h"//remarkAliasNames
//#import "PinYinManager.h"

@interface NIMEditRemarkNameVC ()
@property (nonatomic, weak) IBOutlet UITextField* txtRemarkName;
@end

@implementation NIMEditRemarkNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self qb_setTitleText:@"好友备注"];

    [self qb_showRightButton:@"保存"];
    
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];

    self.txtRemarkName.text = _remarkName;
   
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(_txtRemarkName.frame) - 1,CGRectGetWidth(_txtRemarkName.frame), 1)];
//    lineView.backgroundColor = [SSIMSpUtil getColor:@"DCDCDC"];
//    [_txtRemarkName addSubview:lineView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reviNC_FRIEND_REMARK_RQ:) name:NC_FRIEND_REMARK_RQ object:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)qb_rightButtonAction{
    NSString* remark = [NSString nim_trim:_txtRemarkName.text];
    //        if(remark.length == 0 ){
    //            [MBTip showTipsView:@"备注名称不能为空"];
    //            return;
    //        }
    if (remark.length >24) {
        [MBTip showTipsView:@"备注名称最大长度为24个字符"];
        return;
    }
    
    
    if (remark.length != 0 && [SSIMSpUtil isContainNonEnglishAndUnderscoresAndChinese:remark]) {
        [MBTip showError:@"只能输入字母、数字、下划线或汉字" toView:self.view.window];
        return;
    }
    
    if(remark == nil){
        remark = @"";
    }
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setObject:remark forKey:@"remarkname"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NIMFriendManager sharedInstance]sendFriendRemarkRQ:self.userId remarkName:remark];
}

-(void)reviNC_FRIEND_REMARK_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                //                [MBTip showTipsView:param.p_string atView:self.view.window];
                [MBTip showError:param.p_string toView:self.view.window];
                
                NSLog(@"%d",[noti.userInfo[@"userId"] intValue]);
            }else{
                //                [MBTip showTipsView:@"修改成功" atView:self.view.window];
                [MBTip showError:@"修改成功" toView:self.view.window];
                
                //返回刷新
                if (_backRefesh) {
                    _backRefesh();
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
            //            [MBTip showError:@"请求超时" toView:self.view.window];
        }
    });
}

@end
