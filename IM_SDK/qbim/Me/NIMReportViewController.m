//
//  NIMReportViewController.m
//  QianbaoIM
//
//  Created by 徐庆 on 15/3/20.
//  Copyright (c) 2015年 xuqing. All rights reserved.
//

#import "NIMReportViewController.h"
#import "NIMReportTableViewCell.h"
#import "UITextView+NIMPlaceholder.h"
@interface NIMReportViewController ()<NIMReportTableViewCelldelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *reportTableView;

@property (nonatomic,strong) UITableView * reportTable;
@end

@implementation NIMReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self qb_setTitleText:@"举报"];
    self.dataSourceArray =[[NSArray alloc]init];
    self.dataSourceArray =@[@"法律法规",@"色情暴力",@"虚假诈骗",@"骚扰",@"其他"];
    _reportTable.backgroundColor = [UIColor whiteColor];
    [self qb_showRightButton:@"发送"];
    
    _reportTable.tableHeaderView = self.headView;
    //    self.rightButton.enabled=NO;
    [self setAutoLayout];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_reportTable addGestureRecognizer:tableViewGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvNC_USER_COMPLAINT_RQ:) name:NC_USER_COMPLAINT_RQ object:nil];
    
    self.view.backgroundColor = __COLOR_E6E6E6__;
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.navigationController.navigationBar.translucent = NO; // 默认是YES
    _reportTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _reportTable.delegate = self;
    _reportTable.dataSource = self;
    _reportTable.estimatedRowHeight =0;
    _reportTable.estimatedSectionHeaderHeight =0;
    _reportTable.estimatedSectionFooterHeight =0;

    _reportTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_reportTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:_reportTable];
}


- (void)commentTableViewTouchInSide{
    [self.textView resignFirstResponder];
}

#pragma mark 页面autoLayOUT设置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];

}


- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat maxY = CGRectGetMaxY(self.reportTable.tableFooterView.frame);
    NSLog(@"%f",CGRectGetMaxY(self.reportTable.tableFooterView.frame));
    
    if ((SCREEN_HEIGHT - kbHeight) < maxY) {
        //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
        CGFloat offset = maxY - (SCREEN_HEIGHT - kbHeight)+70;
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        //将视图上移计算好的偏移
        if(offset > 0) {
            [UIView animateWithDuration:duration animations:^{
//                self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
                [self.reportTable setFrame:CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height)];

            }];
        }
    }
}

