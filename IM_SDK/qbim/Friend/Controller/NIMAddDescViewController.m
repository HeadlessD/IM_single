//
//  NIMAddDescViewController.m
//  QianbaoIM
//
//  Created by xuguochen on 15/12/28.
//  Copyright © 2015年 qianbao.com. All rights reserved.
//

#import "NIMAddDescViewController.h"
#import "NIMUserOperationBox.h"
#import "SSIMSpUtil.h"

//#import "NIMFriendManager.h"
#define MAX_LIMIT_NUMS 26
#define MAX_HANS_NUMS 52

@interface NIMAddDescViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView        *inputTextView;
@property (nonatomic, strong) UILabel           *placeholderView;
@property (nonatomic, strong) NSMutableString   *myInfo;
@end

@implementation NIMAddDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    _GET_APP_DELEGATE_(appDelegate);
    
    VcardEntity * vcard = [VcardEntity instancetypeFindUserid:OWNERID];
    
    
    NSString * ownstring = nil;
    if (!IsStrEmpty(vcard.nickName)) {
        ownstring = vcard.nickName;
    }else if (!IsStrEmpty(vcard.userName)) {
        ownstring = vcard.userName;
    }else{
        ownstring =[NSString stringWithFormat:@"%lld",vcard.userid];
    }
    
    self.myInfo = [NSMutableString stringWithString:@"我是"];
    [self.myInfo appendFormat:@"%@",ownstring];
    
    
    
    if ([SSIMSpUtil isValidateChinaChar:self.myInfo]) {
        if (self.myInfo.length > MAX_LIMIT_NUMS - 2) {
            self.myInfo = [NSMutableString stringWithString:[self.myInfo substringToIndex:MAX_LIMIT_NUMS - 2]];
        }

    }else{
        if (self.myInfo.length > MAX_LIMIT_NUMS - 2) {
            self.myInfo = [NSMutableString stringWithString:[self.myInfo substringToIndex:MAX_LIMIT_NUMS - 2]];
        }
    }
    
    [self qb_setTitleText:@"验证消息"];
    [self qb_showRightButton:@"发送"];
    
    [self addConstraints];
    [self.inputTextView becomeFirstResponder];
    
    [self.inputTextView setText:self.myInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvC_CLIENT_FRIEND_ADD_RQ:) name:NC_CLIENT_FRIEND_ADD_RQ object:nil];
}


- (void)qb_rightButtonAction
{
    [self makeFriend];
}

- (void)qb_back
{
    [self dismissViewControllerAnimated:YES completion:^{
        //返回刷新
        if (_addBackRefesh) {
            _addBackRefesh();
        }
    }];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    //返回刷新
    if (_addBackRefesh) {
        _addBackRefesh();
    }
}
- (void)makeFriend{
    //添加好友
    DBLog(@"ID:%ld, MSG:%@",(long)self.userId,_inputTextView.text);
    
    if (_inputTextView.text.length > MAX_LIMIT_NUMS) {
        [MBTip showTipsView:@"验证消息最大限制长度为26个字符"];
    }else{
        FDListEntity * fdlist = [FDListEntity instancetypeFindMUTUALFriendId:self.userId];
        if (!fdlist) {
            if (_inputTextView.text.length != 0 && [SSIMSpUtil isContainNonEnglishAndUnderscoresAndChinese:_inputTextView.text]) {
                [MBTip showError:@"只能输入字母、数字、下划线或汉字" toView:self.view.window];
            }else{
                [[NIMFriendManager sharedInstance] sendFriendAddRQ:self.userId opMsg:_inputTextView.text sourceType:self.addSourceType];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                });
            }
        }else{
            [MBTip showError:@"对方已经是您的好友了" toView:self.view.window];
        }
    }
}

-(void)recvC_CLIENT_FRIEND_ADD_RQ:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    id object = noti.object;
    if (object) {
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary * addDic = object;
            if ([addDic objectForKey:@"isComeBack"]) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [MBTip showError:@"添加好友成功" toView:self.view.window];
                    NSDictionary * dicts = @{@"userId":[addDic objectForKey:@"userId"],@"fdResult":@0};
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FEEDPROFILE" object:dicts];
                }];
            }
        }else if ([object isKindOfClass:[QBNCParam class]]) {
            QBNCParam *param = object;
            [self dismissViewControllerAnimated:YES completion:^{
                [MBTip showError:param.p_string toView:self.view.window];
            }];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{
                [MBTip showError:@"请求发送成功" toView:self.view.window];
            }];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * netAlert = [UIAlertController alertControllerWithTitle:@"网络异常" message:@"请检查当前网络设置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * nAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [netAlert addAction:nAction];
            [self presentViewController:netAlert animated:YES completion:^{
            }];
        });
    
//        [self dismissViewControllerAnimated:YES completion:^{
//            [MBTip showError:@"请求发送失败" toView:self.view.window];
//        }];
    }
}

- (void)addConstraints
{
    [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).width.insets(UIEdgeInsetsMake(10, 10, 300, 10));
    }];
    
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(@4);
        make.top.mas_equalTo(@5);
        make.width.mas_equalTo(@250);
        make.height.mas_equalTo(@25);
    }];
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

- (UITextView*)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        [_inputTextView setBackgroundColor:[UIColor clearColor]];
        [_inputTextView setFont:[UIFont systemFontOfSize:16.0]];
        [_inputTextView setTextColor:[SSIMSpUtil getColor:@"262626"]];
        [_inputTextView setReturnKeyType:UIReturnKeyDone];
        [_inputTextView setDelegate:self];
        [self.view addSubview:_inputTextView];
    }
    return _inputTextView;
}

/*
 - (UILabel*)placeholderView
 {
 if (!_placeholderView) {
 _placeholderView = [[UILabel alloc] init];
 [_placeholderView setText:self.myInfo];
 [_placeholderView setFont:[UIFont systemFontOfSize:16.0]];
 [_placeholderView setTextColor:[SSIMSpUtil getColor:@"888888"]];
 [self.inputTextView addSubview:_placeholderView];
 }
 return _placeholderView;
 }
 */


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self makeFriend];
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
        }
        return NO;
    }
    
}




- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    DBLog(@"    ----toBeString-----     %@",toBeString);
    
    NSInteger length = toBeString.length;
    DBLog(@"--------字符长度-------%ld",(long)length);
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if([lang isEqualToString:@"en-US"] || [SSIMSpUtil isTypeNumber:lang]) { //英文输入输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > MAX_LIMIT_NUMS) {
                textView.text = [toBeString substringToIndex:MAX_LIMIT_NUMS];
                DBLog(@"   中文超过字符的时候   %@",textView.text);
            }
        }else{//有高亮选择的字符串，则暂不对文字进行统计和限制

            
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//        if(toBeString.length > MAX_LIMIT_NUMS) {
//            textView.text= [toBeString substringToIndex:MAX_LIMIT_NUMS];
//            DBLog(@"   其他超过字符的时候    %@",textView.text);
//        }
    }
    
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position){
        if (toBeString.length > MAX_LIMIT_NUMS && textView.markedTextRange == nil){
            //用字符串的字符编码指定索引查找位置     一次遍历一个子串, 而不是遍历一个unichar了.  字符长度设置15
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:14];
            if (rangeIndex.length == 1){
                textView.text = [toBeString substringToIndex:MAX_LIMIT_NUMS];
                DBLog(@"======  1  ====%@",textView.text);
            }else{
                //用字符串的字符编码指定区域段查找位置
                //NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, Max_Length)];
                textView.text = [toBeString substringWithRange:NSMakeRange(0, MAX_LIMIT_NUMS)];
                DBLog(@"======  2  ====%@",textView.text);
            }
        }else{
            length = toBeString.length;
            DBLog(@"-----  length ----%ld",(long)length);
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