#pragma mark ---- 当键盘消失后，视图需要恢复原状
///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        [self.reportTable setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if (textView.text.length >= 140 && text.length > range.length) {
        //在这里提示用户字数不得超过140字
        return NO;
    }
    
    return YES;
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    //该判断用于联想输入
    //    NSInteger res = 50 - [textView.text length];
    if (textView.markedTextRange == nil && 140 > 0 && textView.text.length > 140) {
        textView.text = [textView.text substringToIndex:140];
        self.leathLable.text =[NSString stringWithFormat:@"%d/140", 140];
        
    }
    else {
        self.leathLable.text =[NSString stringWithFormat:@"%lu/140", [textView.text length]];
    }
    
}
-(void)qb_back
{
    if ([self.pushType isEqualToString:@"push"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
-(void)qb_rightButtonAction
{
    
    if (IsStrEmpty(self.reason_type)) {
        [MBTip showTipsView:@"请选择举报原因"];
        [MBTip showError:@"请选择举报原因" toView:self.view.window];

    }else{
       
        if ([self.reason_type isEqualToString:@"5"]){
            self.reason_content = [SSIMSpUtil trimString:self.textView.text];
            if (IsStrEmpty(self.reason_content)) {
                [self.textView resignFirstResponder];
//                [MBTip showTipsView:@"请说明详细举报原因" atView:self.view];
                [MBTip showError:@"请说明详细举报原因" toView:self.view.window];

            }else{
                [self.textView resignFirstResponder];

                [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                if (self.isTweet == NO) {
                    [[NIMUserOperationBox sharedInstance]sendReportUserID:[self.uuid intValue] type:[self.reason_type intValue] reason:self.reason_content];
//                    [MBTip showTipsView:@"举报发送成功" atView:self.view];
                }else{
                    [[NIMUserOperationBox sharedInstance]sendReportUserID:[self.uuid intValue] type:[self.reason_type intValue] reason:self.reason_content];
//                    [MBTip showTipsView:@"举报发送成功" atView:self.view];
                }
            }
        }else{
            if (self.isTweet == NO) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];

                [[NIMUserOperationBox sharedInstance]sendReportUserID:[self.uuid intValue] type:[self.reason_type intValue] reason:self.dataSourceArray[[self.reason_type intValue] - 1]];
            }else{
//                [MBTip showTipsView:@"举报发送失败" atView:self.view];
                [MBTip showError:@"举报发送失败" toView:self.view.window];

            }
        }
    }
}

- (void)setAutoLayout
{
    [self.contView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.footerView.mas_leading).with.offset(15);
        make.top.equalTo(self.footerView.mas_top).with.offset(15);
        make.bottom.equalTo(self.footerView.mas_bottom).with.offset(-15);
        make.trailing.equalTo(self.footerView.mas_trailing).with.offset(-15);
    }];
    
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contView.mas_leading).with.offset(0);
        make.trailing.equalTo(self.contView.mas_trailing).with.offset(0);
        make.top.equalTo(self.contView.mas_top).with.offset(0);
        make.bottom.equalTo(self.contView.mas_bottom).with.offset(-25);
    }];
    
    [self.leathLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contView.mas_trailing).with.offset(-68);
        make.trailing.equalTo(self.contView.mas_trailing).with.offset(-2);
        make.top.equalTo(self.textView.mas_bottom).with.offset(2);
        make.height.with.offset(20);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Reportcell";
    NIMReportTableViewCell  *cell  = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    
    if (cell == nil) {
        cell = [[NIMReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    cell.delegate=self;
    
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [self.lastPath row];
    
    if (row == oldRow && self.lastPath!=nil) {
        [cell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_selected.png") forState:UIControlStateNormal];
    }else{
        [cell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_unchecked.png") forState:UIControlStateNormal];
    }
    cell.labTitle.text=[self.dataSourceArray objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (self.lastPath !=nil)?[self.lastPath row]:-1;
    
    if (newRow != oldRow) {
        
        NIMReportTableViewCell *newCell = (NIMReportTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
        
        [newCell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_selected.png") forState:UIControlStateNormal];
        
        NIMReportTableViewCell *oldCell =(NIMReportTableViewCell*) [tableView cellForRowAtIndexPath:self.lastPath];
        
        [oldCell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_unchecked.png") forState:UIControlStateNormal];
        self.lastPath = indexPath;
    }
    
    if(newRow==4){
        _reportTable.tableFooterView=self.footerView;
        [self.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
        self.reason_type=@"5";
    }else{
        _reportTable.tableFooterView=nil;
        [self.textView resignFirstResponder];
        self.reason_content=[self.dataSourceArray objectAtIndex:indexPath.row];
        switch (newRow) {
                //举报类型:1,法律法规 2,色情暴力 3,虚假诈骗 4,骚扰 5,其他
            case 0:
                self.reason_type=@"1";
                break;
            case 1:
                self.reason_type=@"2";
                break;
            case 2:
                self.reason_type=@"3";
                break;
            case 3:
                self.reason_type=@"4";
                break;
                
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)chooseBtnClick:(NIMReportTableViewCell*)cell
{
    NSIndexPath *indexPath = [_reportTable indexPathForCell:cell];
    NSInteger newRow = [indexPath row];
    
    NSInteger oldRow = (self.lastPath !=nil)?[self.lastPath row]:-1;
    
    if (newRow != oldRow) {
        
        [cell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_selected.png") forState:UIControlStateNormal];
        
        NIMReportTableViewCell *oldCell =(NIMReportTableViewCell*) [_reportTable cellForRowAtIndexPath:self.lastPath];
        
        [oldCell.btnChooseBg setBackgroundImage:IMGGET(@"icon_square_unchecked.png") forState:UIControlStateNormal];
        self.lastPath = indexPath;
        
    }
    if(newRow==4)
    {
        _reportTable.tableFooterView=self.footerView;
        [self.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
        
    }
    else
    {
        _reportTable.tableFooterView=nil;
        [self.textView resignFirstResponder];
        self.reason_content=[self.dataSourceArray objectAtIndex:indexPath.row];
        
    }
    
    switch (newRow) {
        case 0:
            self.reason_type=@"1";
            break;
        case 1:
            self.reason_type=@"2";
            break;
        case 2:
            self.reason_type=@"3";
            break;
        case 3:
            self.reason_type=@"4";
            break;
        case 4:
            self.reason_type=@"5";
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)footerView
{
    
    if(!_footerView)
    {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        //        _footerView.backgroundColor=[UIColor redColor];
        //        _footerView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _footerView;
    
}
-(UIView*)headView
{
    
    if(!_headView)
    {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
        _headView.backgroundColor = [SSIMSpUtil getColor:@"f1f1f1"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 190, 22)];
        titleLabel.textColor=[SSIMSpUtil getColor:@"888888"];
        titleLabel.font =[UIFont systemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text=@"请选择举报原因";
        [_headView addSubview:titleLabel];
        
        
    }
    return _headView;
    
}
-(UIView*)contView
{
    if(!_contView)
    {
        _contView = [[UIView alloc] init];
        _contView.translatesAutoresizingMaskIntoConstraints = NO;
        _contView.layer.borderWidth=0.5;
        _contView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [self.footerView addSubview:_contView];
    }
    return _contView;
    
}
-(UITextView*)textView
{
    if(!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.placeholder=@"请详细填写，以确保举报能够被受理";
        _textView.font=[UIFont boldSystemFontOfSize:14];
        _textView.returnKeyType =UIReturnKeyDone;
        _textView.delegate=self;
        [self.contView addSubview:_textView];
    }
    return _textView;
    
}
-(UILabel *)leathLable
{
    if(!_leathLable)
    {
        _leathLable = [[UILabel alloc] init];
        _leathLable.translatesAutoresizingMaskIntoConstraints = NO;
        _leathLable.font =[UIFont systemFontOfSize:14];
        _leathLable.textColor =[SSIMSpUtil getColor:@"888888"];
        _leathLable.text=@"0/140";
        _leathLable.textAlignment =NSTextAlignmentRight;
        _leathLable.backgroundColor=[UIColor whiteColor];
        [self.contView addSubview:_leathLable];
    }
    return _leathLable;
    
}

-(void)recvNC_USER_COMPLAINT_RQ:(NSNotification *)noti{
    
    id object = noti.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (object) {
            if ([object isKindOfClass:[QBNCParam class]]) {
                QBNCParam *param = object;
                [self dismissViewControllerAnimated:YES completion:^{
                    [MBTip showTipsView:param.p_string];
                }];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
//                    [MBTip showTipsView:@"举报发送成功" atView:self.view];
                    [MBTip showError:@"举报发送成功" toView:self.view.window];

                }];
            }
        }else{
//            [self dismissViewControllerAnimated:YES completion:^{
                UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [netAlert addAction:nAction];
                [self presentViewController:netAlert animated:YES completion:^{
                }];
//                [MBTip showError:@"举报发送失败" toView:self.view.window];

//            }];
        }
    });
}


@end
